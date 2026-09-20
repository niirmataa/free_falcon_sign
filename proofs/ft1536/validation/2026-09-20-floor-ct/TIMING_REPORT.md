# FPEMU_FLOOR_CT — prespecified A/B

PASS_PRESPECIFIED_AB_EXPLORATORY_SHARED_HOST

CPU11, non-SMT verified, shared host. Frozen plan `733401b207afedae6ae32e559a1599b608c9afed1eca452905899c923e59c676`.
30 trials /3 rounds, elapsed 454.495s; each engine budget30s, every observed trial<60s, global1800s.
Official engine/harness/classes0..4/order/warmup/chunk64/batch100000/thresholds unchanged.
No tuning/retry/selection; all outcomes, raw streams,102 test states and percentiles retained.

| Round | Case | Variant | Result | n0 / n1 | final max abs(t) | peak batch max abs(t) |
|---|---|---|---|---|---|---|
|0|positive_loop|baseline|LEAKAGE_FOUND|49993 / 49996|18357.6848|18357.6848|
|0|positive_loop|candidate|LEAKAGE_FOUND|49993 / 49996|17743.8861|17743.8861|
|0|negative_floor|baseline|NO_LEAKAGE_EVIDENCE_YET|33746308 / 33746267|1.43144984|2.4978535|
|0|negative_floor|candidate|NO_LEAKAGE_EVIDENCE_YET|32046493 / 32046456|2.31889552|3.12202654|
|0|floor_fixed_positive|baseline|LEAKAGE_FOUND|49991 / 49998|117.232225|117.232225|
|0|floor_fixed_positive|candidate|NO_LEAKAGE_EVIDENCE_YET|32146479 / 32146448|2.61558351|2.7849971|
|0|floor_fixed_negative|baseline|LEAKAGE_FOUND|49995 / 49994|149.905861|149.905861|
|0|floor_fixed_negative|candidate|NO_LEAKAGE_EVIDENCE_YET|32146471 / 32146456|2.61768845|2.80144568|
|0|floor_random_signed|baseline|LEAKAGE_FOUND|49994 / 49995|144.855865|144.855865|
|0|floor_random_signed|candidate|NO_LEAKAGE_EVIDENCE_YET|32096493 / 32096445|1.79140724|3.44790489|
|1|positive_loop|candidate|LEAKAGE_FOUND|49995 / 49994|16625.1488|16625.1488|
|1|positive_loop|baseline|LEAKAGE_FOUND|49995 / 49994|19677.1651|19677.1651|
|1|negative_floor|candidate|NO_LEAKAGE_EVIDENCE_YET|31946540 / 31946431|1.58795522|2.41881557|
|1|negative_floor|baseline|NO_LEAKAGE_EVIDENCE_YET|33946332 / 33946199|1.71960546|2.74749586|
|1|floor_fixed_positive|candidate|NO_LEAKAGE_EVIDENCE_YET|31946544 / 31946427|3.90581109|3.92649957|
|1|floor_fixed_positive|baseline|LEAKAGE_FOUND|49993 / 49996|142.297931|142.297931|
|1|floor_fixed_negative|candidate|NO_LEAKAGE_EVIDENCE_YET|32146469 / 32146458|1.584992|3.15917614|
|1|floor_fixed_negative|baseline|LEAKAGE_FOUND|49993 / 49996|118.749456|118.749456|
|1|floor_random_signed|candidate|NO_LEAKAGE_EVIDENCE_YET|32046489 / 32046460|2.02441012|2.9815865|
|1|floor_random_signed|baseline|LEAKAGE_FOUND|49996 / 49993|120.033634|120.033634|
|2|positive_loop|baseline|LEAKAGE_FOUND|49993 / 49996|16927.9503|16927.9503|
|2|positive_loop|candidate|LEAKAGE_FOUND|49993 / 49996|17024.7297|17024.7297|
|2|negative_floor|baseline|NO_LEAKAGE_EVIDENCE_YET|33896336 / 33896206|1.83408821|3.24324465|
|2|negative_floor|candidate|NO_LEAKAGE_EVIDENCE_YET|32046522 / 32046427|1.80534784|3.59872913|
|2|floor_fixed_positive|baseline|LEAKAGE_FOUND|49995 / 49994|141.721451|141.721451|
|2|floor_fixed_positive|candidate|NO_LEAKAGE_EVIDENCE_YET|32046470 / 32046479|3.2752584|3.96924256|
|2|floor_fixed_negative|baseline|LEAKAGE_FOUND|49996 / 49993|140.949537|140.949537|
|2|floor_fixed_negative|candidate|NO_LEAKAGE_EVIDENCE_YET|32046508 / 32046441|2.60352111|4.05546941|
|2|floor_random_signed|baseline|LEAKAGE_FOUND|49994 / 49995|115.093947|115.093947|
|2|floor_random_signed|candidate|NO_LEAKAGE_EVIDENCE_YET|31996519 / 31996441|1.38734055|2.80479545|

Baseline floor detections 9/9; candidate no-signal 9/9.
Positive controls 6/6; negative controls 6/6. Candidate floor minimum per-class n=31946427.
All9771 recorded batches were independently reread and recalculated by the unchanged official engine; all102 states match exactly. This is deterministic recalculation, not a second statistical method or new physical campaign.
Machine before/after/latest snapshots per trial, cpuinfo/kernel/topology/process and CPU selection receipts are retained. Affinity is not exclusive core reservation. No privileged OS changes or background worker remains.
Known shared-host conditions and variable frequency remain an exploratory limitation; no blanket CT claim follows from NO_LEAKAGE_EVIDENCE_YET.
Each STREAMS.json specifies lossless ordered parts, sizes and whole-stream hashes. Largest part <=32MiB. No subsampling/outlier removal outside the official engine.
Baseline night context is only the delivered projection:12 supplied raw streams replayed here; external negative/other raw were not read or represented as a full archive.
