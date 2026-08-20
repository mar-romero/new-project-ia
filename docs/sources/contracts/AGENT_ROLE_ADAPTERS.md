# Source Contract — Native Role Adapters

Provider: Claude Code and OpenCode

Status: VERIFIED

Date verified: 2026-08-20

## Claude Code

Sources: [subagents](https://code.claude.com/docs/en/sub-agents),
[memory](https://code.claude.com/docs/en/memory), and
[skills](https://code.claude.com/docs/en/slash-commands).

Project agents are Markdown files under `.claude/agents/**/*.md`. `name` and
`description` are required; `tools`, `disallowedTools`, `permissionMode`, and
`skills` are supported frontmatter. `skills` preloads full skill content.
`permissionMode: plan` is supported. The docs use `Read`, `Glob`, `Grep`,
`Bash`, `Edit`, `Write`, `WebFetch`, and `WebSearch` as tool names. No runtime
body-import mechanism is used for agent prompts.

Claude project skills are discovered under `.claude/skills/<name>/SKILL.md`.
The existing skill contract supports `@path` imports, so each thin adapter
imports its canonical `.agents/skills/<name>/SKILL.md` source. Automatic skill
selection remains enabled when no `disable-model-invocation` setting is present.

## OpenCode

Sources: [agents](https://opencode.ai/docs/agents),
[skills](https://opencode.ai/docs/skills), [rules](https://opencode.ai/docs/rules),
and [V1 to V2 migration](https://opencode.ai/v2/docs/migrate-v1).

Preferred V2 project agent files are `.opencode/agents/<name>.md`; the filename
is the agent name. Markdown frontmatter supports `description`, `mode`, and an
ordered `permissions` array; `mode: subagent` is supported. Each V2 permission
uses `action`, `resource`, and `effect`. V2 renames `bash` to `shell` and
`task` to `subagent`; this project uses `edit`, `shell`, `subagent`,
`webfetch`, and `websearch` actions with `resource: "*"`.
Permission rules are ordered and the last matching action/resource rule is
effective. For this project's seven restricted adapters, the harness does not
model the general evaluator: it permits only the closed five-action set, one
`resource: "*"` rule per action, with no duplicates, wildcards, or
resource-specific overrides.
An effective `subagent` deny prevents model delegation but does not prevent a
user from explicitly invoking an agent with `@name`. OpenCode natively
discovers `.agents/skills/*/SKILL.md`. No agent-body import contract is
documented, so adapters repeat the checked canonical body. This project uses
V2 `.opencode/agents/` terminology and does not mix V1 agent-permission keys.

## Limitations

Provider versions, managed policy, available tools, and administrator settings
can change discovery or effective permissions. The contract does not guarantee
identical model behavior or provider runtime smoke-test results.
