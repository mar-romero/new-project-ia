# Git Worktree Policy

Use one branch and one working tree by default. Add worktrees only for truly
independent tasks with separate acceptance criteria, non-overlapping files and
an explicit integration order.

Each worktree has one task and one writer. Separate worktrees do not isolate
databases, ports, caches, credentials or external services; configure those
resources explicitly before parallel work begins.

Do not parallelize work that changes the same schema, migration, core
abstraction or shared configuration. Before integration, update against the
target branch as needed, resolve conflicts explicitly and rerun affected
checks.

Example layout:

```text
project/
project-worktrees/T-XXXX-short-description/
```

