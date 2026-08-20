# Completion Report — T-0005

## Status

DONE

## Outcome

Codex, Claude Code, OpenCode, Cursor, and Gemini CLI now expose the same seven
canonical role bodies through native project-agent files. The fourteen shared
skills remain canonical under `.agents/skills/`; Codex's existing model,
reasoning-effort, sandbox settings, and substantive role guidance were
preserved.

## Changed

- `.agents/roles/*.md`: retained one complete canonical body for each role.
- `.codex/agents/*.toml`: synchronized canonical bodies without changing the
  original model, reasoning, or sandbox contract.
- `.claude/agents/*.md`, `.opencode/agents/*.md`, `.cursor/agents/*.md`, and
  `.gemini/agents/*.md`: added or synchronized native provider adapters.
- `scripts/check-harness.sh`: verifies exact inventories, byte-equivalent
  bodies, provider metadata, strict frontmatter, permissions, and malformed or
  duplicate configuration fixtures.
- `specs/T-0005-native-agent-parity.md`,
  `docs/decisions/ADR-003-native-agent-parity.md`, and
  `docs/sources/contracts/NATIVE_AGENT_PARITY.md`: record the adapter design,
  official provider behavior, and Cursor's partial enforcement boundary.
- `README.md` and `docs/ai/TOOL_COMPATIBILITY.md`: document current native
  support and the distinction between contract parity and model performance.

## Acceptance Criteria

- [x] AC-1 — all seven roles exist in every native five-tool location and all
  28 Markdown bodies plus seven Codex TOML bodies match the canonical roles.
- [x] AC-2 — exact inventories, strict metadata, permission sets, duplicate
  keys, malformed YAML, and supported no-delegation controls are checked;
  Cursor's unenforceable portion is explicitly documented.
- [x] AC-3 — ADR-003 and the verified source contract record official behavior
  and limitations as of 2026-08-20.
- [x] AC-4 — root, alternate-CWD, syntax, and opt-in self-tests pass.
- [x] AC-5 — all seven Codex TOML files retain their model, reasoning-effort,
  and sandbox settings while using the full canonical responsibilities.

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

Python tomllib parsing
TOML PARSE PASSED: 7 agents

Skill validation
SKILL VALIDATION PASSED: 15 entries

git diff --check
PASS
```

## Review

Independent R2 review ended with `VERDICT: PASS` after two normal fix cycles.
The review first exposed duplicate-key and Cursor-enforcement overclaims, then
an ignored-indentation YAML bypass. The final candidate rejects both classes
and documents the remaining Cursor boundary accurately.

## Residual Risks and Follow-up

- Provider versions, managed policy, available tools, and administrator
  settings can alter actual discovery or effective permissions.
- Cursor no-delegation and complete shell restriction remain best-effort unless
  managed policy or hooks enforce them.
- Deterministic repository checks do not replace live provider smoke tests.
- Copilot native agents and the end-user catalog are intentionally T-0006.

## Rollback

Revert T-0005's native adapters, canonical role synchronization, harness
checks, ADR/spec/source contract, and compatibility documentation together. No
provider-side state requires cleanup.
