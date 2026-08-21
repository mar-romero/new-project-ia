# Completion Report — T-0002

## Status

DONE

## Outcome

Added portable, universal software-engineering guidance for Codex
implementers. It prioritizes correctness, legibility, simplicity and justified
reuse across languages while keeping architecture patterns conditional on
demonstrated requirements.

## Changed

- `AGENTS.md`: added the short, always-on implementation standard and canonical
  skill pointer.
- `.codex/agents/implementer.toml`: requires Codex implementers to load the
  skill and only relevant reference(s) before code design, implementation or
  refactoring.
- `.agents/skills/software-engineering/SKILL.md`: added the portable skill,
  evidence-first decision criteria and conditional reference routing.
- `.agents/skills/software-engineering/references/design-and-architecture.md`:
  added universal choices for boundaries, abstractions, components, ports,
  adapters and architecture styles.
- `.agents/skills/software-engineering/references/quality-testing-security.md`:
  added conditional guidance for code quality, testing, security and delivery.
- `docs/decisions/ADR-001-universal-engineering-guidance.md`: recorded the
  accepted hybrid invariant-plus-skill decision.
- `README.md`: documented the new universal engineering skill.
- `scripts/check-harness.sh`: requires the skill and references, validates
  pointers and exact stable routing entries, and safely checks expected text
  beginning with a hyphen.
- `tasks/done/T-0002-universal-software-engineering-skill.md`: archived the
  completed task.

## Acceptance Criteria

- [x] AC-1 — the validated skill routes design and quality guidance through
  focused relative references; the entrypoint instructs agents to load only
  relevant reference(s).
- [x] AC-2 — `AGENTS.md` and `.codex/agents/implementer.toml` point to the
  same canonical skill; the harness asserts both pointers.
- [x] AC-3 — the harness requires the skill, both reference files, the routing
  marker and both relative routes, and passed with all present.

## Verification

```text
python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .agents\skills\software-engineering
Skill is valid!

C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
exit 0

C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
Checking project starter harness...
HARNESS CHECK PASSED.

git diff --check
exit 0; no output
```

## Review

Independent review: PASS after one fix cycle. The first review requested
plural reference wording and harness verification of the skill's routing; both
were corrected and the re-review found no remaining issue.

## Decisions

- ADR-001: accepted the short always-on invariant plus detailed portable skill.
- Human approval was not required: the user explicitly requested this
  reversible repository guidance.

## Residual Risks and Follow-up

- Guidance quality must be refined from demonstrated usage, not speculative
  rules.
- Exact harness routing text is a deliberate contract and must change together
  with the skill when its routing changes.
- Add tool-specific skill activation or adapters only if evidence shows a
  supported tool does not discover the portable canonical skill sufficiently.

## Rollback

Revert the T-0002 files and the associated `AGENTS.md`, Codex implementer,
README and harness changes together. This removes the guidance and its checks
without affecting application runtime behavior.
