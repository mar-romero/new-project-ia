# ADR-005 — Portable bounded review without the Gentle-AI runtime

Status: ACCEPTED

Date: 2026-08-26

Related task: T-0013

## Context

Review agents invent defects, approve their own work, drop findings, or
expand a fix beyond the finding list. Gentle-AI encodes a stronger review
lifecycle in a native Go engine. This starter already chose static adapters
over a configurator (ADR-003) and already runs Judgment Day on existing
`reviewer` / `implementer` roles (T-0009).

## Decision drivers

- correctness of review (no invented findings, no self-approval)
- no new runtime, credentials, or delivery authority
- reversibility and harness-checkable files
- token cost (do not spawn four lenses or a new role by default)

## Options considered

### Option A — Require the Gentle-AI CLI

Benefits: cryptographic freeze, native receipts, gates.

Costs and risks: installer, binary, provider bindings, and a second
authority next to this harness. Contradicts the static-starter boundary.

Switching cost: high.

### Option B — Add `review-refuter` and four lens roles

Benefits: closer role names to Gentle-AI 4R.

Costs and risks: six-provider adapter explosion; Judgment Day harness
explicitly forbids `review-refuter` / `jd-*` names; extra tokens.

Switching cost: medium.

### Option C — Portable protocol on existing seven roles

Benefits: freeze, fail-closed, ledger, second-instance refutation, bounded
fix; works after clone with `check-harness.sh`.

Costs and risks: independence is best-effort when the runtime cannot launch
a fresh reviewer; no cryptographic receipt.

Switching cost: low.

## Decision and consequences

Select Option C. Add skill `bounded-review` as the ordinary review
orchestrator. Keep `independent-review` as the reviewer actor contract and
`judgment-day` as the explicit dual-judge exception. Map “receipt” to the
task review/completion reports. Delivery stays with ordinary git and CI
policy.

## Reversibility, security and operations

Rollback: revert the skill, policy, and harness inventory entries.

Security impact: none beyond existing read-only reviewer permissions.

Operating and recurring-cost impact: extra reviewer instance only when
inferred severe findings exist.

## Human approval

Required: NO

Decision: Accepted. The user asked to land this anti-hallucination review
model in the repository without adding Gentle-AI as a runtime.
