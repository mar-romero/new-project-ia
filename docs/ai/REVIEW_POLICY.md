# Review Policy

Review tries to falsify a candidate; it is not ceremonial approval. Trust
reproducible tests and static/schema checks before assertions by agents.

For meaningful R1/R2/R3 work, review the frozen candidate against its task,
acceptance criteria, contracts, actual diff and deterministic evidence. Look
for correctness defects, regressions, hidden assumptions, unsafe input
handling, missing failures and weak tests.

Classify real findings as BLOCKER, HIGH, MEDIUM or LOW. Each must give a
location, evidence, impact and minimal remediation direction. A PASS verdict
is valid when the evidence supports it; do not manufacture criticism.

R2/R3 work may require relevant data, security or test specialists. Resolve
blocker/high findings before completion.

