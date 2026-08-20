---
name: test-strategy
description: Use when designing tests for important behavior, when existing tests may provide false confidence, or for R2/R3 tasks requiring stronger validation.
---

# Test Strategy

Select tests by defect-detection value, not count. Use unit tests for pure
logic; integration tests for boundaries and persistence; contract/schema tests
for external interfaces; property tests for shared invariants; golden or
differential tests for trusted behavior; and replay/fuzz tests selectively for
event streams, parsers and state machines.

Control clocks, timezones, randomness, network and environment. Use sanitized,
documented fixtures. Add negative and boundary cases. Invoke a test auditor
when the sufficiency of tests is itself material risk.
