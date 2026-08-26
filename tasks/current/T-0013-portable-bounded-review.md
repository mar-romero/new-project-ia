---
id: T-0013
title: Portable bounded review without Gentle-AI runtime
status: IN_PROGRESS
risk: R1
created: 2026-08-26
updated: 2026-08-26
---

# T-0013 — Portable bounded review without Gentle-AI runtime

## Outcome

Agents in this starter freeze a candidate, record findings in a durable
ledger, fail closed on missing evidence, and cannot self-approve or invent
defects. Ordinary review uses existing `reviewer` instances; Judgment Day
remains the explicit dual-judge exception.

## Why

Review hallucinations (false findings, disappearing rows, unbounded fixes,
author-as-judge) are an operating-model defect. Gentle-AI's native Go review
engine is out of scope; the portable contract still belongs in this repo.

## Out of Scope

- Installing, wrapping, or requiring the `gentle-ai` CLI
- Cryptographic receipt gates, content-addressed blob stores, or pre-commit
  hooks that invoke agents
- An eighth role such as `review-refuter` or `jd-judge`
- Copying Gentle-AI SDD orchestrators or provider-specific Go bindings

## Context and Relevant Files

- `.agents/skills/independent-review/SKILL.md`
- `.agents/skills/implementation-loop/SKILL.md`
- `.agents/skills/judgment-day/SKILL.md`
- `.agents/skills/_shared/review-ledger-contract.md`
- `docs/ai/REVIEW_POLICY.md`
- `docs/ai/AGENT_CATALOG.md`

## Sources / Contracts

- `docs/sources/contracts/GENTLE_AI_BOUNDED_REVIEW.md`

## Risk Classification

Risk: R1

Reason: Operating-model and documentation change for review; no production
secrets, delivery authority, or runtime binary.

## Invariants and Failure Cases

- The implementer is never the final reviewer of its own candidate.
- Unproven claims cannot authorize PASS.
- Findings cannot vanish from a frozen ledger.
- Fixes may touch only corroborated severe IDs.
- Judgment Day must not reference `review-refuter` or `jd-*` agents.

## Acceptance Criteria

### AC-1

Given a frozen R1 candidate
When the parent runs ordinary review
Then it follows `bounded-review`: freeze identity, independent reviewer,
optional refuter instance, bounded fix, fail-closed close

Evidence: skill, implementation-loop pointer, REVIEW_POLICY

### AC-2

Given an inferred BLOCKER/HIGH without corroboration
When a refuter run is required
Then a fresh `reviewer` instance is used; missing evidence drops the finding

Evidence: bounded-review skill and ledger contract

### AC-3

Given the portable inventory
When the harness and skill sync run
Then the new skill has a Claude wrapper and `check-harness.sh` passes

Evidence: exact command results

## Test Requirements

- [x] contract/schema (harness + portable skill sync)
- [ ] unit
- [ ] integration
- [ ] property/golden/replay
- [ ] security

## Agent Plan and Skills

Parent implements. Skills: `portable-skill-authoring`, `source-research`,
`grounded-evidence`, `architecture-decision`, `independent-review`.

## Human Decisions

None. Do not add a Gentle-AI binary dependency.

## Implementation Plan

1. Record the Gentle-AI source contract and ADR (port the contract, not the
   runtime).
2. Add `bounded-review` and tighten reviewer / independent-review / ledger.
3. Point the implementation loop and catalog at the new protocol.
4. Sync wrappers and run the harness.

## Verification Commands

```text
bash scripts/sync-portable-skills.sh --write
bash scripts/sync-portable-skills.sh --check
bash scripts/check-harness.sh
```
