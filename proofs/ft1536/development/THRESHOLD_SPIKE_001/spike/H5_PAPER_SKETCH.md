# H5 — szkic: MPC-wyprowadzanie klucza z udziałów seeda

**Status: szkic toru (nie publikacja).** Tytuł roboczy:
„MPC-wyprowadzanie klucza z udziałów seeda — kernelowo udokumentowane”.

## Teza

Klucz może być **urodzony z udziałów** (share-native KDF/G przez mnożenia
Beavera/`mul_shamir_reshare`), bez kroku „złóż seed → policz → podziel".
Właściciel wskazuje mapę `G(seed*)` z toru R1 jako instrukcję przebudowy
(`R5_R1_INTERFACE_NOTES.md`) — **unikat** (nikt jej nie ma).

## Dowody ze spiku (na dziś)

| Własność | Dowód |
|---|---|
| Wyprowadzanie na udziałach bez reconstruct seeda | `derive_g_frag_shares`, `derive_key_material_native` |
| Weryfikacja udziału bez interpolacji (Pedersen) | `verify_exp_share` |
| Procesy: brak pełnego materiału | `iso ped-demo`, `iso dkg` |
| Próba reconstruct = FAIL | `h3_reconstruct_attempt_panics` |

## Granice (obowiązkowe w paperze)

- Trusted dealer w obecnym keygenie = „moment" (H4 to krok, nie pełne
  usunięcie dealera w FT1536 keygenie)
- SHAKE/KDF w MPC ~10^8 bramek — koszt do oszacowania (H5 full)
- Wariant A (pułapka + MPC-sampler) — rezerwa; NTRU trapdoor w MPC = badania
- Nie jest to bezpieczeństwo progu ani standard Falcon

## Następne

1. Osadzić `G(seed*)` z R1 w formie share-native (pytania do R1 — R5).
2. Pomiar bramek/rund dla SHAKE-kroku vs liniowych kroków `G_frag`.
3. Paper z eksperymentami 129+ testów spiku jako baseline.
