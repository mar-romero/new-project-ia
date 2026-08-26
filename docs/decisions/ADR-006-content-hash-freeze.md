# ADR-006 — Content-hash freeze and structured review validation

Status: ACCEPTED

Date: 2026-08-26

Related task: T-0014

## Context

Bounded review froze candidates as `HEAD` plus a changed-path list. That
identity does not change when file bytes change in a dirty worktree. Reviewer
output was Markdown the parent had to trust.

## Decision drivers

- fail closed on invented paths
- no Gentle-AI binary or extra Python packages
- cheap CI, no live model evals
- reversibility

## Options considered

### Keep HEAD + paths

Rejected: the same identity can name different bytes.

### Import Gentle-AI receipts / CAS

Rejected in T-0013; still a runtime dependency.

### Content-hash freeze plus in-repo JSON validation

Selected. `scripts/review_gate.py` hashes candidate files, verifies them, and
rejects structured findings whose paths/lines are not in the freeze.
`INSUFFICIENT` cannot be BLOCKER/HIGH. Offline fixtures under `evals/reviewer/`
prove the validator, not model quality.

## Decision and consequences

Ordinary R1–R3 review must write `freeze.json`, verify it before close, and
pass `validate-review` on JSON. Markdown remains human-readable notes, not
the gate. Live multi-provider evals stay out of scope.

## Reversibility, security and operations

Rollback: revert T-0014 files. No credentials. CI time grows by harness
self-tests plus four local eval cases.

## Human approval

Required: NO

Decision: Accepted. The user asked for freeze, offline evals, CI self-tests,
and commit-subject checks.
