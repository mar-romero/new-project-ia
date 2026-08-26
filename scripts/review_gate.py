#!/usr/bin/env python3
"""Content-hash freeze and structured review validation. No extra packages."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any

SCHEMA_VERSION = 1
SEVERITIES = {"BLOCKER", "HIGH", "MEDIUM", "LOW"}
EVIDENCE_CLASSES = {"DETERMINISTIC", "INFERRED", "INSUFFICIENT"}
CAUSALITIES = {"candidate", "pre-existing", "unknown"}
STATUSES = {
    "open",
    "corroborated",
    "refuted",
    "dropped",
    "inconclusive",
    "fixed",
    "wont-fix",
}
VERDICTS = {"PASS", "CHANGES_REQUIRED"}
BLOCKING_SEVERITIES = {"BLOCKER", "HIGH"}
POSIX_SEP = "/"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def posix_rel(path: Path, root: Path) -> str:
    return path.resolve().relative_to(root.resolve()).as_posix()


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def dump_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def git(args: list[str], cwd: Path) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=cwd,
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def collect_git_paths(root: Path) -> list[str]:
    names = git(["diff", "--name-only", "HEAD"], cwd=root)
    status = git(["status", "--porcelain", "-uall"], cwd=root)
    paths: list[str] = []
    seen: set[str] = set()
    for line in names.splitlines():
        item = line.strip().replace("\\", POSIX_SEP)
        if item and item not in seen:
            seen.add(item)
            paths.append(item)
    for line in status.splitlines():
        if len(line) < 4:
            continue
        item = line[3:].strip().replace("\\", POSIX_SEP)
        if " -> " in item:
            item = item.split(" -> ", 1)[1]
        if item and item not in seen:
            seen.add(item)
            paths.append(item)
    return paths


def collect_tree_paths(root: Path) -> list[str]:
    paths: list[str] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [name for name in dirnames if name != ".git"]
        for name in filenames:
            path = Path(dirpath) / name
            paths.append(posix_rel(path, root))
    paths.sort()
    return paths


def hash_listed_files(root: Path, rel_paths: list[str]) -> dict[str, str | None]:
    files: dict[str, str | None] = {}
    for rel in rel_paths:
        path = root / Path(*rel.split(POSIX_SEP))
        if path.is_file():
            files[rel] = sha256_file(path)
        else:
            files[rel] = None
    return files


def cmd_freeze(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    if args.no_git:
        rel_paths = collect_tree_paths(root)
        git_head = None
        diff_sha256 = None
    else:
        git_head = git(["rev-parse", "HEAD"], cwd=root).strip()
        diff_sha256 = sha256_bytes(git(["diff", "HEAD"], cwd=root).encode("utf-8"))
        rel_paths = collect_git_paths(root)
        if not rel_paths:
            rel_paths = collect_tree_paths(root)
    payload = {
        "schema_version": SCHEMA_VERSION,
        "task": args.task,
        "git_head": git_head,
        "diff_sha256": diff_sha256,
        "files": hash_listed_files(root, rel_paths),
    }
    dump_json(Path(args.output), payload)
    print(f"FREEZE WRITTEN: {args.output}")
    return 0


def cmd_verify(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    freeze = load_json(Path(args.freeze))
    errors: list[str] = []
    if freeze.get("schema_version") != SCHEMA_VERSION:
        errors.append("unsupported schema_version")
    files = freeze.get("files")
    if not isinstance(files, dict) or not files:
        errors.append("freeze.files must be a non-empty object")
    else:
        for rel, expected in files.items():
            path = root / Path(*str(rel).split(POSIX_SEP))
            if expected is None:
                if path.exists():
                    errors.append(f"expected missing file still exists: {rel}")
                continue
            if not path.is_file():
                errors.append(f"missing frozen file: {rel}")
                continue
            actual = sha256_file(path)
            if actual != expected:
                errors.append(f"hash mismatch: {rel}")
    if not args.no_git and freeze.get("git_head"):
        head = git(["rev-parse", "HEAD"], cwd=root).strip()
        if head != freeze["git_head"]:
            errors.append("git_head mismatch")
        actual_diff = sha256_bytes(git(["diff", "HEAD"], cwd=root).encode("utf-8"))
        if actual_diff != freeze.get("diff_sha256"):
            errors.append("diff_sha256 mismatch")
    if errors:
        print("FREEZE INVALID")
        for item in errors:
            print(f"- {item}")
        return 1
    print("FREEZE VALID")
    return 0


def line_count(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    if text == "":
        return 0
    return len(text.splitlines())


def finding_blocks(finding: dict[str, Any]) -> bool:
    severity = finding.get("severity")
    evidence = finding.get("evidence_class")
    causality = finding.get("causality")
    status = finding.get("status", "open")
    return (
        severity in BLOCKING_SEVERITIES
        and evidence in {"DETERMINISTIC", "INFERRED"}
        and causality == "candidate"
        and status in {"open", "corroborated"}
    )


def cmd_validate_review(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    freeze = load_json(Path(args.freeze))
    review = load_json(Path(args.review))
    errors: list[str] = []
    files = freeze.get("files")
    if not isinstance(files, dict):
        errors.append("freeze.files missing")
        files = {}

    verdict = review.get("verdict")
    if verdict not in VERDICTS:
        errors.append("invalid verdict")
    findings = review.get("findings")
    if not isinstance(findings, list):
        errors.append("findings must be a list")
        findings = []

    ids: set[str] = set()
    blocking = 0
    for index, finding in enumerate(findings):
        prefix = f"findings[{index}]"
        if not isinstance(finding, dict):
            errors.append(f"{prefix} must be an object")
            continue
        finding_id = finding.get("id")
        if not isinstance(finding_id, str) or not finding_id:
            errors.append(f"{prefix}.id missing")
        elif finding_id in ids:
            errors.append(f"{prefix}.id duplicate: {finding_id}")
        else:
            ids.add(finding_id)
        if finding.get("severity") not in SEVERITIES:
            errors.append(f"{prefix}.severity invalid")
        evidence = finding.get("evidence_class")
        if evidence not in EVIDENCE_CLASSES:
            errors.append(f"{prefix}.evidence_class invalid")
        if finding.get("causality") not in CAUSALITIES:
            errors.append(f"{prefix}.causality invalid")
        if finding.get("status", "open") not in STATUSES:
            errors.append(f"{prefix}.status invalid")
        if evidence == "INSUFFICIENT" and finding.get("severity") in BLOCKING_SEVERITIES:
            errors.append(f"{prefix}: INSUFFICIENT cannot be BLOCKER/HIGH")
        path_value = finding.get("path")
        if evidence in {"DETERMINISTIC", "INFERRED"}:
            if not isinstance(path_value, str) or not path_value:
                errors.append(f"{prefix}.path required for {evidence}")
            else:
                rel = path_value.replace("\\", POSIX_SEP)
                if rel not in files or files[rel] is None:
                    errors.append(f"{prefix}.path not in freeze: {rel}")
                else:
                    disk = root / Path(*rel.split(POSIX_SEP))
                    if not disk.is_file():
                        errors.append(f"{prefix}.path missing on disk: {rel}")
                    start = finding.get("start_line")
                    if start is not None:
                        if not isinstance(start, int) or isinstance(start, bool) or start < 1:
                            errors.append(f"{prefix}.start_line invalid")
                        elif disk.is_file():
                            count = line_count(disk)
                            if start > count:
                                errors.append(f"{prefix}.start_line {start} past end ({count})")
        if finding_blocks(finding):
            blocking += 1

    if verdict == "PASS" and blocking:
        errors.append("PASS with unresolved corroborated BLOCKER/HIGH")
    if verdict == "CHANGES_REQUIRED" and blocking == 0:
        errors.append("CHANGES_REQUIRED without a blocking finding")

    if errors:
        print("REVIEW INVALID")
        for item in errors:
            print(f"- {item}")
        return 1
    print("REVIEW VALID")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Freeze candidates and validate review JSON.")
    sub = parser.add_subparsers(dest="command", required=True)

    freeze = sub.add_parser("freeze", help="Write a content-hash freeze file")
    freeze.add_argument("--task", required=True)
    freeze.add_argument("--output", required=True)
    freeze.add_argument("--root", default=".")
    freeze.add_argument("--no-git", action="store_true")
    freeze.set_defaults(func=cmd_freeze)

    verify = sub.add_parser("verify", help="Re-hash files and fail on mismatch")
    verify.add_argument("--freeze", required=True)
    verify.add_argument("--root", default=".")
    verify.add_argument("--no-git", action="store_true")
    verify.set_defaults(func=cmd_verify)

    validate = sub.add_parser("validate-review", help="Validate structured review against a freeze")
    validate.add_argument("--freeze", required=True)
    validate.add_argument("--review", required=True)
    validate.add_argument("--root", default=".")
    validate.set_defaults(func=cmd_validate_review)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    return int(args.func(args))


if __name__ == "__main__":
    sys.exit(main())
