---
id: SPEC-T-0005
title: Native agent parity for five coding tools
status: ACCEPTED
created: 2026-08-20
updated: 2026-08-20
---

# SPEC-T-0005 — Native agent parity for five coding tools

## Objective

Make the repository's seven role contracts natively discoverable in Codex,
Claude Code, OpenCode, Cursor, and Gemini CLI, while preserving one canonical
body per role and the shared fourteen-skill inventory.

## Design

`.agents/roles/<role>.md` is the canonical role body. Each native adapter
keeps only provider-specific frontmatter/configuration and repeats that exact
body; no undocumented runtime import is used. The harness extracts Markdown
and TOML bodies and compares them to the canonical source.

Cursor adapters use `.cursor/agents/<role>.md`, `model: inherit`, and
`readonly: true` for the six readers. Gemini adapters use
`.gemini/agents/<role>.md`, `kind: local`, `model: inherit`, explicit reader
tool allowlists, and the documented writer tool set for implementer. Codex
retains all existing model, reasoning, and sandbox settings; only
`developer_instructions` is synchronized. The canonical bodies retain the
substantive responsibilities from the original Codex roles and add explicit
non-delegation, so portability does not reduce Codex review or implementation
quality.

## Security and failure behavior

Every canonical body forbids delegation. Reader adapters receive the strongest
documented project-agent restriction each provider exposes. Cursor's
`readonly: true` blocks edits and state-changing shell commands, but its agent
frontmatter does not document a tool allowlist or delegation-deny field; the
no-delegation body is therefore an instruction rather than an access-control
boundary in Cursor. A missing, unexpected, non-native, ambiguously parsed, or
drifting adapter fails the harness. The configuration does not replace
provider or organization sandboxing, consent, approvals, or tool policy.

## Limitations

Parity means shared role intent, skills, workflow, and checked configuration.
It cannot make proprietary models, provider policies, context windows, tool
implementations, or runtime performance identical.

## Rollback

Revert the T-0005 files as a unit. No external state is changed.
