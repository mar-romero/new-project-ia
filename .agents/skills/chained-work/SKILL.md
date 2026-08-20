---
name: chained-work
description: Use when a task or pull request becomes too large for effective review and can be divided into independently reviewable work units.
---

# Chained Work

Split large work only when doing so improves reviewability without breaking
coherence. Treat roughly 400 authored changed lines as a prompt to evaluate
review burden, not a rigid limit.

Split when units have separate behavior, tests, rollback boundaries and a
clear dependency order. Do not split if intermediate states would be broken,
tests would be separated from behavior or temporary interfaces would add risk.

Return whether a chain is required, why, the independent work units,
dependencies, verification per unit and rollback boundaries.
