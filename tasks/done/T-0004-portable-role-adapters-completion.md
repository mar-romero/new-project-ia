# Completion Report — T-0004

## Status

DONE

## Outcome

The harness now has seven portable role contracts and checked native adapters
for Claude Code and OpenCode. Claude has thin, on-demand adapters for all 14
canonical skills currently present. OpenCode's seven restricted role adapters
use a closed, least-privilege V2 permission set.

## Changed

- `.agents/roles/*.md`: added the seven canonical neutral role bodies.
- `.claude/agents/*.md`: added native Claude role metadata and permissions;
  bodies exactly match canonical roles.
- `.opencode/agents/*.md`: added native OpenCode V2 role adapters with a closed
  five-action permission set.
- `.claude/skills/*/SKILL.md`: added thin imports for all 14 current canonical
  skills without copying their guidance.
- `scripts/check-harness.sh`: checks CWD independence, role body parity,
  descriptions, exact role paths, canonical Claude skill metadata/imports, and
  the closed OpenCode permission set with opt-in self-tests.
- `docs/decisions/ADR-002-portable-role-contracts.md`: records the adapter and
  anti-drift decision.
- `docs/sources/contracts/AGENT_ROLE_ADAPTERS.md`: records verified Claude and
  OpenCode contracts and their limitations.
- `specs/T-0004-portable-role-adapters.md` and
  `docs/ai/TOOL_COMPATIBILITY.md`: document scope, security boundaries, and
  supported-tool limits.

## Acceptance Criteria

- [x] AC-1 — all seven canonical role bodies exist and are harness-required.
- [x] AC-2 — Claude and OpenCode bodies are deterministically compared to the
  canonical files; required metadata is checked.
- [x] AC-3 — reader permissions deny mutation, shell, delegation, and web
  access except docs-researcher's approved web access.
- [x] AC-4 — implementers can edit but cannot delegate; Claude preloads only
  `software-engineering`.
- [x] AC-5 — harness confirms matching Claude adapters for all 14 current
  canonical skills and rejects orphan adapters.
- [x] AC-6 — harness accepts only the exact five-rule OpenCode permission set;
  opt-in fixtures reject mixed fields, duplicates, wildcards, and specific
  resources while accepting the valid set.

## Source Contract

Provider behavior and sources are recorded in
`docs/sources/contracts/AGENT_ROLE_ADAPTERS.md`, verified 2026-08-20.

## Verification

```text
C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
PASS

C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
HARNESS CHECK PASSED.

C:\Program Files\Git\bin\bash.exe -c 'cd scripts && ./check-harness.sh'
HARNESS CHECK PASSED.

C:\Program Files\Git\bin\bash.exe -c 'CHECK_HARNESS_SELFTEST=1 ./scripts/check-harness.sh'
V2 PERMISSION SELF-TEST PASSED.
HARNESS CHECK PASSED.

python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .agents\skills\software-engineering
Skill is valid!

python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py <each of 14 .claude\skills directories>
All 14 skills valid.

git diff --check
PASS
```

## Review

Independent final review: PASS. Earlier findings tightened the OpenCode V2
permissions and harness checks. Additional review/fix cycles beyond the normal
limit were explicitly authorized by the user; the final closed-set permission
checker and its fixtures were independently approved.

## Decisions

ADR-002 selects canonical role bodies plus native, checked adapters. No human
approval was required for provider-side changes because none were made.

## Residual Risks and Follow-up

- Provider versions, managed policy, available tools, and administrator
  settings can alter actual discovery or effective permissions.
- The harness validates committed structure and configuration, not live
  provider runtime behavior.
- No speculative follow-up is planned.

## Rollback

Revert T-0004's role contracts, Claude/OpenCode adapters, skill wrappers,
ADR/spec/source contract, compatibility documentation, and matching harness
checks together. No external or provider-side state requires cleanup.
