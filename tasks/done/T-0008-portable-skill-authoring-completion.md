# Completion Report — T-0008

## Status

DONE

## Outcome

A future skill can now be made portable through one explicit workflow. Its
canonical body lives only at `.agents/skills/<name>/SKILL.md`; Codex, Cursor,
Gemini CLI, OpenCode, and GitHub Copilot discover that location directly. The
synchronizer creates and verifies the thin Claude Code wrapper when the user
chooses all-provider availability.

## Changed

- `.agents/skills/portable-skill-authoring/` and its generated Claude wrapper:
  added an on-demand skill that asks whether portability is wanted, preserves
  one canonical body, then synchronizes and validates it.
- `scripts/sync-portable-skills.sh`: added deterministic `--write`, `--check`,
  and `--self-test` modes. It validates metadata, detects stale, orphan, and
  nested wrappers, rejects symbolic links and non-regular wrappers, and writes
  atomically through a temporary file.
- `scripts/check-harness.sh`: changed skill checks from a fixed inventory to
  discovery of every direct canonical skill while retaining the required
  baseline and exact Claude-wrapper validation.
- `AGENTS.md`, `README.md`, `docs/ai/AGENT_CATALOG.md`,
  `docs/ai/TOOL_COMPATIBILITY.md`, ADR-003, and the provider contract:
  documented the opt-in all-provider authoring path and why Claude alone has a
  generated wrapper.
- `.claude/skills/software-engineering/SKILL.md`: normalized the existing
  wrapper to the same deterministic generated form.

## Acceptance Criteria

- [x] AC-1: a portable-authoring skill supplies the canonical-first workflow.
- [x] AC-2: synchronization creates exact wrappers and rejects missing, stale,
  invalid, orphan, nested, and unsafe wrapper paths.
- [x] AC-3: dynamic discovery accepts added valid skills while the baseline
  remains mandatory.
- [x] AC-4: the user guide explains the command, provider behavior, and
  explicit portability choice.

## Verification

```text
C:\Program Files\Git\bin\bash.exe -n scripts/sync-portable-skills.sh
PASS

C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --write
C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --check
C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --self-test
PORTABLE SKILL SYNC PASSED: 15 skill(s).
PORTABLE SKILL SYNC SELF-TEST PASSED.

C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe -c 'cd scripts && ./check-harness.sh'
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
HARNESS CHECK PASSED.

Canonical and Claude-wrapper quick validation
30 × Skill is valid!

git diff --check and targeted trailing-whitespace search
PASS
```

## Review

Independent R1 review first found a nested-wrapper bypass and then an
Unix symbolic-link overwrite risk. The implementation now rejects non-direct
paths and symbolic links, uses temporary-file replacement, and includes
fixture coverage where symbolic links are supported. Re-review reproduced the
checks and concluded `VERDICT: PASS`.

## Decisions

Portability remains an explicit request from the user for each future skill.
The provider discovery contract is recorded in
`docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`.

## Residual Risks

- The symbolic-link self-test is skipped where the operating system forbids
  creating symbolic links; the runtime path checks still reject them.
- Provider-native discovery remains dependent on the installed CLI version and
  its administrator or account configuration.

## Rollback

Revert the T-0008 files and restore the previous fixed-skill inventory checks.
There is no provider-side account state to remove.

## Follow-up

None required. A future provider that no longer discovers `.agents/skills/`
should receive its own generated adapter only after its current official
contract is verified.
