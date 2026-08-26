# Source Contract — Gentle-AI bounded review (portable subset)

Provider: Gentleman-Programming / gentle-ai

Purpose: Import only the operating rules that prevent review hallucination
into this static starter. Do not depend on the Gentle-AI binary.

Status: VERIFIED for the subset below

Date verified: 2026-08-26

## Authoritative sources

- Repository: https://github.com/Gentleman-Programming/gentle-ai
- Skill: `internal/assets/skills/judgment-day/SKILL.md` (Judgment Day is a
  standalone dual-judge tool; it does not mint delivery authority)
- Shared review orchestration rendered from
  `internal/assets/skills/_shared/review-ledger-contract.md` (current main is
  a native Go lifecycle: START freeze, capture, burn; not a portable CLI
  for this starter)
- Historical intent: precision-gated 4R (PR #1083) and bounded review
  transactions (PR #1093)
- Later clarification: Judgment Day is not a delivery-receipt mode
  (issue #2512); SDD does not own review authority (issue #3564)

## Interface used by this starter

None. This repository does not invoke `gentle-ai review`.

The imported **ideas**, not APIs:

| Idea | Portable mapping here |
|---|---|
| Freeze once | Worktree + HEAD + changed paths recorded before review |
| Fail closed | Missing/insufficient evidence cannot PASS or drive a fix |
| Separation of duties | `implementer` writes; `reviewer` falsifies; a second `reviewer` instance may refute inferred severe findings; parent validates the delta |
| Precision gate | Report only locatable findings; INSUFFICIENT is not a defect |
| Bounded correction | Fix only corroborated severe IDs; at most two review/fix cycles |
| Frozen ledger | Append-only finding rows; no silent deletion |
| Dual judges | Existing `judgment-day` skill; never both with ordinary review |
| Receipt / gates | Completion + review reports; ordinary git/CI policy owns delivery |

## Not imported

- Native Go transaction, lineage tokens, consent envelopes, artifact burn
- `review-refuter`, `jd-judge`, or `jd-fix` agent profiles
- Mandatory four parallel lenses on every change
- Pre-commit / pre-push / pre-release receipt validation as a product feature
- Content-addressed blob storage beyond git identity of the candidate

## Assumptions

- Two isolated `reviewer` instances are available when refutation or
  Judgment Day is required; otherwise the parent escalates instead of
  simulating independence.
- Deterministic checks remain the cheap first verifier.

## Unknown / Not Documented

Exact current Gentle-AI CLI flags and receipt schema are not a dependency.
Do not reconstruct them from memory if a future task wires the binary.

## Last checked

2026-08-26 against public GitHub `Gentleman-Programming/gentle-ai` main
skill and issue/PR text cited above.
