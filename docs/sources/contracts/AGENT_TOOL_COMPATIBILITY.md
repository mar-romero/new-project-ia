# Source Contract — Agent Tool Compatibility

Provider: Codex, Claude Code, Cursor, OpenCode, GitHub Copilot and Gemini CLI

Purpose: Keep the shared project policy and reusable skills portable without
claiming identical runtime behavior across tools.

Status: VERIFIED

Date verified: 2026-08-21

## Authoritative sources

| Tool | Documentation | Contract used |
|---|---|---|
| Claude Code | [Skills](https://code.claude.com/docs/en/slash-commands), [subagents](https://code.claude.com/docs/en/sub-agents), and [features overview](https://code.claude.com/docs/en/features-overview) | Project skills are discovered from `.claude/skills/<name>/SKILL.md`; `@path` imports are supported; model invocation is enabled when `disable-model-invocation` is absent. Project subagents use `.claude/agents/` and have their own context windows. |
| Gemini CLI | [Using agent skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md), [subagents](https://github.com/google-gemini/gemini-cli/blob/main/docs/core/subagents.md), and [configuration](https://github.com/google-gemini/gemini-cli/blob/main/docs/reference/configuration.md) | Workspace skills are discovered from `.gemini/skills/` or the `.agents/skills/` alias; skills are enabled by default, but each activation requires user consent. `/skills list` inspects discovery and `/skills reload` refreshes it. Project subagents use `.gemini/agents/` and run in separate context loops. |
| OpenCode | [Rules](https://opencode.ai/docs/rules/), [agents](https://opencode.ai/docs/agents/), and [configuration](https://opencode.ai/docs/config) | Root `AGENTS.md` is read; root `opencode.json` supports an `instructions` array that is combined with it. Named project subagents can be invoked by the parent. |
| GitHub Copilot | [Custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions), [custom agents](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli), and [CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) | `.github/copilot-instructions.md` supports repository-relative `@` imports; native project agents use `.github/agents/*.agent.md`; `.agents/skills/` is discovered. |
| Cursor | [Rules](https://prod.cursor.com/docs/rules), [Agent Skills](https://prod.cursor.com/docs/skills), and [subagents](https://prod.cursor.com/docs/subagents) | Root `AGENTS.md` and project `.agents/skills/` are discovered. Project subagents use `.cursor/agents/`, start clean, and can run concurrently. |

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
- The same documented Claude import mechanism applies to every direct
  `.agents/skills/<name>/SKILL.md`. `scripts/sync-portable-skills.sh` derives a
  deterministic wrapper for each canonical skill; the other five providers use
  their documented native `.agents/skills/` discovery.
- Gemini CLI automatically discovers the canonical skill through its native
  `.agents/skills/` alias. Discovery and default enablement do not bypass the
  user's consent: Gemini asks for it every time a skill is activated.
- Role intent is canonical under `.agents/roles/`; every supported provider has
  checked native adapters because their metadata and permission formats differ.
- `judgment-day` resolves its two judges as two fresh invocations of the
  existing `reviewer` role and its optional fix actor as the existing
  `implementer` role. Judge A and Judge B are audit-ledger labels, never
  provider agent names. The skill must stop with `JUDGMENT: ESCALATED` before
  review if the current runtime cannot demonstrate two isolated, read-only
  reviewer invocations.
- Claude Code documents project subagents in `.claude/agents/` and separate
  context windows; Cursor documents project subagents, clean contexts, and
  concurrent launches; Gemini CLI documents project `.gemini/agents/` as
  subagent tools with separate context loops; OpenCode documents named
  subagents; and Copilot CLI documents repository profiles run as subagents
  with separate context windows. These capabilities do not guarantee that a
  particular installed version, policy, or account can launch two `reviewer`
  instances concurrently, so the runtime preflight remains mandatory.
- Tool behavior and discovery may change; re-verify this contract when updating
  compatibility adapters.

## Unknown / Not Documented

- Equivalent instructions do not guarantee identical model behavior, tool
  permissions, context ordering, or automatic skill selection.
- A portable, programmatic way to create named one-off agents from a skill is
  UNKNOWN / NOT DOCUMENTED. The skill relies only on the checked, existing
  role adapters and records the runtime result.
