---
id: T-0004
title: Portable role contracts with Claude Code and OpenCode adapters
status: DONE
risk: R2
created: 2026-08-20
updated: 2026-08-20
---

# T-0004 — Portable role adapters

## Outcome

Seven concise, neutral role contracts provide a common workflow vocabulary;
Claude Code and OpenCode expose native Markdown adapters with equivalent role
bodies and least-privilege permissions. Claude also receives thin adapters for
every current canonical project skill.

## Out of Scope

- Global installation, provider billing, or fixed model selection.
- A claim that providers behave identically or live runtime smoke tests.
- Runtime body-import syntax or a role generator.

## Risk and Invariants

Risk: R2. Role permissions and durable multi-tool configuration can affect
future implementation behavior.

- `.agents/roles/` is the canonical role-body source.
- Claude and OpenCode adapter bodies exactly equal their canonical role body.
- Reader roles cannot edit, execute shell commands, or delegate; only the
  documentation researcher receives web search/fetch access. OpenCode readers
  use ordered V2 `permissions` entries for these explicit denies.
- The implementer can write but cannot delegate; its engineering skill is
  preloaded only in Claude Code because coding is its defined responsibility.
- Claude skill adapters import all current canonical `.agents/skills/` entries;
  no adapter copies a canonical skill body or is orphaned.

## Acceptance Criteria

### AC-1

Given any of the seven named roles, when a user or agent needs its workflow,
then a concise canonical contract exists under `.agents/roles/`.

Evidence: seven role files and harness checks.

### AC-2

Given Claude Code or OpenCode loads the project, when a role is invoked,
then its native Markdown adapter has the documented required metadata and a
body identical to the canonical contract.

Evidence: adapter files and deterministic body-equivalence checks.

### AC-3

Given a reader role is invoked, when it attempts a mutating, shell, nested
delegation, or web action, then its adapter configuration denies that
capability; docs-researcher alone can perform supported web research.

Evidence: frontmatter checks and source contract.

### AC-4

Given implementation work is assigned, when the implementer runs in Claude
Code or OpenCode, then it can edit while nested delegation is denied; Claude
preloads only `software-engineering`.

Evidence: frontmatter checks and source contract.

### AC-5

Given Claude Code discovers project skills only from `.claude/skills/`,

When it loads this repository,

Then every current canonical skill has a thin adapter with matching name and
description and the exact relative canonical import; no orphan adapter exists.

Evidence: harness discovery and metadata checks.

### AC-6

Given an OpenCode permission list contains several rules,

When the harness checks one requested action,

Then it contains exactly the five canonical actions (`edit`, `shell`,
`subagent`, `webfetch`, `websearch`), each once with `resource: "*"` and the
role's expected effect. Extra, duplicate, wildcard, or resource-specific rules
are rejected rather than interpreted by a general permission engine.

Evidence: closed-set checker and opt-in temporary-fixture self-tests.

## Sources

- `docs/sources/contracts/AGENT_ROLE_ADAPTERS.md`

## Verification

```text
C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
C:\Program Files\Git\bin\bash.exe -c 'cd scripts && ./check-harness.sh'
C:\Program Files\Git\bin\bash.exe -c 'CHECK_HARNESS_SELFTEST=1 ./scripts/check-harness.sh'
git diff --check
```
