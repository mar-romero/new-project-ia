---
id: SPEC-T-0008
title: Portable skill authoring and adapter synchronization
status: ACCEPTED
created: 2026-08-20
updated: 2026-08-20
---

# SPEC-T-0008 — Portable skill authoring and adapter synchronization

## Problem and Objective

Canonical project skills are already discovered by Codex, Cursor, Gemini CLI,
OpenCode, and GitHub Copilot. Claude Code requires a thin native wrapper. Make
that asymmetry explicit and deterministic so any supported agent can create a
portable skill without remembering provider-specific paths.

## Non-Goals

- Generate or evaluate arbitrary skill content automatically.
- Duplicate canonical skill bodies across providers.
- Change role adapters or provider permission models.

## Users / Consumers

- Developers adding project skills.
- Coding agents asked to create a new skill for all supported providers.

## Inputs and Outputs

Input: a direct `.agents/skills/<kebab-name>/SKILL.md` with exact `name` and
non-empty `description` frontmatter.

Output: `.claude/skills/<kebab-name>/SKILL.md` containing the same metadata and
an import of the canonical skill. The other providers consume the canonical
file directly.

## Domain Model and Invariants

- Baseline skills are listed explicitly and cannot disappear.
- Additional direct skill directories are valid when their metadata matches the
  directory name and they have a generated Claude wrapper.
- Wrapper text is deterministic; a check can identify drift exactly.
- Portability is opt-in per user request, not assumed from every skill request.

## Failure Behavior and Security

The synchronizer rejects unsafe names, absent/ambiguous metadata, non-direct
skill paths, stale wrappers, and Claude wrappers without canonical sources. It
does not access the network, credentials, provider accounts, or global settings.

## External Dependencies

Provider discovery behavior is recorded in
`docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`.

## Acceptance Criteria and Required Tests

The synchronizer must generate/check adapters; the harness must dynamically
validate all canonical skills; temporary fixtures must cover generation and
stale-wrapper rejection; root and alternate-CWD harness runs must pass.

## Observability, Rollback and Open Questions

The scripts report invalid or orphan paths by name. Rollback removes the new
authoring skill and synchronization command, restoring the prior fixed skill
inventory. No provider-side state exists. The only open user choice is whether a
future skill should be portable or provider-specific.
