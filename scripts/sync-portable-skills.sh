#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
script_path="$script_dir/$(basename -- "${BASH_SOURCE[0]}")"
repo_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
mode=""
root="$repo_root"
errors=0
synced=0

# Locate a Python interpreter that actually works. On Windows the Microsoft
# Store "python" alias can shadow a real install and exit non-zero; prefer an
# explicit PYTHON override, then a working python, then the "py" launcher, then
# python3. This script requires Python 3.11+ (tomllib in the harness).
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

usage() {
  cat <<'EOF'
Usage: scripts/sync-portable-skills.sh --check|--write|--self-test [--root PATH]

--check      Verify every canonical .agents skill has its exact Claude wrapper.
--write      Create or refresh Claude wrappers from canonical skill metadata.
--self-test  Exercise generation and stale-wrapper rejection in a temporary tree.
--root PATH  Use a fixture root. Intended for deterministic testing only.
EOF
}

fail() {
  echo "PORTABLE SKILL SYNC ERROR: $*" >&2
  errors=$((errors + 1))
}

skill_metadata() {
  local canonical="$1"
  local directory_name="$2"

  $PY - "$canonical" "$directory_name" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
directory_name = sys.argv[2]
lines = path.read_text(encoding="utf-8").splitlines()
if not lines or lines[0] != "---":
    raise SystemExit(f"{path}: missing opening frontmatter delimiter")
try:
    end = lines.index("---", 1)
except ValueError as exc:
    raise SystemExit(f"{path}: missing closing frontmatter delimiter") from exc

metadata = {}
for line in lines[1:end]:
    if not line or line[0].isspace() or ": " not in line:
        raise SystemExit(f"{path}: unsupported frontmatter line: {line!r}")
    key, value = line.split(": ", 1)
    if key in metadata or key not in {"name", "description"} or not value:
        raise SystemExit(f"{path}: invalid frontmatter key/value: {line!r}")
    metadata[key] = value

if set(metadata) != {"name", "description"}:
    raise SystemExit(f"{path}: frontmatter must contain only name and description")
if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", metadata["name"]):
    raise SystemExit(f"{path}: invalid skill name")
if metadata["name"] != directory_name:
    raise SystemExit(f"{path}: skill name must match its directory")

print(metadata["name"])
print(metadata["description"])
PY
}

render_claude_wrapper() {
  local name="$1"
  local description="$2"

  printf '%s\n' \
    '---' \
    "name: $name" \
    "description: $description" \
    '---' \
    '' \
    "@../../../.agents/skills/$name/SKILL.md" \
    '' \
    "Canonical guidance remains in \`.agents/skills/$name/\`."
}

prepare_wrapper_path() {
  local name="$1"
  local claude_dir="$root/.claude"
  local skills_dir="$claude_dir/skills"
  local skill_dir="$skills_dir/$name"
  local path

  for path in "$claude_dir" "$skills_dir" "$skill_dir"; do
    if [[ -L "$path" ]]; then
      fail "symbolic links are not allowed in Claude wrapper path: $path"
      return 1
    fi
    if [[ -e "$path" && ! -d "$path" ]]; then
      fail "Claude wrapper path component is not a directory: $path"
      return 1
    fi
  done

  if [[ "$mode" == "--write" ]]; then
    for path in "$claude_dir" "$skills_dir" "$skill_dir"; do
      if [[ ! -e "$path" ]] && ! mkdir -- "$path"; then
        fail "could not create Claude wrapper directory: $path"
        return 1
      fi
    done
  fi
}

