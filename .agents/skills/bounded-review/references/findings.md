# Finding and ledger rows

Use this table after freeze. The parent fills it; reviewers do not own it.

| ID | Sev | Path | Evidence | Class | Causality | Status | Action |
|---|---|---|---|---|---|---|---|
| F-001 | HIGH | `file:line` | command or quoted lines | DETERMINISTIC | candidate | open | fix |
| F-002 | HIGH | `file:line` | reasoning only | INFERRED | candidate | corroborated | fix |
| F-003 | HIGH | none | “might exist” | INSUFFICIENT | unknown | dropped | info only |

## Reviewer output

Ask the `reviewer` role for rows with ID, severity (`BLOCKER` / `HIGH` /
`MEDIUM` / `LOW`), location, evidence, class, causality, problem, impact,
minimal direction. End with `VERDICT: PASS` or `VERDICT: CHANGES_REQUIRED`.

## Refuter input

Supply the freeze identity and only inferred BLOCKER/HIGH rows. Ask for
exactly one of `corroborated` | `refuted` | `inconclusive` per ID, with
evidence. No new blocking IDs.

## Persistence

For R2/R3, write under `docs/audits/<task-id>/` using
`tasks/templates/REVIEW_REPORT.md`. Do not store secrets or raw transcripts.
