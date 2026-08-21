---
id: T-0003
title: Claude Code and Gemini CLI software-engineering skill adapters
status: DONE
risk: R1
created: 2026-08-20
updated: 2026-08-20
---

# T-0003 — Claude Code and Gemini CLI software-engineering skill adapters

## Outcome

Claude Code and Gemini CLI users can discover and apply the canonical
`software-engineering` skill without duplicating its guidance.

## Why

The harness must provide equivalent access to universal implementation guidance
across its supported coding agents while retaining one maintained source.

## Out of Scope

- Copying the canonical skill or references into tool-specific directories.
- Changing tool permissions, user-consent policy, or model behavior.
- Adding language-specific engineering guidance.

## Context and Relevant Files

- `.agents/skills/software-engineering/` is the canonical skill and references.
- `.claude/skills/software-engineering/SKILL.md` is the Claude Code adapter.
- `CLAUDE.md` and `GEMINI.md` are the project instruction adapters.
- `docs/ai/TOOL_COMPATIBILITY.md` and the source contract record supported
  discovery behavior.

## Sources / Contracts

- `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`

## Risk Classification

Risk: R1

Reason: The change affects which durable implementation guidance future agents
discover, but adds no runtime code, credentials, or external side effects.

## Invariants and Failure Cases

- Canonical guidance remains only in `.agents/skills/software-engineering/`.
- Claude Code uses a thin adapter with the canonical relative import.
- Gemini CLI uses native `.agents/skills/` discovery and retains its consent
  behavior; no duplicate `.gemini/skills/` tree is created.

## Acceptance Criteria

### AC-1

Given a Claude Code session opens this repository,

When code design, implementation, refactoring, or review needs engineering
guidance,

Then `/software-engineering` is available through a project skill that imports
the canonical source without duplicating it.

Evidence: Claude adapter frontmatter, canonical import, and skill validation.

### AC-2

Given a Gemini CLI session opens this repository,

When the engineering skill is relevant,

Then it can discover the native `.agents/skills/software-engineering/` skill
and the adapter documents `/skills list` and `/skills reload`.

Evidence: `GEMINI.md`, source contract, and harness content checks.

### AC-3

Given a compatibility adapter regresses,

When the portable harness runs,

Then it fails if the Claude adapter, canonical import, or required Claude and
Gemini discovery markers are absent.

Evidence: `scripts/check-harness.sh`.

## Test Requirements

- [ ] unit
- [ ] integration
- [x] contract/schema
- [ ] property/golden/replay
- [ ] security

## Agent Plan and Skills

- One implementation writer owned all edits.
- Used `software-engineering`, `skill-creator`, `implementation-loop`,
  `cognitive-doc-design`, and `task-close`.
- Deterministic checks and independent review completed.

## Human Decisions

None. The user requested the reversible compatibility adapters.

## Implementation Plan

1. Add the thin Claude Code skill adapter and clarify the project instructions.
2. Document Gemini CLI native discovery without adding a duplicate directory.
3. Update compatibility documentation, source contract, and harness checks.
4. Validate both skill entry points and the portable harness.

## Verification Commands

```text
python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .agents\skills\software-engineering
python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .claude\skills\software-engineering
C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe -c 'cd scripts && ./check-harness.sh'
git diff --check
```
