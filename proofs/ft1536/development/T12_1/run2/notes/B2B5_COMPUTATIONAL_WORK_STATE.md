# B2/B5 — the computational seam (CompPrg + AssemblyComp)

Task: `notes/PROMPT_B2B5_COMPUTATIONAL.md` (window B2/B5 — the last
conceptual seam). Workspace `proofs/ft1536/development/T12_1/run2/`. Own
files only: `formal/CompPrg.lean`, `formal/AssemblyComp.lean` + this entry.
Recorded 2026-10-06. Everything else READ-ONLY (including `AdvPrg.lean` and
`Assembly.lean` — imported and extended, never edited).

## Status

**DONE — `formal/CompPrg.lean` (986 lines) and `formal/AssemblyComp.lean`
(328 lines) build 0/0** (EMPTY logs = 0 errors/0 warnings, guarded serial
compile `tools/original/run_lean_guarded.sh`, exit 0, 2s each). Axiom audit:
**64/64 declarations (defs + theorems) depend only on subsets of
`[propext, Classical.choice, Quot.sound]`** — 56/56 in `CompPrgAudit`, 8/8 in
`AssemblyCompAudit`; zero unfinished-proof markers, zero `sorry`. `#print`
statement evidence in `.build/audit/CompPrgAudit.log` and
`.build/audit/AssemblyCompAudit.log`.

## 1. THE final assumption sentence (one predicate name + one resource line)

> The real-stream assembled bound is CONDITIONAL on **`CompPRGBound C tau
> deltaPRG`** — the distinguishing advantage of the pinned `Extra/c/frng.c`
> whole-run tape law `tau` (width `n = beta.qs * S.bits`, one stream) against
> the fair tape, budget `deltaPRG`, quantified over an ADMITTED CLASS of tests
> `C` — together with the named membership premise **`CompWinCert`** for the
> composed winning event of the game at `A`, whose resource accounting line is
> `cost(winTest) <= T(A) + q * blockCost` (`q` = `AdvPrg.chachaBlocksTotal
> beta S`, the ChaCha20 blocks generating the stream).

Kernel form (the computational shape — the `UniformChallenge` pattern of
`VerifyBind/HashTo.lean:244`, computational reading):

    CompPRGBound (C : Set (CompTest n)) (tau : Law (Fin n -> Bool)) (delta) :=
      forall t in C, compTestAdv tau t <= delta
    -- compTestAdv tau t = |sum x, (tau.mass x - uniform.mass x) * t.run x|
    -- CompTest n = { run : (Fin n -> Bool) -> ℝ // 0 <= run <= 1 }  (randomized
    --   tests; deterministic tests are the {0,1}-valued ones — indicator case)

    CompWinCert C cost t TA blockCost q : Prop :=
      t ∈ C ∧ cost t <= TA + q * blockCost

## 2. THE chained-game statement (goal 2 — the hop CHAINED)

Real game (`CompPrg.AdvEUFStream`): the EUF game whose signing oracle runs
the real `Games.Sampler.code` on the per-call windows of ONE whole-run tape
drawn from `tau` (hash queries and the forgery test stay honest). Fair side:
`tau = Law.uniform`. Chain (all kernel-checked):

    (hop)      AdvEUFStream tau A <= AdvEUFStream uniform A + deltaPRG
               -- CompPrg.stream_game_hop (two-sided: stream_game_hop_abs),
               --   Assembly.tape_game_hop_abs applied to the WINNING EVENT of
               --   A, at winning-probability level, FOR THE ADMITTED CLASS ONLY
               --   (honesty rule 1 — no small TV is derived from CompPRGBound;
               --   route_a_closed stays the recorded death of that route)
    (identity) AdvEUFStream uniform A = AdvMT (beta.qh+1) muH (Reduction.build)
               -- CompPrg.streamGame_uniform_eq_advMT, via
               --   CompPrg.streamGame_uniform (the window-table split
               --   uniform_table_split + simulateStream_uniform) and
               --   Run2.concrete_lazy_game_binding
    (export)   AdvEUFStream tau A
                 <= min 1 (epsColl beta + phi ((1+e)^beta.qs - 1) (AdvMT ...))
                    + deltaPRG        -- AssemblyComp.end_to_end_stream_theorem
               -- with deltaPRG arriving VIA THE HOP (not appended as
               --   0 <= deltaPRG to the ideal-game bound). The old export
               --   (Assembly.end_to_end_assembled_theorem_statement) stays the
               --   abstract honest-game shape; Assembly.lean untouched.

