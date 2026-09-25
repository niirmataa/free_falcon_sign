# CENTERING_CLOSURE — kernelowe domkniecie boundu delta i pelny lemat 2 (Rejection)

Status: **PARTIAL_PROOF**. Material autora: MiMo V2.6 Pro, W
`FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/CENTERING_CLOSURE` (kopia kanoniczna
w repo: `work/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001_OBRAZY/`). Freeze
opakowany przez koordynatora 2026-09-25 na polecenie wlasciciela
(integracja pakietu /Obrazy do rygoru repo). Niezalezny odbior: BRAK
(`independently_reviewed=false`, `owner_accepted=false`).

## Co wykazano kernelowo (czyste logi, bez sorry/admit/native_decide)

1. **Pelny lemat 2 BEZ premises** — `full_rejection_bound_no_premises :
   Rejection (fun _ => ()) () <= 1/2^24` (`formal/ThetaAssembly.lean`,
   `RejectionBound.lean`). Audyt `#print axioms` (`logs/ta1_audit.log`):
   wylacznie [propext, Classical.choice, Quot.sound].
2. **Kanapka theta, Fazy A-D zamkniete** — `ThetaPoisson` -> `Theta2Split`
   -> `ThetaBox` -> `ThetaFinal` -> `ThetaAssembly`: `theta2_lower`,
   `theta2_upper`, `blockSum_eq_boxSum`, `boxSum_le_theta2`,
   `tail_le_pow300 <= 2^-300`, zlozone `thetaBounds`.
3. **Certyfikat wymiarowy hnum kernelowo** (nie tylko Sage/Arb):
   `hnum_rational` (norm_num na Rrat^1536), `exp_neg_239_le`,
   `exp_neg_f_le`, `exp_neg_lamB_le`, `tau_budget` (tau = (1+a)^1536-1 < 2^-40).
4. **Warunkowe domkniecie dla wszystkich kluczy** —
   `all_keys_bridge_closure` / `all_keys_headline`: dla kazdego klucza
   z `Adm`: `1265/10^27 < delta(h) < 127/10^26`, z dokladnie dwiema
   mianowanymi przeslankami i jedna abstrakcja (nizej).

## Jawne przeslanki i abstrakcje (NIE mylic z pelnym zamknieciem)

- **`hraw`** — liczbowe spiecie `rawLo <= rawBad <= rawHi` (produkt
  radialny RUN_002 + poprawki: aliases, input_tail, multiple_changes,
  norm_reject, signed16_emit, theta — dokladne interwaly w
  `centering_interval_closure.PINNED.json`). Kernelowe wiazanie
  produktow/ogonow do sum zdarzen to OTWARTY punkt M6 po stronie RUN_002.
- **`hbridge`** — analityczny transport mostka dla kazdego dopuszczonego
  klucza (T5 dual theta + porownanie mas cosetow Poissona dajace
  FiniteFlat + transport MGF normy/wspolrzednych + cap16 po Emit).
- **`Adm`** — abstrakcyjny predykat "klucz z powodzeniem emitowany przez
  istniejacy KeyGen"; wiazanie do realnego C-KeyGen poza zakresem.
- Poza zakresem: `fiber_transport`/bridge do C, bezpieczenstwo kodu, PRNG,
  `complete_new_kernel_source_binding=false` (PINNED.json).

## Sprostowanie do HANDOFF w korzeniu W

Starszy `HANDOFF.md` w korzeniu W zapowiadał Faze D jako otwarta
(`theta2_upper` + `ThetaAssembly` "ZOSTAJE"). Stan faktyczny materialu:
**Faza D ZAMKNIETA** — `ThetaAssembly.lean` istnieje, `thetaBounds` i
`full_rejection_bound_no_premises` dowiedzione, `logs/ta1_audit.log`
czysty. Powyzszy opis jest autorytatywny dla tego freeze.

## Reprodukcja liczby

`sage sage/check_closure.sage`, `sage sage/close_radial_interval.sage`
(exact ZZ/QQ + Arb), niezaleznia reprodukcja `sage repro/arb_radial.sage`
(2^25) na `repro/radial_engine.pyx/.c` (build: `repro/engine_build_receipt.json`;
binarium `.so` wykluczone z freeze jako binarium robocze, odtwarzalne).
Wynik zgodny z `repro/arb_radial_result.json` (sha
`cac1c4f2c178bd8b8f21d775ba5ef5431f2f03b4a9eff20751d1116b3fb8b78a` = pin
`input_sha256` w PINNED.json) oraz z rekordem RUN_002
`run/arb_radial_full_001/arb_radial_result.json`.

## Wejscia zewnetrzne (INPUTS.sha256)

Piec modulow Lean z rebuilt closure (`library/FT1536/` w OUTPUTS,
oryginaly: `run/replays/replay_005/formal/FT1536/`; hash-identyczne
z `replay_001`) + rekord liczbowy RUN_002. Toolchain piny:
Lean 4.34.0, Mathlib `5ed2965256430c3649e86755f9576b54eca72435`,
SageMath 10.9 (preparser).

## Logi

Wszystkie logi autora w `logs/` (209 plikow, lacznie z probami/iteracjami
skladni) zachowane w freeze; streszczenie lekcji skladni w
`WORK_STATE.md` W autora (poza OUTPUTS, historia w W).
