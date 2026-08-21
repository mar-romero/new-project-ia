---
id: T-0005
title: Native agent parity for five coding tools
status: DONE
risk: R2
created: 2026-08-20
closed: 2026-08-20
---

# T-0005 — Native agent parity for five coding tools

## Outcome

Expose the same seven role contracts through native project-agent adapters for
Codex, Claude Code, OpenCode, Cursor, and Gemini CLI. Preserve the fourteen
canonical skills and the shared project workflow.

## Scope

- Canonical role bodies and native adapters for the five supported tools.
- Deterministic parity, metadata, least-privilege, and inventory checks.
- Compact provider contract and an ADR for the adapter design.

## Out of scope

- Identical model quality, runtime performance, billing, global installation,
  provider smoke tests, Copilot custom agents, and a role catalog for users.

## Invariants

- One writer owns this task; adapters must not delegate.
- The seven role bodies are byte-equivalent to their canonical role bodies.
- Reader roles use the strongest documented native restriction available; only
  docs-researcher receives web tools and implementer is the only configured
  writer. Cursor's weaker shell/delegation boundary is explicitly documented.
- Existing Codex model and sandbox configuration remains unchanged.

## Acceptance criteria

1. Each of the seven roles exists natively for all five tools with equivalent
   body instructions and supported metadata.
2. The harness rejects missing, orphaned, duplicated, ambiguously parsed, or
   drifting role and skill adapters, unsafe configured reader permissions, and
   nesting wherever the provider exposes a project-agent control; unsupported
   Cursor enforcement is recorded as a limitation.
3. The compact source contract and ADR record official behavior verified on
   2026-08-20 and clearly state provider limitations.
4. Harness checks pass from the repository root and the `scripts/` directory,
   including its opt-in permission self-tests.
5. Codex keeps its existing model, reasoning-effort, and sandbox settings while
   its full role responsibilities and universal engineering guidance remain in
   the shared canonical bodies.

## Evidence

- `bash -n scripts/check-harness.sh`
- `bash scripts/check-harness.sh`
- `(cd scripts && bash check-harness.sh)`
- `CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh`
- Python `tomllib` parsing for all Codex agent files
- `git diff --check`

## Rollback

Revert this task's adapters, canonical role changes, checks, decision, and
source contract together. No provider-side state is created.