## 3. THE inverted Phi formula (exact — goal 3)

The repo's `FT1536.EventTransfer.phi D b = (2b+D+sqrt(D^2+4Db(1-b)))/(2(1+D))`
is inverted EXACTLY (the review's `max{0, a - sqrt(D*a*(1-a))}` is CHECKED and
CONFIRMED to be the sharp inverse, not an estimate — `phi_satisfies` gives
equality at `a = phi D b`):

    phiInv D a = max 0 (a - sqrt(D * a * (1 - a)))
    phi_inv_le : 0 <= D -> 0 <= b -> b <= 1 -> a <= phi D b -> phiInv D a <= b

Security-claim export (`AssemblyComp.advMT_ge_of_stream_win`), the exact
`f(epsilon_real, D, deltaPRG, ...)` requested:

    Adv_MT(Reduction.build beta A S) >= max 0 (a - sqrt(D * a * (1 - a)))
    a = epsilon_real - deltaPRG - StoppingLoss.epsColl beta
    D = (1 + (k^32 - 1)) ^ beta.qs - 1            (e = k^32 - 1)

derived as the contrapositive of the re-exported bound. Boundary sanity:
`phiInv D (D/(1+D)) = 0` (`phiInv_at_phi_zero`) consistent with the
already-present `EventTransfer.phi_at_zero : phi D 0 = D/(1+D)`
(`phi_at_zero_export`). Recorded companion
(`advMT_ge_of_stream_win_direct`): this chain ALSO yields
`Adv_MT(B) >= epsilon_real - deltaPRG`, which numerically DOMINATES the
Phi-form; the Phi-form is exported as the requested exact inversion of the
assembled SHAPE and keeps the certificate factor `D` visible. Recorded, not
smoothed.

## 4. Scope/notation cleanup (goal 4 — recorded)

* `n = beta.qs * S.bits` (`CompPrg.tapeWidth`): `beta.qs` is the record FIELD
  `Budget.qs` (the signing-query budget), so `n` is the PRODUCT of the query
  budget and the per-call width — not a double multiplier
  (`tapeWidth_eq`, `tapeWidth_eq_tapeBitsTotal`).
* Per-call width `S.bits` vs the whole-run horizon: joined in ONE game
  definition by the **whole-run tape law with per-call projection**
  (`CompPrg.windowOf` — call `i` reads window `i` of one stream; the
  `windowsEquiv` relabeling, `sum_windowsOf_ite`, `uniform_windowsOf_mass`
  and `draw_uniform_windowsOf` factor the FAIR side into independent
  per-call windows). This is the ONE-STREAM reading recorded in
  `notes/B2_ADVPRG_WORK_STATE.md` §5; the per-call reading (a
  `beta.qs`-fold factor) is NOT mixed in.
