#129 — complete audit at fixed resource limits

Original2288-name audit024 stopped after1475 completed entries at the default
200000-heartbeat Meta.isDefEq budget. Small unchanged G19 audit025 reproduced
the expensive alias-conversion failure. These partial outputs are preserved
and are not accepted evidence for the full audit.

The replacement retains the full expression DAG JSON roundtrip, original
name/type inventory, nontruncated rendering and allowed-axiom closure checks.
It checks the restored body against the ORIGINAL declared type by constructing
a fresh SAFE definition in Lean's kernel. The returned environment is discarded.
The public Kernel.Environment.addDecl API receives the ORIGINAL options, and an
explicit guard rejects debug.skipKernelTC. No unchecked addition, option/limit
increase or native_decide is used. This adds an actual kernel validity check
instead of the problematic Meta.inferType/isDefEq conversion check.

The low-level API name was not exported (026, before any check); the public API
probe027 passed for G19. A combined175-command audit028 aborted with bad_alloc
after5 module parts; none is promoted. The same F07 module passed isolated029.
The final route therefore runs one mathematical module per Lean PROCESS,
sequentially in job030, with identical memory, wall, heartbeat and depth limits.
The standard module/declaration inventory is unchanged:175 modules,2288 names.

keygen_isolated_audit129.py pins the checked probe template and emits each
separate audit source plus ISOLATED_AUDIT_PLAN.json. keygen_audit129_collect.py
requires every175 audit receipt accepted with logs0/0, verifies source hashes,
checks every original name exactly once in the original order, checks the full
DAG/kernel/axiom flags, and writes AUDIT_129.json plus AUDIT_COLLECTION.json.
It accepts no partial output from any failed job. The sealer pins every part,
all source/output snapshots and all failed-job causes, then postseal checks
all inherited and new pins. This remains author validation, NOT an independent
review, whole-KeyGen success witness or probability theorem.
