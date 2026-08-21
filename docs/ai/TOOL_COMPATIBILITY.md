# Compatibility with coding agents

## Outcome

This starter can share its project policy across Codex, Claude Code, Cursor,
OpenCode, GitHub Copilot and Gemini CLI. `AGENTS.md` is the canonical shared
project policy; `AI_POLICY.md` is its companion policy. Adapters reference
those files instead of copying their content.

## Quick path

Open the repository root in your preferred tool, then use its inspection
command below to confirm the expected context was loaded. Run the harness after
editing adapters:

```bash
bash scripts/check-harness.sh
```

| Tool | Committed configuration | What it loads | Verify in the tool |
|---|---|---|---|
| Codex | `AGENTS.md`, `.codex/agents/`, `.agents/skills/` | Shared policy, every canonical skill, and seven checked native roles | Ask Codex to use a named role and inspect the loaded skills. |
| Claude Code | `CLAUDE.md`, `.claude/skills/`, `.claude/agents/` | Shared policy, thin adapters for every canonical skill, and seven native role adapters | `/memory`; `/skills`; `/agents`. |
| Cursor | `.cursor/agents/`, `AGENTS.md`, `.agents/skills/` | Shared policy and skills plus seven native role adapters | Open Customize → Agents/Rules/Skills. |
| OpenCode | `opencode.json`, `.opencode/agents/` | Root rules, native `.agents/skills/` discovery, and seven native role adapters | Use `@explorer` (or another role) and inspect context. |
| GitHub Copilot | `.github/copilot-instructions.md`, `.github/agents/`, `.agents/skills/` | Shared policy and skills plus seven native, tool-restricted role adapters | Copilot CLI: `/agent`; `/instructions`. |
| Gemini CLI | `GEMINI.md`, `.gemini/agents/`, `.agents/skills/` | Shared policy and skills plus seven native, tool-restricted roles | `/agents`; `@explorer`; `/skills list`; `/skills reload`. |

## Intentional boundaries

- `.agents/roles/` contains the canonical bodies for explorer, planner,
  implementer, reviewer, test-auditor, security-reviewer, and docs-researcher.
  Codex, Claude Code, OpenCode, Cursor, Gemini CLI, and GitHub Copilot use
  native adapters whose bodies are checked byte-for-byte against that source.
  Provider-specific frontmatter preserves each tool's documented permission
  model.
- `.agents/skills/` remains the canonical skills location. Claude Code's thin
  adapters import each canonical skill rather than copying it. Codex, Cursor,
  OpenCode, GitHub Copilot, and Gemini CLI discover `.agents/skills/` natively;
  Gemini requires user consent whenever it activates a skill. Skills remain on
  demand, except the Claude implementer's `software-engineering` preload.
- New portable skills are opt-in: when a user requests all-provider support,
  `portable-skill-authoring` creates the canonical source and
  `scripts/sync-portable-skills.sh --write` generates the deterministic Claude
  wrapper. The harness accepts additional valid canonical skills and checks all
  canonical/Claude pairs; it still requires the baseline inventory.
- Parity means the same role intent, skills, and workflow. It does not promise
  identical model quality, latency, cost, context handling, or runtime behavior.
- Each adapter has a checked, provider-native role/model profile. The exact
  matrix, access requirements, runtime fallbacks, and safe customization path
  are documented in [model routing](MODEL_ROUTING.md).
- Cursor's native `readonly` setting blocks edits and state-changing shell
  commands, but its project-agent format does not expose a documented hard
  delegation deny or complete tool allowlist. The shared `Do not delegate`
  contract is therefore best-effort in Cursor unless an organization policy or
  hook enforces it.
- The adapters provide instructions, not sandboxing, approval rules or access
  control. Configure those in each tool or its organization policy.

## References

The shared-file contract is recorded in
[the compatibility source contract](../sources/contracts/AGENT_TOOL_COMPATIBILITY.md).
Native role behavior and its verification date are recorded in
[the native-agent contract](../sources/contracts/NATIVE_AGENT_PARITY.md).
Role purposes, invocation, context policy, and the full matrix are in the
[portable agent catalog](AGENT_CATALOG.md). Copilot behavior and the Gentle-AI
comparison are recorded in
[the Copilot and portable-harness contract](../sources/contracts/COPILOT_AND_PORTABLE_HARNESS.md).
Current model schemas and IDs are recorded in
[the role-model source contract](../sources/contracts/ROLE_MODEL_CONFIGURATION.md).
