---
id: T-0011
title: Make OpenCode subagents work with the connected provider and keep flows/skills
status: DONE
risk: R1
created: 2026-08-20
---

# T-0011 — Make OpenCode subagents work with the connected provider

## Outcome

Every `.opencode/agents/` subagent launches and runs with the model the session
uses, instead of failing with `Model not found: opencode/gpt-5.6-*` (OpenCode
Zen is not connected). Role bodies, permissions, steps and skill access stay
unchanged, so the harness contract and repository flows remain valid.

## Why

The OpenCode adapters pin `model: opencode/gpt-5.6-{luna,terra,sol}` (Zen). The
connected provider does not expose those IDs; invoking any subagent fails at
launch (confirmed with the `reviewer` role). OpenCode V2 documents that a child
session uses its subagent's configured model or inherits the parent session's
model when none is configured. ADR-004 already sanctions restoring `inherit`
when Zen is not connected, and this project's policy forbids guessing the
capability tiers of unverified `opencode-go/*` catalog models.

## Out of Scope

- Connecting OpenCode Zen or purchasing credits.
- Changing role bodies, permissions, skills or the five permission rules the
  harness enforces for OpenCode agents.
- Choosing specific `opencode-go/*` model IDs per role without an evaluation.
- Modifying shared documentation (`README.md`, `docs/ai/MODEL_ROUTING.md`,
  `docs/sources/contracts/ROLE_MODEL_CONFIGURATION.md`, ADR-004): the user
  decided these core files stay untouched; the only non-`.opencode/` change is
  the OpenCode-scoped profile block in `scripts/check-harness.sh`.
- Creating the `jd-judge-a`/`jd-judge-b`/`jd-fix-agent` agents that the
  `judgment-day` skill references (reported separately).

## Context and Relevant Files

- `.opencode/agents/{explorer,docs-researcher,implementer,planner,reviewer,security-reviewer,test-auditor}.md`
- `scripts/check-harness.sh`: `OPENCODE_PROFILE` and `check_role` (OpenCode
  block only; Codex/Claude/Cursor/Gemini/Copilot checks untouched).

## Risk Classification

Risk: R1

Reason: metadata-only change plus the harness expectation that must stay in
sync. Reversible, no external contract or security surface.

## Invariants and Failure Cases

- Frontmatter must keep exactly `description`, `mode: subagent`, `steps` and the
  five V2 permission rules; only `model` is removed.
- The harness must not drift: `OPENCODE_PROFILE` and `check_role` must accept a
  missing `model` and still require `steps`.
- If a future maintainer pins a model, the harness must accept it again via the
  same profile mechanism.
- No other provider adapter changes.

## Acceptance Criteria

### AC-1

Given a connected provider without Zen, when any `.opencode/agents/` subagent is
launched, then it runs (inherits the session model) instead of `Model not found`.

Evidence: reviewer subagent invocation succeeds.

### AC-2

Given the repository, when `bash scripts/check-harness.sh` runs, then it passes
with the updated OpenCode profile.

Evidence: `HARNESS CHECK PASSED`.

### AC-3

Given the repository, when `git diff` of `README.md`, `docs/ai/MODEL_ROUTING.md`
and `docs/sources/contracts/ROLE_MODEL_CONFIGURATION.md` is inspected, then no
T-0011 change appears there (shared docs remain byte-identical to their
pre-task state).

Evidence: no diff attributable to T-0011 in those files.

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

- User approved (2026-08-20): OpenCode subagents inherit the session model, and
  only `.opencode/` plus the OpenCode-scoped harness block may change. Shared
  docs and non-OpenCode adapters must stay untouched.

## Implementation Plan

1. Remove `model:` from the seven OpenCode agent frontmatters.
2. Update `OPENCODE_PROFILE` and `check_role` to require `steps` and accept no
   `model` (or a pinned one), touching only the OpenCode block.
3. Revert the previously staged README/docs edits per the user decision.
4. Run harness, sync and selftest; independent review.

## Verification Commands

```text
bash scripts/check-harness.sh
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
bash scripts/sync-portable-skills.sh --check
```