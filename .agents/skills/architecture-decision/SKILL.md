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

Separate documented facts from assumptions that require empirical validation.
When a material comparison depends on behavior that authoritative sources cannot
establish, use `technical-spike` for the smallest experiment that can resolve
the decision. Do not choose an architecture by treating an untested assumption
as evidence.

Return context, constraints, options with benefits/costs/risks, recommendation
when supported by evidence, reversibility, migration path and any required
human decision. Record accepted decisions as ADRs.
