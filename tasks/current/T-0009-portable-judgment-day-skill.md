---
id: T-0009
title: Make the judgment-day skill executable with existing portable roles
status: IN_PROGRESS
risk: R1
created: 2026-08-20
---

# T-0009 — Synchronize the judgment-day skill for supported providers

## Outcome

Make `judgment-day` available and executable through every supported provider's
documented project discovery mechanism. The skill must use the existing
portable `reviewer` and `implementer` roles rather than referring to undefined
agent profiles.

## Scope

- Update `.agents/skills/judgment-day/SKILL.md` to launch two fresh instances
  of the existing `reviewer` role and, only after approval, one `implementer`.
- Require a runtime-capability preflight and an `ESCALATED` outcome when two
  isolated reviewer instances cannot be demonstrated.
- Generate its deterministic Claude Code wrapper.
- Treat `_shared/` as a non-invocable shared-resource directory rather than a
  malformed portable skill.
- Verify the full portable-skill inventory and harness.

## Invariants

- The canonical skill remains the sole source of instructions.
- Codex, Cursor, Gemini CLI, OpenCode, and GitHub Copilot consume the
  canonical `.agents/skills/` directory natively.
- Claude Code receives only the generated thin wrapper.
- Judge A/B are ledger labels only, not ad-hoc agent profiles.
- No provider model, agent role, permission, credential, or external state
  changes are in scope.

## Acceptance Criteria

1. `judgment-day` has valid canonical skill metadata and required local
   references, and refers only to the existing `reviewer` and `implementer`
   roles.
2. The synchronizer creates an exact `.claude/skills/judgment-day/SKILL.md`
   wrapper and detects drift.
3. The harness and applicable skill validation pass with 16 canonical skills
   and 16 Claude wrappers; `_shared/` remains a non-invocable support folder.
   Hidden or malformed direct skill directories must fail synchronization.
4. The skill exits with `JUDGMENT: ESCALATED` when the current runtime cannot
   provide two fresh, isolated, read-only reviewer instances.
5. An independent R1 review finds no unresolved high-severity defect.

## Verification

```text
bash scripts/sync-portable-skills.sh --write
bash scripts/sync-portable-skills.sh --check
bash scripts/check-harness.sh
```

## Rollback

Remove only the generated Claude wrapper if portability must be withdrawn; the
user-created canonical skill remains unchanged unless the user requests its
removal.
