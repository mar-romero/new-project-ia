---
name: work-unit-commits
description: Use when splitting implementation work into commits or deciding what belongs in a reviewable commit or pull request.
---

# Work Unit Commits

Each commit should provide one coherent, reviewable outcome, with its relevant
tests and required documentation. Do not organize commits only by file type or
mix unrelated changes.

Before committing verify clear purpose, contained scope, applicable checks,
documentation, understandable rollback and a known task. Prefer meaningful
messages such as `feat(api): add request validation` or
`fix(parser): reject malformed input`.

If work grows too large, identify independently testable behavioral slices but
do not split into broken or meaningless intermediate states.
