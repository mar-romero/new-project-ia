---
id: SPEC-T-0007
title: Provider-specific model routing by agent role
status: ACCEPTED
created: 2026-08-20
updated: 2026-08-20
---

# SPEC-T-0007 — Provider-specific model routing by agent role

## Objective

Use each provider's native model controls to improve role fit while keeping
routine work economical and preserving the portable role/skill contract.

## Profile

Roles are grouped by workload:

- `explorer`: fastest economical model, low effort, short budget.
- `docs-researcher`: balanced/fast model, medium effort.
- `implementer`: coding-capable frontier model, high effort.
- `planner`, `reviewer`, `security-reviewer`: frontier reasoning model, high or
  xhigh effort where supported.
- `test-auditor`: strong balanced model, high effort.

Claude uses stable family aliases rather than version pins. Cursor uses current
documented IDs with inline `effort`. Gemini uses current CLI model IDs plus
temperature and maximum turns because custom-agent frontmatter has no direct
reasoning-level field. OpenCode V2 uses current Zen IDs and `steps`; effort
variants require provider/model settings and are not guessed without a
connected catalog. This requires a consumer to connect the optional paid Zen
provider. Copilot uses only models in its CLI supported-model table and its
documented `reasoningEffort`. Codex uses the GPT-5.6 Sol/Terra/Luna role split
and native `model_reasoning_effort`.

## Failure behavior

The harness validates committed metadata, not account entitlement. Providers
may fall back, reject, or hide a model because of CLI version, plan, quota,
region, organization policy, authentication, or deprecation. Consumers must
inspect the effective model in their tool and revise the profile from current
official sources when an ID disappears.

## Security and cost

Model selection does not change tool permissions. No credentials or billing
configuration is committed. Strong models are limited to roles where better
reasoning can materially affect correctness; bounded search uses cheaper
models and explicit turn/step limits where the provider supports them.

## Rollback

Restore `inherit` for Markdown providers and the prior Codex Terra profile.
