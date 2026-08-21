#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
cd -- "$repo_root"

# Locate a Python interpreter that actually works. On Windows the Microsoft
# Store "python" alias can shadow a real install and exit non-zero; prefer an
# explicit PYTHON override, then a working python, then the "py" launcher, then
# python3. These scripts require Python 3.11+ (tomllib).
resolve_python() {
  if [[ -n "${PYTHON:-}" ]]; then
    printf '%s\n' "$PYTHON"
    return 0
  fi
  if command -v python >/dev/null 2>&1 && python -c 'import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)' >/dev/null 2>&1; then
    printf '%s\n' "python"
    return 0
  fi
  if command -v py >/dev/null 2>&1 && py -3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)' >/dev/null 2>&1; then
    printf '%s\n' "py -3"
    return 0
  fi
  if command -v python3 >/dev/null 2>&1 && python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)' >/dev/null 2>&1; then
    printf '%s\n' "python3"
    return 0
  fi
  printf '%s\n' "python"
}
PY="$(resolve_python)"

echo "Checking project starter harness..."

required_files=(
  "AGENTS.md"
  "AI_POLICY.md"
  "CLAUDE.md"
  "GEMINI.md"
  ".claude/skills/software-engineering/SKILL.md"
  "opencode.json"
  ".codex/config.toml"
  ".github/copilot-instructions.md"
  ".github/PULL_REQUEST_TEMPLATE.md"
  ".github/workflows/harness.yml"
  "docs/ai/DEFINITION_OF_READY.md"
  "docs/ai/DEFINITION_OF_DONE.md"
  "docs/ai/PROJECT_MEMORY.md"
  "docs/ai/TOOL_COMPATIBILITY.md"
  "docs/ai/AGENT_CATALOG.md"
  "docs/ai/MODEL_ROUTING.md"
  "docs/product/PRODUCT_VISION.md"
  "docs/product/ROADMAP.md"
  "tasks/templates/TASK.md"
  "tasks/templates/COMPLETION_REPORT.md"
  "tasks/templates/REVIEW_REPORT.md"
  "specs/templates/FEATURE_SPEC.md"
  "docs/decisions/ADR-000-TEMPLATE.md"
  "docs/sources/contracts/SOURCE_CONTRACT_TEMPLATE.md"
  "docs/sources/contracts/AGENT_TOOL_COMPATIBILITY.md"
  "docs/sources/contracts/AGENT_ROLE_ADAPTERS.md"
  "docs/sources/contracts/NATIVE_AGENT_PARITY.md"
  "docs/sources/contracts/COPILOT_AND_PORTABLE_HARNESS.md"
  "docs/sources/contracts/ROLE_MODEL_CONFIGURATION.md"
  "docs/decisions/ADR-002-portable-role-contracts.md"
  "docs/decisions/ADR-003-native-agent-parity.md"
  "docs/decisions/ADR-004-role-model-routing.md"
  "specs/T-0005-native-agent-parity.md"
  "specs/T-0006-six-tool-harness-guide.md"
  "specs/T-0007-provider-model-routing.md"
  "specs/T-0008-portable-skill-authoring.md"
  "scripts/sync-portable-skills.sh"
  "tests/README.md"
)

required_dirs=(
  ".agents/skills"
  ".agents/roles"
  ".claude/agents"
  ".opencode/agents"
  ".cursor/agents"
  ".gemini/agents"
  ".github/agents"
  ".codex/agents"
  "docs/audits"
  "docs/decisions"
  "docs/product/epics"
  "docs/sources/contracts"
  "scripts"
  "specs/templates"
  "sprints"
  "tasks/backlog"
  "tasks/current"
  "tasks/blocked"
  "tasks/done"
  "tasks/templates"
  "tests"
)

required_agents=(
  "explorer.toml"
  "planner.toml"
  "implementer.toml"
  "reviewer.toml"
  "test-auditor.toml"
  "security-reviewer.toml"
  "docs-researcher.toml"
)

required_roles=(
  "explorer"
  "planner"
  "implementer"
  "reviewer"
  "test-auditor"
  "security-reviewer"
  "docs-researcher"
)

required_skills=(
  "architecture-decision"
  "chained-work"
  "cognitive-doc-design"
  "decision-escalation"
  "github-issue"
  "implementation-loop"
  "independent-review"
  "source-research"
  "software-engineering"
  "systemic-defect-triage"
  "task-close"
  "task-intake"
  "test-strategy"
  "work-unit-commits"
  "portable-skill-authoring"
)

errors=0

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "MISSING FILE: $file"
    errors=$((errors + 1))
  fi
done

for dir in "${required_dirs[@]}"; do
  if [[ ! -d "$dir" ]]; then
    echo "MISSING DIRECTORY: $dir"
    errors=$((errors + 1))
  fi
done

for agent in "${required_agents[@]}"; do
  if [[ ! -f ".codex/agents/$agent" ]]; then
    echo "MISSING AGENT: .codex/agents/$agent"
    errors=$((errors + 1))
  fi
done

