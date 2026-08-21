# Completion Report — T-0006

## Status

DONE

## Outcome

GitHub Copilot now joins Codex, Claude Code, OpenCode, Cursor, and Gemini CLI
with seven native project-agent profiles. The developer catalog documents the
same role intent, fourteen skills, lifecycle, provider invocation, limits, and
low-context defaults for all six tools.

## Changed

- `.github/agents/*.agent.md`: added seven native Copilot profiles with exact
  canonical bodies and documented tool allowlists.
- `docs/ai/AGENT_CATALOG.md`: added the human-facing role/skill catalog,
  invocation matrix, workflow, token policy, provider boundaries, and
  Gentle-AI comparison.
- `docs/sources/contracts/COPILOT_AND_PORTABLE_HARNESS.md`: recorded official
  Copilot behavior and the external reference verified on 2026-08-20.
- `scripts/check-harness.sh`: extended exact inventory, body, frontmatter,
  permission, and orphan/nesting checks to Copilot.
- `README.md`, `docs/ai/TOOL_COMPATIBILITY.md`, and
  `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`: updated the final
  six-tool support status and navigation.
- `specs/T-0006-six-tool-harness-guide.md`: recorded scope, security behavior,
  limits, and rollback.

## Acceptance Criteria

- [x] AC-1 — all seven `.agent.md` profiles have exact, non-ambiguous metadata
  and byte-equivalent canonical bodies.
- [x] AC-2 — the harness rejects invalid Copilot inventory, paths, metadata,
  body drift, and over-privileged tool sets while preserving all prior checks.
- [x] AC-3 — the catalog covers every role, all fourteen skills, six-tool
  invocation, workflow, context-saving defaults, and provider limitations.
- [x] AC-4 — official GitHub sources and the Gentle-AI comparison support the
  adapter decision without claiming equal runtime/model performance.
- [x] AC-5 — deterministic validation and independent R2 review pass.

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

Skill validation
SKILL VALIDATION PASSED: 15 entries

Python tomllib parsing
TOML PARSE PASSED: 7 agents

Targeted whitespace and git diff checks
PASS
```

## Review

Independent R2 review found no defects and ended with `VERDICT: PASS`. It
verified the official Copilot path, schema, aliases, allowlists, invocation,
skill discovery, all 35 Markdown body comparisons, prior-provider regression
checks, and task lifecycle safety.

## Residual Risks and Follow-up

- Provider versions, plans, organization policy, and installed tools can alter
  live discovery or permissions.
- Equal contracts do not imply equal model quality, token use, latency, or
  automatic routing.
- Live smoke tests require each consumer's installed and authenticated CLI.
- A generator remains unjustified while the static checked adapter set is
  small; reconsider only if provider/role count creates measured maintenance
  cost.

## Rollback

Revert the Copilot profiles, catalog, source/spec documentation, and T-0006
harness additions. No global or provider-side state requires cleanup.
