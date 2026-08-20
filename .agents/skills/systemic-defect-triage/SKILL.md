---
name: systemic-defect-triage
description: Use when investigating bugs, repeated failures, related defects or several symptoms that may share one root cause.
---

# Systemic Defect Triage

Treat a reported cause as a hypothesis. Reproduce the failure where practical,
identify the broken invariant and locate the actual mechanism before patching.

Classify it as already fixed, duplicate root cause, new defect, feature request
or insufficient evidence. Cluster symptoms that share the same mechanism and
prefer one root correction plus proving tests over separate symptom patches.

Return classification, symptom, reproduction, failed invariant, root cause,
dependent surfaces, minimal fix shape, proving tests and residual unknowns.
