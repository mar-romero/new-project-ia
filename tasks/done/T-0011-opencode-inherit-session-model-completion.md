# Completion Report — T-0011

## Status

DONE

## Outcome

The OpenCode subagents no longer pin unavailable OpenCode Zen models. Per
OpenCode V2 documented behavior, a subagent inherits the parent session model
when `model` is omitted, so every `.opencode/agents/` role now launches with
the connected provider's session model instead of failing with
`Model not found: opencode/gpt-5.6-*`. Only `.opencode/` files and the
OpenCode-scoped block of `scripts/check-harness.sh` changed; shared docs and
all other provider adapters stayed untouched per the user's decision.

## Changed

- `.opencode/agents/{explorer,docs-researcher,implementer,planner,reviewer,security-reviewer,test-auditor}.md`:
  removed the `model: opencode/gpt-5.6-*` line. `mode: subagent`, `description`,
  `steps` and the five V2 permission rules are unchanged.
- `scripts/check-harness.sh` (OpenCode block only): `OPENCODE_PROFILE` maps each
  role to `(None, steps)` with a comment explaining session-model inheritance;
  `check_role` builds the expected OpenCode frontmatter without `model` when it
  is None, so a future verified `provider/model` pin is still accepted.
- `tasks/current/T-0011-opencode-inherit-session-model.md`: task record, moved
  to `tasks/done/` on completion.

## Acceptance Criteria

- [x] AC-1 — the `model:` reference to unavailable Zen IDs is removed; OpenCode
  V2 docs confirm inherit behavior. Functional launch needs an opencode session
  restart (agent definitions are cached at session start).
- [x] AC-2 — `HARNESS CHECK PASSED` (normal and `CHECK_HARNESS_SELFTEST=1`).
- [x] AC-3 — `docs/ai/MODEL_ROUTING.md` and
  `docs/sources/contracts/ROLE_MODEL_CONFIGURATION.md` are not modified; README
  retains only pre-existing T-0008 changes.

## Verification

```text
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
HARNESS CHECK PASSED.

CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
V2 PERMISSION SELF-TEST PASSED.
PORTABLE SKILL SYNC SELF-TEST PASSED.
FRONTMATTER SELF-TEST PASSED.
HARNESS CHECK PASSED.

git status --porcelain
docs/ai/MODEL_ROUTING.md  → clean
docs/sources/contracts/ROLE_MODEL_CONFIGURATION.md → clean
```

## Review

Independent read-only review (general agent acting as reviewer, since the
`reviewer` subagent uses the cached pre-change agent definition until the
opencode session restarts) verified the seven agent files, the harness diff
scope, the docs reverts, and the permission-parity checks. Result:
`VERDICT: PASS`. No blocker or high findings.

## Decisions

- User approved (2026-08-20): OpenCode subagents inherit the session model;
  only `.opencode/` plus the OpenCode-scoped harness block may change. Shared
  docs keep describing the Zen default and were intentionally left untouched.

## Residual Risks and Follow-up

- AC-1 functional launch must be confirmed after restarting the opencode
  session; the running session still caches the old agent definition.
- Shared docs still describe pinned Zen models for OpenCode; updating them is
  deferred per user decision.
- Future model pinning must add `model: <provider/model-id>` verified with
  `opencode models` and update `OPENCODE_PROFILE` accordingly.

## Rollback

Restore the `model: opencode/gpt-5.6-*` lines in the seven agent files and
revert the `OPENCODE_PROFILE`/`check_role` OpenCode block in
`scripts/check-harness.sh`. No other file changed, so no further rollback is
required.