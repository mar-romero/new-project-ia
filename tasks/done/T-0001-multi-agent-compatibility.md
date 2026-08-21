---
id: T-0001
title: Multi-agent compatibility
status: DONE
risk: R1
created: 2026-08-20
updated: 2026-08-20
---

# T-0001 — Multi-agent compatibility

## Outcome

Make this starter use the same canonical project policy in Codex, Claude Code,
Cursor, OpenCode, GitHub Copilot and Gemini CLI without duplicating it.

## Why

Teams should be able to choose a supported coding agent without silently
losing the repository's quality, security and review expectations.

## Out of Scope

- Translating Codex roles into each tool's incompatible agent schema.
- Configuring credentials, models, permissions, hooks or production access.

## Context and Relevant Files

- `AGENTS.md` and `AI_POLICY.md` are canonical policy documents.
- Compatibility adapters and guide are the implementation surface.

## Sources / Contracts

- `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`

## Risk Classification

Risk: R1

Reason: Repository-wide instruction loading can affect every future agent task,
but the change is committed, reversible configuration with no external effect.

## Invariants and Failure Cases

- Canonical policy content must not be copied into tool adapters.
- Missing adapters or broken import paths must fail the harness.
- Codex-specific roles remain explicitly tool-specific.

## Acceptance Criteria

### AC-1

Given a supported agent starts at repository root,

When it loads its committed adapter,

Then it receives the canonical project and AI policies through native loading
or documented native discovery.

Evidence: adapter content checks in `scripts/check-harness.sh` and the
compatibility guide.

### AC-2

Given a maintainer needs to select or verify a tool,

When they read `docs/ai/TOOL_COMPATIBILITY.md`,

Then they can see the adapter path, limitations and an inspection command.

Evidence: source contract with official references dated 2026-08-20.

## Test Requirements

- [x] contract/schema
- [ ] unit
- [ ] integration
- [ ] property/golden/replay
- [ ] security

## Agent Plan and Skills

- One implementation writer owns all edits.
- Use `implementation-loop`, `source-research` and `cognitive-doc-design`.
- Request independent review after deterministic checks pass.

## Human Decisions

None.

## Implementation Plan

1. Add minimal native adapters that reference canonical policy files.
2. Document verified support and intentional tool-specific boundaries.
3. Extend the portable harness for adapter presence and exact imports.
4. Run deterministic checks and independent review.

## Verification Commands

```text
bash scripts/check-harness.sh
```
