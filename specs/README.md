# Specifications

A specification defines the expected behavior of complex or high-risk work
before implementation. It describes the capability, non-goals, inputs,
outputs, invariants, failure behavior, security constraints and acceptance
criteria; it is not implementation history.

Create one for R2/R3 work, cross-module behavior, durable external contracts,
schemas or migrations. Small, isolated R0/R1 tasks usually need only a task
record.

Several tasks may implement one specification. Do not silently change an
accepted specification to fit incorrect code; explicitly revise it when the
behavior intentionally changes.

