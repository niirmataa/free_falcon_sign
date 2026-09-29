# V02 — niezależna recenzja P02 v2

**VERDICT: PASS_SCOPED_REVIEW** dla ściśle ograniczonego `PARTIAL_PROOF`,
nie dla pełnego celu P02. TASK_ID=`B20_001_V02_WORD_FPEMU_REFINEMENT`,
source_task=`B20_001_P02_WORD_FPEMU_REFINEMENT`. Projekt Niirmata;
atrybucja Falcon Project / Thomas Pornin i licencje zachowane.

Recenzent: OpenAI GPT-6 Sol (`openai/gpt-6-sol`), sesja
`ses_f12645f4effei2l7zDf6rzsuJN`, świeży kontekst V02, bez subagentów.
Autor matematyczny: Astra Fast, odrębny model i sesja. Pakujący suplement:
GPT-6 Sol (`ses_f13139bc5ffeFI41laN8mgF1PA`), **ten sam model co recenzent,
ale inna sesja/kontekst**. To jawne ograniczenie niezależności modelowej od
pakującego; odbiór i jego kontrole były osobnym wykonaniem, nie importem
wniosków tamtej sesji. Właściciel zlecił ten odbiór w nowym oknie.

## Dokładny zakres

1. `B20.Word.load_store_le_refines`/`load_le_refines`: kernelowo potwierdzono
   parsowanie przypiętych `shake.c:56–90`, wykonanie abstrakcyjnego CExec
   ↔ LE64, round-trip i ramę 8 bajtów **przy `WriteRegion`/`ReadRegion`** oraz
   modelu LP64. To theorem o tym fragmencie modelu, nie o całym C/ABI/kompilatorze.
2. `neg_execution`, `double_execution`, `half_execution` dla wszystkich
   BitVec64; `pack_execution` pod `packDomain` (signed `e+1076` w zakresie);
   `rint_execution` dla słów o polu wykładnika `y≤1072` i `floor_execution`
   na tej domenie **bez raw −0**. Konkluzja to wykonanie sparsowanego
   fragmentu C w `B20.C.Scalar.execute shiftCalls` równe *literalnej*
   specyfikacji BitVec, nie twierdzenie o błędzie rzeczywistego zaokrąglenia.
   Dodatnie/ujemne zero i subnormals rint są w zakresie modelu; raw −0 floor
   daje −1 w C i jest poza domeną formalnego `floor_execution`.
3. `rint_ursh_domain` i `floor_irsh_domain` dowodzą count<64;
   `rint_ulsh_domain` bierze jawne `he2` (instancja w dowodzie rint ma
   własne `rint_e2_range`). Trzy shift helpers mają przypięte źródło i
   kernelowe wykonanie w ich dziedzinach.
4. `sub_refines_via_add_obligation` jest poprawnym **warunkowym** termem
   Lean. Niezależny lemat `V02.no_add_dispatch` pokazuje jednak
   `∀ x y w, ¬ AddCallObligation x y w` dla aktualnego `shiftCalls`:
   dispatcher ma tylko ursh/irsh/ulsh. Zatem `sub` nie ma instancji dla
   żadnego wywołania w tym interpreterze. Nie wolno konsumować tego jako
   kontraktu arytmetycznego `fpr_sub`; potrzebny nowy dispatcher i dowód add.

**Nieodebrane cele (wymagane dalej):** pełne
`add_sub_mul_div_sqrt_refines` wraz z real-error/rounding (add/mul/div/sqrt
mają tylko unresolved types); real-valued nearest-ties-even dla rint;
caller→Domain dla konsumentów, pełne wejścia finite poza wąskimi domenami;
decyzja o raw −0 floor; powiązanie z realnym frontendem C, GCC/platformą i
maszyną. P01/V01 może być użyte tylko w odebranym wąskim zakresie. Wynik
nie zamyka T03-B, Sign→Verify ani bezpieczeństwa schematu.

## Integralność, replay i niezależne próby

- REPORT `ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5`;
  OUTPUTS `af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e`;
  nowy HEAD `41216bb8d61004bb941a8d1b276f43346df11ce8`.
  Pełny own-input manifest `6b07625125728ce3f8888c067e164e94b9c358e493f9ede74bee028abdc711e6`;
  BOUND_INPUTS `15d1ee66a28743982854bc680ab7c81bf711506686dde8ab940f887a530a0923`.
  30626/30626 wejść, 30612/30612 plików output autora, 29751 static i
  68 poprzednika, exact set/brak symlinków/traversal, zgodność po jobach.
- **Jeden pełny fresh replay** `run/v02_fresh_001`: 43/43 exit0, 34 moduły
  BUILD_PLAN i pełny wydruk 20 terms, 16/16 niezależnie porównanych
  produktów, 45 rzeczywistych child commands; źródło przed/po bez zmiany.
  9 przypiętych korzeni bibliotek sprawdzone przez gate. Czas kroków
  254.708 s; osobna nowa budowa Lean bez autorskich olean. Semantyczny plan
  czterech generated files wskazuje koniec pipeline step3; rzeczywiści
  producenci czterech z nich to step1/2. Werdykt opiera się na rzeczywistych
  producentach, nie samym statusie runnera.
- Własny `sage check_words.sage` (Sage10.9 z preparserem, `ZZ`/`QQ`) stworzył
  1437 syntetycznych przypadków; C oryginalnych pinned header + `shake.c`
  przez UBSan i ASan/UBSan: po 1437 zgodności, 0 stderr. Kontrola signed-zero,
  ties i dokładnych rational checks jest diagnostyką, nie dowodem uniform.
  Cztery kontrole ujemne: sign/shift/rounding odrzucone exit1, count64
  odrzucone exit4 *przed wywołaniem C* (poza domeną). `sub` testowany wyłącznie
  syntetycznym `fpr_add` stubem jako sprawdzenie okablowania.
- Własny moduł Lean `ReviewChecks.lean` exit0 bez ostrzeżeń: wydruki typów i
  transitive axioms LE/rint/floor/sub, kernelowy `no_add_dispatch`, raw−0
  poza floor oraz niedozwolone `pack(e=INT_MAX)`. Użyte aksjomaty wyłącznie
  `propext`, `Classical.choice`, `Quot.sound`; brak `sorryAx` w czystym logu.
- Historical: 9 runów, 144 kroki, 288 raw step streams sprawdzone; **sześć
  dawnych ścieżek child stdout/stderr nadpisano**. Zachowane równoważne bajty
  z innych przypiętych runów nie odzyskują oryginalnej proweniencji ścieżki.
  Stary final HEAD pozostaje `UNRECORDED`. Historyczny wydruk AuditTerms
  zawiera 51 `⋯`; suplementowy pełny druk 20 terms bez skrótów nie zamienia
  historycznej liczby 489 skanowanych nazw na 489 pełnych wydruków.

Własne failed attempts Sage/Lean, wszystkie późniejsze źródła, osobne raw
stdout/stderr, real argv/cwd/timestamps/exit i porównania są w `evidence/`.
`source_changed=false`, `owner_accepted=false`, wszystkie joby review
zakończone. Bez Git, push, zmiany frozen autora i uruchamiania innych modeli.
