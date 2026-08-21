---
name: grounded-evidence
description: Use when research, analysis, decisions, documentation or implementation depend on external facts that must remain traceable to verifiable sources.
---

# Grounded Evidence

Preserve the provenance of material external claims.

A retrieved fact is not trustworthy merely because it appeared in search results,
documentation, an API response or another agent's summary.

For every material external claim, preserve enough evidence that another reviewer
can verify where it came from and whether the claim follows from the source.

## Core Rule

Never convert:

source
→ memory
→ claim

when you can preserve:

source
→ evidence
→ claim

Do not invent URLs, citations, quotations, versions, dates, API behavior or source
attribution from memory.

## When to Use

Use this skill when work depends materially on:

- current documentation;
- external APIs or protocols;
- library or framework behavior;
- provider capabilities;
- regulations or standards;
- research papers;
- current product behavior;
- externally reported facts;
- benchmarks or measurements;
- disputed or high-impact claims.

Do not require formal evidence tracking for trivial syntax lookups or facts that do
not affect the resulting decision.

## Relationship to Source Research

`source-research` determines what external behavior is supported by authoritative
sources.

This skill determines how material findings remain traceable after retrieval.

When both apply:

1. use `source-research` to identify authoritative sources;
2. capture the implementation-relevant facts;
3. preserve evidence for material claims;
4. distinguish sourced facts from assumptions and interpretation.

## Source Priority

Prefer, in order:

1. official documentation;
2. official specification or protocol;
3. official source repository;
4. official changelog or release notes;
5. primary research;
6. authoritative public records;
7. reputable secondary sources.

Use secondary sources when they provide useful context, but do not let them silently
override a primary source.

## Evidence Record

For each material source, preserve:

- source title;
- canonical URL or repository path;
- date accessed or revision inspected when relevant;
- material claim supported;
- exact evidence or precise source location for claims where wording,
  values or contract semantics materially affect the result;
- confidence or limitations;
- contradictions with other sources.

Keep the record compact. Do not archive entire documentation sites when a narrow
extract is sufficient.

## Claims

Classify material claims as one of:

### VERIFIED

Directly supported by inspected evidence.

### INFERRED

Reasonable interpretation derived from verified facts, but not stated directly.

### ASSUMED

Required for progress but not verified.

### UNKNOWN

The available sources do not establish the answer.

Never silently convert INFERRED, ASSUMED or UNKNOWN into VERIFIED.

## Exact Values

For values where precision matters, preserve the exact sourced representation:

- version;
- date;
- units;
- timestamp semantics;
- ordering;
- precision;
- limits;
- default values;
- error conditions;
- status codes;
- enum values;
- protocol states.

Do not normalize values in a way that changes their semantics.

## Quotations

Use direct quotations only when exact wording matters.

A quotation must come from inspected source text.

Never:

- reconstruct a quote from memory;
- quote a search-result snippet as though the full source was inspected;
- slightly rewrite text while presenting it as verbatim.

Prefer paraphrase plus source reference unless the original wording is important.

## Conflicting Sources

When reliable sources disagree:

1. preserve both claims;
2. identify each source;
3. check publication or revision dates;
4. prefer the source authoritative for the relevant contract;
5. explain why one source is weighted more heavily;
6. leave the question unresolved when evidence is insufficient.

Do not merge conflicting claims into a synthetic answer that no source supports.

## Multi-Agent Work

When several agents research the same task:

- each agent must return source identity with its findings;
- summaries without provenance are not sufficient evidence;
- the parent agent owns reconciliation of conflicting claims;
- downstream agents must not cite another agent as the underlying source.

The evidence chain should end at the real source, not at an intermediate model.

## Durable External Contracts

When external behavior materially affects implementation, pair this skill with
`source-research` and store the durable contract under:

`docs/sources/`

Include only implementation-relevant information.

Recommended structure:

```text
Source:
Verified:
Relevant contract:
Evidence:
Assumptions:
Known limitations:
Last checked:
```

## Handoff

When evidence informs implementation, architecture or review, pass forward:

- the verified claim;
- source identity;
- relevant evidence;
- assumptions or limitations;
- verification date when freshness matters.

Do not require downstream agents to rediscover already verified facts unless
freshness, contradiction or changed external behavior makes revalidation
necessary.