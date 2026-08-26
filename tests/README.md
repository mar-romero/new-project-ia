# Test Strategy

Tests are executable evidence. Choose the least expensive test that can detect
the defect; coverage percentage alone is not the goal.

## Test types

- Unit: deterministic domain logic and transformations.
- Integration: persistence, service boundaries and serialization.
- Contract: externally consumed APIs, protocols and schemas.
- Property: shared invariants across many valid inputs.
- Golden or differential: stable, trusted input/output behavior.
- Replay or fuzz: event streams, parsers and state machines when justified.

## Rules

- Make tests deterministic: control clocks, timezones, randomness, environment
  and network access.
- Use small, sanitized and documented fixtures.
- Test failure paths, invalid input and important boundaries.
- Never change a valid expected result only to make an implementation pass.
- Keep routine unit tests offline; isolate live or expensive integration checks.

## Domain additions

Add domain-specific test requirements only after the product scope is known.
For example, data pipelines may need schema/replay tests and model-driven
systems may need fixed evaluation data and reproducible seeds.

Offline reviewer-gate cases live under `evals/reviewer/` and run through
`bash scripts/run-review-evals.sh` (invoked by the harness). They do not call
models.


