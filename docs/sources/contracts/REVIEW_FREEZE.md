# Source Contract — Review freeze and finding gate

Provider: this repository (`scripts/review_gate.py`)

Purpose: Identify a review candidate by file content hashes and reject
structured findings that cannot be located in that freeze.

Status: VERIFIED

Date verified: 2026-08-26

## Interface used

```text
python scripts/review_gate.py freeze --task T-XXXX --output PATH [--root DIR] [--no-git]
python scripts/review_gate.py verify --freeze PATH [--root DIR] [--no-git]
python scripts/review_gate.py validate-review --freeze PATH --review PATH [--root DIR]
```

Python 3.11+. No extra packages. File hashes are SHA-256 of raw bytes, not
Git blob headers.

## Freeze object

| Field | Meaning |
|---|---|
| `schema_version` | `1` |
| `task` | Task id |
| `git_head` | `git rev-parse HEAD`, or `null` in `--no-git` evals |
| `diff_sha256` | SHA-256 of `git diff HEAD` text, or `null` in `--no-git` |
| `files` | Map of POSIX relative paths to hex digest, or `null` if deleted |

## Review object

`verdict`: `PASS` | `CHANGES_REQUIRED`

Each finding: `id`, `severity`, `path`, optional `start_line`,
`evidence_class`, `causality`, `status`.

Fail closed when:

- DETERMINISTIC/INFERRED path is missing from `files` or the file is gone;
- `start_line` is past the frozen file;
- `INSUFFICIENT` is BLOCKER/HIGH;
- `PASS` still has unresolved candidate BLOCKER/HIGH;
- `CHANGES_REQUIRED` has no blocking finding.

## Tests

`bash scripts/run-review-evals.sh`

## Limitations

The gate does not decide whether a locatable finding is a true defect. It does
not call models. Git checks are skipped with `--no-git`.
