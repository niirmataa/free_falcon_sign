# B20/P02 + V02 — przyjęty scoped review i import

2026-09-29. Projekt Niirmata; Falcon Project / Thomas Pornin,licencje zachowane.
Koordynator ses_f137502d0ffe6BYk3HEHU1xxZL. Kontrola organizacyjna: piny,
source/log/product bindings,import i Git. Matematyki/replayu nie powtarzano.

## Zewnętrzne piny i statusy

- P02 REPORT ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5;
  OUTPUTS af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e.
- V02 REVIEW30a82492d4e9b385ea2b3b3c991b984b2b8077d0e373b4ad8a9b38a6ace95e8d;
  REVIEW_OUTPUTS792b5fb6c5b7dc42f1a4ffb7d02343f6d6a76f9c7f6921ce2ce1817a17836a6c.
- Oceniany HEAD41216bb8d61004bb941a8d1b276f43346df11ce8.
- P02 REVIEWED / PARTIAL_PROOF,V02 REVIEW_COMPLETE / PASS_SCOPED_REVIEW.
  Owner_accepted=false,push=false. Kryterium konsumpcji to frozen verdict_scope.

Autor matematyczny Astra Fast;recenzent Sol,w świeżej sesji
ses_f12645f4effei2l7zDf6rzsuJN. Właściciel doprecyzował niezależność względem
autora dowodu. Ten sam model co pakujący w innej sesji pozostaje jawnym
ograniczeniem proweniencji. Dokładny zapis:DECISION_AND_CHECKER_NOTE.md.

## Faktycznie odebrany zakres

LE64 przy ReadRegion/WriteRegion/LP64;literal-word neg/double/half,pack pod
packDomain,rint exponent≤1072,floor w tej domenie poza raw−0;3 shift domains.
V02.no_add_dispatch kernelowo wykazuje brak AddCallObligation dla obecnego
dispatchera. Conditional sub nie dostarcza używalnego arithmetic contract.
Real-error add/mul/div/sqrt,real-rint,caller domains i C→machine OPEN.

## Evidence

INTAKE potwierdza30612 author outputs/29751 inputs,343 review outputs/
30633 inputs. Własny replay recenzenta43/43 i16/16,45 child commands,
50 source bindings. Własne końcowe kontrole10/10 expected exits i1437
przypadków C;3 source-before/after bindings i6 zapisanych Sage runów.
Wszystkie finalne raw logi i tekstowe produkty związane,jobów nie wykryto.

Pierwszy własny komparator koordynatora miał błędną mapę build→semantic.
Źródło i stop record zachowane;po zgłoszeniu poprawiono wyłącznie mapowanie
do ścieżek zapisanych w sealed sources/build_review_package.py. Końcowa
kontrola check_review_002 ma stdout/stderr/receipt. To nie failure dowodu.

Granice ewidencji:6 historycznych nadpisań child streams P02,old final HEAD
UNRECORDED,old print51 truncations versus nowy pełny druk20 terms. Wczesne
organizacyjne skrypty recenzenta były edytowane w miejscu;ich raw błędy są,
ale brak dawnych osobnych source snapshots. Wszystko pozostaje opisane.

Kanoniczne narzędzia:identity+frozen binding V02 przez b20_status_set.py,
import autora i review przez archive.py,przypięty scoped verdict przez setter.
Stage autora B20_001_P02_FINAL_001;recenzji B20_001_V02_FINAL_001.
Catalog replay=none to custom protocol;nie oznacza braku replayu w evidence.

Global archive.verify:46 checkpointów i59 dokumentów PASS,exit0,stderr pusty.
Lista archiwum i receipty komend zachowane. Checkpoint obejmie pełną closure;
ze względu na34k pathspeców canonical archive uruchamiany z32MiB stack
(ARG_MAX6MiB zamiast2MiB),bez zmiany jego kodu/walidacji i bez zmiany limitów
proof jobs. Następny obowiązek:P02 source arithmetic/real-error/caller domains.
