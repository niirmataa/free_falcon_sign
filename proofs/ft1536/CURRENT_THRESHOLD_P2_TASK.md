# THRESHOLD P2 — progowy podpis FT1536

**TASK_ID=FT1536_THRESHOLD_P2_001** · **ROADMAP_ID=S09**
**Status2026-10-26:** **G0 IN_PROGRESS — plan i spec v0 gotowe, czekają
decyzje właściciela.** To NIE jest produkcja, NIE jest deklaracja
bezpieczeństwa, NIE jest „threshold FT gotowy”.

## Cel

Progowy podpis FT1536 **k-z-n** w modelu złośliwym, w którym klucz nigdy
nie istnieje w całości — od setupu do podpisu — a wynik jest **bajtowo
zgodny** z `ft1536-sys` (pk 2881 B, sk 7681–10369 B, nonce 40 B,
q=18433, N=1536, pierścień `X^1536−X^768+1`, secret ternarny).

## Wejście

- Spike: [`development/THRESHOLD_SPIKE_001/`](development/THRESHOLD_SPIKE_001/)
  (414/414) — spec zachowania, oracle, testkit, retained failures.
- Lane: [`development/THRESHOLD_P2_001/`](development/THRESHOLD_P2_001/)
  — README, PLAN, SPEC v0, THREAT_MODEL, DECISIONS, CLAIMS_REGISTER,
  GATES, WORK_PACKAGES, RISKS, SOURCE_MAP.

## Zakres v1 (proponowany)

- **2-of-3** (D-003), wariant **A** — udziały pułapki `(f,g,F,G)` (D-021).
- Setup: Pedersen VSS, complaints, transkrypt, `pk` bez reconstruct.
- Podpis: nonce commit/reveal, HTP, ffSampling na udziałach, check normy,
  `s2`, encoding 0xAA, engine verify.
- Model: malicious static ≤ k−1, rushing, synchroniczne rundy, abort.
- G2 = signing plumbing na `TEST-ORACLE`; G3 = bezdealerowy ważny setup
  NTRU + realny Klein/ffSampling (D-022).
- Poza v1: P1 seed-custody, FTKEY, `[N]`, FT768/FT3072, QROM, FIPS.

## Decyzje do potwierdzenia przed G1

| ID | Pytanie | Domyślnie |
|---|---|---|
| D-003 | 2-of-3 czy 3-of-5? | 2-of-3 |
| D-010 | TLS 1.3/mTLS czy Noise? | TLS 1.3/mTLS |
| D-011 | CBOR czy inny format? | kanoniczne CBOR |
| D-013 | HSM od G2 czy G3? | od G3 |
| D-016 | produkcja w `[N]` na G3? | tak |
| D-021 | wariant A czy B? | A (udziały pułapki) |

D-022 (G2 = `TEST-ORACLE`, G3 = realna krypto) wymaga potwierdzenia przed
WP-030.

## Czego ten TASK nie robi

- nie uruchamia drugiego workera ani relayu,
- nie startuje modeli bez polecenia właściciela,
- nie publikuje na GitHub bez jawnego „push”,
- nie ogłasza G2 jako produkcji ani „bez dealera”,
- nie zastępuje toru T12.1 (baza FT1536) ani T03/S01.

## Najbliższy krok

1. Właściciel potwierdza D-003/010/011/013/016/021 (i D-022).
2. Wpis S09 w [`ROADMAP.md`](../../docs/onboarding/ROADMAP.md) i wpis
   w [`STATE.md`](../../docs/onboarding/STATE.md) — w toku.
3. WP-010/011: workspace + hermetyczne CI.
4. WP-012: port prymitywów z KAT (bez `unsafe`, bez dealera).
5. WP-013: ukryte δ (#9) jako pierwszy izolowany fix.

## Reguły

- Małe commity, dokładne pathspecy, jeden writer Git, bez amend/force-push.
- Push wyłącznie po słowie właściciela.
- Autor ≠ recenzent; każdy milestone ma niezależny odbiór.
- Sekrety nie trafiają do repo/logów; dane syntetyczne.
- Retained failures zachowane; korekta = nowy wpis.
- Kod kryptograficzny pisze okno główne, nie subagent (D-020).

## Wskaźniki

- [README lane](development/THRESHOLD_P2_001/README.md)
- [PLAN](development/THRESHOLD_P2_001/PLAN.md)
- [SPEC v0](development/THRESHOLD_P2_001/SPEC.md)
- [DECISIONS](development/THRESHOLD_P2_001/DECISIONS.md)
- [GATES](development/THRESHOLD_P2_001/GATES.md)
- [WORK_PACKAGES](development/THRESHOLD_P2_001/WORK_PACKAGES.md)
- [CLAIMS](development/THRESHOLD_P2_001/CLAIMS_REGISTER.md)
- [THREAT MODEL](development/THRESHOLD_P2_001/THREAT_MODEL.md)
- [RISKS](development/THRESHOLD_P2_001/RISKS.md)
- [SOURCE_MAP](development/THRESHOLD_P2_001/SOURCE_MAP.md)