for role in "${required_roles[@]}"; do
  for file in ".agents/roles/$role.md" ".claude/agents/$role.md" ".opencode/agents/$role.md" ".cursor/agents/$role.md" ".gemini/agents/$role.md" ".github/agents/$role.agent.md" ".codex/agents/$role.toml"; do
    if [[ ! -f "$file" ]]; then
      echo "MISSING ROLE: $file"
      errors=$((errors + 1))
    fi
  done
done

for skill in "${required_skills[@]}"; do
  if [[ ! -f ".agents/skills/$skill/SKILL.md" ]]; then
    echo "MISSING SKILL: .agents/skills/$skill/SKILL.md"
    errors=$((errors + 1))
  fi
done

required_skill_references=(
  ".agents/skills/software-engineering/references/design-and-architecture.md"
  ".agents/skills/software-engineering/references/quality-testing-security.md"
)

for reference in "${required_skill_references[@]}"; do
  if [[ ! -f "$reference" ]]; then
    echo "MISSING SKILL REFERENCE: $reference"
    errors=$((errors + 1))
  fi
done

require_exact_line() {
  local file="$1"
  local expected="$2"

  if ! grep -Fqx -- "$expected" "$file"; then
    echo "MISSING CONTENT: $file must contain: $expected"
    errors=$((errors + 1))
  fi
}

require_description() {
  local file="$1"

  if ! grep -Eq '^description: .+' "$file"; then
    echo "MISSING DESCRIPTION: $file"
    errors=$((errors + 1))
  fi
}

