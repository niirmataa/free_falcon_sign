# P02 — historia prób

## scalar_controls_001–006 (2026-09-25)

1. Sage `^` to potęga, XOR to `^^` — `spec_neg/rint/floor` liczyły potęgowanie
   zamiast xor (OverflowError). Reguła: w `.sage` xor zawsze `^^`.
2. `random.Random` w Sage nie przyjmuje int seeda — własny deterministyczny
   LCG w czystym ZZ (zero zależności).
3. Link `fpr_add`: nagłówek tylko deklaruje; definicja w `fpr-emulated.c`,
   który wymaga `-DFPR_IMPL="fpr-emulated.h"` (jak pinned Makefile), inaczej
   wybiera backend `double` i sypie redefinicjami.
4. `INT_MIN+1076` się NIE przepełnia — fałszywy wiersz reject liczył się jako
   match i padał na cichym `scope`. Prawdziwe rejecty tylko w górę
   (`INT_MAX`, `INT_MAX-1`); w dół przepełnienie niemożliwe dla int e.
5. Ciche `return 3` kosztowały godzinę bisekcji — odtąd każda ścieżka błędu
   harnessu drukuje `FORMAT_ERROR`/`COUNT_ERROR` z linią i licznikami.

## domain_iface_001–002 (2026-09-25)

Pierwsza wersja `Domain.lean` skompilowała wszystkie dowody za pierwszym
razem; jedynie linter nazw (`m`/`a` nieużywane w aliasach domen) — poprawka
prefiksem `_`, reszta bez zmian. Lekcja: argumenty domen biorące udział
tylko w identyfikacji call-site oznaczaj od razu `_`.

## input_binding_001 (2026-09-23)

Materializacja archiwów i hash checks doszły do zapisu HEAD. Sandbox miał
`--ro-bind / /` bez osobnego bindu urządzeń; Git nie mógł otworzyć `/dev/null`
do zapisu. Exit 1, bez uruchamiania matematyki. Źródło skryptu i pełny stderr
są w `run/input_binding_001/`. Niekompletne wejścia zachowane jako
`run/input_binding_001/inputs_incomplete/`. Następna próba dodaje
`--dev-bind /dev /dev`; jedynym zapisywalnym drzewem danych projektu nadal W.

## shift_001

Pierwszy driver obliczył katalog repo o jeden poziom za płytko (proofs/proofs).
Nie uruchomiono Lean; snapshot źródła i wadliwego drivera zachowany w
`run/shift_001/`. Poprawa dotyczy wyłącznie wyliczenia ścieżki repo.

## shift_002

Zewnętrzny limit narzędzia 120 s przerwał próbę przed wydrukowaniem diagnostyki;
stdout/stderr puste, nie powstał receipt końcowy ani olean. Po timeout sprawdzono
brak procesu P02/Lean. Snapshot zachowany. Usunięto zbędny import całego
Mathlib.Tactic i skorygowano nazwy lematów na podstawie pinned Lean source.
Kolejny tool timeout będzie większy od poprzedniego; limit joba pozostaje1800s.

## shift_003 → shift_004

Pierwszy proof nie normalizował maski −1 do BitVec.allOnes; otwarte cele i
ostrzeżenia unusedSimpArgs zachowane w shift_003. shift_004 poprawia argument,
dodaje signed helper i przechodzi z czystym logiem; transitive axioms wyłącznie
propext/Classical.choice/Quot.sound. To na razie proof wyrażeń, nie source C.

## parser_001 / parser_002

Lean abort134 przy tworzeniu wątku, pod limitem address-space8GiB. Powtórzenie
bez zmian potwierdziło błąd; brak nowych proofów. Wersje źródła/logi zachowane.
Syntax nie używa algebraicznych struktur Mathlib.Data.BitVec, więc import
zawężono do Mathlib.Logic.Basic i Init.Data.BitVec.Lemmas, bez podnoszenia limitu.

## parser_003–005

Ścieżka minimalnego importu w Mathlib4.34 to Mathlib.Basic.Logic.Basic;
parser_003 ujawnił błędną starszą nazwę. parser_004 odrzucił doc-comment przed
`mutual`; parser_005 z poprawnym komentarzem zbudował Syntax/Parser bez ostrzeżeń.

## source_shift_001–004 i parse_probe_001–008

