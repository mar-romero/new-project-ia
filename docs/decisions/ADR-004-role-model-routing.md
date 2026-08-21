# ADR-004 — Quality-balanced model routing by role

Status: ACCEPTED

Date: 2026-08-20

Related task: T-0007

## Context

The harness has portable roles but most provider adapters inherit the parent
model. The user requested explicit model and reasoning selection per role.
Model catalogs, configuration syntax, entitlements, and reasoning controls
differ by provider and change over time.

## Options considered

### Strongest available model for every role

Maximizes nominal capability but wastes cost and latency on file discovery and
bounded research. Official provider guidance recommends smaller models for
routine tasks and higher effort only where thoroughness has value.

### Inherit or automatic routing everywhere

Most portable and least likely to hit an unavailable model, but does not encode
the requested role specialization and may spend frontier capacity on trivial
work or use a weak parent model for critical review.

### Multiple selectable generated profiles

Could expose budget, balanced, and maximum-quality variants, but adds a
generator, synchronization path, user choices, and test surface before usage
evidence justifies them.

### One quality-balanced checked profile

Selected. Route discovery to fast models, implementation to coding/frontier
models, and high-risk judgment to stronger reasoning. Use native fields only,
document provider fallback/access, and keep rollback to `inherit` simple.

## Decision

Adopt the role matrix in `docs/ai/MODEL_ROUTING.md`. Use rolling Claude aliases
to avoid stale version pins; current explicit IDs where other providers require
them; and no `max`/unbounded effort by default. OpenCode selects the optional
Zen provider because its official catalog is explicitly tested for coding
agents; consumers who do not connect Zen must restore `inherit` or substitute
an available `provider/model-id` verified by `opencode models`.

## Consequences

Critical roles get more capability while exploration remains economical. The
profile can consume paid quota and explicit IDs will age. Provider fallback
means the effective runtime model may differ, so committed metadata is a
starting policy, not an evaluation result or availability guarantee.

## Reversibility and approval

The change is repository-only and reversible. It performs no purchase,
authentication, or provider mutation. Using paid models is an explicit runtime
choice by the developer and remains subject to their plan and organization
policy.
