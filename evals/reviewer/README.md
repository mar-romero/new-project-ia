# Reviewer evals (offline)

These cases exercise `scripts/review_gate.py`, not live models.

Each directory needs `expect` (`valid` or `invalid`), `review.json`, and a
`tree/` snapshot. The runner hashes `tree/` at eval time so hashes do not
depend on Git worktree state.

| Case | Expect | Defect it catches |
|---|---|---|
| `clean_candidate` | valid | PASS with no findings |
| `known_bug` | valid | locatable HIGH on a frozen path/line |
| `nonexistent_path` | invalid | invented path cannot block |
| `insufficient_blocks` | invalid | INSUFFICIENT cannot be HIGH |
| `pass_with_blocker` | invalid | PASS cannot keep BLOCKER/HIGH |

```bash
bash scripts/run-review-evals.sh
```

Do not add provider API calls here. Live multi-model evals are out of scope.
