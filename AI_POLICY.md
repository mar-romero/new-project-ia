# <PROJECT_NAME> — AI Assistance Policy

AI assistance is permitted, but it is not evidence of correctness and never
transfers responsibility away from the human owner.

## Evidence over claims

Do not accept an agent's assertion that code, a source, a benchmark or a
security property is correct without evidence. Prefer executed checks,
reproducible results, authoritative documentation, sanitized fixtures and
independent review.

Agents must never invent APIs, behavior, output, paths, configuration values,
citations, test results, review findings or source provenance. Mark unknown
information as unknown and verify mutable external behavior before relying on
it. Unproven claims fail closed: they are not defects and cannot authorize
PASS.

## Scope and quality

Keep AI-generated changes within the active task. Do not add speculative
infrastructure, dependencies, abstractions or configuration merely because an
agent suggested them. The implementation writer is not its own final reviewer
and must not write the review verdict.

## Privacy and publication

Never place secrets, credentials, private data, internal paths or confidential
content in prompts, code, tests, documentation, logs or external reports.
Before any publication, verify the target, evidence and removal of sensitive
information. Do not present an AI system as a human author, approver or
reviewer.

## Human gates

Human approval is required before irreversible production changes, use of
production credentials, security weakening, destructive operations, material
recurring cost or an irreversible architecture decision.

## Principle

Accept a result because evidence supports it, not because an AI produced it.