Pierwszy literal całego headera wymagał zwiększenia maxRecDepth; źródło
ma4527 linii/223901 bajtów. Transport podzielono na64-liniowe definicje,
zachowując dokładne bajty. Monolityczny `decide` dla kompozycji lexer→parser
przekraczał pamięć. ProbeHead, ProbeLex, ProbeExpr, ProbeParams i ProbeStmts
izolowały działające składowe; sam podział listy/mniejszy fuel nie usunął problemu.
Rozwiązanie: oddzielne kernel proofs source slice→chars,chars→tokens,tokens→AST,
potem ich kompozycja przez przepisywanie. Parser ma teraz nierekurencyjne
wzajemnie poziomy precedencji. Żaden AST wygenerowany Pythonem nie jest premise.
source_shift_003 wykazał brak instancji Fintype(Fin64); dodano minimalny import.
source_shift_004 i word_checks_001 są clean PASS,łącznie z source refinement
i siedmioma kontrolami negatywnymi. Wszystkie wcześniejsze źródła/logi pozostają
w osobnych runach. Probe*.lean to diagnostyka,część celowo nie kompiluje.

## word_controls_001 → word_controls_002

Sage wykonał rachunek i zapisał cases,ale JSON odrzucił Sage Integer; dodatkowo
`version()` zgłaszało deprecation. Poprawiono jedynie transport JSON przez int
i odczyt `sage.version.version`. word_controls_002:12288 przypadków,2 odrzucenia
preflight,normal/UBSan PASS,4 mutacje i brak producenta wykryte.

## memory_001

Monolityczne omega dla sumy8 cyfr bajtowych przekroczyło limit kernela2048MiB.
Nie jest to dowód ani kontrprzykład; jego olean i wydruki nie są eksportem.
Zamiast zwiększać limit rozbito dowód na radix_step/Nat.mod_mul i7 krótkich
przepisań. Snapshot i pełne logi memory_001 zachowane.

## memory_002–006 — doprecyzowanie diagnozy

Sam radix_step nie wystarczył: memory_002–005 nadal przekraczały pamięć przy
kernelowej redukcji rozwiniętego foldl z arytmetycznym argumentem. Oddzielny
Radix.lean przeszedł. Decydująca poprawka w memory_006: najpierw generyczny
`foldl_eight (f : Nat → Nat)` z nieinterpretowanym f,potem podstawienie cyfr
bajtowych i krótki radix proof. memory_006 clean PASS w pierwotnym limicie.
Zatem wcześniejszy opis „monolityczne omega” był diagnozą wstępną; zachowujemy
go i tę korektę. Nie przekuto żadnego failed output/aksjomatu zastępczego
z odrzuconych kompilacji w eksport.

## fresh_word_001

Po rozwiązaniu redukcji wykonano18/18 fresh kroków,14 modułów clean,26 audytowanych
eksportów z pełnymi typami/termami/axioms. Transport źródła regeneruje identyczne
Header/Slices. Normal/UBSan12288 cases i4 mutants+empty-product checks PASS.
Oddzielny word_asan_001 także12288 cases,5/5 wewnętrznych kroków exit0.
Library gate potwierdził pełne tracked bytes9 repozytoriów i zapisał cached hashes.

## scalar_probe_005 / scalar_binding_002–004

`mutual` parser powodował wykładniczy wybuch elaboratora na samym
`((uint64_t)s)` (6 tokenów, OOM niezależnie od fuel). Przyczyna: Leanowy
kompilator równań dla `mutual`. Rozwiązanie: niemutualna rekurencja
strukturalna z jawnym `sub : Parser` / `subPrec : Nat → Parser`
(`scalar_parser_006–008`). Po zmianie krytyczny przypadek przechodzi,
`ProbeScalarStatement` (packStmt8) przechodzi, a pełne wiązanie 7 funkcji
przy fuel 8 jest czyste (bez sorryAx). Fuel 6 był niewystarczający dla
rint/floor/double (fałszywe `decide is false`, nie OOM).

## Maski rint i kruchość simp (fpr_spec_018–048)

Duży `simp` z domyślnym simpsetem normalizuje cele i niszczy dopasowanie
późniejszych reguł (bmod-ekspansja `toInt`, literały negacji). Wzorzec:
kruche kroki przez `rw`/`simp only`, pełny `simp` tylko na końcu.
Fałszywe hipotezy Nat dla maski (bez zakresu signed) Lean słusznie odrzucił
— maska zależy od `toInt`, nie `toNat`. Przy domenie `ex≤1072` wszystko
przechodzi w samym `toNat` (e.toNat = e.toInt ∈ [13,1085]).
`check_transport.py` miał zdublowaną linię po edycji (naprawione).
`fresh_scalar_le_002`: 38/38 exit 0, 195,6 s, 31 modułów.

## floor_execution: koniec przez `rfl`, nie przez dopasowanie masek (floor_exec_001–014)

