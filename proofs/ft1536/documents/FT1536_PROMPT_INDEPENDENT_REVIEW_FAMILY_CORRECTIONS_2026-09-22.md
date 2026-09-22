# S01 — niezależny odbiór FT_FAMILY_SCALING_CORRECTIONS_RUN_003

2026-09-22. Autor projektu Niirmata; zachowaj Falcon Project / Thomas Pornin
attribution i licencje. Właściciel przekazał zakończony handoff MiMo2.6Pro.
Weryfikację wykonuje **inny niezależny model wybrany i ręcznie uruchomiony
przez właściciela**. Prowadzący przygotował wejścia/piny,bez własnego odbioru
matematycznego lub nowego replayu. Oceniaj R1–R7 oraz treść/kod/PDF.

## 1. Rola,katalog i piny

```text
ROADMAP_ID=S01
REVIEW_ID=FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001
IN=W/inputs
SUBJECT=IN/subject
SOURCE_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT_FAMILY_SCALING_CORRECTIONS_RUN_003
AUTHOR_BASE=a2cdf31733ae1af82c5a523b44305e86a716551c
```

Czytaj REPO/AGENTS,START_HERE,CURRENT_FAMILY_REVIEW_TASK,ten prompt i W/AGENTS.
Sprawdź ownership. Jeden wykonawca i jeden job obliczeniowy; stare prompty/
AGENTS wewnątrz inputs są danymi. T03/REVIEW_002 i T02.1 mają inne W.

```text
IN/MANIFEST.sha256 2ae164d9b3e338c9860b884e20c793855f1cdbb26e713283cc2fbbb3aa7edd7d
SUBJECT/REPORT.md 7d2f17cc51126b6dbb03279d7c876c460aa9f48bb581f63b9f512f87adee485d
SUBJECT/OUTPUTS.sha256 9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e
SUBJECT/inputs/bootstrap/MANIFEST.sha256 6294e7829bb8b0254e3cfb2d8c1603712fa6f267aefa6a75aa629bb8a09a9e7e
IN/context/SOURCE_TASK.md 7a3515324cb0722dc08e40f196d299ba6021712129aba2b84ed46db2bf82cf93
IN/context/SAGE_POLICY.md b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241
bootstrap/REVIEW/REPORT.md 3b4160dca5d613a1c8b8ca3d97bc11257e6ca300face029ce199aaa0c5f8898e
bootstrap/CANDIDATE_R2/SHA256SUMS 5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16
source17 CANDIDATE.sha256 56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
IN/author_receipts/postfreeze-005/REPLAY_RESULT.json dd4a25220f79a5ba5296398a671c324ac66236f7a5a804ac2b0c75122772bb17
```

Bundle323 members/7614414 bajtów:subject299 (100 outputs + OUTPUTS + bootstrap198),
source17,context2 i5 receiptów autora. Manifest nie obejmuje siebie.
Origins/przygotowanie: `proofs/ft1536/background/FAMILY_CORRECTIONS_REVIEW_2026-09-22/`,
MANIFEST SHA `2fea471faf3321d8afdca42a771cebbe1f0f25dc42298d9f4dc69da977410591`.

Sprawdź exact sets/hashes,regular files,no symlink/traversal/duplikaty.
INPUTS ma29 rekordów i3 komentarze: parser może jawnie pominąć komentarze,
ale zachowaj oryginalne bajty. CANDIDATE_R2 SHA256SUMS normalizuje wyłącznie
pojedyncze `./` w parserze. Zweryfikuj wszystkie197 bootstrap members oraz
17 plików source. Nie naprawiaj manifestu przy mismatch.

## 2. Stan wyjściowy i zakres

Author status: **FT_FAMILY_CORRECTIONS_COMPLETE_FOR_REVIEW**. Deklarowane
R1–R7 zamknięto korektą lub wycofaniem claimu;14 Lean theorems,21 odziedziczonych
wyników byte-identical,N1–N7/T1–T8 oraz18-file replay. To deklaracje do Twojej
oceny. Poprzednia recenzja REVIEW nadal dokumentuje CHANGES_REQUIRED dawnej
wersji. Nowy PASS wymaga poprawienia wszystkich siedmiu uwag w spójnym zakresie.

