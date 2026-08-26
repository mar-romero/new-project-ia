#!/usr/bin/env bash
set -euo pipefail

# Validates one commit subject. Does not scan history (older "." commits exist).
message="${1:-}"
if [[ -z "$message" ]]; then
  message="$(git log -1 --pretty=%s)"
fi

subject="$(printf '%s\n' "$message" | head -n 1)"
subject="${subject%"${subject##*[![:space:]]}"}"
subject="${subject#"${subject%%[![:space:]]*}"}"

if [[ -z "$subject" ]]; then
  echo "COMMIT MESSAGE INVALID: empty subject"
  exit 1
fi
if [[ "$subject" == "." || "$subject" == "..." || "$subject" == "-" ]]; then
  echo "COMMIT MESSAGE INVALID: placeholder subject '$subject'"
  exit 1
fi
if [[ ${#subject} -lt 8 ]]; then
  echo "COMMIT MESSAGE INVALID: subject too short"
  exit 1
fi
echo "COMMIT MESSAGE VALID"
