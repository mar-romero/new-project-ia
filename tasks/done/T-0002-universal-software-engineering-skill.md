---
id: T-0002
title: Universal software engineering skill
status: DONE
risk: R1
created: 2026-08-20
updated: 2026-08-20
---

# T-0002 — Universal software engineering skill

## Outcome

Codex implementers receive portable, decision-oriented engineering guidance
that improves correctness, legibility, simplicity and justified reuse across
languages without prescribing a framework or architecture.

## Why

The harness governs how work is performed; implementers also need concise
guidance for making sound design and implementation choices.

## Out of Scope

- Language- or framework-specific practices.
- Application code, dependencies, tool installation instructions or a
  mandatory architecture pattern.
- Copying the full guidance into every tool adapter.

## Context and Relevant Files

- `AGENTS.md` supplies the always-on project standard.
- `.agents/skills/software-engineering/` is the portable canonical detail.
- `.codex/agents/implementer.toml` is the Codex-specific implementation hook.

## Sources / Contracts

- None. This task records repository engineering policy rather than an
  external runtime contract.

## Risk Classification

Risk: R1

Reason: The guidance affects future implementation decisions across the
repository, but is reversible documentation and configuration with no external
side effects.

## Invariants and Failure Cases

- Correctness, legibility and simplicity take priority over pattern adoption.
- Guidance must remain universally applicable and conditional on demonstrated
  requirements.
- Agents must be able to discover the canonical skill without duplicating its
  detailed policy in `AGENTS.md`.

## Acceptance Criteria

### AC-1

Given an agent designs, implements, refactors or reviews code,

When the task needs engineering judgment beyond the short project invariant,

Then it can discover concise, universal guidance and only load the relevant
design and/or quality reference(s).

Evidence: validated skill frontmatter and reference routing.

### AC-2

Given a Codex implementer starts a code change,

When it reads its role instructions and root instructions,

Then both point to the same canonical software-engineering skill and require
the simplest coherent, evidence-backed implementation.

Evidence: harness content checks.

### AC-3

Given the starter harness is checked,

When the skill or its essential references and pointers are absent,

Then the check fails.

Evidence: `scripts/check-harness.sh`.

## Test Requirements

- [ ] unit
- [ ] integration
- [x] contract/schema
- [ ] property/golden/replay
- [ ] security

## Agent Plan and Skills

- One implementation writer owns all edits.
- Use `implementation-loop`, `skill-creator`, `architecture-decision` and
  `cognitive-doc-design`.
- Run deterministic checks, freeze the candidate, then request independent
  review.

## Human Decisions

None. The user explicitly requested this reversible guidance structure.

## Implementation Plan

1. Record the hybrid always-on invariant plus detailed-skill decision.
2. Add the portable skill and focused design and quality references.
3. Point root and Codex implementer instructions at the canonical source.
4. Extend the portable harness and README, then validate and review.

## Verification Commands

```text
python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .agents\skills\software-engineering
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
git diff --check
```
