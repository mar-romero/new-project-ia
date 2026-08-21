# Completion Report — T-0001

## Status

DONE

## Outcome

The starter now shares its canonical `AGENTS.md` and `AI_POLICY.md` policy
across Codex, Claude Code, Cursor, OpenCode, GitHub Copilot and Gemini CLI,
using native discovery or small adapters rather than copied policy text.

## Changed

- `CLAUDE.md`: imports the canonical policy files and records Claude Code's
  project-skill limitation.
- `GEMINI.md`: imports the canonical policy files with Gemini CLI syntax.
- `opencode.json`: explicitly loads both canonical files in OpenCode.
- `.github/copilot-instructions.md`: repository-wide Copilot adapter importing
  the canonical files.
- `docs/ai/TOOL_COMPATIBILITY.md`: concise support, verification and boundary
  guide for all six tools.
- `docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md`: verified external
  contracts and authoritative sources, dated 2026-08-20.
- `README.md`: links quick start and delivered scope to compatibility guidance.
- `scripts/check-harness.sh`: checks adapter presence and required import/
  instruction lines without depending on a task-specific lifecycle path.
- `tasks/done/T-0001-multi-agent-compatibility.md`: durable task record.

## Acceptance Criteria

- [x] AC-1 — Claude Code and Gemini CLI import both canonical files; OpenCode
  has explicit instructions; Copilot has repository instructions; Cursor's
  native discovery is documented; harness checks the adapters.
- [x] AC-2 — the compatibility guide lists paths, limitations, inspection
  commands and a source contract with authoritative URLs.

## Verification

```text
C:\Program Files\Git\bin\bash.exe scripts/check-harness.sh
Checking project starter harness...
HARNESS CHECK PASSED.

node -e "const fs=require('fs'); const cfg=JSON.parse(fs.readFileSync('opencode.json','utf8')); const wanted=['AGENTS.md','AI_POLICY.md']; if (JSON.stringify(cfg.instructions)!==JSON.stringify(wanted)) process.exit(1); console.log('opencode instructions: canonical files only')"
opencode instructions: canonical files only

git diff --check
No output; passed.
```

## Review

Independent review: PASS after one targeted fix. The initial HIGH finding was
removed by making the reusable harness independent of the task's current/done
lifecycle location; the re-review found no blocker or high finding.

## Residual Risks and Follow-up

- Provider conventions, import behavior and skill discovery can change by
  version. Re-verify the source contract before changing adapters.
- Equivalent instruction files do not guarantee equivalent model behavior or
  permissions. Configure enforcement controls in the selected tool.
- Codex roles are intentionally not translated to other agent schemas.

## Rollback

Revert this task's tracked adapter, documentation, README and harness changes
with the normal Git revert workflow. No credentials, remote state or migrations
were created.