sync_skill() {
  local canonical="$1"
  local name="$2"
  local metadata
  local metadata_lines
  local canonical_name
  local description
  local wrapper

  if ! metadata="$(skill_metadata "$canonical" "$name")"; then
    fail "invalid canonical skill: $canonical"
    return
  fi
  mapfile -t metadata_lines <<<"$metadata"
  canonical_name="${metadata_lines[0]:-}"
  description="${metadata_lines[1]:-}"
  canonical_name="${canonical_name%$'\r'}"
  description="${description%$'\r'}"
  if [[ -z "$canonical_name" || -z "$description" || "${#metadata_lines[@]}" -ne 2 ]]; then
    fail "invalid canonical skill metadata: $canonical"
    return
  fi

  wrapper="$root/.claude/skills/$name/SKILL.md"
  if ! prepare_wrapper_path "$name"; then
    return
  fi
  if [[ -L "$wrapper" ]]; then
    fail "symbolic links are not allowed for Claude wrappers: $wrapper"
    return
  fi
  if [[ -e "$wrapper" && ! -f "$wrapper" ]]; then
    fail "Claude wrapper is not a regular file: $wrapper"
    return
  fi
  if [[ "$mode" == "--write" ]]; then
    local wrapper_dir
    local temporary_wrapper

    wrapper_dir="$(dirname -- "$wrapper")"
    temporary_wrapper="$(mktemp "$wrapper_dir/.SKILL.md.XXXXXX")"
    if ! render_claude_wrapper "$canonical_name" "$description" > "$temporary_wrapper" || \
      ! mv -f -- "$temporary_wrapper" "$wrapper"; then
      rm -f -- "$temporary_wrapper"
      fail "could not write Claude wrapper: $wrapper"
      return
    fi
    synced=$((synced + 1))
    return
  fi

  if [[ ! -f "$wrapper" ]]; then
    fail "missing Claude wrapper: $wrapper"
    return
  fi
  if ! diff -q -- "$wrapper" <(render_claude_wrapper "$canonical_name" "$description") >/dev/null; then
    fail "stale Claude wrapper: $wrapper"
    return
  fi
  synced=$((synced + 1))
}

