# Git Policy

`main` represents accepted state. Develop on one task branch per coherent work
unit, verify it, review it and merge through the repository's chosen process.

Suggested names are `task/T-XXXX-short-description`,
`research/T-XXXX-short-description` and `hotfix/T-XXXX-short-description`.
Use meaningful, small commits such as `feat(api): add request validation` or
`docs(architecture): record storage decision`.

Do not mix unrelated work in one commit or rewrite shared history, force-push
protected branches, or delete protected branches without explicit approval.
The history should explain what changed, why and the verifying evidence; it
must not become a transcript of AI activity.

