---
name: portable-skill-authoring
description: Create or update a reusable project skill and, when the user explicitly chooses portability, synchronize it for every supported coding provider.
---

# Portable Skill Authoring

Use this skill when a user asks to create or revise a project skill and may want
it to work in Codex, Claude Code, Cursor, Gemini CLI, OpenCode, and GitHub
Copilot.

## Decide scope first

Confirm whether the user wants the skill shared across all supported providers
or only in one provider. Do not assume portability from a generic request to
"create a skill." If the user chooses all providers, follow the portable path
below. For a provider-specific skill, use that provider's native location and
do not claim cross-provider availability.

## Portable path

1. Choose a concise kebab-case name and a discriminating description. Ask only
   if the intended behavior cannot be inferred safely.
2. Create or update the canonical content at
   `.agents/skills/<name>/SKILL.md`. Keep only `name` and `description` in its
   frontmatter; make the directory name and `name` identical.
3. Write useful, task-specific guidance. Keep the entrypoint concise and move
   substantial conditional detail to a linked reference only when it materially
   reduces context use.
4. Run `bash scripts/sync-portable-skills.sh --write`. This creates the thin
   Claude Code wrapper. Codex, Cursor, Gemini CLI, OpenCode, and GitHub Copilot
   discover `.agents/skills/` natively.
5. Run `bash scripts/sync-portable-skills.sh --check` and
   `bash scripts/check-harness.sh`. Use the Codex skill validator too when it is
   available.
6. Update user-facing documentation when the skill is broadly useful. Do not
   add a skill to every catalog merely because it exists.

## Constraints

- The canonical file is the only source of skill instructions. Never copy its
  body into provider-specific directories.
- A direct `.agents/skills/_.../` directory is a shared support resource, not
  an invocable skill: it must not contain `SKILL.md` and receives no adapter.
- The generated Claude wrapper is deterministic. Do not edit it by hand.
- Do not change role permissions, provider credentials, or models while adding
  a skill unless the user separately requests that work.
- If the synchronizer or harness reports a stale/orphan wrapper, repair the
  canonical source and rerun synchronization rather than weakening validation.
