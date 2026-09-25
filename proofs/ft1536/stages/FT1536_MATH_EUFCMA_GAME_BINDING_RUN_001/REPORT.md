# INTERACTIVE_GAME_AND_RESOURCE_BINDING — raport wykonania

**Wynik: PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW.**
Wykonanie alternatywną ścieżką: RUN w `/home/footfalcon/Obrazy/
FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001` (jawna decyzja właściciela
2026-09-23, zamiast `REPO/proofs/ft1536/work/...` z §2 zlecenia). Repozytorium
całkowicie tylko-do-odczytu; nic nie zapisano w repo.

Wykonawca: MiMo V2.6 Pro (`xiaomi-token-plan-ams/mimo-v2.6-pro`), sesja
`ses_f30c85aabffeE0EajJzzGUNZc0`, świeży kontekst, 2026-09-23.
Autor projektu/zlecenia: Niirmata. Bez delegacji/subagentów, bez Git/push.

## 0. Weryfikacja wejścia

Zlecenie (`~/Pobrane/FT1536_EUFCMA_GAME_BINDING_zlecenie`): MANIFEST 4/4 OK.
Zamrożony poprzednik FT1536_MATH_EUFCMA_MTISIS_RUN_001: REPORT/OUTPUTS/
REPLAY_SEED/MODEL/NEXT_INTERFACE/BRIDGE_LEDGER — 6/6 pinów zgodnych,
4461/4461 członków OUTPUTS OK, archiwum `e4434fa5…afeff1` OK.
Kontrola integralności; **nie** jest to niezależny odbiór poprzednika
(`inputs/bootstrap/PREV_VERIFICATION.json`).

## 1. Co zostało osiągnięte (kernelowo, bez sorry/admit)

Nowe moduły (4 + generowany certyfikat), **201 eksportów** audytowanych
łącznie z odziedziczonymi (101+100), wszystkie z transitive axioms ⊆
{propext, Classical.choice, Quot.sound}, czyste logi (0 warningów):

| Moduł | Rzeczywisty zakres |
|---|---|
| GameByte | Bijekcja nonce↔40 bajtów (256^40 = 2^320 kernelowo), iniektywność renderowania nazw, brak kolizji short↔Sign, brak obcinania (`render_injective`, `pair_framing`, `long_names_distinct`) |
| GameNames | Bijekcja `NameKind ≃ Name` (`render_decodeName`/`decodeName_render`), adresacja tabeli pair-kompatybilna z `ROM.State` (`paint (tableAddr n) = n`, `tableAddr_sign/short`, `paint_injective_wf`) |
| GameMach | Jeden interpreter `step` dla EUF_real/EUF_stopped/SIM_targets, atomowość Sign, SeenSign na aborty (`step_sq_seen`), STOP absorbujący, dyscyplina celów (`used_le_of_step`, `signStep_used`), wzrost tabeli, świeżość werdyktu (`verdict_fresh`), budżet niezmieniający gry w granicach |
| PaidSteps | **Główny nowy lemat**: `second_self` (wspólny kernel = dokładnie 1) + `paid_counter_chi2`/`paid_counter_le` — drugi moment ≤ (1+e)^Q_s przez licznik płatnych przejść, niezależnie od liczby kroków maszyny; transfer `paid_event_bound`/`paid_trace_bound` do `min 1 (eps + Phi((1+e)^Q_s−1, b))`; `sign_frame_injective`+`sign_conflict_risk`+`conflict_bound_shape` = dokładne `eps_coll`; granica Q_s=0 |
| GameCertificate | Wartości dokładne z Sage sprawdzone kernelowo (norm_num) |

Sage (`sage check_games.sage`, preparser, ZZ/QQ, RBF256): małe dokładne
modele trzech interpreterów — kroki wspólne identyczne, licznik płatnych =
liczba Sign (4 kroki maszyny, 2 płatne, `(1+e)^2 = 25/16 < (1+e)^4`),
cached H bez zużycia celu, SeenSign na submit, STOP bez wygranej po
konflikcie, indeks/wartość finalnego wpisu, jednostajność i niezależność
niewykorzystanych celów (dokładna enumeracja), Q_s=0 ⇒ second = 1, suma
konfliktów zgodna z formułą; instancjacja realnych parametrów (2^320, B,
kontrprzykład centrowania zachowany). **Kontrole negatywne 8/8 reagują
na realną zmianę semantyki**, poprawny no-op przechodzi.

## 2. Doprecyzowanie: trzy typy wiążące ZAMKNIĘTE kernelowo

W toku wykonania właściciel zlecił domknięcie „tu i teraz" trzech typów
wiążących (rygor repo dla weryfikacji nieobowiązujący; dyscyplina matematyczna
zachowana). Zamknięte w modułach `Mixture`/`Lazy`/`GameLaw` (audyt łącznie
**234 eksportów**, 0 sorry, 0 warningów, axioms ⊆ standardowe):

1. `one_key_lift` — `Mixture.mixture_event_eq/le`, `mixture_good_bound`
   (jawny p_K, z p_K=0 jako literalną wartością), `latent_secret_event_muH`.
