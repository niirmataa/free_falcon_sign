# REPORT — FT1536_PRNG_LAYOUT_COUNTER_RUN_001 (ROADMAP T02.1)

Autor projektu: **Niirmata**. Falcon Project / Thomas Pornin attribution
i licencje zachowane. Data: 2026-09-22. Wykonawca: model wybrany i ręcznie
uruchomiony przez właściciela (przejęcie W po poprzedniku — patrz §8).
Source pin `56974571…a0985`, BASE `c90233c1`, TASK SHA `7b0007c0…89fe5f` —
piny zweryfikowane (preflight: 39/39 członków, 17 source, 5750423 B,
37 origins, brak symlinków/escapes).

## Rzeczywisty status

**PRNG_LAYOUT_COUNTER_PROVED_FOR_PINNED_SOURCE_MODEL.** Deterministyczny
kontrakt A+B+C dla pinned modelu (GCC14.2/C99/x86_64 LP64 LE): mapa init56
i dispatch typów (A), exact refill4096 z licznikiem 64-bit i ramką (B),
consumer budżetu T01 + q-refill corollary (C). Uniwersalny argument źródłowy:
SOURCE_MODEL_BINDING.md (struktura pętli, funkcje całkowite, wyczerpujący
switch); 7 fixtures × 3 stages to kontrole wiążące, nie kwantyfikator.
Bez nowej bramy, bez przesłanek o rozkładzie, bez referencji zdefiniowanej
outputem.

## A — init i layout: PROVED

Mapa LE 56 B (key 0..31, IV 32..47, counter 48..55), dispatch (0→1, 1→1,
reszta→0 przed zapisem/extractem), kolejność extract→type→refill→ptr→return,
ramka (init: state[0..55]; state[56..255] nigdy). Obie gałęzie FALCON_LE_U
zgodne na hoście LE (różni się 1 bajt tagu); przenośność BE analityczna.

## B — exact block/refill i counter: PROVED

64 bloki/refill z licznikami cc0+k mod 2^64; post counter +64 mod 2^64;
pierwsze 48 B zachowane; ptr=0. XOR lanes 14/15 = offsets 40..47 (OSTATNIE
8 B IV) — komentarz frng.c:198 rozbieżny (finding, C nietknięte). KAT 5/5
(rdzeń, OpenSSL + RFC 8439 §2.3.2 + all-zero). Mutacje: 6 meaningful KILLED
(z klasami low-counter) + 2 NO_OP czyste. Wrap ≠ repeat; cross-context reuse
jawny; deterministyczny ident-init56 → ident-buf.

## C — consumer zasobów: PROVED

r_max = 396; ≤25408 bloków/kontekst; 406528/region na H; ≤896 B SHAKE
(+40 nonce poza cutem); spójne z ghost budget T01 exact ZZ. Pr(H^c) zostaje
w T01; q-refill corollary z odebranych reguł getterów (exhaustive 0..20000).

## Formalizacja i kontrole

Lean nieużyty (opcjonalny wg TASK §6). Rachunek: `model/*.sage` przez
`sage file.sage` (10.9, preparser, ZZ/exact ints, zero float). Harness
oryginalnego C: 3 buildy (normal -O, ASan+UBSan, altbranch FALCON_LE_U=0),
czyste stderr, canaries/poison/stub/unsupported/determinizm kontrole.
Kontrole: 7 fixtures × 3 stages × 3 buildy (63 stage-kontrole C) +
405 checks Sage (105 pól stage) + 8 mutacji + KAT 5/5.

## Znaczenie i następny krok

Pierwszy domknięty deterministyczny kontrakt PRNG dla pinned modelu:
layout, koszty blokowe (64/refill, 25408/kontekst, 406528/region) i fakty
licznikowe dla przyszłej gry T02. Następny krok: niezależny odbiór
(review + replay) przez inny model; potem właściwy hop real→IID (T02 OPEN).
T02 pozostaje OPEN; statusy T01/T05/T06 bez zmian.

## Flagi/statusy

`real_prng_to_iid_bridge_proved=false`, `SHAKE/ChaCha_security_proved=false`,
`whole_real_Sign_proved=false`, `source_changed=false`,
`production_source_changed=false`, `owner_accepted=false`, `T02_parent_open=true`.
Własne obliczenia zakończone; brak aktywnych jobów. Nie uruchamiano Astry/T01,
T03, S01, dudect, relay ani publikacji.
