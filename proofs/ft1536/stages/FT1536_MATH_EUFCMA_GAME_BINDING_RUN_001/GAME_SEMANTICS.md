# GAME_SEMANTICS — trzy gry, front-end, jądra (Etap A–D)

Wszystkie definicje wykonalne są w `formal/FT1536/GameMach.lean` (maszyna),
nazwy w `GameByte.lean`/`GameNames.lean`, jądra praw w `PaidSteps.lean`.
Sigma_math bez zmian wobec MODEL poprzednika: E0 / coefficient-valued
finite-box G16 / direct-output ROM.

## 1. Front-end bajtowy jednej tabeli

- `Byte = Fin 256`, `Name = Message = List Byte`.
- `nonceBytes : Fin (2^320) → List Byte` — dokładnie 40 bajtów, bijekcja
  (`nonceBytes_val`, `nonceBytes_nonceOf`, `nonceOf_nonceBytes`,
  `nonceBytes_injective`; `256^40 = 2^320` dowiedzione kernelowo).
- `NameKind = short (b, |b|<40) | sign r m`; `render` do literalnych bajtów:
  `sign r m ↦ nonceBytes r ++ m`. `render_injective`; `short_ne_sign`;
  `render_sign_frame` (dłuższe nazwy nieobcinane: `|render (sign r m)| =
  40+|m|`, `long_names_distinct`).
- `decodeName : Name → NameKind` z `render_decodeName`, `decodeName_render`
  (`nameKind_bijection`): KAŻDY literalny ciąg bajtów jest dokładnie jednym
  legalnym typem nazwy; krótkie (len<40) nigdy nie kolidują z Sign (len≥40).
- Adresy tabeli pair-kompatybilne z `ROM.State`: `tableAddr = embedName ∘
  decodeName`, `paint (tableAddr n) = n`, `tableAddr_injective`,
  `tableAddr_sign/short`. Równość adresów ↔ równość bajtów.

## 2. Zapytania i maszyna

- `Op = hq (k : NameKind) | sq (m : Message) | fin (r) (m) (sig : BoxVec)`.
  `sq` niesie w pełni ustalone m przed solą; `env.nonce` czytany wyłącznie
  wewnątrz `signStep` — atomowość (`sign_atomic`), brak reentrancy.
- `Reply = hval c | sign o | verdict Bool | halt`. `o : Option (Nonce ×
  Option BoxVec)` = istniejący typ obserwacji (PRE_ABORT=outer none nie
  powstaje w E0; POST_ABORT = `some (r, none)`). `halt` = wewnętrzny STOP
  lub przekroczenie budżetu — NIE jest zwracanym abortem.
- Alfabet odpowiedzi jest skończony przy skończonym C; operacje przeciwnika
  są funkcjami historii odpowiedzi (nie wchodzą do alfabetu losowego).
- `Mach`: `st : ROM.State NameBody Message C`, `mode`, `stopped`, `over`,
  liczniki `hq`, `sq`. Kroki delegują do `ROM.hash`/`ROM.submit`/lookup;
  programowanie przez wpis `target = none` (Sign-origin).

### Trzy tryby (`Mode`)

1. **EUF_real** (`real`): przy konflikcie nazwy Sign z tabelą gra uczciwa
   używa istniejącego wpisu (`c := e.value`, ciało losowane przy tym c).
2. **EUF_stopped** (`stopped`): konflikt → wewnętrzny STOP bez wygranej
   (`stopped_absorbing`), bez zwracanych tagów abort.
3. **SIM_targets** (`sim`): Sign programuje parę `(c,o)` z publicznego S
   (`env.simOut`, prawo = pushforward monet S); H z wektora celów.

Wspólne kroki (H hit/miss, final, submit, tabela) mają **dosłownie ten sam
kod** w trzech trybach — w warstwie praw identyczny kernel. Kroki „płatne"
to wyłącznie świeże nazwy Sign (odpowiednik wywołań honest signBody vs S).

## 3. Budżet i kolejność kroków

- `Budget (Q_H, Q_s, maxSteps, maxName, maxMsg)`; `stepBounded` kończy grę
  `halt` po przekroczeniu budżetu i **nie zmienia gry dla A w budżecie**
  (`stepBounded_eq_step_of_within`).
