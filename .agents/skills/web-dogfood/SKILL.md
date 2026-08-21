---
name: web-dogfood
description: Use for exploratory end-to-end QA of a runnable web application after deterministic checks pass, especially when user-visible state, browser behavior or cross-component flows may reveal defects not covered by automated tests.
---

# Web Dogfood

Test a running web application as a user rather than as its implementer.

The goal is to discover defects that static review, unit tests and implementation
context may miss.

This skill complements deterministic verification and independent code review.
It does not replace them.

## When to Use

Use when:

- a web application or web flow is runnable;
- important behavior crosses several components;
- UI state, browser behavior or interaction matters;
- a release candidate needs exploratory validation;
- automated tests pass but user-visible confidence is still required.

Especially useful for:

- authentication;
- forms;
- onboarding;
- navigation;
- search;
- checkout or transaction flows;
- error states;
- asynchronous UI;
- permissions;
- responsive interfaces;
- destructive actions.

## Preconditions

Before dogfooding:

1. identify the target environment;
2. confirm the intended scope;
3. know which actions are safe;
4. avoid destructive production operations unless explicitly authorized;
5. prefer test or staging data for mutating flows.

When dogfooding before review, test the exact implementation candidate intended
for freezing.

When dogfooding a candidate that is already frozen, do not mutate source files
or otherwise change the reviewed artifact during validation.

## Test as a User

Do not begin from the implementation narrative.

Start from expected product behavior.

For each relevant flow:

1. establish the starting state;
2. perform the user action;
3. observe the resulting state;
4. verify expected behavior;
5. inspect failure and recovery paths.

Test both normal and abnormal usage.

## Exploration Lenses

### Functional

Check:

- controls perform the intended action;
- navigation reaches the correct state;
- data persists when expected;
- cancellation works;
- repeated actions behave correctly;
- loading states terminate correctly;
- errors do not leave inconsistent state.

### Input

Try relevant:

- empty values;
- invalid values;
- maximum or unusually long values;
- unicode;
- whitespace;
- malformed input;
- duplicate submissions;
- rapid repeated actions.

Do not perform security exploitation beyond the authorized testing scope.

### State

Check transitions such as:

- fresh state;
- existing data;
- empty state;
- partial completion;
- refresh;
- back navigation;
- reconnect;
- expired session;
- repeated login/logout where relevant.

### Failure

When practical, inspect:

- network failure;
- backend error;
- timeout;
- invalid response;
- permission denial;
- unavailable dependency.

The UI should fail coherently rather than silently.

### Visual and Interaction

Check:

- important content is visible;
- controls are reachable;
- feedback is understandable;
- disabled and loading states are distinguishable;
- layout remains usable at relevant viewport sizes;
- focus and keyboard interaction work for critical flows.

### Browser Diagnostics

When tooling permits, inspect:

- console errors;
- failed network requests;
- uncaught exceptions;
- hydration or render warnings;
- repeated requests;
- obvious client-side performance failures.

A console error is evidence, not automatically a user-visible defect.

Determine impact before assigning severity.

## Findings

A real finding requires:

### Severity

Use:

- BLOCKER
- HIGH
- MEDIUM
- LOW

### Evidence

Observed behavior and supporting artifact where available.

### Reproduction

Minimal sequence required to reproduce.

### Expected

What the product should have done.

### Actual

What occurred.

### Impact

Why the difference matters.

### Scope

Known affected flow or state.

Do not inflate severity because a defect looks visually dramatic.

## Deduplication

Several symptoms may share one root mechanism.

Before reporting separate issues:

1. compare reproduction;
2. compare affected state;
3. inspect whether the failures share a mechanism;
4. use `systemic-defect-triage` when multiple symptoms appear related.

Prefer one defensible root defect over several duplicate reports.

## Evidence Artifacts

Capture when tooling permits:

- screenshot;
- relevant console output;
- request or response evidence;
- URL or route;
- test account state without secrets;
- timestamp when useful.

Do not store:

- passwords;
- tokens;
- private session values;
- unrelated personal data.

## Relationship to Independent Review

`independent-review` evaluates the implementation candidate critically.

`web-dogfood` evaluates the resulting product behavior experientially.

For ordinary web implementation work, prefer:

```text
deterministic checks
        ↓
web-dogfood
        ↓
candidate freeze
        ↓
independent-review
        ↓
completion
```

This keeps exploratory defect discovery before the frozen review candidate.

For release-level validation, `web-dogfood` may also be repeated against the
final frozen candidate after independent review, provided no source mutation
occurs during that validation.

If dogfood discovers a BLOCKER or HIGH defect before completion:

1. return the finding to implementation;
2. make the smallest coherent correction;
3. rerun affected deterministic checks;
4. rerun affected dogfood flows;
5. freeze a new candidate;
6. repeat independent review.

Do not preserve a PASS verdict across source changes.

## Completion

Report:

### Scope tested

What was actually exercised.

### Findings

Confirmed findings ordered by severity.

### Evidence

Artifacts or observations supporting the findings.

### Untested

Relevant behavior not exercised and why.

### Residual risks

Important behavior that could not be validated.

A clean dogfood run means no defect was found in the tested scope. It does not
prove that the application is defect-free.