validate_markdown_frontmatter() {
  if ! $PY - <<'PY'
import os
import re
from pathlib import Path

ROLES = (
    "explorer",
    "planner",
    "implementer",
    "reviewer",
    "test-auditor",
    "security-reviewer",
    "docs-researcher",
)
DESCRIPTIONS = {
    "explorer": "Explore the repository read-only to map relevant files, flows, checks, and risks.",
    "planner": "Plan ambiguous or high-risk work without editing files.",
    "implementer": "Implement one scoped task with evidence-backed checks and no nested delegation.",
    "reviewer": "Independently review a checked candidate and try to falsify it without edits.",
    "test-auditor": "Audit whether tests can detect meaningful defects without editing files.",
    "security-reviewer": "Review security boundaries and report real risks without editing files.",
    "docs-researcher": "Research current official technical contracts without editing application code.",
}
READERS = set(ROLES) - {"implementer"}
NON_WEB_READERS = READERS - {"docs-researcher"}
READ_TOOLS = "Read, Glob, Grep"
GEMINI_READ_TOOLS = "[read_file, read_many_files, list_directory, glob, grep_search]"

CLAUDE_PROFILE = {
    "explorer": ("haiku", "low", "10"),
    "docs-researcher": ("sonnet", "medium", "16"),
    "implementer": ("sonnet", "high", "30"),
    "planner": ("opus", "high", "20"),
    "reviewer": ("opus", "high", "20"),
    "security-reviewer": ("opus", "high", "24"),
    "test-auditor": ("sonnet", "high", "18"),
}
CURSOR_PROFILE = {
    "explorer": "composer-2.5[fast=true]",
    "docs-researcher": "grok-4.6[effort=medium,fast=false]",
    "implementer": "composer-2.5[fast=false]",
    "planner": "grok-4.6[effort=high,fast=false]",
    "reviewer": "grok-4.6[effort=xhigh,fast=false]",
    "security-reviewer": "grok-4.6[effort=xhigh,fast=false]",
    "test-auditor": "grok-4.6[effort=high,fast=false]",
}
GEMINI_PROFILE = {
    "explorer": ("gemini-3-flash-preview", "0.1", "12", "5"),
    "docs-researcher": ("gemini-3-flash-preview", "0.1", "18", "8"),
    "implementer": ("gemini-3.1-pro-preview", "0.1", "30", "10"),
    "planner": ("gemini-3.1-pro-preview", "0.1", "20", "10"),
    "reviewer": ("gemini-3.1-pro-preview", "0.1", "20", "10"),
    "security-reviewer": ("gemini-3.1-pro-preview", "0.1", "24", "10"),
    "test-auditor": ("gemini-3.1-pro-preview", "0.1", "18", "10"),
}
OPENCODE_PROFILE = {
    # OpenCode V2: each agent pins a verified Zen model (opencode/gpt-5.6-*)
    # with a comment showing the opencode-go alternative. The harness skips
    # YAML comment lines (`#...`) in frontmatter so the comment is harmless.
    "explorer": ("opencode/gpt-5.6-luna", "12"),
    "docs-researcher": ("opencode/gpt-5.6-terra", "18"),
    "implementer": ("opencode/gpt-5.6-sol", "30"),
    "planner": ("opencode/gpt-5.6-sol", "20"),
    "reviewer": ("opencode/gpt-5.6-sol", "20"),
    "security-reviewer": ("opencode/gpt-5.6-sol", "24"),
    "test-auditor": ("opencode/gpt-5.6-terra", "18"),
}
COPILOT_PROFILE = {
    "explorer": ("claude-haiku-4.5", "low"),
    "docs-researcher": ("gemini-3.7-flash", "medium"),
    "implementer": ("gpt-5.3-codex", "high"),
    "planner": ("gpt-5.4", "high"),
    "reviewer": ("gpt-5.4", "high"),
    "security-reviewer": ("gpt-5.4", "high"),
    "test-auditor": ("gpt-5.4", "high"),
}


class FrontmatterError(ValueError):
    pass


def discover_skills() -> tuple[str, ...]:
    skills_root = Path(".agents/skills")
    if not skills_root.is_dir():
        raise FrontmatterError("missing canonical skills directory")
    skills: list[str] = []
    for entry in sorted(skills_root.iterdir()):
        if not entry.is_dir():
            raise FrontmatterError(f"canonical skill entry is not a directory: {entry}")
        if entry.name.startswith("_"):
            if (entry / "SKILL.md").exists():
                raise FrontmatterError(
                    f"shared support directory must not contain SKILL.md: {entry}"
                )
            continue
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", entry.name):
            raise FrontmatterError(f"canonical skill directory has invalid name: {entry}")
        if not (entry / "SKILL.md").is_file():
            raise FrontmatterError(f"missing canonical skill file: {entry / 'SKILL.md'}")
        skills.append(entry.name)
    if not skills:
        raise FrontmatterError("no canonical skills found")
    return tuple(skills)


def parse_frontmatter_text(
    text: str, source: str, allow_permissions: bool = False
) -> tuple[dict[str, str], list[str]]:
    lines = text.splitlines()
    if not lines or lines[0] != "---":
        raise FrontmatterError(f"{source}: missing opening delimiter")
    try:
        end = lines.index("---", 1)
    except ValueError as exc:
        raise FrontmatterError(f"{source}: missing closing delimiter") from exc

    values: dict[str, str] = {}
    nested: list[str] = []
    current_key = ""
    for line in lines[1:end]:
        if not line:
            raise FrontmatterError(f"{source}: blank frontmatter line is not allowed")
        if line.startswith('#'):
            continue
        if line[0].isspace():
            if not allow_permissions or current_key != "permissions":
                raise FrontmatterError(f"{source}: unexpected indented YAML: {line}")
            nested.append(line)
            continue
        match = re.fullmatch(r"([A-Za-z][A-Za-z0-9_-]*):(?: (.*))?", line)
        if not match:
            raise FrontmatterError(f"{source}: unsupported top-level YAML: {line}")
        key, value = match.group(1), match.group(2) or ""
        if key in values:
            raise FrontmatterError(f"{source}: duplicate top-level key: {key}")
        values[key] = value
        current_key = key
    return values, nested


def validate_text(
    text: str,
    source: str,
    expected: dict[str, str],
    expected_nested: list[str] | None = None,
) -> None:
    actual, nested = parse_frontmatter_text(
        text, source, allow_permissions=expected_nested is not None
    )
    if actual != expected or nested != (expected_nested or []):
        raise FrontmatterError(
            f"{source}: metadata mismatch\n"
            f"  expected={expected}, nested={expected_nested or []}\n"
            f"  actual={actual}, nested={nested}"
        )


def require_exact(
    path: Path, expected: dict[str, str], expected_nested: list[str] | None = None
) -> None:
    validate_text(
        path.read_text(encoding="utf-8"), str(path), expected, expected_nested
    )


def permission_lines(effects: dict[str, str]) -> list[str]:
    lines: list[str] = []
    for action in ("edit", "shell", "subagent", "webfetch", "websearch"):
        lines.extend(
            (
                f"  - action: {action}",
                '    resource: "*"',
                f"    effect: {effects[action]}",
            )
        )
    return lines


def check_role(role: str) -> None:
    description = DESCRIPTIONS[role]
    claude_model, claude_effort, claude_turns = CLAUDE_PROFILE[role]
    gemini_model, gemini_temperature, gemini_turns, gemini_timeout = GEMINI_PROFILE[role]
    opencode_model, opencode_steps = OPENCODE_PROFILE[role]
    copilot_model, copilot_effort = COPILOT_PROFILE[role]
    if role == "implementer":
        claude = {
            "name": role,
            "description": description,
            "model": claude_model,
            "effort": claude_effort,
            "maxTurns": claude_turns,
            "tools": "Read, Glob, Grep, Bash, Edit, Write",
            "disallowedTools": "Agent",
            "skills": "[software-engineering]",
        }
        cursor_readonly = "false"
        gemini_tools = (
            "[read_file, read_many_files, list_directory, glob, grep_search, "
            "write_file, replace, run_shell_command, activate_skill]"
        )
        opencode_effects = {
            "edit": "allow",
            "shell": "allow",
            "subagent": "deny",
            "webfetch": "deny",
            "websearch": "deny",
        }
    else:
        claude_tools = (
            "Read, Glob, Grep, WebFetch, WebSearch"
            if role == "docs-researcher"
            else READ_TOOLS
        )
        claude = {
            "name": role,
            "description": description,
            "model": claude_model,
            "effort": claude_effort,
            "maxTurns": claude_turns,
            "tools": claude_tools,
            "disallowedTools": "Agent, Bash, Edit, Write",
            "permissionMode": "plan",
        }
        cursor_readonly = "true"
        gemini_tools = (
            "[read_file, read_many_files, list_directory, glob, grep_search, "
            "google_web_search, web_fetch]"
            if role == "docs-researcher"
            else GEMINI_READ_TOOLS
        )
        web_effect = "allow" if role == "docs-researcher" else "deny"
        opencode_effects = {
            "edit": "deny",
            "shell": "deny",
            "subagent": "deny",
            "webfetch": web_effect,
            "websearch": web_effect,
        }

    require_exact(Path(f".claude/agents/{role}.md"), claude)
    opencode_expected: dict[str, str] = {
        "description": description,
        "mode": "subagent",
        "steps": opencode_steps,
        "permissions": "",
    }
    if opencode_model is not None:
        opencode_expected["model"] = opencode_model
    require_exact(
        Path(f".opencode/agents/{role}.md"),
        opencode_expected,
        permission_lines(opencode_effects),
    )
    require_exact(
        Path(f".cursor/agents/{role}.md"),
        {
            "name": role,
            "description": description,
            "model": CURSOR_PROFILE[role],
            "readonly": cursor_readonly,
        },
    )
    require_exact(
        Path(f".gemini/agents/{role}.md"),
        {
            "name": role,
            "description": description,
            "kind": "local",
            "model": gemini_model,
            "temperature": gemini_temperature,
            "max_turns": gemini_turns,
            "timeout_mins": gemini_timeout,
            "tools": gemini_tools,
        },
    )
    copilot_tools = (
        "[read, search, edit, execute]"
        if role == "implementer"
        else "[read, search, web]"
        if role == "docs-researcher"
        else "[read, search]"
    )
    require_exact(
        Path(f".github/agents/{role}.agent.md"),
        {
            "name": role,
            "description": description,
            "model": copilot_model,
            "reasoningEffort": copilot_effort,
            "tools": copilot_tools,
        },
    )


def check_skill(skill: str) -> None:
    canonical_path = Path(f".agents/skills/{skill}/SKILL.md")
    canonical, nested = parse_frontmatter_text(
        canonical_path.read_text(encoding="utf-8"), str(canonical_path)
    )
    if nested:
        raise FrontmatterError(f"canonical skill has nested metadata: {skill}")
    if set(canonical) != {"name", "description"} or canonical["name"] != skill:
        raise FrontmatterError(f"canonical skill metadata is not exact: {skill}")
    expected_wrapper = (
        "---\n"
        f"name: {canonical['name']}\n"
        f"description: {canonical['description']}\n"
        "---\n\n"
        f"@../../../.agents/skills/{skill}/SKILL.md\n\n"
        f"Canonical guidance remains in `.agents/skills/{skill}/`.\n"
    )
    wrapper_path = Path(f".claude/skills/{skill}/SKILL.md")
    if wrapper_path.read_text(encoding="utf-8") != expected_wrapper:
        raise FrontmatterError(f"Claude wrapper drift: {wrapper_path}")


def run_self_tests() -> None:
    scalar_expected = {"name": "explorer", "readonly": "true"}
    invalid = (
        (
            "---\nname: explorer\nreadonly: true\nreadonly: false\n---\n",
            scalar_expected,
            None,
        ),
        (
            "---\nname: explorer\ntools: [read_file]\ntools: [write_file]\n---\n",
            {"name": "explorer", "tools": "[read_file]"},
            None,
        ),
        (
            "---\nname: skill\nname: changed\ndescription: test\n---\n",
            {"name": "skill", "description": "test"},
            None,
        ),
        (
            "---\nname: explorer\nreadonly: true\n  , false\n---\n",
            scalar_expected,
            None,
        ),
        (
            "---\ndescription: test\nmode: subagent\npermissions:\n"
            "  malformed: [\n  - action: edit\n    resource: \"*\"\n"
            "    effect: deny\n---\n",
            {"description": "test", "mode": "subagent", "permissions": ""},
            ["  - action: edit", '    resource: "*"', "    effect: deny"],
        ),
        (
            "---\nname: explorer\nmodel: inherit\nreadonly: true\n---\n",
            {
                "name": "explorer",
                "model": "composer-2.5[fast=true]",
                "readonly": "true",
            },
            None,
        ),
    )
    for index, (fixture, expected, expected_nested) in enumerate(invalid, 1):
        try:
            validate_text(
                fixture, f"self-test-{index}", expected, expected_nested
            )
        except FrontmatterError:
            continue
        raise FrontmatterError(f"self-test-{index}: invalid metadata was accepted")
    validate_text(
        "---\nname: explorer\nreadonly: true\n---\n",
        "self-test-valid-scalar",
        scalar_expected,
    )
    valid_permissions = [
        "  - action: edit",
        '    resource: "*"',
        "    effect: deny",
    ]
    validate_text(
        "---\ndescription: test\nmode: subagent\npermissions:\n"
        "  - action: edit\n    resource: \"*\"\n    effect: deny\n---\n",
        "self-test-valid-nested",
        {"description": "test", "mode": "subagent", "permissions": ""},
        valid_permissions,
    )
    print("FRONTMATTER SELF-TEST PASSED.")


try:
    for role in ROLES:
        check_role(role)
    for skill in discover_skills():
        check_skill(skill)
    if os.environ.get("CHECK_HARNESS_SELFTEST") == "1":
        run_self_tests()
except (FrontmatterError, OSError) as exc:
    print(f"INVALID MARKDOWN FRONTMATTER: {exc}")
    raise SystemExit(1)
PY
  then
    errors=$((errors + 1))
  fi
}

