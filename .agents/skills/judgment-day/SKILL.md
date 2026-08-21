---
name: judgment-day
description: "Trigger: judgment day, dual review, adversarial review, juzgar. Run explicit blind dual review with at most two scoped fix/re-judgment rounds."
---

## Activation Contract

Load only when the user explicitly requests `$judgment-day`, "Judgment Day",
"dual review", "adversarial review", or "juzgar" for a concrete target. It
replaces the ordinary independent-review method for that target; never run
both. It is a review method, not a commit, push, PR, or release authorization.

## Hard Rules

- Before freezing the target, resolve the existing `reviewer` and `implementer`
  roles in the current runtime. Do not invent, configure, or invoke ad-hoc
  judge or fixer agent profiles.
- Before freezing the target, verify that the runtime can launch two **fresh,
  isolated, read-only** instances of the existing `reviewer` role in addition
  to the parent. Do not reuse an instance that authored, implemented, or
  previously reviewed the target.
- If that capacity is unavailable, stop before any judgment, record the reason,
  and return `JUDGMENT: ESCALATED` with the next action: start a new isolated
  session in a runtime that can execute the frozen review packet. Never replace
  the two judges with one judge, the parent, or two agents carrying target
  context.
- Treat Judge A and Judge B as ledger labels, not agent configuration names.
  Resolve matching project skills before starting and pass the same paths to
  both `reviewer` instances and, if needed, the `implementer` instance.
- Build one complete immutable target, then launch two blind read-only judges in parallel with identical scope and criteria.
- Each judge returns one neutral findings result and terminates. Wait for both; never accept a partial judgment.
- Never launch `review-refuter`; two-judge agreement is the corroboration mechanism.
- Only the parent orchestrator merges/persists findings, launches the existing
  `implementer` role after human approval, and launches scoped re-judgment.
- Fix only severe findings confirmed by both judges. WARNING/SUGGESTION rows remain `info`.
- Permit at most two fix rounds and two scoped re-judgments. Re-judgment sees only the frozen ledger plus fix delta and may record fix-caused defects.
- The only terminal verdicts are `APPROVED | ESCALATED`; never reset or extend an exhausted round budget.
- A judgment issues no receipt and carries no delivery authority: it satisfies no commit, push, PR, or release gate. When the caller explicitly wants delivery authority for the same target, run the ordinary negotiated review lifecycle as its own step; a runtime that cannot uphold receipt guarantees loses the receipt, not the judgment.

## Audit record

- Persist the judgment record under `docs/audits/judgment-day/<target-identity>/`.
- Before requesting a human decision or returning a terminal verdict, write the applicable immutable round ledger in that directory. Do not overwrite a frozen ledger; use `round-<n>-ledger.md` for each round.
- At the end of the process, write or update `summary.md` with the decision, work actually completed, deterministic evidence, artifact references, and the terminal verdict or pending human authorization state.
- Record only the review outcome and evidence needed to audit it. Do not store raw agent conversations, secrets, or unrelated repository state.

## Decision Gates

| Condition | Action |
|---|---|
| Target unclear | Ask one scope question and stop. |
| Both judges confirm severe finding | Ask before round-one correction; then use the bounded fix actor. |
| One judge reports it | Record suspect; do not auto-fix. |
| Judges contradict | Escalate for explicit human decision. |
| Scoped re-judgment fails before round two | Parent may launch the final bounded fix round. |
| Any issue remains after round two | Escalate and stop. |

## Execution Steps

1. Resolve the existing `reviewer` and `implementer` roles and verify capacity
   for two fresh, isolated `reviewer` instances. If unavailable, stop with the
   documented `ESCALATED` verdict; do not freeze a partial judgment.
2. Build the complete immutable target and freeze the scope both judges will inspect.
3. Launch two read-only `reviewer` instances in parallel against the same
   immutable target; record their returned instance identifiers as Judge A and
   Judge B in the ledger.
4. Merge findings into the frozen ledger and persist it through the selected artifact store.
5. Ask before round-one correction; run the existing `implementer` role only
   for confirmed severe IDs.
6. Run two new `reviewer` instances only over the frozen ledger plus immutable fix delta.
7. Repeat once at most, then run independent final verification and return the terminal verdict.

## Output Contract

Return target identity, round, confirmed/suspect/contradiction/INFO counts, correction work units, scoped re-judgment result, artifact references, skill resolution, and exactly one final `JUDGMENT: APPROVED` or `JUDGMENT: ESCALATED`. Reference the persisted audit record.

## References

- [references/prompts-and-formats.md](references/prompts-and-formats.md) - compact judge/fix prompts and verdict shape.
- [../_shared/review-ledger-contract.md](../_shared/review-ledger-contract.md) - delivery-authority route only: consult it when the caller explicitly opts into the ordinary negotiated review lifecycle; never required to run judges.
