# Source Contract — Role model configuration

Provider: Codex, Claude Code, Cursor, Gemini CLI, OpenCode, GitHub Copilot CLI

Purpose: Configure model capability and reasoning/work budget per role without
guessing provider syntax.

Status: VERIFIED

Date verified: 2026-08-21

## Codex / OpenAI

- [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model)
  defines GPT-5.6 Sol for frontier capability, Terra for balanced capability and
  cost, and Luna for efficient high-volume work. It documents effort levels
  from `none` through `max` and recommends measuring higher effort rather than
  assuming it always wins.
- Project agent TOML supports `model` and `model_reasoning_effort`; this starter
  uses Sol for implementation/high-risk reasoning, Terra for balanced audit or
  research, and Luna for exploration.

## Claude Code

- [Subagents](https://code.claude.com/docs/en/sub-agents) supports `model` as
  `haiku`, `sonnet`, `opus`, a full ID, or `inherit`; `effort` supports
  `low`, `medium`, `high`, `xhigh`, and `max` when the chosen model supports it;
  `maxTurns` caps agentic turns.
- [Model configuration](https://code.claude.com/docs/en/model-config) documents
  rolling aliases and currently resolves Anthropic API `opus` and `sonnet` to
  Opus 5 and Sonnet 5. Alias resolution can differ on Bedrock, Google Cloud, or
  Microsoft Foundry.
- Anthropic's [model/effort guidance](https://claude.com/blog/claude-model-and-effort-level-in-claude-code)
  recommends smaller models for routine work, larger models for ambiguity, and
  higher effort when the model skipped investigation or verification.

## Cursor

- [Cursor subagents](https://cursor.com/docs/subagents) accepts `model` as an
  exact ID. Parameters use `model-id[id=value]` pairs; documented examples
  include `claude-opus-5[effort=high]`, `composer-2.5[fast=false]`, and
  combined options such as `effort=high,context=300k`. Empty `composer-2.5[]`
  selects the standard (non-fast) variant. Bracket syntax applies in project
  agent frontmatter; the Task tool's inline model list may expose only one
  variant per family.
- [Grok 4.6](https://cursor.com/docs/models/grok-4-6) is the first-party
  general/reasoning model. Documented effort values are `low`, `medium`,
  `high` (named-model default), and `xhigh`. Fast is the default speed tier on
  Pro and higher; the Start plan fixes Grok at medium effort and standard
  speed. ID used here: `grok-4.6`.
- [Composer 2.5](https://cursor.com/blog/composer-2-5) is the first-party
  coding model. Fast is the product default; this starter pins
  `composer-2.5[fast=true]` for exploration and `composer-2.5[fast=false]` for
  implementation. Composer effort is UNKNOWN / NOT DOCUMENTED in subagent
  frontmatter, so this profile does not invent an `effort` field for it.
- [Models and pricing](https://cursor.com/docs/models-and-pricing) places Grok
  4.6 and Composer 2.5 in the Cursor Models pool. Third-party IDs (Claude,
  GPT-5.6, Gemini) remain available but draw from the Other Models pool.
  Admin and plan restrictions may force a fallback.

## Gemini CLI

- [Custom subagents](https://geminicli.com/docs/core/subagents/) supports
  `model`, `temperature`, `max_turns`, and `timeout_mins`. It does not document
  a direct reasoning-effort field in custom-agent frontmatter.
- [Gemini 3 on Gemini CLI](https://geminicli.com/docs/get-started/gemini-3/)
  documents `gemini-3.1-pro-preview` availability and routing, subject to
  account rollout, quota, and capacity. The subagent schema example uses
  `gemini-3-flash-preview`.
- [Advanced model configuration](https://geminicli.com/docs/cli/generation-settings/)
  can inject `thinkingConfig` through settings overrides, but values are passed
  with minimal validation. This starter does not guess thinking budgets; it
  uses model capability and bounded turns instead.

## OpenCode

- [V2 agents](https://opencode.ai/v2/docs/agents) accepts `model` as
  `provider/model-id` and documents `steps` as the per-agent work limit. It does
  not document `reasoningEffort` as agent frontmatter.
- [V2 models](https://opencode.ai/v2/docs/models) configures provider/model
  settings and selects a defined variant with `model#variant`. This starter
  does not invent a reasoning variant without a connected catalog; it uses the
  model tier plus `steps` in each agent.
- [OpenCode Zen](https://opencode.ai/docs/zen) is an optional paid gateway whose
  catalog is tested and recommended for coding agents. Current IDs include
  `gpt-5.6-sol`, `gpt-5.6-terra`, and `gpt-5.6-luna`; configuration uses the
  `opencode/` provider prefix. Consumers must connect Zen and add billing before
  these profiles can execute.
- `opencode models` is the authoritative local check for the currently
  connected catalog. Alternative providers require replacing both model IDs
  and any verified provider/model variant.

## GitHub Copilot CLI

- [Copilot CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
  documents custom-agent `model` and `reasoningEffort`; an unavailable setting
  falls back to the session value. Its current supported table recommends
  Haiku 4.5 for lightweight work, GPT-5.4 for complex reasoning, and
  GPT-5.3-Codex for code-focused tasks.
- The same reference states that session `Auto` overrides a subagent's declared
  model with the resolved session model.

## Limitations and unknowns

- “Best” is workload-specific and requires evaluations. This profile is an
  evidence-backed starting point, not a cross-provider benchmark result.
- Model IDs, aliases, price, quotas, and supported effort levels are unstable.
- Live entitlements and effective fallbacks cannot be validated without each
  developer's installed, authenticated CLI.
- GitHub Copilot does not expose current Opus 5 or GPT-5.6 in the supported CLI
  table used here; the profile does not invent those IDs.
- Gemini preview availability is account-dependent. If unavailable, use the
  tool's current Pro/Auto routing or update the profile from `/model`.
