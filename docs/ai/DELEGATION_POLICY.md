# Delegation Policy

Delegate only when it reduces context, creates independent verification or
allows truly independent work. More agents do not automatically improve
correctness.

Use an explorer for broad repository mapping, a researcher for mutable
external contracts, one writer for a scoped implementation and an independent
reviewer after deterministic checks. Add a domain specialist only when the
task risk requires it.

Never assign two writers to overlapping files. Before review, freeze the
candidate: formatter/checks complete, HEAD and changed files recorded, and
diff inspected. Give reviewers requirements, acceptance criteria, relevant
rules, the frozen identity, the diff and test evidence—not the full
implementation conversation.

Limit normal review/fix cycles to two. If material evidence remains unresolved,
stop and request a human decision. The parent, not the writer, owns the
review ledger.

