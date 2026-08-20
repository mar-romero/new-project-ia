#!/usr/bin/env bash

set -euo pipefail

echo "Checking project starter harness..."

required_files=(
  "AGENTS.md"
  "AI_POLICY.md"
  ".codex/config.toml"
  ".github/PULL_REQUEST_TEMPLATE.md"
  ".github/workflows/harness.yml"
  "docs/ai/DEFINITION_OF_READY.md"
  "docs/ai/DEFINITION_OF_DONE.md"
  "docs/ai/PROJECT_MEMORY.md"
  "docs/product/PRODUCT_VISION.md"
  "docs/product/ROADMAP.md"
  "tasks/templates/TASK.md"
  "tasks/templates/COMPLETION_REPORT.md"
  "tasks/templates/REVIEW_REPORT.md"
  "specs/templates/FEATURE_SPEC.md"
  "docs/decisions/ADR-000-TEMPLATE.md"
  "docs/sources/contracts/SOURCE_CONTRACT_TEMPLATE.md"
  "tests/README.md"
)

required_dirs=(
  ".agents/skills"
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

required_skills=(
  "architecture-decision"
  "chained-work"
  "cognitive-doc-design"
  "decision-escalation"
  "github-issue"
  "implementation-loop"
  "independent-review"
  "source-research"
  "systemic-defect-triage"
  "task-close"
  "task-intake"
  "test-strategy"
  "work-unit-commits"
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

for skill in "${required_skills[@]}"; do
  if [[ ! -f ".agents/skills/$skill/SKILL.md" ]]; then
    echo "MISSING SKILL: .agents/skills/$skill/SKILL.md"
    errors=$((errors + 1))
  fi
done

if [[ "$errors" -ne 0 ]]; then
  echo
  echo "HARNESS CHECK FAILED: $errors problem(s)."
  exit 1
fi

echo "HARNESS CHECK PASSED."
