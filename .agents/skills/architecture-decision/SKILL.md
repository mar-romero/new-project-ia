---
name: architecture-decision
description: Use when choosing between materially different architectures, databases, providers, protocols, frameworks or other durable technical decisions with meaningful switching cost.
---

# Architecture Decision

Evaluate only durable, cross-cutting, externally constrained or
security-sensitive decisions. Do not create an ADR for trivial details.

Compare viable options for correctness, complexity, operational burden, cost,
performance, observability, testability, security, reversibility and lock-in.
Prefer the smallest solution that meets demonstrated requirements; do not add
infrastructure for speculative scale.

Return context, constraints, options with benefits/costs/risks, recommendation
when supported by evidence, reversibility, migration path and any required
human decision. Record accepted decisions as ADRs.
