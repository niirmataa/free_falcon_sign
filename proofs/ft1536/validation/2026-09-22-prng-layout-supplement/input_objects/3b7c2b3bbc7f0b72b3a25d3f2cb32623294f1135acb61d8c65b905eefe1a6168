# REPORT — FT1536_PRNG_LAYOUT_COUNTER_RUN_003 (ROADMAP T02.1, suplement F1–F5)

Autor projektu: **Niirmata**. Falcon Project / Thomas Pornin attribution
i licencje zachowane. Data: 2026-09-22. Wykonawca: model wybrany i ręcznie
uruchomiony przez właściciela. Suplement sprostowawczy do niezależnego odbioru
RUN_002 (werdykt CHANGES_REQUIRED, wyłącznie F1–F5 zakres/dokumentacja;
matematyka bez zmian): poprawki scope.open kernela (F1), słowa „frame" (F2),
liczb plików i receiptu w REPLAY (F3), kluczy `*_max` (F4) oraz `task_id` (F5).
Poprzednicy frozen i nietknięci: RUN_001 (OUTPUTS `34c49d61…`), RUN_002
(OUTPUTS `8eda4cb9…`).
Source pin `56974571…a0985`, BASE `c90233c1`, TASK SHA `7b0007c0…89fe5f` —
piny zweryfikowane (preflight: 39/39 członków, 17 source, 5750423 B,
37 origins, brak symlinków/escapes).

## Rzeczywisty status

**PRNG_LAYOUT_COUNTER_PROVED_FOR_PINNED_SOURCE_MODEL** — z granicą kernelową:
licznik/layout/zasoby/q-refill w `formal/CounterLayout.lean` (Lean 4.34,
core-only, 28 twierdzeń, czyste logi, aksjomaty [propext, Quot.sound]);
rundy ChaCha Word32 w modelu Sage exact + wiązaniu C (jawna nie-kernelizowana
granica, patrz SOURCE_MODEL_BINDING.md). Bez nowej bramy, bez przesłanek
o rozkładzie.

## A/B/C — jak w RUN_001, plus kernel

- **A.** Mapa init56/dispatch/ramka: kernel (`typeOut`, offsets; arytmetyka ramki) +
  wiązanie C. **B.** Refill/counter: kernel (`blockCounter`, brak powtórzeń,
  post counter, wrap vs repeat, instancje F4/F5) + exact Sage + C.
  Komentarz frng.c:198 rozbieżny (finding). KAT 5/5, mutacje 6+2.
  **C.** Consumer: kernel (`r_max` 396, 25408, 406528, 896, 936) + Sage ZZ.

## Formalizacja

Lean 4.34.0, `formal/CounterLayout.lean` — 28 named theorems, czyste
stdout/stderr, bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu
celu/supresji; aksjomaty tylko [propext, Quot.sound] (równoważność wrapu
rozbita na dwie implikacje, by nie ciągnąć Classical.choice).
Sage: `sage model/*.sage` (10.9, exact/ZZ); C: 3 buildy z czystymi stderr.

## Kontrole i replay

7 fixtures × 3 stages × 3 buildy + 405 checks Sage (105 pól) + 8 mutacji +
KAT 5/5 + 28 lematów Lean. Standard `replay.py` (17 plików semantycznych:
15 z RUN_001 + `formal/CounterLayout.lean` + `logs/lean_counter_layout.stdout`).

## Flagi/statusy

`real_prng_to_iid_bridge_proved=false`, `SHAKE/ChaCha_security_proved=false`,
`whole_real_Sign_proved=false`, `source_changed=false`,
`production_source_changed=false`, `owner_accepted=false`, `T02_parent_open=true`.
T02 pozostaje OPEN. Własne obliczenia zakończone; brak aktywnych jobów.
Nie uruchamiano Astry/T01, T03, S01, dudect, relay ani publikacji.
