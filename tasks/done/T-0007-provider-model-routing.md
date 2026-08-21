---
id: T-0007
title: Provider-specific model routing by agent role
status: DONE
risk: R2
created: 2026-08-20
completed: 2026-08-20
---

# T-0007 — Provider-specific model routing by agent role

## Outcome

Configure each native agent adapter with a documented model and reasoning/work
budget appropriate to its role in Codex, Claude Code, Cursor, Gemini CLI,
OpenCode, and GitHub Copilot.

## Scope

- A quality-balanced role/model profile for all six tools.
- Only provider-native, officially documented configuration fields.
- Deterministic exact metadata checks and negative self-tests.
- Source contract, ADR, catalog, and compatibility updates.

## Out of scope

- Purchasing plans, adding credentials, changing organization settings, live
  provider benchmarks, and claiming one model is universally best.

## Invariants

- Canonical role bodies, tool restrictions, skills, and workflow do not change.
- Cheap/fast models handle bounded discovery; strongest models are reserved for
  implementation or high-risk judgment.
- Model unavailability, quota, or admin fallback is visible in documentation.
- No secrets, provider connection, or external billing action is performed.

## Acceptance criteria

1. Every native role has the exact documented provider model and supported
   effort/budget metadata selected by ADR-004.
2. The harness rejects missing, duplicate, unsupported, or drifting model
   profiles without weakening permissions or body parity.
3. Official sources verified on 2026-08-20 record schema, model IDs, effort
   behavior, fallbacks, access requirements, and unknowns.
4. The catalog explains the role matrix, tradeoffs, provider commands, and how
   consumers can change the profile safely.
5. Syntax, root/alternate-CWD harness, self-tests, TOML, skill, whitespace, and
   diff checks pass, followed by independent review.

## Rollback

Remove provider model/effort metadata and restore `inherit` or the prior Codex
values. No provider-side state requires cleanup.