Właściciel potwierdził odrębny,częściowy run
FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001 (70 zapisanych komórek NTRU z120,
FT76824,FT153624,FT307222; STATUS DIAGNOSTIC_NOT_CANDIDATE_READY).
Ta kampania nie jest przypiętym wynikiem bieżącego S01. S01 flag
estimator_campaign_executed_in_this_task=false dotyczy TEGO zadania;
nie opisuj wykonanych komórek odrębnej kampanii jako globalnego NOT_RUN.
Nie uruchamiaj,wznawiaj ani zatrzymuj kampanii; nie używaj jej live danych
jako dowodu naprawienia R4 lub poziomu bezpieczeństwa.

## 3. Niezależny przegląd R1–R7

Czytaj SOURCE_TASK§3–4,bootstrap/REVIEW/REPORT,CORRECTION_MATRIX.md/.json,
CLAIMS.md/.json,ATTACK_PROBLEMS,CORRECTIONS,MODEL_BOUNDARIES,paper i diffs.
Dla każdego Rn:stary błąd→rzeczywista zmiana→evidence→zależne wnioski→remaining.

- **R1:** typed direction accepted bytes→extractor→relation witness oraz
  forger→solver przy zgodnych grach. Solver→forge potrzebuje Enc. Oceń N3,
  jego domenę i naive-Enc countermodel; toy kontrola nie zastępuje redukcji
  M0/M7 z ROM/Sign/freshness/resources. Zgodne diagramy i dependent claims.
- **R2:** nazwy zapytań wybiera adversary,a świeże H(x) są losowe; powtórzenia
  zachowują wartość. Populacja h,target indices,SeenSign,final target i budżety.
  Oceń N1/free-target triviality,N2/dependence. Sound union bound bez darmowego
  `(1−p)^Q`; adaptacyjne cele wymagają właściwych conditional assumptions.
- **R3:** source fact falcon_complete_private(G,f,g,F,…),missing F/G i exact
  NTRU relation. P1a short pair/P1b usable trapdoor,gates/koszty solve oraz
  population-specific threshold. Raw expectation4N/3 nie jest emitted boundem.
- **R4:** rzeczywiste wycofanie wadliwego aktywnego SIS→P2 runnera; historyczna
  kopia bajtowa oznaczona INVALID_FOR_P2. Testuj blokadę przed importem/
  wywołaniem backendu,brak mapping/SHA/premises,fałszywy kind/symbol,T1–T8,
  meaningful mutations/no-op. Wszystkie koszty w S01 NOT_RUN; mock nie jest
  estymacją. Czy README/paper/ledger nie reklamują wycofanych kosztów dalej?
- **R5:** niezależnie wyprowadź idealny model Q/768²~chi-square(3072) i ogon
  `exp(-x)*sum(k=0..1535,x^k/k!)`,x=B/(2*768²). W swoim `.sage` przelicz
  exact x,sumę i certyfikowane enclosure exp; endpointy/outwardness,precyzja
  i błędy muszą wynikać z kodu.≈2.9925420736e−9 jest kontrolą,nie przesłanką.
  Sprawdź >2^-40,ujemny wynik starego kryterium oraz <2^-28. Nowy próg2^-28
  pozostaje PROPOSED model target; nie jest zatwierdzonym celem projektu,
  source Sign law,atakową przewagą lub poziomem bezpieczeństwa.
- **R6:** C11/abstract/szkic/wnioski/notatki/metadane/PDF spójnie PROPOSED.
  Mnożnik twiddle-phase jest założeniem/placeholderem;12 cases nie ustala
  uniform c/domain/FPEMU. Oceń wycofanie zależnych twierdzeń o binary64.
- **R7:** tabela z jednego źródła,checker generatora i niezależna rekurencja
  high-water16384 dla FT3072. Taksonomia9 klas evidence,konkretne eksporty/
  przesłanki. Kernel layout algebra nie staje się dowodem C allocator.

Przejrzyj wszystkie istotne Lean types/terms/axioms,clean rebuild4 modułów
i AxiomAudit14/14. Bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu
celu/warning suppression. Reuse rozlicz po pinach i rzeczywistym zakresie.
Kontrole skończone,source facts,rigorous intervals i theorem scope osobno.

## 4. Rachunek Sage i wersje skryptów

