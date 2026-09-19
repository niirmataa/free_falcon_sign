# Odbiór M0 — 2026-09-19

**M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE; świeży replay PASS.**
Status oznacza zdefiniowany kontrakt i ograniczone nowe dowody pomocnicze,
zgodnie ze zleceniem; nie zamknięcie całej redukcji bezpieczeństwa.

## Piny i wykonanie

- REPORT: `b71d71e8d89022ea321241d0ddabdddf4a3b81bfc9fe4faca08476baf6e71c29`.
- OUTPUTS: `08c9b6afe630e11bd98f33a910476950442854e5925efaa7f8fa1d0d8c8d695d`.
- Import zweryfikował **1325 członków OUTPUTS i 97 wejść**.
- Rodzic Git podczas odtworzenia: `dde8e7c79b8ada275102f71654fd92e62b87cae9`.
  Odtwarzano zaimportowane przypięte pliki, przed commitem etapu, w izolowanym
  worktree main; nie deklaruje się czystości innych roboczych plików worktree.

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_M0_CONTRACT_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Wynik: **FRESH_REPLAY_PASS, 273/273 pliki identyczne**, exit 0, bez timeoutu,
180.173 s, pusty stderr kontrolera. Oryginalne Dokumenty/H ukryto pustymi
tmpfs; root był read-only, zapis tylko w świeżym seed, sieć odłączona.
Nie przeniesiono wcześniejszych olean, binariów lub cache.

## Sprawdzony zakres

- **67 modułów, 535 twierdzeń, 43 nowe**; czyste końcowe logi Lean i standardowe
  aksjomaty propext/Classical.choice/Quot.sound. 61 odziedziczonych modułów
  jest bajtowo identycznych z konsumowaną zależnością L_V/Norm64.
- `CAPACITY_3160` i `STATIC_FITS_4096` przejrzano jako uniwersalne twierdzenia
  o Q i source-bound modelu licznika kodera. Powiązanie z C dotyczy długości
  i guards; nie jest nowym uniwersalnym dowodem wszystkich wartości bajtów.
- C/Sage i normal/ASan/UBSan potwierdzają Q=2093088768, payload=3156,
  failure dla 2049/3073, sukces 4096, round-trip, canaries i nietknięty suffix.
- Trzy natywne zmiany kodera/framingu wykryte; no-op PASS. Osiem kontroli
  zmienionego kontraktu wykrytych; są kontrolami spójności definicji.
- GAME, RESOURCE_MODEL, TARGET_TYPE i ledger sprawdzono pod kątem jednego
  K_seed[E], obserwowalnych abortów, nonce40, pełnej domeny przeciwnika,
  właściwego kierunku chi-square i jawnych przyszłych przesłanek M1–M6.
  M7 jest wnioskiem docelowym, nie założeniem wejściowego rekordu.
- Dokładne C/Lean/Sage wyniki są ponownie wykonywane. Kopiowane dokumenty
  specyfikacji są definicjami; ich zgodność hashy nie jest dowodem EUF-CMA.

`VALIDATION.sha256` przypina 13 plików receipts, strumieni, nowych audytów
i kontroli. Strumienie wskazane w receipts kernelowych i natywnych zostały
sprawdzone względem hashy. ASan ma osobną rezerwację shadow, zwykłe joby
limit 8 GiB. Przypięty runner ustawia detect_leaks=0; nie jest to kontrola LSan.

`security_reduction_proved=false`, `source_integrated=false`,
`protocol_wrapper_integrated=false`, `owner_accepted=false` są zgodne
z celem M0. Kolejny wąski obowiązek: H3 opisany w H3_INTERFACE.md.