2. `lazy_sampling_refinement` — `Lazy.lazy_independence` (niewykorzystany cel
   jednostajny i niezależny od całego prefixu przeszłości),
   `seqTargets_eq_uniform` (refinement wejściowego wektora).
3. `game_kernel_identification` — jądra z logiki `step` (`second_map_inj`,
   `ac_map`, `sign_miss_reply_bound` = certyfikat na pełnej parze (c,o),
   `sign_hit_shared`, `advance_correct` — publiczny reply odtwarza stan),
   składanie `game_kernel_identification`/`conditional_shape`.

**Pozostało (dokładne typy w NEXT_INTERFACE)**: 0.
`adversary_fold_paid_flag_binding` — mechaniczny fold dla konkretnego A
przypinający flagę paid i licznik ≤Q_s do certyfikatu budżetu A (wszystkie
składniki kernelowe gotowe); 4. `reducer_bit_cost_bound` (Etap E,
`OPEN_TYPED_MACHINE_BINDING`); 5. sampler/małe e/bridge — poza zakresem cyklu.

Zatem `conditional_eufcma_theorem_proved=false` (domknięcie wymaga poz. 0
i bit-cost), `conditional_eufcma_theorem_kernelized=false`; wynik nie jest
`PROVED_CONDITIONAL_REDUCTION_FOR_FINITE_BOX_E0_MODEL`.

## 3. Wykonanie i kontrola

- Lean 4.34.0 (pin `e8baaa71…d5550`), Mathlib `5ed2965…2435`, SageMath 10.9
  (`sage check_games.sage`) — jak TOOLCHAIN poprzenika; tożsamości binariów
  potwierdzone.
- Konsumowane moduły poprzednika (15) przebudowane od zera w tym W,
  bajtowo zgodne z pinami (`INHERITED_SOURCES.sha256`); zamrożone oryginały
  nietknięte. Rozszerzenia w NOWYCH plikach.
- Świeży replay w nowym trwałym DEST (poza pakietem, poza repo):
  wynik w `replay/REPLAY_RESULT.json`; produkty semantyczne zadeklarowane
  PRZED replayem (`EXPECTED.json`) i zgodne. Kontrole sterownika:
  zły zewnętrzny pin, zmieniony człon, niepełny manifest, istniejący DEST,
  niedozwolona ścieżka — odrzucone; poprawny no-op — przechodzi.
- Limity: 1 job, `lean -j1 -M6144`, wall 1800s/krok, AS 12GiB, RSS ≤ 8GiB,
  `bwrap --unshare-net`; HOME/TMP/cache pod W. Brak sieci w jobach.
- Historia prób: `history/` (13 nieudanych/iteracyjnych kroków Lean,
  7 przebiegów Sage) + `FAILED_ROUTES.md`. Ukończone joby: brak.

## 4. Piny końcowe

- TASK_ID=`FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001` (W: `/home/footfalcon/
  Obrazy/…`, decyzja właściciela 2026-09-23 — alternatywna ścieżka wykonania).
- Poprzednik: REPORT `fa6bbac7…de9a`, OUTPUTS `a9e3af2e…c98f`,
  REPLAY_SEED `a5ff7f1a…4b707` (6/6 + 4461/4461 OK).
- REPLAY_SEED tego pakietu oraz finalny REPORT/OUTPUTS SHA-256: w
  `HANDOFF.md` i komunikacie końcowym (raport nie haszuje sam siebie).

## 5. Moja ocena (własna, po polsku)

**Co rzeczywiście udało się wykazać.** Etap A jest zamknięty kernelowo:
front-end bajtowy to prawdziwa bijekcja z nietrywialnymi lematami
o braku kolizji/obcinania, a trzy gry powstają z JEDNEGO interpretera, dzięki
czemu „wspólne kroki mają identyczny kernel" nie jest hasłem, tylko
definicyjnym faktem. Najcenniejszy nowy wynik to paid-step counter lemma:
drugi moment transkryptu zależy tylko od liczba wywołań Sign, nie od liczby
kroków maszyny — dokładnie luka wskazana w NEXT_INTERFACE poprzednika
(„n liczy wszystkie kroki maszyny"). Transfer Phi i dokładne eps_coll z
realnymi rozmiarami tabeli też są już liczbami, nie szkicem. Wynik negatywny
centrowania został zachowany, nie „naprawiony".

**Co nie wyszło / otwarte.** Po domknięciu trójki wiążącej (decyzja
właściciela: „tu i teraz") zostały dwa konkretne kawałki: mechaniczny
fold-binding dla konkretnego przeciwnika (`adversary_fold_paid_flag_binding` —
wszystkie składniki kernelowe już istnieją) oraz bit-cost reduktora (specyfikacja
bez maszyny bitowej). To wciąż nie jest pełna redukcja — stąd PARTIAL_PROOF.

**Co to zmienia w projekcie.** Zostało złożenie, nie teoria: gry, straty,
konflikty, ekstrakcja, jednorazowy klucz i leniwy sampler mają teraz wspólne
dowody kernelowe; wynik wciąż nazywamy PARTIAL_PROOF, bo brak domknięcia
foldu A i bit-costu.

**Następny krok.** `adversary_fold_paid_flag_binding` (krótki, mechaniczny),
potem bit-cost; niezależny odbiór pakietu osobnym modelem.
