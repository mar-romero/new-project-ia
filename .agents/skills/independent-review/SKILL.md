---
name: independent-review
description: Use when acting as the reviewer actor on a frozen candidate (not as the parent orchestrator). Falsify the diff with locatable evidence; do not invent findings.
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

Report only findings you can locate in the frozen candidate or its checks.
Classify evidence as DETERMINISTIC, INFERRED or INSUFFICIENT. Do not report
INSUFFICIENT rows as defects. Stay inside the stated scope. Do not invent
APIs, paths, test results or missing files.

Every real finding needs severity, location, evidence, evidence class,
causality, problem, impact and minimal remediation. End with exactly
`VERDICT: PASS` or `VERDICT: CHANGES_REQUIRED`, then residual risks.
