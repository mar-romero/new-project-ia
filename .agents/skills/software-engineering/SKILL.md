---
name: software-engineering
description: Guide software design, implementation, refactoring, and code review when universal engineering judgment is needed across languages; choose simple, evidence-backed solutions rather than applying patterns by default.
---

# Universal Software Engineering

Produce correct, legible, simple code that fits the existing project. Prefer
evidence over intuition: understand the requested outcome, existing behavior,
conventions, boundaries and applicable checks before changing code. Identify
and verify the minimum required toolchain when the project needs one; do not
invent installation or stack requirements.

Choose the smallest coherent design that meets demonstrated requirements. State
material tradeoffs and assumptions. Add abstractions, patterns, infrastructure
or reuse only when they solve a present problem and reduce total complexity;
repetition alone is not sufficient until its stable shape is clear.

Consider invalid input, failure, retry, ownership, state, side effects and
observability at relevant boundaries. Make a minimal targeted verification
plan before implementation, then run the project's applicable deterministic
checks. Preserve project policy, public contracts and behavior outside scope.

## Route by need

- Read [design and architecture](references/design-and-architecture.md) when
  choosing code boundaries, collaborators, API shape, a composition root, or
  an architectural style. Do not load it for a mechanical local edit.
- Read [quality, testing and security](references/quality-testing-security.md)
  when the task needs validation, tests, error handling, security, release or
  operational decisions. Read only the relevant sections.

Escalate to the project's decision process when a choice has meaningful
switching cost, security impact, irreversible state or recurring cost.
