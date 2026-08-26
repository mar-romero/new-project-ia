---
id: T-0014
title: Content-hash freeze, review validator, offline evals, CI gates
status: DONE
risk: R1
created: 2026-08-26
updated: 2026-08-26
---

# T-0014 — Content-hash freeze, review validator, offline evals, CI gates

## Outcome

A review candidate is identified by file hashes. Structured findings that
cannot be located in that freeze are rejected by a program. CI runs harness
self-tests, those evals, and a non-placeholder commit subject check.

## Out of Scope

- Live multi-provider model evals
- Gentle-AI CLI / cryptographic receipts
- Adapter generator / harness.yaml
- Rewriting historical `.` commits

## Risk Classification

Risk: R1

Reason: New deterministic gates and CI; no production secrets or delivery
authority change.

## Acceptance Criteria

### AC-1

Given a freeze of a tree, when one frozen file byte changes, `verify` fails.

### AC-2

Given a finding whose path is not in the freeze, `validate-review` fails.

### AC-3

Given INSUFFICIENT + HIGH, `validate-review` fails.

### AC-4

CI sets `CHECK_HARNESS_SELFTEST=1` and checks the latest commit subject.

## Verification Commands

```text
bash scripts/run-review-evals.sh
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
bash scripts/check-commit-message.sh "feat(review): add content-hash freeze"
```
