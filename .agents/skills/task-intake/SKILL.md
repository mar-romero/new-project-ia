---
name: task-intake
description: Use when starting a new feature, bug, refactor, investigation, integration, or other work that does not yet have a precise task definition.
---

# Task Intake

Turn a request into a small, verifiable work unit before implementation.
Identify outcome, out-of-scope items, affected areas, R0–R3 risk, invariants,
measurable acceptance criteria, evidence, human gates and minimum agents.

Identify material unresolved technical assumptions separately from ordinary
implementation work. When an assumption could materially change feasibility,
architecture, provider choice, performance expectations or integration shape,
and cannot be resolved reliably from existing code or authoritative sources,
route it through `technical-spike` before committing to implementation.

If understanding requires broad repository reading, use one explorer. Ask the
human only when a missing decision materially affects behavior, security,
architecture, cost, irreversible state or compliance. Otherwise document a
safe, reversible assumption.

Output: outcome, out of scope, risk, relevant areas, invariants, acceptance
criteria, required evidence, agents and human decisions. Do not implement
during intake.
