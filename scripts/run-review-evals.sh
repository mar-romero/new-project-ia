#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
cd -- "$repo_root"

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

tmp_dir="$(mktemp -d)"
trap 'rm -rf -- "$tmp_dir"' EXIT

errors=0
ran=0

shopt -s nullglob
for case_dir in evals/reviewer/*/; do
  name="$(basename -- "$case_dir")"
  expect_file="$case_dir/expect"
  review_file="$case_dir/review.json"
  tree_dir="$case_dir/tree"
  if [[ ! -f "$expect_file" || ! -f "$review_file" || ! -d "$tree_dir" ]]; then
    echo "EVAL MALFORMED: $name (need expect, review.json, tree/)"
    errors=$((errors + 1))
    continue
  fi
  expect="$(tr -d '[:space:]' < "$expect_file")"
  freeze_file="$tmp_dir/$name.freeze.json"
  $PY scripts/review_gate.py freeze --task "eval-$name" --root "$tree_dir" --output "$freeze_file" --no-git >/dev/null
  if ! $PY scripts/review_gate.py verify --freeze "$freeze_file" --root "$tree_dir" --no-git >/dev/null; then
    echo "EVAL FREEZE VERIFY FAILED: $name"
    errors=$((errors + 1))
    continue
  fi
  set +e
  $PY scripts/review_gate.py validate-review --freeze "$freeze_file" --review "$review_file" --root "$tree_dir" >/dev/null
  status=$?
  set -e
  if [[ "$expect" == "valid" && "$status" -eq 0 ]]; then
    echo "EVAL PASSED: $name (valid)"
  elif [[ "$expect" == "invalid" && "$status" -ne 0 ]]; then
    echo "EVAL PASSED: $name (invalid as expected)"
  else
    echo "EVAL FAILED: $name (expect=$expect exit=$status)"
    $PY scripts/review_gate.py validate-review --freeze "$freeze_file" --review "$review_file" --root "$tree_dir" || true
    errors=$((errors + 1))
  fi
  ran=$((ran + 1))
done

if [[ "$ran" -lt 5 ]]; then
  echo "EVAL SUITE TOO SMALL: $ran cases"
  exit 1
fi
if [[ "$errors" -ne 0 ]]; then
  echo "REVIEW EVAL FAILED: $errors"
  exit 1
fi
echo "REVIEW EVAL PASSED: $ran cases"

# Mutation: a frozen byte change must fail verify.
mut_root="$tmp_dir/mut-tree"
mkdir -p "$mut_root/src"
printf '%s\n' 'export const n = 1;' > "$mut_root/src/app.ts"
mut_freeze="$tmp_dir/mut.freeze.json"
$PY scripts/review_gate.py freeze --task eval-mutation --root "$mut_root" --output "$mut_freeze" --no-git >/dev/null
printf '%s\n' 'export const n = 2;' > "$mut_root/src/app.ts"
set +e
$PY scripts/review_gate.py verify --freeze "$mut_freeze" --root "$mut_root" --no-git >/dev/null
mut_status=$?
set -e
if [[ "$mut_status" -eq 0 ]]; then
  echo "EVAL FAILED: freeze mutation was accepted"
  exit 1
fi
echo "EVAL PASSED: freeze mutation rejected"
