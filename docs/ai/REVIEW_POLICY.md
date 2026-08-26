# Review Policy

Review tries to falsify a candidate; it is not ceremonial approval. Trust
reproducible tests and static/schema checks before assertions by agents.

The writer of a change is not its final reviewer. Ordinary R1/R2/R3 review
follows `bounded-review`: freeze the candidate, run an independent `reviewer`,
drop findings that cannot be located, refute inferred blocker/high rows, and
limit fixes to corroborated IDs. Judgment Day is an explicit dual-judge
exception, not a second silent pass by the author.

For meaningful R1/R2/R3 work, review the frozen candidate against its task,
acceptance criteria, contracts, actual diff and deterministic evidence. Look
for correctness defects, regressions, hidden assumptions, unsafe input
handling, missing failures and weak tests.

Classify real findings as BLOCKER, HIGH, MEDIUM or LOW. Each must give a
location, evidence, evidence class, impact and minimal remediation direction.
A PASS verdict is valid when the evidence supports it; do not manufacture
criticism and do not treat missing evidence as a defect.

R2/R3 work may require relevant data, security or test specialists. Resolve
corroborated blocker/high findings before completion. Unproven claims fail
closed: they cannot authorize PASS.
