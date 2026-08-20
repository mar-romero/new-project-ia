# Source Contract — Native Agent Parity

Status: VERIFIED

Date verified: 2026-08-20

## Sources and behavior used

- [Codex custom agents](https://learn.chatgpt.com/docs/agent-configuration/subagents.md)
  and [AGENTS.md instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md.md):
  project agents use `.codex/agents/*.toml`; `name`, `description`, and
  `developer_instructions` are required, with optional model and sandbox
  settings. Codex discovers `.agents/skills/`.
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents): project
  agents use `.claude/agents/*.md`; frontmatter supports tools, permissions,
  and skill preload. Claude skills use `.claude/skills/`.
- [OpenCode agents](https://opencode.ai/docs/agents) and
  [skills](https://opencode.ai/docs/skills): project agents use
  `.opencode/agents/*.md`; agents use native permissions and `.agents/skills/`
  is discovered.
- [Cursor subagents](https://cursor.com/docs/subagents) and
  [skills](https://cursor.com/docs/skills): project agents use
  `.cursor/agents/*.md`; supported fields include `name`, `description`,
  `model`, and `readonly`; `.agents/skills/` is discovered. `readonly: true`
  blocks edits and state-changing shell commands, but does not disable all
  shell use. Cursor permits a direct subagent to launch one child; its project
  agent frontmatter does not document a per-agent tool allowlist or a field
  that denies delegation.
- [Gemini CLI subagents](https://geminicli.com/docs/core/subagents/),
  [tools](https://geminicli.com/docs/reference/tools/), and
  [agent skills](https://geminicli.com/docs/cli/using-agent-skills/): project
  agents use `.gemini/agents/*.md`; supported fields include `name`,
  `description`, `kind`, `tools`, and `model`; `.agents/skills/` is
  discovered. Local subagents are enabled by default in the current release.

## Adapter contract

All five providers receive the same seven canonical role bodies. Model
selection was subsequently specialized by role in T-0007 and ADR-004.
The current exact profile and provider limitations are recorded in
`ROLE_MODEL_CONFIGURATION.md`; this contract remains authoritative for native
agent discovery, permissions, invocation, and body parity.
Gemini reader roles use only `read_file`, `read_many_files`, `list_directory`,
`glob`, and `grep_search`; docs-researcher additionally uses
`google_web_search` and `web_fetch`; implementer adds `write_file`, `replace`,
`run_shell_command`, and `activate_skill`.

## Limitations

Provider documentation, managed policy, CLI version, available tools, consent,
and organization configuration can change. These files guarantee checked
repository configuration, not identical model performance, token consumption,
or runtime behavior. In Cursor, non-delegation is prompt-level guidance and
`readonly` is a partial native restriction; deployments that require a hard
boundary must enforce it with their own managed tool policy or hook.
