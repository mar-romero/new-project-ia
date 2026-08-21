---
id: T-0006
title: Six-tool harness guide and Copilot agents
status: DONE
risk: R2
created: 2026-08-20
closed: 2026-08-20
---

# T-0006 — Six-tool harness guide and Copilot agents

## Outcome

Complete native role coverage for GitHub Copilot and give developers one
accurate guide for using the same roles, skills, workflow, and low-context
operating model in Codex, Claude Code, OpenCode, Cursor, Gemini CLI, and
GitHub Copilot.

## Scope

- Seven native project agents for GitHub Copilot.
- Deterministic Copilot inventory, metadata, body, and tool checks.
- Six-tool agent catalog, invocation matrix, and token/context guidance.
- Official Copilot contract and a compact comparison with Gentle-AI.

## Out of scope

- Global installation, provider accounts, live provider smoke tests, identical
  model performance, and automatic synchronization generators.

## Invariants

- Copilot bodies remain byte-equivalent to `.agents/roles/`.
- Reader agents receive only documented read/search tools; docs-researcher may
  use web; only implementer receives edit/execute; no role receives `agent`.
- Existing Codex and other provider adapters are not weakened.
- Documentation distinguishes checked contract parity from runtime parity.

## Acceptance criteria

1. Copilot discovers all seven native `.agent.md` profiles with exact,
   non-ambiguous metadata and canonical bodies.
2. The harness rejects missing, orphaned, nested, malformed, drifting, or
   over-privileged Copilot profiles and still validates all prior providers.
3. A compact catalog explains every role, skill availability, invocation, the
   shared lifecycle, and context-saving defaults across all six tools.
4. Official sources and the Gentle-AI comparison support the chosen adapter
   model without claiming identical provider performance.
5. Root, alternate-CWD, self-test, skill, TOML, and diff checks pass, followed
   by independent review.

## Rollback

Revert Copilot profiles, T-0006 documentation, and their harness checks. No
provider-side or global configuration is changed.