require_exact_restricted_opencode_permissions() {
  local file="$1"

  if ! has_exact_restricted_opencode_permissions "$@"; then
    echo "INVALID RESTRICTED V2 PERMISSION SET: $file"
    errors=$((errors + 1))
  fi
}

has_exact_restricted_opencode_permissions() {
  local file="$1"
  local edit_effect="$2"
  local shell_effect="$3"
  local subagent_effect="$4"
  local webfetch_effect="$5"
  local websearch_effect="$6"

  awk -v edit_effect="$edit_effect" -v shell_effect="$shell_effect" -v subagent_effect="$subagent_effect" -v webfetch_effect="$webfetch_effect" -v websearch_effect="$websearch_effect" '
    function expected_effect(action) {
      if (action == "edit") return edit_effect
      if (action == "shell") return shell_effect
      if (action == "subagent") return subagent_effect
      if (action == "webfetch") return webfetch_effect
      if (action == "websearch") return websearch_effect
      return ""
    }
    function check_rule() {
      if (!in_rule) return
      if (expected_effect(rule_action) == "" || seen[rule_action]++) invalid = 1
      if (resource_count != 1 || rule_resource != "*" || effect_count != 1 || rule_effect != expected_effect(rule_action) || extra_field) invalid = 1
      rule_count++
    }
    $0 == "permissions:" { permission_sections++; in_permissions = 1; next }
    in_permissions && $0 == "---" { check_rule(); in_rule = 0; in_permissions = 0; permissions_closed = 1; next }
    !in_permissions { next }
    /^  - action: / {
      check_rule()
      in_rule = 1
      rule_action = substr($0, length("  - action: ") + 1)
      resource_count = 0
      effect_count = 0
      rule_resource = ""
      rule_effect = ""
      extra_field = 0
      next
    }
    in_rule && /^    resource: / { resource_count++; rule_resource = substr($0, length("    resource: ") + 1); gsub(/^"|"$/, "", rule_resource); next }
    in_rule && /^    effect: / { effect_count++; rule_effect = substr($0, length("    effect: ") + 1); next }
    in_rule && NF { extra_field = 1 }
    END {
      if (in_permissions) check_rule()
      for (action in seen) expected_count++
      valid = permission_sections == 1 && permissions_closed && !invalid && rule_count == 5 && expected_count == 5
      exit !valid
    }
  ' "$file"
}

