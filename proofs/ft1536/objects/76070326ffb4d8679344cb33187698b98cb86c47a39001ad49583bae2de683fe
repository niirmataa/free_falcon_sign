# Odbiór L_NTT_FORWARD — 2026-09-18

**Wynik odtworzenia: PASS. Zachowany werdykt: L_NTT_PROVED_FOR_PINNED_MODEL.**

## Tożsamość pakietu

Etap: `FT1536_L_NTT_FORWARD_RUN_001`.

| Kotwica przekazana przez właściciela | SHA-256 |
|---|---|
| REPORT.md | `ff172360348004527b7ef2a68c3f70967463619f039145d856f1969d69b866eb` |
| OUTPUTS.sha256 | `32147f114b448a1e1c2659b45ed3e69bfac02c44164ac380001df39c98fb498e` |

Importer sprawdził 884 członków OUTPUTS i 55 zadeklarowanych wejść.
Archiwum zawiera dokładnie OUTPUTS oraz jego członków, a publiczne wejścia
są związane z obiektami po SHA-256. Protokół katalogu: `standard`.

Odtwarzanie wykonano z zaimportowanych, przypiętych bajtów w worktree
`/tmp/opencode/ft1536-noreply-history`, przed commitem tego etapu.
Rodzic Git: `6f44972e80e4e063962bdba811013ba829e7e078`.
To walidacja konkretnego nowego archiwum, nie deklaracja czystego checkoutu
wszystkich pozostałych roboczych plików tego worktree.

## Polecenie i wynik

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_L_NTT_FORWARD_RUN_001 --run maintainer-replay-001 --timeout 600 --hide-originals
```

- `FRESH_REPLAY_PASS`, exit 0, bez timeoutu; 176.61 s całego wykonania.
- **217/217** plików znaczeniowych zgodnych bajtowo z zamrożonym receipt.
- **63 moduły, 472 twierdzenia, 109 nowych**, ponownie zbudowane przez Lean.
- Czyste końcowe logi; audit dopuszcza tylko `propext`, `Classical.choice`,
  `Quot.sound`. Wszystkie 63 wykonania kernelowe zakończone kodem 0.
- Ponownie wykonane kontrole C/Sage: dwa przypadki pipeline, 6144 współczynniki,
  pięć wykrytych mutacji i dodatnia kontrola no-op.
- Root sandboxa read-only, zapis w świeżym seed, sieć odłączona.
  Dokumenty i historyczny Szablon ukryte pustymi tmpfs.
- Standardowy replay odbudował moduły z lokalnych źródeł, bez przenoszenia
  wcześniejszych olean, binariów lub cache. Nie adaptowano zawartości seed.
- Po wykonaniu sprawdzono ponownie wszystkie sześć checkpointów archiwum.

Kontrola bajtów indeksu potwierdziła zgodność całego zarchiwizowanego materiału
z plikami roboczymi i zachowanie pinów. Pełne `git diff --cached --check` dla
tego checkpointu zwróciło kod 2 z 17 uwagami whitespace w niezmienionych,
przypiętych plikach etapu: końcowe puste linie strumieni/toolchainu oraz spacje
w kontekście `Rho.patch` i historycznych źródłach C. Te bajty należą do OUTPUTS.
Osobna kontrola nowej dokumentacji, katalogu, obiektów wejściowych i validation
jest czysta. Nie są to ostrzeżenia Lean ani błędy odtworzenia.

`execution.json` wiąże wykonanie z pinem OUTPUTS i surowymi strumieniami.
`replay_result.json` zawiera pełne 217 porównań. `replay_commands.json`,
`COMMANDS.log` i `kernel_receipts.json` zachowują komendy i metadane świeżych
wykonań. `formal_audit.json` jest odtworzonym audytem źródeł, twierdzeń
i aksjomatów. `VALIDATION.sha256` przypina osiem plików tych dowodów wykonania.
Zgodne końcowe strumienie modułów są także członkami archiwum etapu;
robocze obliczenia i cache pozostają w ignorowanym `replay-work/`.

## Sprawdzenie zakresu

Przejrzano `ForwardGlobal.lean`, `Product.lean`, `Complete.lean`, pełne typy
i termy dowodowe oraz binding C/model. Końcowy `L_NTT` ma tylko trzy
przesłanki `CanonVec`; dowód wprost podstawia dowiedziony `forward_product`
do odziedziczonego `L_NTT_pending_forward`. Definicja iloczynu jest związana
z pierwotnym `productCoefficient/remMonomial`, a forward z rzeczywistym
harmonogramem etapów i porządkiem bufora `3i+j`.

Zakres to przypięty model źródłowy oraz jego jawna translacja C99/GCC/LP64
z warunkami legalnych buforów. Odbiór techniczny i kernelowy nie jest nowym
pełnym dowodem semantyki kompilatora C ani owner acceptance.

Kandydat `falcon-vrfy.c` ma SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Pozostają `source_integrated=false`, `owner_accepted=false`,
`full_L_V_proved=false`. Dalszy most L_V obejmuje parser, centrowanie C,
dokładność Q i ścisły próg B.
