# ADR-002 — Portable role contracts with native adapters

Status: ACCEPTED

Date: 2026-08-20

Related task: T-0004

## Context

The harness needs a common role vocabulary without claiming that all coding
agents share one configuration format or support runtime prompt imports.

## Decision drivers

- correctness and drift detection
- least privilege
- low token and maintenance cost
- reversibility

## Options considered

### One shared runtime format

Not supported by the verified Claude Code and OpenCode agent contracts.

### Native copies without verification

Simple initially, but role bodies silently drift across tools.

### Canonical contracts plus native adapters and checks

Selected. Neutral bodies live in `.agents/roles/`; provider adapters retain
native frontmatter and are compared deterministically to their source body.

### Generated adapters

Would reduce manual repetition but adds a generator, schema, and failure mode
without a current need.

## Decision and consequences

Use canonical neutral role bodies and checked Markdown adapters for Claude Code
and OpenCode. Do not use undocumented body imports. Preload
`software-engineering` only for the Claude implementer because its role always
owns coding judgment; other skills remain on demand to conserve context.

OpenCode adapters use the native V2 ordered `permissions` array rather than
legacy grouped permission keys. Reader roles explicitly deny `edit`, `shell`,
`subagent`, `webfetch`, and `websearch`; docs-researcher allows only the two
web actions, while implementer allows only `edit` and `shell`.

Claude receives thin adapters for every current canonical skill because it does
not natively discover `.agents/skills/`; each imports its canonical skill and
is checked for metadata and path parity. OpenCode, Codex, Cursor, and Gemini
use native `.agents/skills/` discovery where documented.

The role contracts give Cursor and Gemini a portable workflow reference, not a
claim of provider-native agent configuration parity.

## Reversibility, security and operations

Rollback is a repository revert. Reader permissions are explicit deny rules;
implementers may write but cannot create nested work. No production access,
credentials, recurring cost, or external configuration is introduced.

## Human approval

Required: NO

Decision: Accepted
