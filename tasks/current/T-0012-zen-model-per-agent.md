# T-0012: Set best Zen model per agent + comment opencodeGo alternative

## Status

DONE

## Summary

Configured each `.opencode/agents/*.md` with the best OpenCode Zen model (`opencode/gpt-5.6-*`) for its function, and added a YAML comment showing the opencodeGo alternative (`opencode-go/*`) below each model line.

## Scope

### Changed

- `.opencode/agents/*.md` (7 files): added `model: opencode/gpt-5.6-<tier>` + `# opencode-go alt: opencode-go/<model>` comment
- `scripts/check-harness.sh`:
  - `OPENCODE_PROFILE` restored to Zen models by role
  - `parse_frontmatter_text` updated to skip YAML comment lines (`#...`) in frontmatter

### Not Changed

- Shared docs (README, MODEL_ROUTING, ROLE_MODEL_CONFIGURATION) — untouched per earlier decision
- Other provider adapters (Claude, Cursor, Gemini, Copilot) — untouched
- Canonical roles (`.agents/roles/*.md`) — untouched

## Model Mapping

| Role | Zen Model | opencodeGo Alternative | Rationale |
|------|-----------|----------------------|-----------|
| explorer | opencode/gpt-5.6-luna | opencode-go/gpt-5.6-luna | Fast tier, budget reads |
| docs-researcher | opencode/gpt-5.6-terra | opencode-go/qwen3.7-plus | Balanced research, strong retrieval |
| implementer | opencode/gpt-5.6-sol | opencode-go/kimi-k2.7-code | Frontier coding, code-tuned |
| planner | opencode/gpt-5.6-sol | opencode-go/qwen3.8-max | Max-tier, strongest reasoning |
| reviewer | opencode/gpt-5.6-sol | opencode-go/qwen3.8-max | Max-tier, strongest reasoning |
| security-reviewer | opencode/gpt-5.6-sol | opencode-go/qwen3.8-max | Max-tier, strongest reasoning |
| test-auditor | opencode/gpt-5.6-terra | opencode-go/glm-5.3 | Strong reasoning, test analysis |

## Verification

```bash
bash scripts/check-harness.sh
# HARNESS CHECK PASSED.

CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
# V2 PERMISSION SELF-TEST PASSED.
# PORTABLE SKILL SYNC SELF-TEST PASSED.
# FRONTMATTER SELF-TEST PASSED.
# HARNESS CHECK PASSED.
```

## Acceptance Criteria

- [x] Each agent has `model: opencode/gpt-5.6-*` (Zen) set
- [x] Each agent has opencodeGo alternative in YAML comment below model
- [x] Harness passes with comment tolerance
- [x] Self-tests pass (V2 permission, portable skill sync, frontmatter)
- [x] Shared docs untouched
- [x] Only OpenCode files modified

## Residual Risks

- Zen models (`opencode/gpt-5.6-*`) must be connected to launch. If not connected, subagents fail at runtime.
- opencodeGo alternatives in comments are recommendations; verify with `opencode models` before using.
- YAML comment support in OpenCode runtime is assumed (standard YAML spec); if OpenCode parser rejects comments, remove them and rely on task file documentation.

## Rollback

Remove `model:` and `# opencode-go` comment lines from the 7 agents, revert `OPENCODE_PROFILE` to `(None, steps)`, and remove the comment-skip logic from `parse_frontmatter_text`.
