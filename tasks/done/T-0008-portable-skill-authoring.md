---
id: T-0008
title: Portable skill authoring and adapter synchronization
status: DONE
risk: R1
created: 2026-08-20
completed: 2026-08-20
---

# T-0008 — Portable skill authoring and adapter synchronization

## Outcome

An agent or developer can create one canonical project skill and, when the user
explicitly chooses portability, make it available to all supported providers by
generating and verifying the required Claude adapter.

## Why

Adding a skill currently requires remembering that five providers discover
`.agents/skills/` directly while Claude Code requires a wrapper. The workflow
must be discoverable, deterministic, and safe for future agents to use.

## Out of Scope

- Writing the domain content of a particular future skill.
- Adding provider-global skills, credentials, plugins, or billing.
- Generating role adapters; this task covers skills only.

## Context and Relevant Files

- `.agents/skills/`: canonical shared skills.
- `.claude/skills/`: Claude Code wrappers.
- `scripts/check-harness.sh`: baseline and adapter validation.
- `README.md`: user-facing onboarding.

## Sources / Contracts

- `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`
- `docs/sources/contracts/NATIVE_AGENT_PARITY.md`

## Risk Classification

Risk: R1

Reason: the change automates repository configuration used by several coding
providers. Incorrect generation could silently leave a provider without a skill.

## Invariants and Failure Cases

- `.agents/skills/<name>/SKILL.md` remains the only canonical skill content.
- Claude wrappers must exactly import their canonical counterpart.
- Existing required skills remain required; additional valid canonical skills are
  allowed and must receive Claude wrappers.
- A user must explicitly request all-provider portability; otherwise the authoring
  workflow asks whether the skill should be portable or provider-specific.
- Invalid names, missing metadata, stale wrappers, and orphan wrappers fail checks.

## Acceptance Criteria

### AC-1 — Portable authoring skill

Given: an agent receives a request to create a reusable skill.

When: the user chooses all-provider portability.

Then: the new `portable-skill-authoring` skill directs the agent to create
canonical content, generate adapters, and verify the result without inventing
provider-specific copies.

Evidence: canonical skill and Claude wrapper validate.

### AC-2 — Synchronization

Given: a valid canonical skill exists.

When: `scripts/sync-portable-skills.sh --write` runs.

Then: it creates or refreshes the matching Claude wrapper; `--check` rejects a
missing, stale, invalid, or orphan wrapper.

Evidence: positive and negative temporary-fixture self-test.

### AC-3 — Harness behavior

Given: the baseline skills plus a future valid canonical skill.

When: the harness runs after synchronization.

Then: it accepts the additional skill and validates every canonical/Claude pair,
while still rejecting removal of a baseline skill.

Evidence: dynamic discovery validation and harness self-test.

### AC-4 — Documentation

Given: a new contributor or supported agent.

When: they read the README or invoke the authoring skill.

Then: they can choose portability, create a skill, synchronize it, and understand
why only Claude needs a generated wrapper.

Evidence: documented command and linked skill.

## Test Requirements

- [x] unit: deterministic sync-script self-test
- [x] integration: root and alternate-CWD harness checks
- [x] contract/schema: strict frontmatter validation
- [ ] property/golden/replay
- [ ] security

## Agent Plan and Skills

- `task-intake`: scope and acceptance criteria.
- `implementation-loop`: implementation and evidence.
- `skill-creator`: concise, discoverable canonical authoring skill.
- `independent-review`: R1 candidate review after deterministic checks.

## Human Decisions

None. Portability is an explicit per-skill choice by the requesting user.

## Implementation Plan

1. Add a canonical portable-skill-authoring skill and Claude wrapper.
2. Add a deterministic synchronizer with check, write, and self-test modes.
3. Make harness skill discovery dynamic while retaining baseline requirements.
4. Document the flow and validate it.

## Verification Commands

```text
bash scripts/sync-portable-skills.sh --check
bash scripts/sync-portable-skills.sh --self-test
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
```