- `submit m` aktualizuje SeenSign **przed** każdym rozgałęzieniem — aborty
  też trafiają do SeenSign (`step_sq_seen`; dziedziczone
  `ROM.submitted_even_on_abort`). Ordinary freshness: nowy podpis starej
  wiadomości to nie wygrana (warunek `msg ∉ st.seen` w `verdict`).

## 4. Wektor celów i dyscyplina odczytów (Etap B)

- Jeden na run `targets : ℕ → C` (wejściowy wektor T=Q_H+1 w SIM; taśma
  leniwej wyroczni w EUF — realizacja przez `Law.uniform : Law (Fin T → C)`).
- `ROM.hash` czyta `targets[used]` tylko przy miss; cached H nie zużywa
  celu (`used` bez zmian), Sign programuje bez zużycia (`signStep_used`),
  końcowa świeża nazwa zużywa ≤1 (`used_le_of_step`).
- Małe modele Sage wykazują jednostajność i niezależność nieużytych celów
  względem przeszłości (dokładna enumeracja) — lokalne prawo lazy.
- **Pozostały jawny typ (NEXT_INTERFACE, poz. 2)**: pełne formalne
  refinement „wejściowy wektor = sekwencyjne losowania = leniwa wyrocznia"
  na poziomie praw (`lazy_sampling_refinement`); w tym wykonaniu
  udowodnione: nieantycypacyjność kroku (`ROM.hash_nonanticipating`,
  dziedziczona), dyscyplina `used` (nowe) i kontrola dokładna małego modelu.

## 5. Jądra lokalne (Etap C)

Certyfikat jednego wywołania S w świeżym punkcie (PARAMETR twierdzenia):

```
J_S = pushforward monet S przez S.run(h, pubState, m, r)
P   = uniform_Rq(c) × signBody(h,c)(o)     -- pełna para (c,o), z POST_ABORT
AC(J_S, P)   oraz   second(J_S, P) ≤ 1+e,  e ≥ 0
```

Obejmuje pełną parę (c,o) i dokładny stan dostępny S; nie jest to porównanie
samych obrazów ani samych udanych odpowiedzi. Wspólne kroki: `second p p = 1`
dokładnie (`PaidSteps.second_self`).

## 6. Wygrana i MT (Etap D)

- `verdict c msg sig` = `Relation.Verify h c (sigVec sg)`; `sigVec` dekoduje
  `BoxVec → Vec`. Ograniczenie do BoxVec jest win-neutralne: `Verify` zawiera
  `signed16`, więc wygrywające s i tak leżą w boxie.
- Wygrana: `msg ∉ seen ∧ verdict` (`verdict_fresh` — świeżość kernelowo).
- Ekstrakcja: końcowy wpis + `Reduction.indexed_extraction` (dziedziczone)
  daje `j < Q_H+1` i `ShortPreimage h (targets j) (extract h c s)` —
  zdarzenie MT **definiowane jako zwrócony wynik programu B** (indeks +
  świadek), nie dowolny predykat.
- Konflikt nonce: rama `r ↦ tableAddr (signName r msg)` iniektywna
  (`sign_frame_injective` z 40-bajtowej ramki), ryzyko per-call z realnego
  rozmiaru tabeli (`sign_conflict_risk`), suma `Q_H+i` → dokładne
  `eps_coll = min 1 ((Q_s·Q_H + Q_s(Q_s−1)/2)/2^320)`
  (`conflict_bound_shape` = `accumulated_conflicts` + `collision_sum`).

## 7. Kontrole małych modeli (sage check_games.sage)

Mała dokładna skala (nonce 2 bajty, przestrzenie 3/8, Q_H=Q_s=2): zgodność
kroków wspólnych trzech gier, licznik płatnych = liczba Sign (≠ liczba
kroków), cached H bez celu, SeenSign na submit, STOP absorbujący bez wygranej
po konflikcie, indeks/wartość finalnego wpisu, jednostajność nieużytych celów
(dokładna enumeracja), tożsamość `(1+e)^2` dla 2 płatnych przy 4 krokach
(wyraźnie mniejsza niż luźny `(1+e)^4`), Q_s=0 ⇒ 1, suma konfliktów
zgodna z formułą. Kontrole negatywne (8/8 reagują, no-op przechodzi):
pominięty SeenSign, zużycie celu przez cached H, reindex celu, brak finalnego
celu, konflikt jako wygrana (detekcja: brak wygranej), strata przy każdym H,
nieoszacowana lista celów.
