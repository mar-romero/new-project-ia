---
id: SPEC-T-0006
title: Six-tool harness guide and Copilot agents
status: ACCEPTED
created: 2026-08-20
updated: 2026-08-20
---

# SPEC-T-0006 — Six-tool harness guide and Copilot agents

## Objective

Extend the canonical-role adapter design selected in ADR-003 to GitHub Copilot
and make the portable operating contract easy for developers to discover and
use without loading unnecessary context.

## Design

GitHub Copilot profiles live at `.github/agents/<role>.agent.md`. Their
provider frontmatter uses only documented fields and their bodies match
`.agents/roles/<role>.md` byte-for-byte. Reader tool allowlists are
`[read, search]`; docs-researcher adds `web`; implementer uses
`[read, search, edit, execute]`. No profile receives `agent`, so nested
delegation is unavailable through its documented Copilot tool alias.

`docs/ai/AGENT_CATALOG.md` is the human entry point. It separates the portable
contract from provider differences and recommends one specialist, on-demand
skills, focused handoffs, and independent review only when task risk warrants
it. No generator or installer is added: seven small checked adapters are
simpler and more reversible for this repository.

## Security and failure behavior

The harness strictly consumes all Markdown frontmatter, compares exact
effective metadata and canonical bodies, rejects extra files/nesting, and
checks the Copilot tool allowlists. Provider policy, approval prompts, and
available tools remain external controls.

## Limitations

Equivalent repository instructions cannot equalize models, context windows,
latency, price, automatic routing, provider policy, or tool implementation.
Live CLI behavior is not exercised by the deterministic repository harness.

## Rollback

Remove the seven Copilot profiles and revert T-0006 docs/checks. No external
state is created.
