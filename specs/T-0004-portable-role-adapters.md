---
id: SPEC-T-0004
title: Portable role adapters
status: ACCEPTED
created: 2026-08-20
updated: 2026-08-20
---

# SPEC-T-0004 — Portable role adapters

## Objective

Provide portable contracts for explorer, planner, implementer, reviewer,
test-auditor, security-reviewer, and docs-researcher while configuring native,
reviewable adapters only where the provider contract is verified.

## Non-Goals

- Identical provider runtime behavior, global setup, live provider checks, or
  a fixed model/provider.
- Copying canonical skill bodies or inventing a cross-provider import mechanism.

## Design

`.agents/roles/<role>.md` contains the canonical role body. Claude Code
adapters live in `.claude/agents/`; OpenCode V2 adapters live in
`.opencode/agents/`. Adapter frontmatter supplies only provider configuration;
its body equals the canonical file. Every current canonical skill has a Claude
thin adapter that preserves its name and description and imports its canonical
source. Cursor and Gemini can use neutral role contracts and native
`.agents/skills/` discovery respectively, but this task makes no unsupported
claim of native custom-agent discovery for either.

## Security and Failure Behavior

Reader adapters deny edits, shell execution, nested delegation, web fetch, and
web search. The docs-researcher alone permits web fetch/search. Implementers
deny nested delegation and web access. OpenCode uses its ordered V2
`permissions` array with `edit`, `shell`, and `subagent` actions. A missing
adapter, unsafe permission marker, or body drift fails the harness before
review.

## Acceptance and Tests

The T-0004 acceptance criteria are the required contract tests. The portable
harness checks file presence, frontmatter markers, role-body equivalence, and
canonical/Claude skill metadata and import parity, including no orphan Claude
skill adapters, from any working directory. Its OpenCode permission assertion
evaluates each ordered V2 rule atomically, and role discovery accepts only the
seven exact top-level `<role>.md` paths. For these seven restricted OpenCode
adapters, the permission set is closed: exactly five canonical actions, one
`resource: "*"` rule each, and no overrides. Opt-in temporary fixtures cover
mixed fields, duplicates, wildcard and resource-specific rules, and a valid
set; this is not a general V2 permission evaluator.

## Rollback

Revert the T-0004 role, adapter, contract, ADR, specification, and harness
changes together; no provider-side state is created.
