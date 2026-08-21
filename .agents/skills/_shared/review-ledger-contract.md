# Review ledger contract

Use this only when a caller explicitly combines Judgment Day with the ordinary
review/delivery lifecycle. Judgment Day itself has no delivery authority.

A durable ledger records target identity, frozen revision, review round,
criteria, each finding's evidence and status, fix delta, re-judgment evidence,
and terminal verdict. Never record secrets, credentials, or raw private data.

`APPROVED` means the bounded adversarial judgment found no unresolved confirmed
severe finding. It does not authorize a commit, push, deployment, or financial
action; those retain their normal human and repository gates.
