# Design and Architecture Decisions

## Start with the smallest useful boundary

Use a function, module, data structure, class/object or component according to
the language and the problem; none is inherently superior. Create a class or
object when it gives a coherent home to state, invariants, lifecycle or related
behavior. Keep plain data plain when behavior and invariants do not justify an
object.

Before creating a class, check:

- What responsibility, state and invariant does it own?
- Which collaborators does it need, and are their dependencies explicit?
- Can its public surface be named by intent and tested through observable
  behavior?
- Is a function, existing module or simple data type clearer?
- Is this a stable concept or a premature generalization?

Use an abstraction or interface at a real variation boundary: multiple current
implementations, an external boundary, independently evolving code, or a
testable contract. Depend on the narrow behavior actually needed. Do not add
an interface only because a class exists or a future replacement is imaginable.
In collections and function parameters, use the least-specific type/contract
that preserves the required operations and invariants.

Avoid strong coupling: do not make a unit navigate another unit's internals,
rely on incidental concrete behavior, or accumulate long dependency chains.
Constructor injection is useful when a dependency is required and stable, but
too many constructor parameters can reveal mixed responsibilities or a missing
collaborator grouping. A constructor should not silently build heavyweight,
environment-dependent collaborators when those can be supplied at the boundary.

## Components and composition

A component is a replaceable unit with a clear responsibility and contract; a
layer is an organizational direction for dependencies. A component can exist
inside a layer, and a layer need not be independently replaceable.

Make a component swappable only when callers rely on a deliberate contract and
interchanging implementations preserves required behavior. Dependency
injection/IoC means the caller or composition root supplies dependencies
instead of a unit constructing policy or infrastructure itself. Use it for
real configuration, substitution or boundary needs; direct construction is
often clearest for local, stable value objects.

An entity has identity that persists through state changes. Model one only when
identity matters; otherwise a value or record may be enough. A use case is an
application operation that coordinates domain rules and external work; do not
introduce a separate use-case layer for a single trivial action.

Primary ports describe how callers invoke application behavior. Secondary
ports describe what the application needs from external systems. Primary
adapters translate inbound mechanisms (for example UI, CLI, jobs or HTTP) into
application calls; secondary adapters translate outbound needs (storage,
network, files) into infrastructure. These boundaries are useful when they
protect domain/application logic from volatile mechanisms—not as ceremony.

Expose an API only for an actual caller boundary. Define its inputs, outputs,
validation, errors, authorization, versioning and idempotency needs from the
consumer contract. Keep framework setup and concrete wiring in a composition
root; inject dependencies there rather than dispersing construction.

## Choosing an architecture

Choose the lightest style that protects real constraints:

| Style | Warranted when | Usually not warranted when |
| --- | --- | --- |
| MVC | A user-facing application benefits from separating presentation flow and state. | A small non-UI service has no view/controller concerns. |
| Layered | Dependency direction and separation of UI/application/domain/infrastructure clarify a growing application. | The layers merely forward calls without boundaries or policy. |
| Hexagonal / ports and adapters | External mechanisms must be replaceable or must not leak into core rules. | A small local program has no volatile external boundary. |
| DDD | Complex, changing business rules need a shared domain language and explicit invariants. | The domain is simple CRUD with little business behavior. |
| Microservices | Independently deployable domains need separate scaling, ownership or release cadence. | A modular monolith meets current needs; distributed operations would dominate. |
| Event-driven | Producers and consumers genuinely need asynchronous decoupling, fan-out or durable event history. | Synchronous request/response is sufficient and clearer. |
| Twelve-factor practices | A deployable service needs portable configuration, stateless processes and operational discipline. | A local library or short-lived tool has no deployment lifecycle. |

These styles can combine, but each additional boundary has cost. Select based on
current evidence, not terminology.

## When to plan first

Use plan mode before coding when requirements, acceptance criteria, affected
boundaries, data semantics, failure modes, architecture choice, migration or
verification are uncertain enough that coding would create rework or risk.
For a small, well-understood local change with clear checks, state the approach
briefly and implement directly.
