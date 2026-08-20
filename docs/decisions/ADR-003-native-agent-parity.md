# ADR-003 — Canonical role bodies with checked native adapters

Status: ACCEPTED

Date: 2026-08-20

Related task: T-0005

## Context

The harness began with Codex roles and later gained Claude Code and OpenCode
adapters. It must now offer the same seven roles in Cursor and Gemini CLI
without falsely assuming a common configuration format or relying on
undocumented prompt imports.

## Options considered

### Compatibility paths only

Some tools recognize another tool's agent directory, but that leaves native
metadata, least-privilege settings, and tool-specific discovery implicit.

### Symbolic links

Links would avoid repeated files but are not reliably portable across Windows,
archives, and repository consumers.

### Generator or installer

An installer-style approach, such as the broader Gentle-AI project, can suit a
large distribution with optional modules. Here it would add a generator,
schema, execution path, and new drift failure mode for seven small static
adapters.

### Canonical bodies with native adapters and deterministic checks

Selected. Keep the canonical neutral role body in `.agents/roles/`; retain
native files for each tool; verify body parity and provider metadata in the
existing harness.

## Decision

Use the selected approach for Codex, Claude Code, OpenCode, Cursor, and Gemini
CLI. At the time of this decision, Cursor and Gemini used `inherit` and Codex
preserved its existing settings. ADR-004 supersedes only that model-selection
choice with a provider-specific profile. All role bodies explicitly forbid
delegation.
Skills remain canonical under `.agents/skills/`; Claude uses its existing
fourteen thin wrappers, while the other four tools discover that directory
natively. Cursor's `readonly` field is used, but its documented project-agent
frontmatter cannot hard-disable all shell access or child delegation; those
remain prompt-level constraints unless a deployment adds managed policy.

## Consequences

The repository gets native discovery and comparable role intent across the
five tools, with small checked duplication rather than a new build system.
Users still need each provider installed and authorized, and actual model
quality, available tools, policies, and token usage remain provider-specific.

## Reversibility and approval

Rollback is a repository revert. No credentials, billing, provider settings,
or external state changes are involved. Human approval is not required.