run_v2_permission_self_tests() {
  local fixture_dir

  fixture_dir="$(mktemp -d)"
  trap 'rm -rf -- "$fixture_dir"' RETURN

  printf '%s\n' 'permissions:' '  - action: edit' '    resource: "*"' '  - action: shell' '    resource: "*"' '    effect: deny' '---' > "$fixture_dir/mixed-fields.md"
  if has_exact_restricted_opencode_permissions "$fixture_dir/mixed-fields.md" deny deny deny deny deny; then
    echo "V2 SELF-TEST FAILED: mixed fields matched"
    return 1
  fi

  printf '%s\n' 'permissions:' '  - action: edit' '    resource: "*"' '    effect: deny' '  - action: edit' '    resource: "*"' '    effect: allow' '  - action: shell' '    resource: "*"' '    effect: deny' '  - action: subagent' '    resource: "*"' '    effect: deny' '  - action: webfetch' '    resource: "*"' '    effect: deny' '  - action: websearch' '    resource: "*"' '    effect: deny' '---' > "$fixture_dir/duplicate-action.md"
  if has_exact_restricted_opencode_permissions "$fixture_dir/duplicate-action.md" deny deny deny deny deny; then
    echo "V2 SELF-TEST FAILED: duplicate action matched"
    return 1
  fi

  printf '%s\n' 'permissions:' '  - action: edit' '    resource: "*"' '    effect: deny' '  - action: shell' '    resource: "*"' '    effect: deny' '  - action: subagent' '    resource: "*"' '    effect: deny' '  - action: webfetch' '    resource: "*"' '    effect: deny' '  - action: websearch' '    resource: "*"' '    effect: deny' '---' > "$fixture_dir/positive.md"
  if ! has_exact_restricted_opencode_permissions "$fixture_dir/positive.md" deny deny deny deny deny; then
    echo "V2 SELF-TEST FAILED: valid rule did not match"
    return 1
  fi

  cp "$fixture_dir/positive.md" "$fixture_dir/wildcard.md"
  sed '$d' "$fixture_dir/positive.md" > "$fixture_dir/wildcard.md"
  printf '%s\n' '  - action: *' '    resource: "*"' '    effect: allow' '---' >> "$fixture_dir/wildcard.md"
  if has_exact_restricted_opencode_permissions "$fixture_dir/wildcard.md" deny deny deny deny deny; then
    echo "V2 SELF-TEST FAILED: wildcard action matched"
    return 1
  fi

  sed '0,/    resource: "\*"/s//    resource: "src\/\*\*"/' "$fixture_dir/positive.md" > "$fixture_dir/specific-resource.md"
  if has_exact_restricted_opencode_permissions "$fixture_dir/specific-resource.md" deny deny deny deny deny; then
    echo "V2 SELF-TEST FAILED: specific resource matched"
    return 1
  fi

  echo "V2 PERMISSION SELF-TEST PASSED."
}

