# Continuous Integration Policy

CI supplies deterministic evidence; agent review supplements it but does not
replace it.

Run cheap checks first, make the same commands usable locally, use
least-privilege permissions and avoid production secrets in ordinary pull
requests. A starter may initially run only the harness check.

Once the stack exists, define fast checks (format/lint/types/unit), selective
domain checks (contracts, schemas or security), integration checks and optional
heavy/nightly checks. A required correctness check must not be skipped merely
to save cost.

Do not execute untrusted pull-request code with privileged credentials.

