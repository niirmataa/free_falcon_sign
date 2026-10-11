# CHECKPOINT — F04 naprawa (wariant A) + F05, okno run2

Etap: `F04_ROM_VARIANT_A_001`. Okno: `proofs/ft1536/development/T12_1/run2`.
Zamknięcie: 2026-10-11 (decyzja właściciela 2026-10-11: F04 = wariant A;
F05 w tym samym oknie). Piny/receipty pary: `notes/F04_ROM_VARIANT_A_001.json`
+ `notes/F04_ROM_VARIANT_A_001_NOTES.md`. Próby (run_001..run_011,
final_clean_001/002) zachowane w `.build/f04_rom_a_001/attempts/`.
Bez push (polecenie okna). Commity: `832a9953`, `46761f1d`, `5f907a43`,
`0a8693d1`, `63b81a3c` (+ ten checkpoint).

## Podsumowanie dla właściciela (polskie)

**Co rzeczywiście udało się wykazać (kernel Lean, standardowe aksjomaty):**
Wyzwanie `c = H(r‖m)` jest teraz losowane z ROM-u, spoza taśmy samplera —
dokładnie tak jak w rzeczywistym kodzie (sampler rysuje tylko szum).
Przepisano typy run2 (`Sampler.code` przyjmuje wyzwanie z ROM-u i zwraca
samą odpowiedź; `Games.sample` losuje najpierw odpowiedź ROM, potem szum;
`samplerLaw` to iloczyn `Law.uniform` × szum) oraz **wszystkich 12
konsumentów** z listy DO-NOT-CONSUME audytu. Kluczowy fakt „margines
wyzwania = Law.uniform” jest teraz TWIERDZENIEM kernelowym
(`JointDecomp.samplerLaw_marginal_uniform`, `d1 = 0` bez luki), a nie
przesłanką — czyli naprawa F04 jest dostarczonym dowodem, nie etykietą A2
i nie nową nazwą na starej fałszywej przesłance (stare `UniformChallengeAt`
usunięto w całości). Argumentacja wszystkich 12 eksportów wydrukowana i
przeszła audyt aksjomatów (tylko `propext/Classical.choice/Quot.sound`).
Koszty i `hprg` przepisano pod wariant A: wejście samplera niesie pole
wyzwania, wyjście to sama odpowiedź (≤ 26113 bitów), taśma i szew PRG
obejmują wyłącznie szum, a produkcja wyzwania z ROM-u jest osobno
zafakturowana (`challengeCost`). W tym samym oknie domknięto F05: podłoga
ograniczona do właściwego supportu (tam gdzie `0 < target`), zera poza
włóknem obsłużone osobną przesłanką `hzero`, oraz estyma punktowa względna
(bez podłogi); pin spójności pokazuje, że na rzeczywistym celu `TowerWhole`
sprzeczność warunkowa audytu znika. Pełna closure run2 (167 modułów)
buduje się czysto z przypiętych bajtów.

**Co nie wyszło / pozostaje otwarte:** naprawa F04 jest typowo interfejsowa
— nie dostarcza źródłowego wiązania `S.code` z rzeczywistym `do_sign`
(B1/source3, osobne tory), wiązania bajtowego, ani zastrzeżenia o błędzie
addytywnym. F05 w wariancie podłogowym potrzebuje przesłanki `hzero`
(wsparcie włókna po stronie maszyny) — to nazwana przesłanka źródłowa,
nigdzie niezałożona. Zastrzeżenie F06 (różnica statystyczne/obliczeniowe)
stoi nietknięte. Poza zakresem i nietknięte: `AssemblyComp.
advMT_ge_of_public_sim_stream_win` (nie ma `huc` w typie — poza zarzutem),
trzy historyczne pliki-śladki (nie budują się od `3396e8e0`, nic ich nie
importuje) oraz trzy pliki FftBind zależne od Source3 (osobny tor napraw
062).

**Co ten wynik zmienia w projekcie:** lista DO-NOT-CONSUME audytu F04 jest
wyczerpana dla nowych sygnatur — 12 eksportów można ponownie konsumować,
a warstwa wyzwania (Layer 1, `d1 = 0`) przestaje być otwartym ryzykiem
modelowym: jest rozstrzygnięta decyzją właściciela i dowodem kernelowym.
Zostaje to, co było zawsze realnym ryzykiem: warstwa źródłowa (ReplyShape,
S.code) i most bajtowy.

**Następny krok:** niezależny odbiór pakietu (argument lists + audyt
aksjomatów + receipt `final_clean_002`) w trybie BATCH; następnie, po
akceptacji, import/przeniesienie przez koordynatora wg rytmu projektu.

## Piny i receipty

- 12 konsumentów + `romChallengeAt` + `samplerLaw_marginal_uniform` +
  `AssemblyComp.advMT_ge_of_public_sim_stream_win` + 3 twierdzenia F05:
  `#print`/`#print axioms` w `.build/f04_rom_a_001/audit/F04ConsumersAudit.lean`,
  log: `audit/F04ConsumersAudit.log` (sha w JSON-u pary).
