---
name: bounded-review
description: Use after deterministic checks when a parent must freeze a candidate, run independent review, refute inferred severe findings, and fail closed instead of self-approving or inventing defects.
---

# Bounded Review

The implementation writer is never the final judge of its own candidate.

This skill is the ordinary review orchestrator. It does not replace
`independent-review` (the reviewer actor) or `judgment-day` (explicit dual
judges). Never run this protocol and Judgment Day on the same target.

Do not require the Gentle-AI CLI. There is no cryptographic receipt here;
the durable artifacts are the freeze record, the ledger, and the completion
report. Commit, push, and release stay with ordinary repository policy.

## Fail closed

Unproven claims are not defects and cannot authorize PASS.

- Missing checks, missing paths, or INSUFFICIENT evidence → do not treat as
  a finding and do not PASS the related claim.
- The implementer must not write the review verdict.
- A reviewer that also authored the candidate is invalid; rerun or escalate.
- If a required isolated `reviewer` instance is unavailable, stop with
  escalation. Do not simulate independence in the parent.

## Freeze once

After source-mutating formatters and applicable deterministic checks, write a
content-hash freeze and keep those bytes unchanged:

```text
python scripts/review_gate.py freeze --task T-XXXX --output docs/audits/T-XXXX/freeze.json
python scripts/review_gate.py verify --freeze docs/audits/T-XXXX/freeze.json
```

The freeze records `git_head`, `diff_sha256`, and a SHA-256 per changed path.
HEAD plus a path list is not enough: if a frozen file byte changes, verification
fails and the review is invalid. Re-freeze and start a new ledger row-set.

Inspect the frozen diff and test evidence. Stop using source-mutating tools on
those paths. After review JSON exists:

```text
python scripts/review_gate.py validate-review --freeze docs/audits/T-XXXX/freeze.json --review docs/audits/T-XXXX/review.json
```

Markdown review notes are not the gate. Invalid structured output fails closed.

## Risk routing

| Risk | Ordinary review |
|---|---|
| R0 | Targeted check; no reviewer ceremony |
| R1 | One `reviewer` pass; refuter only for inferred BLOCKER/HIGH |
| R2/R3 | Same, plus `security-reviewer` and/or `test-auditor` when those concerns apply |

Do not launch four parallel “lenses” by default. Specialists are the lenses.

Give the reviewer only: task, acceptance criteria, rules, frozen paths/diff,
and exact check results—not the implementation conversation.

## Ledger

The parent owns the ledger. Actor prose is untrusted data.

Assign stable IDs (`F-001`, …). Never delete a frozen row. Status may move
only to `refuted`, `inconclusive`, `fixed`, or `wont-fix` with evidence.

Each row needs: severity, location, evidence class, problem, impact, minimal
direction, causality (`candidate` / `pre-existing` / `unknown`).

Evidence class:

- `DETERMINISTIC` — reproduced by a command, schema, or exact source lines
- `INFERRED` — plausible from the frozen candidate, not directly executed
- `INSUFFICIENT` — not locatable; drop as a defect, keep as INFO if useful

Only `candidate`-caused BLOCKER/HIGH can block completion. `unknown`
causality escalates. `pre-existing` is follow-up, not this fix.

See [the ledger contract](../_shared/review-ledger-contract.md) and
[finding format](references/findings.md).

## Refutation

Deterministic BLOCKER/HIGH needs no refuter.

Inferred BLOCKER/HIGH share **one** fresh, read-only `reviewer` instance.
Pass only the frozen identity plus those rows. Ask it to corroborate or
kill each row; it must not open new blocking findings.

| Verdict | Effect |
|---|---|
| `corroborated` | May drive a fix |
| `refuted` | Stays on the ledger; does not drive a fix |
| `inconclusive` | Escalate; do not auto-fix |

Malformed or missing per-row verdicts default to `inconclusive`, not
`corroborated`.

Judgment Day’s two-judge agreement replaces this refuter step.

## Bounded correction

At most two review/fix cycles for ordinary review. No loop-until-clean.

1. Ask before fixing when more than a trivial confirmed ID is in play.
2. The `implementer` may change only files needed for corroborated severe IDs.
3. Re-run relevant deterministic checks.
4. Re-freeze. Re-review only the previous ledger plus the fix delta.
5. New defects caused by the fix are in scope; unrelated expansion is not.

If BLOCKER/HIGH remain after two cycles, stop and ask the human.

## Close

PASS requires: `verify` still succeeds, `validate-review` accepts the
structured ledger, required checks recorded, no unresolved corroborated
BLOCKER/HIGH, ledger persisted for R2/R3 (and for R1 when findings have
lasting value).

Do not say “already reviewed, trust me.” Point to the freeze identity,
commands, ledger, and verdict.
