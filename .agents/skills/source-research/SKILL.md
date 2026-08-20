---
name: source-research
description: Use before implementing behavior that depends on an external API, exchange, provider, protocol, library, dataset or current technical documentation.
---

# Source Research

Do not code against remembered external behavior when the contract can change.

## Source priority

1. official documentation;
2. official protocol/spec;
3. official source repository;
4. official changelog/release;
5. primary research;
6. trusted secondary source.

## Research only what is needed

Do not download or summarize entire documentation sites.

Extract implementation-relevant facts.

For APIs capture:

- endpoint/channel;
- request;
- response;
- fields used;
- units;
- timestamps;
- precision;
- authentication;
- pagination;
- sequencing;
- rate limits;
- reconnect behavior;
- historical coverage;
- errors;
- limitations.

## Unknowns

If official documentation does not define something:

write:

UNKNOWN / NOT DOCUMENTED

Do not invent behavior.

## Durable contract

When the application depends materially on the external behavior,
store a compact provider/source contract under:

docs/sources/

Include:

- source;
- relevant behavior;
- date verified;
- assumptions;
- known limitations.

Use `docs-researcher` for broad external research.