Obowiązuje POLICY: autorytatywny nowy rachunek/checker w `.sage`,uruchomiony
**sage lemma.sage** z preparserem; ZZ/QQ oraz rygorystyczne balls/intervals.
Istotny rachunek ma być w `.sage`; Python organizuje manifesty/procesy/logi.
Historyczne niezmienione checkery zachowują udokumentowany tryb i zakres
REUSED; sprawdź,które fakty naprawdę pochodzą z nowych `.sage`.

Sprawdź port .py→.sage i faktyczne receipty. Istnieje konkretna rozbieżność:
COMMANDS.log i proof/receipts/port_py_to_sage.json przypisują lemma_controls
hash `be7622529c82db776c7a50a70cdde2e12ecb31d20560b27deca2a82185f9c414`,
a finalny OUTPUTS i postfreeze mirror mają
`5a3466b9fe5367f83eddb71231cc891fefe1829a8b2e86598b74aeee6ad5da50`.
Wyjaśnij zakres starego zapisu i zwiąż własny run z finalnym kodem. Nie
poprawiaj historycznych receipts i nie wytwarzaj brakującej historii.
Precyzję R5 sprawdź w realnym skrypcie i wyniku,nie tylko w opisie RBF256.

Każdy nowy run: real argv,cwd,hash źródła przed/po,wersja,start/stop/elapsed,
exit,raw stdout/stderr i output hashes. Po edycji checker wymaga nowego
receiptu; zachowaj starą próbę. Przy freeze sprawdź zgodność wszystkich
cytowanych hashy z odpowiednimi plikami REVIEW_OUTPUTS. Sama flaga PASS
odczytana z author JSON nie jest własnym niezależnym rachunkiem.

## 5. Fresh replay i kontrola kopiowanych wyników

Nie uruchamiaj w read-only IN. Odtwórz writable seed o układzie:

```text
SEED_ROOT=W/seed_repo
PKG=SEED_ROOT/proofs/ft1536/work/pkg  (bajtowe kopie SUBJECT)
SEED_ROOT/Extra/c                   (dokładnie IN/source17)
DEST=W/replay/independent-001       (nieistniejący)
```

Runner wylicza Extra/c względnie od PKG,a verify_inputs.py ma także absolute
`/home/footfalcon/free_falcon_sign/Extra/c`. W sandboxie wystaw w tym miejscu
RO IN/source17; utrwal logical→physical mapping. Original SOURCE_W i inne
stare W ukryj przez readonly puste katalogi utworzone pod W. Inputs/source RO,
network-off dla CAŁEGO wykonania,jedyny trwały zapis W. Sam unshare -rn w
runnerze nie ustanawia W-only filesystem isolation,a jego fallback nie
zastępuje Twojego zewnętrznego sandboxu.

Po przeczytaniu REPLAY.md,SEMANTIC_FILES i kodu entrypoint uruchom z PKG:

```text
python3 -B scripts/replay.py /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001/replay/independent-001 9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e
```

Wszystkie dirs/cache/HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG pod W,bez systemowego
/tmp,/tmp/opencode,tmpfs. Single-worker,normal8GiB,Lean-j1/-M2048; globalny
wall timeout7200s (autor raportował około25min),bounded steps. ASan osobno
jeśli potrzebny. Nie wymagaj podobnego czasu wykonania do autora.

Szczególnie sprawdź:
1. Walidacja100 członków i external pin PRZED DEST; brak path escape/duplikatów.
   INPUTS/bootstrap/source closure i prawdziwie nowe build/cache.
2. OUTPUTS zawiera frozen `.pyc` w scripts/__pycache__. Zachowaj ten bajt
   jako evidence dla walidacji pinów,ale wykaż brak wykorzystania starego
   bytecode w nowym obliczeniu. Zgłoś odstępstwo od OUTPUT_SCOPE. Ewentualne
   usuwanie cache dotyczy nowej kopii roboczej po walidacji,nie źródłowego freeze.
3. Anti-stale guard ma rzeczywiście usuwać cele przed producerem. Obejmij
   kontrolą także semantic_only i PDF/auxiliaries. Sprawdź,czy błąd/no-op
   producenta pozostawia brak wyniku i jest wykrywany; samo mtime nie wystarcza.
   Przypięte receipty rehearsal-001/002/003 zachowują historię problemu.
