---
name: implementation-loop
description: Use when a scoped and accepted task is ready to be implemented.
---

# Implementation Loop

Implement a task with the smallest coherent and verifiable change.

## Before Coding

Read only:

1. the active task;
2. root AGENTS.md;
3. closest local AGENTS.md if one exists;
4. relevant specification if required;
5. relevant source files;
6. this skill.

Do not preload unrelated repository documentation.

## Implementation

Use one implementation agent as the default writer.

The implementer must:

1. understand acceptance criteria;
2. identify existing behavior;
3. make the smallest coherent change;
4. add or update tests;
5. avoid unrelated refactors;
6. preserve existing behavior outside task scope.

## Cheap Verification First

Before requesting AI review, run applicable deterministic checks:

1. formatter/check;
2. lint;
3. type/static analysis;
4. unit tests;
5. schema/contract checks;
6. targeted integration tests.

Do not spend reviewer tokens on code that already fails deterministic checks.

## Runtime Verification When Relevant

When the task changes a user-visible web flow and a runnable application is
available, use `web-dogfood` after deterministic checks for the affected flow.

Treat confirmed BLOCKER or HIGH dogfood findings like failed verification:
correct them and rerun the relevant deterministic and runtime checks before
freezing the review candidate.

Do not require web dogfooding for changes without a relevant runnable user
interface.

## Candidate Freeze

Once deterministic checks pass:

1. inspect the diff;
2. identify changed files;
3. avoid source-mutating tools;
4. treat those bytes as the review candidate.

If code changes after review, the relevant review must be repeated.

## Independent Review

Invoke an independent reviewer using:

- task;
- acceptance criteria;
- relevant rules;
- frozen diff;
- test evidence.

Do not give the reviewer the complete implementer conversation.

## Fix Cycle

If reviewer returns BLOCKER or HIGH findings:

1. return findings to implementer;
2. make targeted fixes;
3. rerun relevant deterministic checks;
4. rerun independent review.

Maximum total review/fix cycles:

2

If important findings remain after two cycles:

STOP.

Report the unresolved issue instead of continuing indefinitely.

## Completion

A successful implementation must report:

### Changed
Files changed and why.

### Verified
Exact commands/checks and results.

### Review
Independent review verdict.

### Residual risks
Known remaining limitations.

### Decision needed
Only when human input is genuinely required.

Never self-declare success without evidence.