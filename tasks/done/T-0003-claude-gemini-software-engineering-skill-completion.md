# Completion Report — T-0003

## Status

DONE

## Outcome

Claude Code now exposes the canonical `software-engineering` guidance through
a thin project-skill adapter, and Gemini CLI uses its native `.agents/skills/`
alias. Neither tool receives a copied canonical skill or reference tree.

## Changed

- `.claude/skills/software-engineering/SKILL.md`: added the Claude Code skill
  entry point with a relative import to the canonical guidance.
- `CLAUDE.md`: documents `/software-engineering` and relevant automatic model
  invocation.
- `GEMINI.md`: documents native discovery, skill use, `/skills list`,
  `/skills reload`, and activation consent.
- `docs/ai/TOOL_COMPATIBILITY.md`: records the Claude adapter and Gemini native
  discovery boundary.
- `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`: records the verified
  discovery, import, invocation, enablement, and consent contracts.
- `scripts/check-harness.sh`: checks the adapters and canonical import, and now
  resolves the repository root from its own location before checking paths.
- `tasks/done/T-0003-claude-gemini-software-engineering-skill.md`: records the
  completed task and its acceptance criteria.

## Acceptance Criteria

- [x] AC-1 — Claude adapter has valid skill frontmatter and the exact canonical
  import; both canonical and adapter skill validation passed.
- [x] AC-2 — `GEMINI.md` and the source contract record native `.agents/skills/`
  discovery, `/skills list`, and `/skills reload`; the harness checks markers.
- [x] AC-3 — the harness requires the Claude adapter and canonical import, and
  passed both from the repository root and when invoked from `scripts/`.

## Source Contract

Authoritative discovery and activation details are recorded in
`docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`, verified 2026-08-20.

## Verification

```text
python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .agents\skills\software-engineering
Skill is valid!

python C:\Users\romer\.codex\skills\.system\skill-creator\scripts\quick_validate.py .claude\skills\software-engineering
Skill is valid!

C:\Program Files\Git\bin\bash.exe -n scripts/check-harness.sh
PASS

C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
HARNESS CHECK PASSED.

C:\Program Files\Git\bin\bash.exe -c 'cd scripts && ./check-harness.sh'
HARNESS CHECK PASSED.

git diff --check
PASS
```

## Review

Independent review: PASS after one targeted fix cycle. The first review found
that the harness depended on the caller's current directory; resolving the
repository root from `BASH_SOURCE[0]` fixed it, and the re-review passed.

## Decisions

No human decision or ADR was required. The external runtime contracts used are
documented in the source contract.

## Residual Risks and Follow-up

- Tool runtime versions or administrator settings can change skill discovery,
  model invocation, or consent behavior; re-verify the source contract when
  upgrading the supported tools.
- No speculative follow-up is planned.

## Rollback

Revert the T-0003 files together: the Claude adapter, `CLAUDE.md`, `GEMINI.md`,
compatibility documentation, source contract, and matching harness checks. The
canonical `.agents/skills/software-engineering/` content remains unchanged.
