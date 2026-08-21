---
id: T-0010
title: Resolve a working Python interpreter in harness scripts on Windows
status: DONE
risk: R1
created: 2026-08-20
---

# T-0010 — Resolve a working Python interpreter in harness scripts on Windows

## Outcome

`scripts/check-harness.sh` and `scripts/sync-portable-skills.sh` locate a real
Python 3.11+ interpreter on Windows Git Bash (where the Microsoft Store
`python` alias shadows a real install) while behaving unchanged on macOS, Linux
and CI.

## Why

On Windows, Git Bash resolves `python` to the WindowsApps Store stub, which
prints an error and exits non-zero. The harness then reports every
Python-dependent check as failed (`HARNESS CHECK FAILED: 9 problem(s).`) even
though Python 3.12 is installed. The scripts hardcode `python`, so there is no
way to point them at a working interpreter.

## Out of Scope

- Installing Python or disabling the WindowsApps alias on the user machine.
- Changing role bodies, skills, permissions, model profiles or provider
  adapters.
- Changing the generated Claude wrappers or any canonical skill content.
- CI workflow changes (must keep working unchanged).

## Context and Relevant Files

- `scripts/check-harness.sh`: calls `python` at two sites (frontmatter
  validation and Codex role validation).
- `scripts/sync-portable-skills.sh`: calls `python` at one site (skill metadata
  parsing).
- Real interpreter available: `C:\Users\romer\AppData\Local\Programs\Python\Python312\python.exe`
  and via the `py` launcher (`py -3`), which reads scripts from stdin.

## Risk Classification

Risk: R1

Reason: internal tooling change with deterministic checks; no external
contract, persistence or security surface. Blast radius limited to the two
harness scripts.

## Invariants and Failure Cases

- Wrapper generation must remain byte-identical: Python is used only to read
  metadata; rendering is done by `printf` in bash, so interpreter choice cannot
  change output.
- Resolution order must prefer an explicit `PYTHON` override, then a working
  `python`, then the `py` launcher, then `python3`. All candidates must be
  real (>= 3.11) where possible so `tomllib` works.
- If no Python is found, scripts must still fail with a clear, counted error,
  not a silent success.

## Acceptance Criteria

### AC-1

Given a Windows Git Bash session, when `bash scripts/sync-portable-skills.sh --check` runs,
then it passes without using the Store stub.

Evidence: command output `PORTABLE SKILL SYNC PASSED`.

### AC-2

Given the same environment, when `bash scripts/check-harness.sh` runs,
then it passes with all 16 canonical skills and 7 roles valid.

Evidence: command output `HARNESS CHECK PASSED`.

### AC-3

Given the repository, when `bash scripts/sync-portable-skills.sh --write` runs and `git diff` is inspected,
then no generated wrapper changes (output stays deterministic).

Evidence: empty diff for `.claude/skills/`.

### AC-4

Given the resolver, when a Python detection self-test is performed,
then `py -3` reading a script from stdin works as a fallback path.

Evidence: `printf 'print("PY_STDIN_OK")\n' | py -3 -` printed `PY_STDIN_OK`.

## Test Requirements

- [x] integration
- [ ] unit
- [ ] contract/schema
- [ ] property/golden/replay
- [ ] security

## Agent Plan and Skills

- `implementer` with `software-engineering` skill.
- `reviewer` for independent R1 review.

## Human Decisions

None. Change is reversible and local to the scripts.

## Implementation Plan

1. Add a `resolve_python` helper and `PY="$(resolve_python)"` to both scripts.
2. Replace the three hardcoded `python` invocations with `$PY`.
3. Run `--write` then `--check` for skill sync.
4. Run `check-harness.sh` (and selftest) to confirm pass.

## Verification Commands

```text
bash scripts/sync-portable-skills.sh --write
bash scripts/sync-portable-skills.sh --check
bash scripts/check-harness.sh
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
printf 'print("PY_STDIN_OK")\n' | py -3 -
```