if [[ "${CHECK_HARNESS_SELFTEST:-0}" == "1" ]]; then
  run_v2_permission_self_tests
  bash scripts/sync-portable-skills.sh --self-test
fi

if ! bash scripts/sync-portable-skills.sh --check; then
  errors=$((errors + 1))
fi

validate_markdown_frontmatter

require_claude_role_name() {
  local file="$1"
  local role="$2"
  local name_count

  name_count="$(grep -Ec '^name:' "$file")"
  if [[ "$name_count" -ne 1 ]]; then
    echo "INVALID CLAUDE ROLE NAME COUNT: $file"
    errors=$((errors + 1))
  fi
  require_exact_line "$file" "name: $role"
}

is_expected_role_path() {
  local relative="$1"
  local role

  [[ "$relative" == *.md && "$relative" != */* ]] || return 1
  role="${relative%.md}"
  for expected_role in "${required_roles[@]}"; do
    [[ "$role" == "$expected_role" ]] && return 0
  done
  return 1
}

require_no_orphan_roles() {
  local role_dir="$1"
  local role_file
  local relative

  while IFS= read -r -d '' role_file; do
    relative="${role_file#"$role_dir"/}"
    if ! is_expected_role_path "$relative"; then
      echo "ORPHAN ROLE FILE: $role_file"
      errors=$((errors + 1))
    fi
  done < <(find "$role_dir" -type f -print0)
}

require_no_orphan_copilot_roles() {
  local role_file
  local relative
  local role
  local found

  while IFS= read -r -d '' role_file; do
    relative="${role_file#.github/agents/}"
    if [[ "$relative" != *.agent.md || "$relative" == */* ]]; then
      echo "ORPHAN COPILOT ROLE FILE: $role_file"
      errors=$((errors + 1))
      continue
    fi
    role="${relative%.agent.md}"
    found=0
    for expected_role in "${required_roles[@]}"; do
      [[ "$role" == "$expected_role" ]] && found=1
    done
    if [[ "$found" -ne 1 ]]; then
      echo "ORPHAN COPILOT ROLE FILE: $role_file"
      errors=$((errors + 1))
    fi
  done < <(find .github/agents -type f -print0)
}

require_no_v1_permission() {
  local file="$1"

  if grep -Eq '^(permission:|[[:space:]]+bash:|[[:space:]]+task:)' "$file"; then
    echo "LEGACY OPENCODE PERMISSION: $file"
    errors=$((errors + 1))
  fi
}

require_exact_line "CLAUDE.md" "@AGENTS.md"
require_exact_line "CLAUDE.md" "@AI_POLICY.md"
require_exact_line "CLAUDE.md" 'Thin adapters expose every canonical project skill under `.claude/skills/`;'
require_exact_line "GEMINI.md" "@./AGENTS.md"
require_exact_line "GEMINI.md" "@./AI_POLICY.md"
require_exact_line "GEMINI.md" 'Gemini CLI discovers `.agents/skills/` natively. For design, implementation or'
require_exact_line "GEMINI.md" '`/skills reload` after changing skills; Gemini asks for consent on activation.'
require_exact_line "opencode.json" '  "instructions": ['
require_exact_line "opencode.json" '    "AGENTS.md",'
require_exact_line "opencode.json" '    "AI_POLICY.md"'
require_exact_line ".github/copilot-instructions.md" "@../AGENTS.md"
require_exact_line ".github/copilot-instructions.md" "@../AI_POLICY.md"
require_exact_line "AGENTS.md" '`.agents/skills/software-engineering/SKILL.md` and only its relevant reference(s).'
require_exact_line ".agents/skills/software-engineering/SKILL.md" "## Route by need"
require_exact_line ".agents/skills/software-engineering/SKILL.md" '- Read [design and architecture](references/design-and-architecture.md) when'
require_exact_line ".agents/skills/software-engineering/SKILL.md" '- Read [quality, testing and security](references/quality-testing-security.md)'
require_exact_line ".claude/skills/software-engineering/SKILL.md" "name: software-engineering"
require_exact_line ".claude/skills/software-engineering/SKILL.md" "@../../../.agents/skills/software-engineering/SKILL.md"

require_role_body() {
  local role="$1"
  local adapter="$2"

  if ! diff -q -- ".agents/roles/$role.md" <(agent_body "$adapter") >/dev/null; then
    echo "ROLE BODY DRIFT: $adapter must equal .agents/roles/$role.md"
    errors=$((errors + 1))
  fi
}

