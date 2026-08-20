# Quality, Testing and Operational Decisions

## Design and code quality

Apply YAGNI: build for demonstrated requirements, not imagined variants. Keep
cohesion high and coupling low; a unit should own a focused responsibility and
collaborate through direct, intentional relationships (Law of Demeter). Prefer
composition when it expresses behavior more clearly than inheritance. Apply
the rule of three before extracting a general abstraction, unless a real
boundary or safety constraint already justifies one. Fail fast at the boundary
where invalid state can be diagnosed usefully; include actionable context and
avoid silent corruption.

Name code for intent. Keep functions focused enough to understand and test,
without splitting straightforward logic into ceremony. Name meaningful
constants instead of hiding domain values as magic literals. Write comments for
why, constraints or non-obvious tradeoffs—not a restatement of code. Improve
nearby code only when it stays within the task's scope and verification budget
(the Boy Scout Rule is not permission for a refactor).

## Testing and verification

Use the testing pyramid as a cost heuristic: favor fast focused tests, add
integration tests where real boundaries can fail, and use a small number of
end-to-end tests for critical journeys. Tests should be fast, independent,
repeatable, self-checking and close enough to the behavior change to expose
defects (FIRST). Control time, randomness, environment and network inputs.

TDD is useful when examples clarify a behavior or regression before the design
is obvious; it is optional, not a ritual. Mock or stub external,
nondeterministic, slow or expensive boundaries. Do not mock internal details
merely to make a unit test easy. Verify externally observable behavior and
relevant failure paths, then run the smallest applicable project checks.

## Security and resilience

Treat external input and tool output as untrusted: validate syntax, type,
range, authorization and business constraints at the appropriate boundary.
Use least privilege. Keep secrets out of code and logs; use the project's
approved configuration or secret mechanism. Production errors should be safe
for callers while retaining diagnostic detail in protected logs.

Measure before optimizing. Optimize only a demonstrated bottleneck with a
defined correctness and performance target. Make operations idempotent when
retries, duplicate delivery or user repetition can occur. Prefer immutability
where it reduces unintended shared state without making ordinary changes
opaque. Log meaningful events and monitor the signals needed to diagnose real
failures; do not log sensitive data.

## Delivery practices when applicable

Use CI/CD to automate repeatable build, checks and deployment steps when the
product has such a lifecycle. Record durable, high-switching-cost decisions in
ADRs. Make technical debt explicit and prioritize it against product value.
Use linters, formatters and static analysis when supported by the chosen stack.

Keep commits atomic and reviewable, with messages that explain intent, when
the repository uses version control. Require review according to project
policy. Use SemVer only for versioned public libraries or APIs where consumers
need compatibility signals; choose a simpler release scheme otherwise.