- Definitywny receipt: `.build/f04_rom_a_001/attempts/final_clean_002/
  RECEIPT.json` — czysty pełny rebuild 167 modułów z bajtów commitowanych,
  0 błędów; sha w JSON-ie pary.
- Środowisko: Lean 4.34.0, Mathlib `5ed296525643`, guard `run_lean_guarded.sh`
  sha `76a4a4a0e0bb...` (jak w BATCH).

## Strażniki (stan)

- brak zastępowania dowodu etykietą A2 — ✓ (Layer 1 = twierdzenie kernelowe);
- brak nowych nazw na tej samej fałszywej przesłance — ✓ (`UniformChallengeAt`
  usunięte; `RomChallengeAt` zrealizowane przez `romChallengeAt`);
- `AssemblyComp.advMT_ge_of_public_sim_stream_win` nienaruszony — ✓;
- lista DO-NOT-CONSUME zaktualizowana po naprawie każdego konsumenta — ✓
  (tabela w `B4_SYNTHESIS.md` i w JSON-ie pary);
- próby zachowane — ✓ (`.build/f04_rom_a_001/attempts/`);
- bez push — ✓; cudze pliki nietknięte (Source3 = tor 062) — ✓
  (commity z dokładnymi pathspecami).

## Korekta granicy zaufania po REVIEW_001 — R1/R2 (2026-10-11)

Ta dopisana korekta zastępuje szeroką interpretację opisu powyżej.
Wcześniejsze bajty NOTES/CHECKPOINT są zachowane jako dokładne prefiksy oraz
osobne kopie `F04_ROM_VARIANT_A_SCOPE_002/PREVIOUS_{NOTES,CHECKPOINT}.md`.
Historyczny receipt `final_clean_002` pozostaje bez zmian, SHA256
`e37814b7b768a414f4bd6a18eca34e7441d4a2ff3986b6c3cf8cc6b63107caae`;
167/167 oznacza historyczny czysty rebuild, nie liczbę modułów objętych
twierdzeniem „standard only”. REVIEW_001 pozostaje **CHANGES_REQUIRED**.

**Odbierana closure F04/F05: dokładnie 166 modułów, #001–#165 i #167.**
To świadomie szeroki zakres domknięty na importy, nie minimalna closure
samych eksportów. Nowy receipt `F04_ROM_VARIANT_A_SCOPE_002/RECEIPT.json`
podaje każdy numer/moduł, SHA256 źródła, importy i powiązanie z zachowanymi
logami autora oraz recenzenta. Czytelna lista: `MODULES.md` w tym katalogu.
Twierdzenie **standard-only** dotyczy audytów tej właśnie closure 166 modułów:
569 wydruków aksjomatów i 21 osobno audytowanych deklaracji recenzenta
używa jedynie `propext`, `Classical.choice`, `Quot.sound`. Liczby wydruków
nie utożsamiamy z enumeracją całego środowiska Lean.

**R1:** historyczny diagnostyczny **#166 SelectBitPreserve jest świadomie
wyłączony**. Zero konsumentów w grafie importów; usunięcie go nie odcina
żadnej zależności odbieranych modułów. Źródło ma SHA256
`b7f57ec65c98b3477a7177e4107d92eefc78ff58ff5c8f57c6d5fb7cb47a9523`.
Zachowany log (pin w nowym receipcie) cytuje dodatkowy aksjomat
`select_bits_equiv._native.bv_decide.ax_1_5` w trzech eksportach. Moduł
pozostaje historycznym materiałem diagnostycznym, poza standard-only claim.

**R2:** **#156 ThetaBox pozostaje w closure** z historycznym lokalnym
wyłączeniem `linter.constructorNameAsVariable` przy `blockSum_eq_boxSum`.
To jawny wyjątek narzędziowy, nie wyciszenie dowodu lub kernela. Źródło
ma SHA256 `07db75cf4adfc8e3349c92919bf4789ef9453e08685ead8a5026eee203365ebe`.
Wersjonowana testowa kopia `ThetaBoxLinterEnabled.lean.txt` i log
`theta_linter_enabled.log` zachowują dokładne bajty testu REVIEW_001:
exit 1, „linter Lean.Linter.constructorNameAsVariable failed: maximum
recursion depth has been reached”. Pełne piny kopii i logu podano w NOTES
oraz nowym receipcie. Nie deklarujemy „zero wyciszeń” całej closure.

**Wynik korekty:** SCOPE_CORRECTED_AWAITING_TARGETED_RECHECK. Sprawdzono
graf, piny, audyty i nienaruszenie 3813 wcześniejszych plików; bez nowego
rebuilda Lean, zmian matematycznych F04/F05 lub awansu werdyktu recenzji.
Następny krok to ukierunkowany recheck zmienionego zakresu/evidence.
ReplyShape/source-defined sampler, most bajtowy, hzero/budżety i F06
pozostają otwarte. MIGRATION_HOLD zachowany; bez push/importu/tagu.

**Kolejka utwardzania T12.1, NISKI priorytet, osobna partia:** przepisanie
SelectBitPreserve bez `bv_decide` oraz naprawa rekurencji lintera w ThetaBox
bez wyłączenia. Zlecenia i kryteria odbioru dopisano do żywego ROADMAP;
nie uruchomiono ich w tej korekcie.