Program floor przeszedł S1–S9 (bridges jak w rint), ale finał stanął na
selekcji maski: cel `XI>>>C &&& ~~~Mprog ||| … = XI>>>C &&& ~~~Mspec ||| …`
z identycznymi XI/C po obu stronach. Wszystkie reguły maskowe
(`hmaskF` zwinięte, `floor_mask_fold`, jawny `hmaskF_exp` w kształcie
definicji) były "unused" —simp nie dopasowywał ani formy jawnej programu,
ani zwiniętej specyfikacji, mimo pozornej identyczności wydruków.
Lekcje (każda potwierdzona przebiegiem):
1. `obtain` rozbijający `∃` z `cond_neg_add64_le` na czyste równania
   (`hxor7/hadd7/…`) — opakowanie `∃` blokowało użycie reguły w S7.
2. Askyrypcja typu calla z literałem listy (`['f','p','r',…]` zamiast
   `"fpr_irsh".toList`) odblokowała S9 (obserwacja; przyczyna w matchingu
   nazw, do potwierdzenia przy `fpr_add`).
3. Finał domknięty przez `rfl`, nie simp: kernel widzi równość definicyjną
   masek (delta przez `floor_mask`/`rint_e`/`rint_y`), której simp matchujący
   nie widzi. Reguły maskowe wypadły z finału jako zbędne (linter).
4. `cond_neg_add64_le` (wariant `≤` zamiast `<`, dowód identyczny) dopisany
   do `SignedArith.lean` — argument msb wymaga tylko `≤`; `m0_lt` wystarcza.
5. Fakty muszą być w formie zwiniętej, żeby atomy pasowały do `omega`
   (`floor_t_range` o `(floor_t x).toNat`, nie o `(x>>>63).toNat`).
6. `have hmaskF := floor_mask_zero _ (by omega)` bez asercji typu zostawia
   metazmienną (`?m.toNat`) — jawna asercja `floor_mask (rint_e x) = …`.
7. `def` przed użyciem (`floor_t` przed `floor_t_range`); `←def` w `simp`
   jest nielegalne — folding wymaga lematu `rfl` (`floor_mask_fold`,
   ostatecznie nieużyty po przejściu na finał `rfl`).
Wynik: `B20.Fpr.floor_execution` PROVED (`floor_exec_014` exit 0, czysty log;
`floor_ax`: propext/choice/Quot.sound), `full_scalar_floor_001` 33/33.

## rint_execution: maska jawna vs zwinięta i rozjazd faz simp (fpr_spec_086–110)

Monolityczny `simp` w `rint_execution` nie domykał się: cel po ewaluacji
programu miał maskę-literał `18446744073709551615#64`, a hipotezy
(`hcall5`, `hf`) formę negacji — albo odwrotnie — zależnie od zestawu reguł.
Przyczyny, każda potwierdzona wydrukiem kontekstu:
1. `hmask_exp` przepisany ręcznie bez wewnętrznego `.setWidth 32`
   (definicja `rint_mask` to `-((((e-64).setWidth 32 >>>31).setWidth 64))`);
   reguła nigdy nie pasowała do rozwiniętego `hcall5`.
2. Pełny `simp` rozwijał negację do arytmetyki Nat (`2^64 - …`), po czym
   reguły poziomu BitVec (`hmask`) już nie pasowały — dotyczyło `hf`,
   którego maska siedzi wewnątrz `rint_d`/`rint_dd`.
3. Zwinięte `hmask : rint_mask _ = …` nie przepisuje jawnej maski programu;
   jawne `hmask` po `simp` ulegało manglingowi (gubiony wewnętrzny setWidth).
4. `cast .i64 (.u32 s)` to `setWidth 64`, a `rintSpec` używa `signExtend 64`
   — końcowy `neg` nie pasował; potrzebny mostek `hcast_s` dla `s∈{0,1}`.
Rozwiązanie (działa, kernel-checked, czyste logi):
CP-A: `rint_execution` wydzielony z `Spec.lean` do `B20/Fpr/RintExec.lean`
(BUILD_PLAN 31→32), zielona baza odblokowana. Dwufazowa normalizacja:
najpierw `simp only` na poziomie BitVec z jawnym `hmask_exp` (poprawiona
składnia z `.setWidth 32`), potem pełny `simp` z manglowanym `hmask` dla
strony programu; `hm1 : rint_m1 = rint_m0 / = 0`, `hcast_s`, `lit_allOnes64`.
Finał: czyszczenie list `simp` ściśle wg lintra `unusedSimpArgs`
(`fpr_spec_110` exit 0, zero ostrzeżeń). `rint_execution` zależy wyłącznie
od propext/Classical.choice/Quot.sound (sprawdzone `#print axioms`).
Ślepe próby po drodze: `rw [hmask_exp]` po simpie (już przepisane),
przepisywanie `hmask` na siebie, jawny `hall_lit` w finalnym simpie
(częściowo zbędny — linter). Lekcja: przy rozjeździe form zawsze najpierw
porównać wydruki obu stron i ustalić, która reguła ma pasować do której
postaci, zamiast dokładać reguły do jednego worka.
