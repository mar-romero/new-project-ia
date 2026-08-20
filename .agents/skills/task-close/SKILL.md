---
name: task-close
description: Use after implementation and all applicable validation/review gates have completed and a task may be marked done.
---

# Task Close

A task is not done merely because code was written.

## Final checks

Confirm applicable:

- acceptance criteria satisfied;
- deterministic checks pass;
- tests pass;
- integration/contract checks pass;
- independent review completed;
- no unresolved BLOCKER/HIGH;
- domain review completed;
- human decisions resolved;
- documentation updated;
- no secrets introduced.

## Completion report

Record:

### Outcome

What was achieved.

### Changed

For every meaningful changed file:

- what changed;
- why.

### Evidence

Exact verification commands and results.

### Reviews

- reviewer verdict;
- domain-review verdicts.

### Decisions

Human decisions or ADR references.

### Residual risks

Known limitations that remain.

### Rollback

How to safely revert.

### Follow-up

Future work that is explicitly out of this task.

Do not include raw agent conversations.

After completion:

move/archive the task according to repository workflow.

Do not mark DONE if required evidence is missing.