require_codex_role_body() {
  local role="$1"
  local adapter=".codex/agents/$role.toml"

  if ! $PY - "$adapter" ".agents/roles/$role.md" "$role" <<'PY'
import sys
import tomllib
from pathlib import Path

adapter = Path(sys.argv[1])
canonical = Path(sys.argv[2])
role = sys.argv[3]
data = tomllib.loads(adapter.read_text(encoding="utf-8"))
actual = data.get("developer_instructions")
expected = canonical.read_text(encoding="utf-8")
profiles = {
    "explorer": ("gpt-5.6-luna", "low"),
    "docs-researcher": ("gpt-5.6-terra", "medium"),
    "implementer": ("gpt-5.6-sol", "high"),
    "planner": ("gpt-5.6-sol", "high"),
    "reviewer": ("gpt-5.6-sol", "xhigh"),
    "security-reviewer": ("gpt-5.6-sol", "xhigh"),
    "test-auditor": ("gpt-5.6-terra", "high"),
}
required_keys = {
    "name", "description", "model", "model_reasoning_effort",
    "developer_instructions",
}
if role != "implementer":
    required_keys.add("sandbox_mode")
if set(data) != required_keys:
    raise SystemExit(1)
if not isinstance(actual, str) or data.get("name") != role or not isinstance(data.get("description"), str) or not data["description"]:
    raise SystemExit(1)
if (data.get("model"), data.get("model_reasoning_effort")) != profiles[role]:
    raise SystemExit(1)
if role != "implementer" and data.get("sandbox_mode") != "read-only":
    raise SystemExit(1)
if actual.startswith("\n"):
    actual = actual[1:]
if actual != expected:
    raise SystemExit(1)
PY
  then
    echo "INVALID OR DRIFTING CODEX ROLE: $adapter"
    errors=$((errors + 1))
  fi
}

agent_body() {
  awk '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { in_frontmatter = 0; after_frontmatter = 1; next }
    after_frontmatter && $0 == "" { after_frontmatter = 0; next }
    after_frontmatter { after_frontmatter = 0 }
    !in_frontmatter { print }
  ' "$1"
}

for role in "${required_roles[@]}"; do
  require_claude_role_name ".claude/agents/$role.md" "$role"
  require_exact_line ".opencode/agents/$role.md" "mode: subagent"
  require_exact_line ".cursor/agents/$role.md" "name: $role"
  require_exact_line ".gemini/agents/$role.md" "name: $role"
  require_exact_line ".gemini/agents/$role.md" "kind: local"
  require_description ".claude/agents/$role.md"
  require_description ".opencode/agents/$role.md"
  require_description ".cursor/agents/$role.md"
  require_description ".gemini/agents/$role.md"
  if [[ "$role" == "implementer" ]]; then
    require_exact_line ".agents/roles/$role.md" "work."
    require_exact_line ".agents/roles/$role.md" "universal guidance without assuming a language, framework, architectural style,"
  else
    require_exact_line ".agents/roles/$role.md" "Do not delegate."
  fi
  require_role_body "$role" ".claude/agents/$role.md"
  require_role_body "$role" ".opencode/agents/$role.md"
  require_role_body "$role" ".cursor/agents/$role.md"
  require_role_body "$role" ".gemini/agents/$role.md"
  require_role_body "$role" ".github/agents/$role.agent.md"
  require_codex_role_body "$role"
  require_no_v1_permission ".opencode/agents/$role.md"
done

for role in explorer planner reviewer test-auditor security-reviewer; do
  require_exact_line ".claude/agents/$role.md" "tools: Read, Glob, Grep"
  require_exact_line ".claude/agents/$role.md" "disallowedTools: Agent, Bash, Edit, Write"
  require_exact_line ".claude/agents/$role.md" "permissionMode: plan"
  require_exact_restricted_opencode_permissions ".opencode/agents/$role.md" deny deny deny deny deny
  require_exact_line ".cursor/agents/$role.md" "readonly: true"
  require_exact_line ".gemini/agents/$role.md" "tools: [read_file, read_many_files, list_directory, glob, grep_search]"
done

for role in explorer planner reviewer test-auditor security-reviewer docs-researcher; do
  require_exact_line ".codex/agents/$role.toml" 'sandbox_mode = "read-only"'
done

require_exact_line ".codex/agents/explorer.toml" 'model = "gpt-5.6-luna"'
require_exact_line ".codex/agents/explorer.toml" 'model_reasoning_effort = "low"'
require_exact_line ".codex/agents/docs-researcher.toml" 'model = "gpt-5.6-terra"'
require_exact_line ".codex/agents/docs-researcher.toml" 'model_reasoning_effort = "medium"'
require_exact_line ".codex/agents/test-auditor.toml" 'model = "gpt-5.6-terra"'
require_exact_line ".codex/agents/test-auditor.toml" 'model_reasoning_effort = "high"'
for role in planner implementer; do
  require_exact_line ".codex/agents/$role.toml" 'model = "gpt-5.6-sol"'
  require_exact_line ".codex/agents/$role.toml" 'model_reasoning_effort = "high"'
