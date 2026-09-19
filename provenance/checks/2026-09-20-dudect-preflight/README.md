# FT1536 — official dudect harness preflight, 2026-09-20

**PREFLIGHT_PASS. The eight-hour campaign was not yet started when this
checkpoint was frozen.** This is a build/harness/control receipt, not a
constant-time proof or an emitted Sign attack.

Source baseline: `1a04145c89e81ba0a51465c32e011880750696b6`, with the
unchanged candidate 17-file manifest
`2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
The reproducible [harness and protocol](../../../tests/ft1536/dudect/README.md)
use the actual `-O` Makefile profile and official dudect commit
`dc269651fb2567e46755cfb2a13d3875592968b5`. All three upstream files and
licenses are retained in vendor/. The engine header SHA-256 is
`3fb3b2bd7f9e17ae34b7c92518c1311c67342c56facc80da925d85f121b649da`.

Latest accepted preparation is **attempt002**, CPU9 (a non-SMT core), GCC
Debian14.2.0-19, Linux x86_64 LP64. There are **28672 public fixture checks**
per attempt, covering all14 contrasts including controls. Compiler stderr
is empty. The floor branch is present in the wrapper and the original
falcon-sign assembly. No KeyGen, secret-key loader or Sign was executed.

| Latest preflight | Uncropped n0 / n1 | max abs(t) | Engine result |
|---|---:|---:|---|
| positive loop | 49993 /49996 |15120.31|LEAKAGE_FOUND|
| negative floor |1049886 /1049883|1.89|NO_LEAKAGE_EVIDENCE_YET|
| floor(+1/4) vs floor(+3/4) |49998 /49991|129.49|LEAKAGE_FOUND|
|0.5s timebox, identical floor distributions|549943 /549936|2.57|NO_LEAKAGE_EVIDENCE_YET|

The timebox completed in0.543s. Three truncated raw-record forms were rejected.
Every saved preflight t-test state was reproduced exactly from the raw
class/timing stream; streaming hashes were independently checked.

Attempts000 and001 are retained in full, including their different CPU9/11
snapshots and all outcomes. They preceded engineering improvements to the
logging budget, streaming hash/replay, deadline checks and service launcher;
no observation was discarded to select a favorable statistic. Every negative
control had NO_LEAKAGE_EVIDENCE_YET and every positive/floor probe found a
signal. Repeated preflights reused public fixture orders and are not the
three independent-order rounds of the planned campaign.

[PREPARATION.json](PREPARATION.json) binds the accepted sources, binary,
compiler argv and upstream hashes. [REVIEW.json](REVIEW.json) inventories
all11 preflight trials. The source code, machine data, assembly, full logs,
raw compressed times and replay outputs are retained. Compiled objects and
executables stay in work and are hash-bound; the source/build recipes allow
rebuilding them. No package installation was needed.

`CHECKS.sha256` covers389 byte-exact files (17456573bytes), SHA-256:
`fd45bd35ea25f13f18c87e97235fef8e30687171515b6910b1f98c1ea5d0fb08`.
The README, attributes and checksum file itself are outside that manifest.
Historical upstream/source/log whitespace is retained.

The host is a shared desktop, with recorded intel_pstate powersave governor,
performance EPP and turbo enabled. The control results support proceeding
with the exploratory campaign; they do not establish exclusive host control,
constant time, caller reachability, or a full-signature timing attack.
The larger campaign gets its own receipts and eventual result checkpoint.
