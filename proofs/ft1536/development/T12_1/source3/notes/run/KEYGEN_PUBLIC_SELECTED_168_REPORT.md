# Both actual selected public forward calls168

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Source commitaf0ec90a.

SelectedForwardInputs168 derives fresh blocks33/34 from the finite old
heap, the proved norm memory frame and actual conversion frame. The
initialized writable h and t domains come from the same conversion.
SelectedForwardH168.source constructs the original first h call, using167.
SelectedForwardFrame168 derives global-table separation from the finite
table map and ternary_slots; forward_other then preserves t through that
actual h call. Cleanup supplies fresh reusable blocks for the second call.
SelectedForwardT168.source/both constructs the actual t call and the
original two-call sequence. continue_suffix retains the exact original
suffix obligation. There is no remaining forward-execution premise and
no injected native intermediate snapshot.

Four modules/26 declarations passed full expression-DAG roundtrip and
fresh safe kernel audit in job144, four sequential processes, standard
axioms only. Jobs143/144 accepted every module with empty stdout/stderr,
0 errors and0 warnings; no failed job. ENTRY168 checked57291 inherited
pins; seal/postseal recheck the closure. ENTRY SHA256:
98c1dab53b053fe77d2767e75c75614119ddd18a6604cfb15be25df914880250.
Audit collection SHA256:
63e1a743061157c62414bdeda2808b385984e5f5799f7701084bd7a50ee9cdd0.
Evidence: KEYGEN_PUBLIC_SELECTED_168.json and
.build/selected168/POSTSEAL_168.json.

OPEN: attach polynomial values to the actual afterT heap; prove the
selected nonzero tests and construct division/inverse/return, then root
solver, certificate/codecs and full G(seed*) witness. No concrete positive
acceptance/coding/whole-law bound is claimed. Corrected134 remains the
target; old110, measured wording and five do_sign obligations are unchanged.
No new assumption, C/model change, limits increase, review status, push,
second worker or parallel Lean process.
