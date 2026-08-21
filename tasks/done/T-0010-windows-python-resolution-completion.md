# Completion Report — T-0010

## Status

DONE

## Outcome

The harness now passes on Windows Git Bash. Both `scripts/check-harness.sh` and
`scripts/sync-portable-skills.sh` resolve a working Python 3.11+ interpreter
instead of hardcoding `python`, which on this machine was shadowed by the
Microsoft Store alias stub. `HARNESS CHECK PASSED` with all 16 canonical skills
and 7 roles, including the negative self-tests.

## Changed

- `scripts/check-harness.sh`: added `resolve_python()` + `PY`; the two heredoc
  Python invocations (frontmatter and Codex role validation) now use `$PY`.
- `scripts/sync-portable-skills.sh`: added `resolve_python()` + `PY`; the
  metadata-parsing invocation now uses `$PY`.
- `tasks/current/T-0010-windows-python-resolution.md`: task record with
  acceptance criteria, moved to `tasks/done/` on completion.

Resolution order: explicit `PYTHON` override, then a working `python` (probe
`sys.version_info >= (3, 11)`), then `py -3` (probed), then `python3` (probed),
then `python` as a last resort that fails loudly and is counted as an error.

## Acceptance Criteria

- [x] AC-1 — `PORTABLE SKILL SYNC PASSED: 16 skill(s).`
- [x] AC-2 — `HARNESS CHECK PASSED.`
- [x] AC-3 — `--write` regenerated wrappers with no diff in `.claude/skills/`.
- [x] AC-4 — `printf 'print("PY_STDIN_OK")\n' | py -3 -` printed `PY_STDIN_OK`.

## Verification

```text
C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --write
PORTABLE SKILL SYNC PASSED: 16 skill(s).          # no wrapper changed

C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --check
PORTABLE SKILL SYNC PASSED: 16 skill(s).

C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
HARNESS CHECK PASSED.

CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
V2 PERMISSION SELF-TEST PASSED.
PORTABLE SKILL SYNC SELF-TEST PASSED.
FRONTMATTER SELF-TEST PASSED.
HARNESS CHECK PASSED.
```

## Review

Independent review (read-only `general` agent acting as reviewer, since the
configured `reviewer` role model `opencode/gpt-5.6-sol` is not connected)
attempted falsification across call sites, `set -euo pipefail` semantics,
Windows stub rejection, CI regression, failure semantics, determinism and
coverage. Result: `VERDICT: PASS` with only LOW findings. The one cheap
correctness item — version-probing the `py` branch — was applied, and the full
check suite re-passed.

## Residual Risks and Follow-up

- The `reviewer` role model is configured for OpenCode Zen
  (`opencode/gpt-5.6-sol`), which is not connected on this machine. This is a
  provider/model routing issue unrelated to Windows configuration; review was
  performed with the session model instead.
- A `PYTHON` override must be a single token command; values with spaces are
  not documented as supported.
- The `resolve_python` helper is duplicated in both scripts; acceptable at this
  size (drift risk is covered by the harness check that calls both).

## Rollback

Revert the two script edits and the task record. No generated wrapper, role,
permission or provider adapter changed, so no further rollback is required.