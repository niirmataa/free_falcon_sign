# FT1536 — GPT-ASTRA: H3_RANGE

Bieżące zadanie:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_RANGE_2026-09-19.md`.
Wersjonowana kopia: `proofs/ft1536/documents/` na main.

SHA-256 zadania:
`7eb75c4f19c32c1a20a3ec7677ef75293132e9238b8dd64cfff1f4d4f34607e0`.

Jedyny katalog zapisu:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_RANGE_RUN_001`.
Kontynuuj w tej samej rozmowie Astry. Przeczytaj też AGENTS.md repo.
Potwierdź rzeczywisty sandbox/cwd; HOME/TMPDIR/DOT_SAGE/LEAN_PATH i cache pod W.

## Gotowe wejścia

`inputs/bootstrap/` zawiera dokładne źródła kandydata z main f526676,
M0/freeze oraz publiczne wybrane H3/H4/T5. Sprawdź przed pracą
SHA-256 jego MANIFEST.sha256:
`f9ea278838e9d1f8f959100175f56c62217997ff25611fccc0b9353dd9fcfe40`.
52 wpisy manifestu, 50 publicznych oryginałów. Nie jest to pełny eksport
historycznych pakietów; zakres i ORIGINS są jawne. Wejścia pozostają read-only.

Używaj przypiętej kopii source, nie przypadkowego Extra/c starszego lokalnego
checkoutu. Nie zmieniaj branch refs/indeksu ani archiwów. Aktywny build main
jest już kandydatem L_RHO; wcześniejszy lokalny indeks jest chroniony.

## Cel

Wyprowadź Reach_call_C z faktycznego Sign dla emitted-KeyGen support i
udowodnij wymagany zakres floor(mu), poprawną konwersję oraz s+z.
Zachowaj M0 (4096 payload, osobny nonce40, parametryczny cel), sigma768/B2093922385.

Szczególne punkty: floor jest przed dss guardem; signed zero/subnormals/
underflow muszą odpowiadać rzeczywistemu FPEMU; terminal leaves nie zastępują
internal LDL multipliers; output ternary ffSampling to residua. Indukcja
nie może zakładać bezpieczeństwa późniejszych calls, które ma dopiero wykazać.

Bez nowych kluczy/KeyGen/Sign z sekretem, odczytu sekretów/seedów, instalacji,
sieci badawczej i innych agentów. Tylko publiczne/syntetyczne kontrole.
Nowe Lean mają czyste logi, pełne typy/axioms i brak sorry/admit/native_decide.
Joby mają skończone limity; niepowodzenia i próby pozostają zachowane.

Po freeze wykonaj standardowy replay z finalnym zewnętrznym pinem.
Raportuj pełny dowód, precyzyjny partial lub prawidłowo sklasyfikowany
kontrprzykład. Git/import/commit wykonuje prowadzący sesję. Kończysz na H3_RANGE.
