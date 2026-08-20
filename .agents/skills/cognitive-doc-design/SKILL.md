---
name: cognitive-doc-design
description: Use when writing or restructuring documentation, ADRs, specs, task reports, runbooks or review material that should be easy to scan and verify.
---

# Cognitive Documentation Design

Documentation should reduce cognitive load.

The reader should not have to reconstruct the entire project
to understand the relevant decision or action.

---

# Lead With the Answer

Prefer:

Decision:
Use UTC internally.

Reason:
External providers use different timestamp semantics.

Then provide detail.

Avoid several paragraphs of context before revealing the decision.

---

# Progressive Disclosure

Structure documentation from most important to most detailed:

1. outcome or decision;
2. quick path;
3. constraints;
4. details;
5. edge cases;
6. references.

Do not force every reader to consume every detail.

---

# Chunking

Group related concepts.

Prefer short sections with meaningful headings.

Avoid:

- giant paragraphs;
- extremely long flat bullet lists;
- mixing decisions and background;
- repeating the same rule in several places.

---

# Recognition Over Recall

Prefer:

- checklists;
- tables;
- examples;
- explicit status fields;
- links to authoritative documents.

Avoid requiring readers to remember rules from another unrelated conversation.

---

# Review-Oriented Documentation

When writing for reviewers, make verification easy.

State:

- what changed;
- what to inspect first;
- what is out of scope;
- what evidence exists;
- what assumptions remain;
- what could fail.

---

# Avoid Duplication

Do not copy the same durable information into:

- task;
- spec;
- ADR;
- source contract;
- project memory.

Use references.

Each artifact has one responsibility.

---

# Suggested Structure

For operational documentation:

```text
TITLE

OUTCOME / DECISION

QUICK PATH

CONSTRAINTS

DETAILS

VERIFICATION

FAILURE / RECOVERY

REFERENCES