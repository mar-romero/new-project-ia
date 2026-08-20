---
name: github-issue
description: Use when preparing, creating or triaging a GitHub issue for a bug, feature request, investigation or external provider problem.
---

# GitHub Issue Workflow

An issue should represent a verified problem or scoped request.

Do not publish speculative claims as facts.

---

# Before Creating

Discover repository policy.

Check:

- repository;
- issue templates;
- contribution rules;
- labels;
- existing open issues;
- existing closed issues.

Do not assume another repository's workflow applies here.

---

# Search First

Search for:

- same symptom;
- same subsystem;
- same root cause;
- previous closed fix;
- canonical tracking issue.

Do not create duplicates when an existing issue already owns the problem.

---

# Evidence

For a bug include where possible:

- observed behavior;
- expected behavior;
- reproduction;
- environment;
- affected revision/version;
- logs or error messages;
- minimal evidence.

Distinguish:

OBSERVED

from:

HYPOTHESIS

---

# Privacy Review

Immediately before publishing, inspect content for:

- API keys;
- tokens;
- passwords;
- private repository names;
- usernames;
- absolute local paths;
- internal IP addresses;
- internal hostnames;
- confidential datasets.

Replace environment-specific values with placeholders where appropriate.

Example:

```text
C:\Users\realname\project