done
for role in reviewer security-reviewer; do
  require_exact_line ".codex/agents/$role.toml" 'model = "gpt-5.6-sol"'
  require_exact_line ".codex/agents/$role.toml" 'model_reasoning_effort = "xhigh"'
done
if grep -Eq '^sandbox_mode[[:space:]]*=' ".codex/agents/implementer.toml"; then
  echo "UNEXPECTED CODEX IMPLEMENTER SANDBOX: .codex/agents/implementer.toml"
  errors=$((errors + 1))
fi

require_exact_line ".claude/agents/docs-researcher.md" "tools: Read, Glob, Grep, WebFetch, WebSearch"
require_exact_line ".claude/agents/docs-researcher.md" "disallowedTools: Agent, Bash, Edit, Write"
require_exact_line ".claude/agents/docs-researcher.md" "permissionMode: plan"
require_exact_restricted_opencode_permissions ".opencode/agents/docs-researcher.md" deny deny deny allow allow
require_exact_line ".cursor/agents/docs-researcher.md" "readonly: true"
require_exact_line ".gemini/agents/docs-researcher.md" "tools: [read_file, read_many_files, list_directory, glob, grep_search, google_web_search, web_fetch]"
require_exact_line ".claude/agents/implementer.md" "tools: Read, Glob, Grep, Bash, Edit, Write"
require_exact_line ".claude/agents/implementer.md" "disallowedTools: Agent"
require_exact_line ".claude/agents/implementer.md" "skills: [software-engineering]"
require_exact_restricted_opencode_permissions ".opencode/agents/implementer.md" allow allow deny deny deny
require_exact_line ".cursor/agents/implementer.md" "readonly: false"
require_exact_line ".gemini/agents/implementer.md" "tools: [read_file, read_many_files, list_directory, glob, grep_search, write_file, replace, run_shell_command, activate_skill]"

for skill in "${required_skills[@]}"; do
  claude_skill=".claude/skills/$skill/SKILL.md"
  canonical_skill=".agents/skills/$skill/SKILL.md"
  if [[ ! -f "$claude_skill" ]]; then
    echo "MISSING CLAUDE SKILL ADAPTER: $claude_skill"
    errors=$((errors + 1))
    continue
  fi
  require_exact_line "$claude_skill" "name: $skill"
  require_exact_line "$claude_skill" "@../../../.agents/skills/$skill/SKILL.md"
  canonical_description="$(grep -m1 '^description:' "$canonical_skill")"
  canonical_description="${canonical_description%$'\r'}"
  require_exact_line "$claude_skill" "$canonical_description"
done

judgment_day_skill=".agents/skills/judgment-day/SKILL.md"
require_exact_line "$judgment_day_skill" "- Treat Judge A and Judge B as ledger labels, not agent configuration names."
require_exact_line "$judgment_day_skill" '  both `reviewer` instances and, if needed, the `implementer` instance.'
if grep -Eq 'jd-(judge|fix)' "$judgment_day_skill"; then
  echo "INVALID JUDGMENT-DAY AGENT REFERENCE: $judgment_day_skill"
  errors=$((errors + 1))
fi

while IFS= read -r -d '' claude_skill; do
  skill="$(basename "$(dirname "$claude_skill")")"
  if [[ ! -f ".agents/skills/$skill/SKILL.md" ]]; then
    echo "ORPHAN CLAUDE SKILL ADAPTER: $claude_skill"
    errors=$((errors + 1))
  fi
done < <(find .claude/skills -type f -name SKILL.md -print0)

for canonical_skill in .agents/skills/*/SKILL.md; do
  skill="$(basename "$(dirname "$canonical_skill")")"
  if [[ ! -f ".claude/skills/$skill/SKILL.md" ]]; then
    echo "MISSING CLAUDE SKILL ADAPTER: .claude/skills/$skill/SKILL.md"
    errors=$((errors + 1))
  fi
done

require_no_orphan_roles .agents/roles
require_no_orphan_roles .claude/agents
require_no_orphan_roles .opencode/agents
require_no_orphan_roles .cursor/agents
require_no_orphan_roles .gemini/agents
require_no_orphan_copilot_roles

while IFS= read -r -d '' codex_agent; do
  relative="${codex_agent#.codex/agents/}"
  if [[ "$relative" != *.toml || "${relative%.toml}" == */* ]]; then
    echo "ORPHAN CODEX AGENT FILE: $codex_agent"
    errors=$((errors + 1))
    continue
  fi
  role="${relative%.toml}"
  found=0
  for expected_role in "${required_roles[@]}"; do
    [[ "$role" == "$expected_role" ]] && found=1
  done
  if [[ "$found" -ne 1 ]]; then
    echo "ORPHAN CODEX AGENT FILE: $codex_agent"
    errors=$((errors + 1))
  fi
done < <(find .codex/agents -type f -print0)

if [[ "$errors" -ne 0 ]]; then
  echo
  echo "HARNESS CHECK FAILED: $errors problem(s)."
  exit 1
fi

echo "HARNESS CHECK PASSED."
