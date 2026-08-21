---
name: technical-spike
description: Use when a material technical uncertainty should be resolved empirically before committing to production implementation or architecture.
---

# Spike

Resolve important technical uncertainty with the smallest disposable experiment.

A spike is not production implementation.

Its purpose is to produce evidence that can justify, change or reject a
technical decision.

## Trigger

Use a spike when:

- feasibility is uncertain;
- documentation cannot answer the important question;
- two plausible approaches need empirical comparison;
- performance, compatibility or behavior must be measured;
- an architectural decision depends on an unverified assumption;
- implementing the production solution before validating the assumption would create significant rework.

Do not use a spike when:

- the answer is available from authoritative documentation;
- the behavior is already demonstrated in the repository;
- the task is a normal implementation with low uncertainty;
- the experiment would effectively become the production implementation.

## Relationship to Other Skills

Use:

- `source-research` first when authoritative documentation may answer the question;
- `grounded-evidence` when the spike depends on external facts;
- `architecture-decision` when the result changes an architectural choice;
- `implementation-loop` only after the relevant uncertainty is sufficiently resolved.

A spike may inform implementation.

## Production Boundary

Spike code is evidence, not production code.

Do not move spike code into the production path merely because the experiment
succeeded.

If reuse appears valuable, evaluate the code independently against normal
production requirements for:

- correctness;
- maintainability;
- security;
- observability;
- error handling;
- testing;
- project conventions.

A validated idea does not imply production-quality implementation.

## Define the Question

Every individual spike starts with one primary falsifiable question.

If the uncertainty contains several independent questions, split them into
separate spikes rather than combining several loosely related experiments into
one artifact.

Bad:

> Test whether Redis is good.

Good:

> Can Redis Streams preserve the ordering and recovery behavior required by the
> ingestion contract under the expected concurrency?

Define:

### Given

The relevant starting condition.

### When

The experiment or workload.

### Then

The observable criterion that determines the outcome.

## Success Criteria

Specify measurable evidence before running the experiment.

Examples:

- latency below a defined threshold;
- compatibility with a required protocol;
- deterministic ordering;
- recovery after reconnect;
- memory usage within a bound;
- successful handling of a known edge case;
- ability to represent required data without loss.

Avoid criteria such as:

- "looks good";
- "seems fast";
- "works";
- "probably compatible".

## Risk First

When several uncertainties exist, test the one most capable of invalidating the
approach first.

Do not spend time validating easy details while a fundamental assumption remains
untested.

## Experiment Design

Keep the spike:

- isolated;
- minimal;
- reproducible;
- observable;
- disposable.

Avoid production abstractions unless required to answer the question.

Prefer:

1. a small executable;
2. a focused test harness;
3. a minimal endpoint;
4. a small fixture or benchmark.

Do not build infrastructure unrelated to the experiment.

## Comparison Spike

When comparing approaches, hold the question and evaluation criteria constant.

Evaluate each candidate against the same dimensions.

Example:

| Dimension | A | B |
|---|---|---|
| correctness | | |
| latency | | |
| complexity | | |
| failure behavior | | |
| operational dependency | | |

Do not choose a winner based only on implementation familiarity.

## Evidence

Record:

- environment;
- versions;
- inputs;
- exact command or procedure;
- observed output;
- unexpected behavior;
- limitations.

When reproducibility matters, preserve enough detail for another agent to rerun it.

## Result

A spike ends with exactly one result:

### VALIDATED

The tested assumption is supported under the stated conditions.

### PARTIAL

The approach works only under material constraints.

### INVALIDATED

The experiment disproves or materially undermines the assumption.

### INCONCLUSIVE

The experiment could not produce enough evidence.

An INVALIDATED spike is successful work if it eliminates a bad direction.

## Artifact

Store non-trivial spikes under:

`spikes/<id>-<name>/`

Recommended contents:

```text
README.md
minimal experiment files
results.md
```

Keep the artifact focused on the question, evidence, and result. Remove it
when its outcome has been recorded elsewhere and the repository does not need
to preserve reproducibility.
