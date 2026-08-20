# Claude Code project adapter

@AGENTS.md
@AI_POLICY.md

Thin adapters expose every canonical project skill under `.claude/skills/`;
they may invoke automatically when relevant and import their canonical content
from `.agents/skills/`. They remain on demand except `software-engineering`,
which the implementer preloads because coding is its defined responsibility.