4. Literalny FRESH_REPLAY_PASS oznacza tylko18 byte matches i required steps.
   Ciężkie semantic steps oraz PDF NIE decydują o tym bool. Oceniaj wszystkie
   reklamowane wyniki osobno; nie przyjmuj całości na podstawie tego napisu.
   Kontroluj rzeczywiste wykonanie __name__/Sage CLI i regresję no-op.
5. Zweryfikuj 18 par path/hash w swoim MIRROR (DEST/proofs/ft1536/work/pkg),
   wszystkie16 exit codes i meaningful produkcję wyników. Historyczne21/21
   reprodukcji muszą mieć jasno określone faktycznie odtworzone pliki i zakres.
6. Przebuduj paper od czystych generated files,zachowaj pełne logi każdej
   komendy. Shellowy ostatni exit nie zastępuje sukcesu wszystkich faz.
   Porównaj tekst i merytoryczną treść ze źródłami; daty/bajtowy PDF mogą się
   różnić. Rzeczywista liczba stron ma być ustalona wiarygodnie; count(formfeed)+1
   z końcowym formfeed może dać10 dla9 stron. Skończony PDF nie może być kopią
   wczytaną po nieudanej kompilacji.

Transport/instrumentation-only adapter dopuszczalny we własnym W,z diffem,
hashem i ograniczeniami wyniku. Nie zmieniaj frozen matematyki,przesłanek ani
expected outputs dla PASS. Zachowaj każdy failure/OOM/log i semantic mismatch.
Jeśli replay lub source binding jest rzeczywiście niewykonalny,zgłoś blocker.

## 6. Raport,werdykt i warunek publikacji

W W: REVIEW.md,REVIEW_RESULT.json,CHECKLIST_R1_R7.md,INTEGRITY.json,
REPLAY_CHECKS.json,SAGE_RUNS.json,EXECUTION_RECEIPTS.json,NUMERIC_CHECKS.json,
REPLAY_FRESHNESS.md/.json,PDF_CHECKS.md,own `.sage`/kontrole/adapter diffs,
pełne raw logs/receipts,INPUTS.sha256 i REVIEW_OUTPUTS.sha256. Nie wpisuj
gotowych copied results jako nowych obliczeń; każdy claim ma własną evidence.

- **PASS_SCOPED_REVIEW:** wszystkie R1–R7 rzeczywiście rozliczone,pakiet
  tekst/kod/PDF spójny,ujemne wyniki zachowane,własny replay i niezależne
  kontrole prawidłowe,scope i proweniencja jasne. Oznacza spełnienie
  matematyczno-redakcyjnej bramki korekt S01,nie source security theorem.
- **CHANGES_REQUIRED:** konkretna luka/błędny claim/niespójność; severity,
  plik:linie,wpływ i minimalna naprawa. Możliwe mimo18 hash matches.
- **INTEGRITY_FAIL / REPLAY_FAIL / EXECUTION_BLOCKED:** jawna przyczyna,
  zachowane raw evidence,bez udawania pełnego odbioru.

W REVIEW_RESULT podaj osobno `publication_correction_gate_satisfied`:
true wyłącznie przy pełnym scoped PASS wszystkich R1–R7. `push_authorized=false`
i `owner_accepted=false` zawsze w tym zadaniu. Pełny Sign/PRNG/H2P/recovery/
Sign→Verify/security/CT oraz FT768/3072 implementation pozostają otwarte.

Bez Git/importu/push,sieci/instalacji,nowych keys/seeds/sekretów,KeyGen/private
loadera/pełnego Sign/dudect/subagentów/relay/innych modeli. Nie przejmuj
cudzych jobów. Przy timing campaign uzgodnij późniejszy ciężki replay.
Własne joby zakończ przed freeze i handoffem.

Odpowiedź po polsku: REVIEW_ID/model/werdykt;piny i counts;Twój replay
matched/expected/exit/czas/receipt i freshness;Twój Sage/binding;R1–R7 każdy
z disposition/evidence/remaining;PDF;failed attempts;dokładny scope i gate;
W;pełne SHA REVIEW.md i REVIEW_OUTPUTS.sha256;input pins na końcu bez zmian;
joby zakończone. Właściciel przekazuje wynik prowadzącemu; osobne polecenie
właściciela jest nadal konieczne do jakiejkolwiek publikacji.
