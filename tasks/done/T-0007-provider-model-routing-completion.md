# Completion Report — T-0007

## Status

DONE

## Outcome

All seven roles now have a checked, quality-balanced native model profile in
Codex, Claude Code, Cursor, Gemini CLI, OpenCode, and GitHub Copilot. Model
capability, reasoning where supported, and turn/step limits are selected by
role without changing canonical bodies, permissions, skills, or workflow.

## Changed

- `.codex/agents/*.toml`: routed exploration to Luna, balanced research/audit
  to Terra, and implementation/high-risk reasoning to Sol with role-specific
  effort; retained read-only sandboxes and canonical bodies.
- `.claude/agents/*.md`, `.cursor/agents/*.md`, `.gemini/agents/*.md`,
  `.opencode/agents/*.md`, and `.github/agents/*.agent.md`: added each
  provider's documented model and supported effort/work-budget metadata.
- `scripts/check-harness.sh`: added exact provider-profile validation, strict
  Codex TOML key/value validation, permanent T-0007 documents, and a negative
  model-drift fixture while preserving permission/body/inventory checks.
- `docs/ai/MODEL_ROUTING.md`: added the complete matrix, rationale, runtime
  checks, access/cost fallbacks, and safe customization procedure.
- `docs/sources/contracts/ROLE_MODEL_CONFIGURATION.md`: recorded official
  schemas, current catalog evidence, limitations, and provider differences
  verified on 2026-08-20.
- `docs/decisions/ADR-004-role-model-routing.md` and
  `specs/T-0007-provider-model-routing.md`: recorded the quality-balanced
  decision, scope, failure behavior, and rollback.
- `README.md`, `docs/ai/AGENT_CATALOG.md`, `docs/ai/TOOL_COMPATIBILITY.md`,
  `docs/decisions/ADR-003-native-agent-parity.md`, and
  `docs/sources/contracts/NATIVE_AGENT_PARITY.md`: updated navigation and
  superseded only the earlier inherited-model choice.

## Acceptance Criteria

- [x] AC-1 — all 42 native role adapters match the exact provider profile in
  ADR-004 and the checked matrix.
- [x] AC-2 — strict frontmatter/TOML validation rejects missing, duplicate,
  extra, malformed, or drifting model metadata while body and permission checks
  continue to pass.
- [x] AC-3 — current official sources record schema, IDs, effort semantics,
  fallback behavior, optional Zen billing, previews, and unknowns.
- [x] AC-4 — the developer guide explains every role/provider selection,
  tradeoffs, inspection commands, and safe modification.
- [x] AC-5 — all deterministic checks and independent R2 review pass.

## Verification

```text
C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
PASS

C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
HARNESS CHECK PASSED.

C:\Program Files\Git\bin\bash.exe -c 'cd scripts && ./check-harness.sh'
HARNESS CHECK PASSED.

CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
V2 PERMISSION SELF-TEST PASSED.
FRONTMATTER SELF-TEST PASSED.
HARNESS CHECK PASSED.

Canonical software-engineering plus 14 Claude wrapper quick validations
15 × Skill is valid!

Python tomllib parsing
7 CODEX TOML FILES VALID.

Targeted whitespace and git diff --check
PASS
```

## Review

Independent R2 review initially found one HIGH defect: OpenCode V2 does not
support `reasoningEffort` as agent frontmatter. The implementation removed that
field, retained documented `model` plus `steps`, and updated the contract,
matrix, spec, and harness. Re-review reproduced the checks, found no remaining
defect or Codex regression, and ended with `VERDICT: PASS` after one fix cycle.

## Residual Risks and Follow-up

- Model IDs, aliases, previews, quotas, organization policy, and entitlements
  can change the effective runtime model.
- OpenCode Zen is optional and paid; no account was connected and no credits
  were purchased. A different connected provider needs verified model IDs.
- No authenticated live CLI sessions were available to smoke-test effective
  model selection or fallback on each developer account.
- “Best” remains workload-specific. Change effort or models only after measuring
  quality, latency, tokens, and cost on representative tasks.

## Rollback

Remove the T-0007 provider model/budget metadata and restore inherited models or
the previous Codex values. Revert the matching harness profile and T-0007
documentation. No provider-side state requires cleanup.
