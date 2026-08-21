# Judgment Day formats

Read this reference only after the target is frozen.

## Judge prompt

Give both judges the identical target identity, acceptance criteria, applicable
repository rules, frozen changed files/diff, deterministic evidence, and the
same relevant skill paths. Do not give either judge the other judge's findings
or the implementation conversation.

Ask each judge to return a table with: ID, severity, evidence, problem,
impact, and minimal direction. Severity is `SEVERE` only when the target cannot
be accepted without correction; otherwise use `WARNING` or `SUGGESTION`.

## Merged ledger

The parent writes one immutable ledger per round:

| ID | Judge A | Judge B | Status | Action |
|---|---|---|---|---|
| JD-001 | SEVERE | SEVERE | confirmed | ask before fix |
| JD-002 | WARNING | none | suspect | record only |

Only matching severe findings are confirmed. Semantically conflicting severe
findings require human escalation instead of inference by the parent.

## Re-judgment input

Supply only the previous frozen ledger, the immutable fix delta, and relevant
fresh deterministic evidence. Judges may record defects caused by the fix but
must not reopen unrelated scope.
