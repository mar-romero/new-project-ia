# Source Contract — Copilot agents and portable harness

Provider: GitHub Copilot CLI / coding agent and Gentle-AI reference repository

Purpose: Add native Copilot role adapters and validate the multi-runtime
adapter approach.

Status: VERIFIED

Date verified: 2026-08-20

## Authoritative sources

- [Creating custom agents for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli):
  project agents use `.github/agents/<id>.agent.md`; Copilot can infer a role,
  users can select it with `/agent`, and the CLI supports `--agent`.
- [Custom agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration):
  Markdown profiles use YAML frontmatter; `description` is required; `name`,
  `tools`, and model fields are supported. The `tools` field is an allowlist.
- [Copilot CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference):
  tool aliases include `read`, `search`, `edit`, `execute`, `agent`, and `web`;
  project skills are discovered from `.agents/skills/`.

## Interface used

- Seven files at `.github/agents/<role>.agent.md`.
- Exact `name`, `description`, and `tools` metadata.
- Reader tools: `read` and `search`.
- Docs researcher: reader tools plus `web`.
- Implementer: reader tools plus `edit` and `execute`.
- The `agent` tool is omitted from every profile to prevent nested delegation.
- No provider model is fixed; the active Copilot model remains provider/user
  controlled.

## Gentle-AI comparison

[Gentle-AI](https://github.com/Gentleman-Programming/gentle-ai) supports several
coding runtimes through a configurator and runtime-specific adapters. Its
[agent documentation](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/agents.md)
also records different delegation capabilities by runtime. This supports two
decisions here: keep canonical intent independent of providers, and adapt the
native configuration rather than pretending one file format behaves equally
everywhere.

This repository does not copy Gentle-AI code or require its installer. A
committed static adapter set is smaller for seven roles, works after cloning,
avoids writes to user-global configuration, and is deterministically checked.

## Limitations and unknowns

- Unrecognized or unavailable Copilot tool aliases may be ignored or affected
  by product version, plan, organization policy, and runtime surface.
- Profile-body import syntax is not documented, so bodies are checked copies
  rather than undocumented imports.
- Same instructions and skills do not guarantee equal model quality, routing,
  context usage, latency, or cost.
- Provider installation, authentication, and live smoke tests remain the
  consumer's responsibility.
