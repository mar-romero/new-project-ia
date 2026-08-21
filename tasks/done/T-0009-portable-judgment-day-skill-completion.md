# Completion Report — T-0009

## Status

DONE

## Outcome

`judgment-day` now requests two fresh instances of the existing `reviewer`
role, labels their results Judge A/B only in the audit ledger, and uses the
existing `implementer` role only after human approval. It fails safely with
`JUDGMENT: ESCALATED` when a runtime cannot provide the required isolation.

## Changed

- `.agents/skills/judgment-day/`: removed references to undefined judge/fixer
  profiles and documented the portable preflight and role mapping.
- `.claude/skills/judgment-day/SKILL.md`: generated deterministic Claude Code
  wrapper from the canonical skill.
- `scripts/check-harness.sh`: validates the portable role contract and rejects
  legacy undefined profile references.
- `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`: records the supported
  subagent capabilities and the mandatory runtime preflight.

## Evidence

```text
C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --write
C:\Program Files\Git\bin\bash.exe scripts/sync-portable-skills.sh --check
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe -c "CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh"
```

The synchronizer and normal harness passed. The self-test reported V2
permission, portable-skill-sync, and frontmatter self-test success before the
local command-output limit; a prior complete run passed the harness.

## Review

The first independent R1 review found one HIGH issue: an undefined legacy
reviewer profile remained in the canonical skill. The profile reference was
removed and the harness now rejects it. Scoped re-review returned
`VERDICT: PASS` with no findings.

## Decisions

The user approved a portable solution that reuses the existing role adapters
instead of adding provider-specific one-off judge or fixer profiles.

## Residual Risks

Actual two-instance isolation and concurrent dispatch remain dependent on the
installed provider runtime and policy. The mandatory preflight and escalation
path contain that uncertainty; live activation was not executed across all six
providers.

## Rollback

Revert the judgment-day commits. There is no provider-side state to clean up.

## Follow-up

Run a live cross-provider smoke test when each supported CLI is available in a
controlled environment.
