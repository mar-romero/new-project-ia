# Source Contract — Agent Tool Compatibility

Provider: Codex, Claude Code, Cursor, OpenCode, GitHub Copilot and Gemini CLI

Purpose: Keep the shared project policy and reusable skills portable without
claiming identical runtime behavior across tools.

Status: VERIFIED

Date verified: 2026-08-20

## Authoritative sources

| Tool | Documentation | Contract used |
|---|---|---|
| Claude Code | [Skills](https://code.claude.com/docs/en/slash-commands) and [features overview](https://code.claude.com/docs/en/features-overview) | Project skills are discovered from `.claude/skills/<name>/SKILL.md`; `@path` imports are supported; model invocation is enabled when `disable-model-invocation` is absent. |
| Gemini CLI | [Using agent skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md) and [configuration](https://github.com/google-gemini/gemini-cli/blob/main/docs/reference/configuration.md) | Workspace skills are discovered from `.gemini/skills/` or the `.agents/skills/` alias; skills are enabled by default, but each activation requires user consent. `/skills list` inspects discovery and `/skills reload` refreshes it. |
| OpenCode | [Rules](https://opencode.ai/docs/rules/) and [configuration](https://opencode.ai/docs/config) | Root `AGENTS.md` is read; root `opencode.json` supports an `instructions` array that is combined with it. |
| GitHub Copilot | [Custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions), [custom agents](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli), and [CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) | `.github/copilot-instructions.md` supports repository-relative `@` imports; native project agents use `.github/agents/*.agent.md`; `.agents/skills/` is discovered. |
| Cursor | [Rules](https://prod.cursor.com/docs/rules) and [Agent Skills](https://prod.cursor.com/docs/skills) | Root `AGENTS.md` and project `.agents/skills/` are discovered. |

## Interface used

Committed instruction and skill files only. No credentials, network service,
provider model, permission setting, or automatic role translation is configured.

## Semantics and limitations

- Imports supply context; they are not enforcement boundaries.
- Claude Code automatically discovers the thin project adapter at
  `.claude/skills/software-engineering/SKILL.md`. Its absent
  `disable-model-invocation` setting permits model invocation; the adapter's
  `@../../../.agents/skills/software-engineering/SKILL.md` import keeps the
  canonical content in the shared directory.
- Gemini CLI automatically discovers the canonical skill through its native
  `.agents/skills/` alias. Discovery and default enablement do not bypass the
  user's consent: Gemini asks for it every time a skill is activated.
- Role intent is canonical under `.agents/roles/`; every supported provider has
  checked native adapters because their metadata and permission formats differ.
- Tool behavior and discovery may change; re-verify this contract when updating
  compatibility adapters.

## Unknown / Not Documented

- Equivalent instructions do not guarantee identical model behavior, tool
  permissions, context ordering, or automatic skill selection.
