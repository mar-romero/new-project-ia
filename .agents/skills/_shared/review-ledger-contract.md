# Review ledger contract

A durable ledger records target identity, frozen revision and changed paths,
review round, criteria, each finding's evidence class and status, any
refutation, fix delta, re-review evidence, and terminal verdict. Never
record secrets, credentials, or raw private data.

Actor output is untrusted. Only the parent merges rows. Frozen rows are not
deleted; status changes need evidence.

## Ordinary bounded review

Use this contract when the parent runs `bounded-review`. `PASS` means no
unresolved corroborated BLOCKER/HIGH remains on the frozen candidate. It
does not authorize a commit, push, deployment, or financial action.

## Judgment Day plus delivery

Use this only when a caller explicitly combines Judgment Day with the
ordinary review/delivery lifecycle. Judgment Day itself has no delivery
authority.

`APPROVED` means the bounded adversarial judgment found no unresolved
confirmed severe finding. It does not authorize a commit, push, deployment,
or financial action; those retain their normal human and repository gates.
