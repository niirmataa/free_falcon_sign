# Przypięte wejścia i zakres reuse

MANIFEST2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c:
382 członków,381 origin records,59892355 bytes. BASE20ed84a86d9374b026e2ea9ab78f7656a6650a8c.
INPUTS/provenance obejmuje386 publicznych rekordów z TASK/AGENTS/manifestem.

| Wejście | Zakres konsumpcji |
|---|---|
| AUDIT/REPORT420aedb4… i TIMING_REVIEW | Potwierdzony baseline exponent branch oraz oddzielne fpr_lt(-0,+0); nie pełny CT/arith proof |
| ZERO SourceFloor eb0ac429… | Literal old raw model i NumericCenter-only floor/range/int bridge |
| ZERO Floor/ValueDomain | Dependencies SourceFloor, pełna finite value interpretation; floorParts scope nie jest rozszerzone |
| DUD REPORT7387aa3b… / RESULT a7b5ab0e… | Zakończona nocna kampania, baseline9/9 floor signals,27 other no-signal results |
| DUD RECEIPT_REVIEW b6b93a30… | Maintainer replay15 selected raw trials same engine; nie drugi statistical method |
| vendor/dudect.h3fb3b2bd… | Niezmieniony upstream dc269651fb2567e46755cfb2a13d3875592968b5 |
| harness benchmark dd06a9f8… / targets7130dafe… | Identyczne w A/B, fixed classes/order/warmup/chunk/batch/sink/thresholds |
| H3/ROOT/NODE3/NODE2/TOWER/M0/LV | Historyczne tezy/piny do impact/transport, nie reimportowane z podmienionymi hashami |

Pełne hashe są w INPUTS/MANIFEST/ORIGINS. Projection obejmuje wszystkie42
night receipts/snapshots i pełne stdout selected15, ale raw tylko9 floor+3
positive controls. External negative raw i27 other trial streams nie były
czytane; ich inventory pozostała jawna. Tutaj odtworzono dostarczone12 raw,
a nie całe archiwum nocne. Trzy negative recalculation receipts pochodzą
od prowadzącego i są przypiętymi wejściami, nie nowym własnym przeliczeniem.

Trzy konsumowane Lean modules są byte-identical i przebudowane. Helpery
lean/dyadic/fp_literal/replaylib skopiowano z ZERO do nowego cwd. Official
benchmark/targets/vendor są niezmienione. Campaign.py skopiowano jako
dudect_mechanics.py: wykorzystano order/topology/snapshot/lossless raw ACK
helpers; jego stary8h main/prepare/launch nie został uruchomiony.

Nowy A/B driver ma własny frozen plan i bounds. Recalculation i storage
parts są nowymi adapterami, opisanymi wraz z diffami/source bindingiem.
Nie pobrano/instalowano silnika. Wszystkie failed setup/elaboration attempts
zachowano, bez zmian historycznych pakietów. No native_decide/axiom of result.
