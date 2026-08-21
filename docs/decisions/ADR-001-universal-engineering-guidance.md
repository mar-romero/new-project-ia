# ADR-001 — Universal engineering guidance

Status: ACCEPTED

Date: 2026-08-20

Related task: T-0002

## Context

The starter needs reusable programming judgment across languages while keeping
always-loaded instructions short. Detailed guidance must improve decisions
without turning optional patterns into default architecture.

## Decision drivers

- correctness and legibility
- simplicity and maintainability
- discoverability across agent tools
- context cost and flexibility
- reversibility

## Options considered

### Option A — Full manual in `AGENTS.md`

Benefits: always loaded.

Costs and risks: high context cost, duplicated or rigid policy, and pressure
to apply unrelated patterns.

Switching cost: low, but future edits affect every task's instruction load.

### Option B — Skill only

Benefits: focused, progressive disclosure.

Costs and risks: an implementation may not activate the skill, so core
engineering priorities could be missed.

Switching cost: low.

### Option C — Short invariant plus detailed portable skill

Benefits: essential priorities are always visible; detailed, conditional
guidance remains discoverable and reusable by compatible tools.

Costs and risks: two linked artifacts must remain aligned.

Switching cost: low; remove the pointers and skill if it proves unhelpful.

## Decision and consequences

Select Option C. Keep a short universal implementation standard in
`AGENTS.md`, and keep design and quality decisions in
`.agents/skills/software-engineering/`. Codex implementers must read the
skill and only the relevant reference(s) before designing, implementing or
refactoring code.

This preserves a shared baseline without mandating classes, layers, interfaces,
DDD, microservices, events, dependency injection, TDD, mocks or abstractions.
It adds a small maintenance obligation: the harness checks the skill's
existence and pointers.

## Reversibility, security and operations

Migration/rollback path: remove the pointers and skill, then remove the
harness checks in one reversible repository change.

Security impact: the guidance reinforces validation, least privilege and safe
error handling; it adds no credentials or external access.

Operating and recurring-cost impact: none.

## Human approval

Required: NO

Decision: Accepted. The user explicitly requested this reversible repository
guidance.
