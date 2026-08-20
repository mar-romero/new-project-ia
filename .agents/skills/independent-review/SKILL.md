---
name: independent-review
description: Use when an implementation candidate has passed deterministic checks and requires independent review.
---

# Independent Review

Review independently to find real defects before completion. Receive the task,
acceptance criteria, applicable instructions, relevant specification, frozen
diff and deterministic results—not the implementation conversation.

Try to falsify valid inputs, failure paths, undocumented assumptions,
regressions, external-contract assumptions and test strength. For any relevant
data or calculation, check semantics, ordering, units, precision and
reproducibility. For tests, check that they can fail, assert behavior and
control nondeterminism.

Every real finding needs severity, evidence, problem, impact and minimal
remediation. End with exactly `VERDICT: PASS` or
`VERDICT: CHANGES_REQUIRED`, then residual risks.