sync_all() {
  local skills_root="$root/.agents/skills"
  local claude_root="$root/.claude/skills"
  local skill_dir
  local name
  local wrapper
  local wrapper_name
  local wrapper_relative
  local found=0

  if [[ ! -d "$skills_root" ]]; then
    fail "missing canonical skills directory: $skills_root"
    return
  fi
  if [[ "$mode" == "--check" && ! -d "$claude_root" ]]; then
    fail "missing Claude skills directory: $claude_root"
    return
  fi

  while IFS= read -r -d '' skill_dir; do
    if [[ ! -d "$skill_dir" ]]; then
      fail "canonical skill entry is not a directory: $skill_dir"
      continue
    fi
    name="$(basename -- "$skill_dir")"
    if [[ "$name" == _* ]]; then
      if [[ -e "$skill_dir/SKILL.md" ]]; then
        fail "shared support directory must not contain SKILL.md: $skill_dir"
      fi
      continue
    fi
    if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
      fail "canonical skill directory has invalid name: $skill_dir"
      continue
    fi
    found=1
    if [[ ! -f "$skill_dir/SKILL.md" ]]; then
      fail "missing canonical skill file: $skill_dir/SKILL.md"
      continue
    fi
    sync_skill "$skill_dir/SKILL.md" "$name"
  done < <(find "$skills_root" -mindepth 1 -maxdepth 1 -print0 | sort -z)

  if [[ "$found" -ne 1 ]]; then
    fail "no canonical skills found under: $skills_root"
  fi
  [[ -d "$claude_root" ]] || return

  while IFS= read -r -d '' wrapper; do
    wrapper_relative="${wrapper#"$claude_root"/}"
    wrapper_name="${wrapper_relative%/SKILL.md}"
    if [[ "$wrapper_relative" != "$wrapper_name/SKILL.md" || "$wrapper_name" == */* ]]; then
      fail "nested or invalid Claude wrapper path: $wrapper"
      continue
    fi
    if [[ ! -f "$skills_root/$wrapper_name/SKILL.md" ]]; then
      fail "orphan Claude wrapper: $wrapper"
    fi
  done < <(find "$claude_root" -type f -name SKILL.md -print0)

  while IFS= read -r -d '' wrapper; do
    fail "symbolic links are not allowed in Claude skills: $wrapper"
  done < <(find "$claude_root" -type l -print0)
}

run_self_test() {
  local fixture_root
  local fixture_skill
  local fixture_wrapper
  local orphan_wrapper
  local nested_wrapper
  local symlink_wrapper
  local shared_resource
  local invalid_shared_skill
  local hidden_skill

  fixture_root="$(mktemp -d)"
  trap 'rm -rf -- "$fixture_root"' RETURN
  fixture_skill="$fixture_root/.agents/skills/example-skill/SKILL.md"
  fixture_wrapper="$fixture_root/.claude/skills/example-skill/SKILL.md"
  mkdir -p -- "$(dirname -- "$fixture_skill")"
  printf '%s\n' \
    '---' \
    'name: example-skill' \
    'description: Exercise portable skill adapter generation.' \
    '---' \
    '' \
    '# Example' > "$fixture_skill"

  bash "$script_path" --root "$fixture_root" --write
  bash "$script_path" --root "$fixture_root" --check

  shared_resource="$fixture_root/.agents/skills/_shared/review-ledger-contract.md"
  mkdir -p -- "$(dirname -- "$shared_resource")"
  printf '%s\n' '# Shared support resource' > "$shared_resource"
  bash "$script_path" --root "$fixture_root" --write
  bash "$script_path" --root "$fixture_root" --check

  invalid_shared_skill="$fixture_root/.agents/skills/_invalid/SKILL.md"
  mkdir -p -- "$(dirname -- "$invalid_shared_skill")"
  printf '%s\n' '# Invalid shared skill' > "$invalid_shared_skill"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: shared directory with SKILL.md accepted.' >&2
    return 1
  fi
  rm -rf -- "$fixture_root/.agents/skills/_invalid"

  hidden_skill="$fixture_root/.agents/skills/.hidden/SKILL.md"
  mkdir -p -- "$(dirname -- "$hidden_skill")"
  printf '%s\n' \
    '---' \
    'name: hidden' \
    'description: Invalid hidden skill directory.' \
    '---' \
    '' \
    '# Hidden' > "$hidden_skill"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: hidden skill directory accepted.' >&2
    return 1
  fi
  rm -rf -- "$fixture_root/.agents/skills/.hidden"

  rm -f -- "$fixture_wrapper"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: missing wrapper accepted.' >&2
    return 1
  fi
  bash "$script_path" --root "$fixture_root" --write

  printf '%s\n' 'stale wrapper' > "$fixture_wrapper"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: stale wrapper accepted.' >&2
    return 1
  fi
  bash "$script_path" --root "$fixture_root" --write

  orphan_wrapper="$fixture_root/.claude/skills/orphan-skill/SKILL.md"
  mkdir -p -- "$(dirname -- "$orphan_wrapper")"
  printf '%s\n' 'orphan wrapper' > "$orphan_wrapper"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: orphan wrapper accepted.' >&2
    return 1
  fi
  rm -rf -- "$(dirname -- "$orphan_wrapper")"

  nested_wrapper="$fixture_root/.claude/skills/unrelated/example-skill/SKILL.md"
  mkdir -p -- "$(dirname -- "$nested_wrapper")"
  printf '%s\n' 'nested wrapper' > "$nested_wrapper"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: nested wrapper accepted.' >&2
    return 1
  fi
  rm -rf -- "$fixture_root/.claude/skills/unrelated"

  symlink_wrapper="$fixture_root/.claude/skills/example-skill/SKILL.md"
  rm -f -- "$symlink_wrapper"
  if ln -s "$fixture_skill" "$symlink_wrapper" 2>/dev/null; then
    if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
      echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: symbolic wrapper accepted.' >&2
      return 1
    fi
    rm -f -- "$symlink_wrapper"
    bash "$script_path" --root "$fixture_root" --write
  fi

  sed -i 's/^name: example-skill$/name: wrong-name/' "$fixture_skill"
  if bash "$script_path" --root "$fixture_root" --check >/dev/null 2>&1; then
    echo 'PORTABLE SKILL SYNC SELF-TEST FAILED: invalid metadata accepted.' >&2
    return 1
  fi
  echo 'PORTABLE SKILL SYNC SELF-TEST PASSED.'
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --check|--write|--self-test)
      if [[ -n "$mode" ]]; then
        usage >&2
        exit 2
      fi
      mode="$1"
      ;;
    --root)
      shift
      if [[ "$#" -eq 0 ]]; then
        usage >&2
        exit 2
      fi
      root="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ -z "$mode" ]]; then
  usage >&2
  exit 2
fi

root="$(CDPATH= cd -- "$root" && pwd)"
if [[ "$mode" == "--self-test" ]]; then
  run_self_test
  exit 0
fi

sync_all
if [[ "$errors" -ne 0 ]]; then
  exit 1
fi

echo "PORTABLE SKILL SYNC PASSED: $synced skill(s)."