* Test shape (recorded): a composed adversary is randomized beyond the tape
  (the key, the coins, the nonces and the ROM draws live in the one-draw
  continuation), so its tape-level winning event is the win FUNCTION
  (`CompPrg.winFun`). `CompTest` is the [0,1]-valued test type (the class
  shape that "supports exactly what the hop needs: membership of the game's
  winning event for a composed adversary" — `CompWinCert.mem`); the task's
  e.g. predicate on Prop-events is kept verbatim as `CompPRGBoundEvent`
  (deterministic/indicator special case). No Turing machines, no cost model
  invented beyond the seam's accounting line.
* All TV lemmas and `AdvPrg.route_a_closed` stay as the recorded death of the
  statistical route (`formal/AdvPrg.lean` §4, READ-ONLY here).
* The seed/SHAKE boundary (A2) and the byte bridge (A3/A4) stay outside, as
  recorded. `keyIdent` stays the exact-type slot (B1.10 owns it) and the new
  exports USE `hkey` structurally (the `gate` pattern of the old exports — the
  consumer proof is a function of `keyIdent`, so the final identification is
  its ONLY free point).
* Premise honesty (recorded): the assembled named premises
  `huc`/`hshape`/`hattempt` belong to the honest-game chain of the OLD export
  (they discharge the B4 certificate there); the new chain (hop + reducer
  identity) does not consume them, so they are NOT carried — carrying
  unconsumed premises would be over-assumption. The new argument list is
  `hk, hkey, hcomp, hwin` over the assembled objects.

## 5. What the seam now honestly supports (and what not)

* A reader of the public description may now honestly claim: **"the
  real-stream EUF advantage of any composed adversary is at most the assembled
  bound `min 1 (epsColl + phi((1+e)^qs-1, Adv_MT(Reduction.build)))` plus the
  computational tape term `deltaPRG`, where `deltaPRG` bounds the whole-run
  ChaCha20 stream against the fair tape FOR THE ADMITTED CLASS of
  cost-bounded tests containing the composed winning event (accounting
  `cost <= T(A) + q * blockCost`)"** — and, contrapositively, the exact
  reduction form `Adv_MT(B) >= max 0 (a - sqrt(D*a*(1-a)))` at
  `a = epsilon_real - deltaPRG - epsColl`.
* NOT supported (unchanged, recorded): any claim about ChaCha20 security
  itself (assumption); any statistical reading of `deltaPRG` (route (a)
  closed — every unbounded `delta` on the real tape is `>= 1 - 2^448/2^n`,
  `AdvPrg.chacha20PRFBound_delta_ge`); the A2 seed boundary; the A3/A4 byte
  bridge; the B1.10 `keyIdent` content; anything about a deployment-side
  timing/attempt-count adversary (A1, out of model scope).

## 6. Receipts

* `bash tools/original/run_lean_guarded.sh formal/CompPrg.lean
  .build/check_lib/CompPrg.olean 900 1800` — exit 0, 2s, log EMPTY (0/0).
* `bash tools/original/run_lean_guarded.sh formal/AssemblyComp.lean
  .build/check_lib/AssemblyComp.olean 900 1800` — exit 0, 2s, log EMPTY (0/0).
* Axiom audit `bash tools/original/run_lean_guarded.sh
  .build/audit/CompPrgAudit.lean .build/audit/CompPrgAudit.olean 900 1800` —
  exit 0, log 0 errors; **56/56 declarations, standard axioms only**; the
  `#print` blocks print the exact shapes of `CompPRGBound`, `CompWinCert`,
  `comp_game_hop_abs`, `tapeWidth_eq`, `streamGame_uniform_eq_advMT`,
  `stream_game_hop_abs`.
* Axiom audit `... .build/audit/AssemblyCompAudit.lean ...` — exit 0, log 0
  errors; **8/8 declarations (axioms `[propext, Classical.choice,
  Quot.sound]` only)**; the `#print` blocks print `phiInv`, `phi_inv_le`,
  `end_to_end_stream_theorem`, `advMT_ge_of_stream_win`.
* Hashes (sha256/16): `formal/CompPrg.lean` `d0a92b2ab8f1de1f…`,
  `formal/AssemblyComp.lean` `1412be31ccacf68b…`,
  `CompPrg.log` `e3b0c44298fc1c14…` (= empty),
  `AssemblyComp.log` `e3b0c44298fc1c14…` (= empty),
  `CompPrgAudit.lean` `f6b3a83b60872f98…`, `CompPrgAudit.log`
  `298de2937125acc3…`, `AssemblyCompAudit.lean` `aea1da3022ac6ddd…`,
  `AssemblyCompAudit.log` `d22743371e1a53aa…`.

## 7. Workstate lessons (for the next window)

* **`simulateLazy`-style matcher equations do NOT reduce definitionally on
  variables** (dependent `Program s q` matcher). Use `simp only
  [simulateStream]/[simulateLazy]`-proved `have`-equations and `rw`, never
  `show`/`rfl` through them.
* **`bind_comm`'s natural form matters**: `p.bind fun x => q.bind (f x)` vs
  `q.bind fun y => p.bind fun x => f x y` — when the continuation carries a
  `match o with`, keep the match UNDER the innermost bind (eta-move first) or
  the `exact`-unification fails on `bind`/`match` commutation.
* `Dist.Same` is a `∀ f, expect-eq` Prop — no `.symm`/`.trans` fields; use
  `same_symm'`/`same_trans'` transport lemmas.
* `Nat.add_mul_div_left (x z) {y} : (x + y * z) / y = x / y + z` — divisor is
  the IMPLICIT middle binder; `Nat.div_lt_of_lt_mul : a < b * c → a / c < b`.
* `linarith` treats compound monomials as atoms only up to degree 2 — keep
  `D*a*(1-a)`-shaped terms inside `have`-equalities and combine with
  `mul_nonneg`/`le_of_mul_le_mul_left`, not `nlinarith`.
* `rw [h]` under a `fun`-binder with the bound variable in the instantiated
  lemma fails (`hstream (winRead w) st`-style); use `simp_rw [h]` or a
  quantified `have`.
* `one_le_pow₀ : 1 ≤ a → 1 ≤ a ^ n` — `1 ≤ 1 + (k^32 - 1)` is `1 ≤ k^32`
  (needs `one_le_pow₀ hk`), NOT `0 ≤ k^32`.
* `Finset.sum_product`'s summand must be PAIRED `f (x, y)`-shaped; transport
  `univ ×ˢ univ = univ` at the `have`-level (`rw [hpu] at hp`), not in the
  goal (the rewrite hits every `univ`).

## 8. Podsumowanie dla właściciela (po polsku)

**Zadanie B2/B5 (szew obliczeniowy) — zamknięte.** Dwa zweryfikowane luki
recenzji (2026-10-06) są domknięte kernelowo, pliki `CompPrg.lean` (986
linii) + `AssemblyComp.lean` (328 linii) budują się 0/0, audyt aksjomatów
64/64 tylko standardowe.

- **Zdanie założenia (jedna nazwa + jedna linia zasobów):** rachunek jest
  warunkowy na **`CompPRGBound C tau deltaPRG`** — kwantyfikację po DOPUSZCZONEJ
  KLASIE testów (parametr, bez maszyn Turinga) nad całobiegową taśmą realnego
  strumienia ChaCha20 (`n = beta.qs * S.bits`, jeden strumień — `beta.qs` to
  POLE rekordu budżetu, nie mnożnik) — razem z nazwaną przesłanką członkostwa
  **`CompWinCert`**: wygrana zdarzenie gry dla złożonego adwersarza jest w klasie,
  z linią księgowania `cost ≤ T(A) + q * blockCost` (q bloków ChaCha20 generuje
  strumień). To realna kwantyfikacja obliczeniowa — w przeciwieństwie do starego
  `ChaCha20PRFBound` (wszystkie zdarzenia), który na realnej taśmie jest próżny
  (`delta ≥ 1 − 2^448/2^n`, ~1).
- **Zdanie gry sprzężonej (hop NA STAŁE w eksporcie):** gra strumieniowa
  `AdvEUFStream` (sygnaturka realnego `Games.Sampler.code` na oknach JEDNEGO
  strumienia) jest w `deltaPRG` od gry taśmy równej
  (`stream_game_hop` — rodzina `tape_game_hop_abs` zastosowana do WYGRANEGO
  ZDARZENIA A, na poziomie prawdopodobieństwa wygranej, TYLKO dla dopuszczonej
  klasy — zgodnie z regułą uczciwości; żadnego małego TV z założenia
  obliczeniowego, `route_a_closed` zostaje), a strona taśmy równej jest
  identycznie identyfikowana z sukcesem reduktora
  (`AdvMT(Reduction.build)` — przez nowy rozkład okien-tabeli
  `uniform_table_split` + `simulateStream_uniform` + gotowe
  `concrete_lazy_game_binding`). Nowy eksport niesie `deltaPRG` WŁAŚNIE PRZEZ
  HOP, nie doklejone `0 ≤ deltaPRG`; stary eksport zostaje abstrakcyjnym
  kształtem gry idealnej, `Assembly.lean` nietknięte.
- **Wzór odwróconego Phi (dokładny):** `f = max 0 (a − sqrt(D·a·(1−a)))` z
  `a = ε_real − deltaPRG − epsColl` i `D = (1 + (k^32−1))^beta.qs − 1` —
  hipoteza recenzji SPRAWDZONA i potwierdzona jako ostry odwrotnik
  (`phi_satisfies` daje równość na `a = phi D b`; brzeg `phiInv D (D/(1+D)) = 0`
  zgodny z istniejącym `phi D 0 = D/(1+D)`). Eksport bezpieczeństwa:
  `Adv_MT(Reduction.build) ≥ f(ε_real, D, deltaPRG, …)`. Uczciwie zapisane: ten
  sam łańcuch daje też mocniejsze `Adv_MT ≥ ε_real − deltaPRG` (bezpośredni
  hop) — forma Phi jest żądanym dokładnym odwróceniem KSZTAŁTU montażu i jako
  jedyna pokazuje czynnik certyfikatu `D`.
- **Co faktycznie wykazaliśmy (mocna część okna):** szew „statystyka vs
  obliczeniowość” jest teraz kwantyfikatorem, nie komentarzem; hop jest
  naprawdę wciągnięty w tezę (gra na LHS zmienia taśmę); odwrócenie Phi jest
  kernelowe i dokładne; porządek szerokości taśm domknięty w jednej definicji
  gry (whole-run + projekcje per-call, odczyt jeden-strumień).
- **Czego NIE rozstrzygnęliśmy (otwarte, wprost):** bezpieczeństwa ChaCha20
  (założenie); statystycznego odczytu `deltaPRG` (trasa (a) zamknięta
  twierdzeniem); granicy siewu A2, mostka bajtowego A3/A4, treści `keyIdent`
  (B1.10/source3). Dodatkowo zapisane: przesłanki montażu `huc/hshape/hattempt`
  należą do łańcucha gry idealnej starego eksportu — nowy łańcuch ich nie
  zużywa, więc NIE są dalej zakładane (brak nadmiarowych założeń).
- **Co ten wynik zmienia w projekcie:** ostatni szew B2/B5 jest domknięty —
  publiczny opis może teraz uczciwie mówić o realnej grze strumieniowej z
  warunkowym składnikiem obliczeniowym `deltaPRG` na dopuszczoną klasę testów
  (z linią kosztów), oraz o redukcji EUF-CMA→MT-ISIS w dokładnym wzorze
  `max 0 (a − sqrt(D·a·(1−a)))`.
- **Następny krok:** niezależny odbiór okna (recenzent zewnętrzny), potem
  koordynator importuje i commituje; równoległe tor B1/source3 niezależny.
  Przy odbiorze warto sprawdzić odnotowane lekcje §7 (dopasowanie `match`
  w matcherach zależnych, `bind_comm`-forma naturalna) — to najczęstsze
  pułapki przy kolejnych oknach.

Małe lokalne commity wykonane według promptu (`git commit --only` o własnych
plikach), **bez push** (czekam na sygnał właściciela).
