---
id: T-0009
title: Make the judgment-day skill executable with existing portable roles
status: DONE
risk: R1
created: 2026-08-20
completed: 2026-08-21
---

# T-0009 — Make the judgment-day skill executable with existing portable roles

## Outcome

`judgment-day` is available through every supported provider's documented skill
discovery mechanism and uses only the checked `reviewer` and `implementer`
roles. It exits with `JUDGMENT: ESCALATED` rather than simulating a dual review
when the current runtime cannot provide two fresh, isolated reviewer instances.

## Scope

- Keep `.agents/skills/judgment-day/SKILL.md` as the canonical source.
- Use two fresh instances of `reviewer` and, only after approval, one
  `implementer`.
- Generate the deterministic Claude Code wrapper.
- Treat `_shared/` as a non-invocable support directory.
- Verify the full portable-skill inventory and harness.

## Invariants

- Codex, Cursor, Gemini CLI, OpenCode, and GitHub Copilot consume the canonical
  `.agents/skills/` directory natively; Claude Code receives only its wrapper.
- Judge A/B are audit-ledger labels, not agent configuration names.
- No provider model, role permission, credential, or external state changes are
  required.

## Acceptance Criteria

- [x] `judgment-day` has valid metadata and local references, and uses only
  existing `reviewer` and `implementer` roles.
- [x] The synchronizer creates and verifies the exact Claude wrapper.
- [x] The harness validates all canonical skills and rejects malformed,
  hidden, stale, orphan, or nested wrappers.
- [x] The skill escalates when two isolated, read-only reviewer instances are
  unavailable.
- [x] Independent R1 review found no unresolved high-severity defect.

## Rollback

Revert the commits that added the skill and its portable-role correction. No
provider-side state must be removed.
