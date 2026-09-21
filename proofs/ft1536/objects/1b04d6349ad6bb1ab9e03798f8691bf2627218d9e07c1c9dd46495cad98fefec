# Niezależny odbiór SOURCE_POSTPROCESSING_AND_PRECAST — 2026-09-21

Autor projektu: Niirmata. **PARTIAL_PROOF**, z odebranym subclaim
**H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL**. Rodzic:
`f142a11832cb42ab2600eacb58b2009569c29e4a`.

| Artefakt | SHA-256 |
|---|---|
| REPORT.md | `4cd7ab1a6f63256ed6c015f3ba9bbef97597d7a68bb948bfd8c9264bab307662` |
| OUTPUTS.sha256 | `b860e5453a7a72716acd8636cc581ff57b1b9c00dff20baa907e4636344d1401` |
| SOURCE_POSTPROCESSING_CERTIFICATE.json | `157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef` |
| Candidate17-file manifest | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| VALIDATION.sha256 | `e7f83ba3554aaf85c098911bae6619f8b5e064e835955f2204975bec00bbb194` |

## Import i świeży replay

Pierwszy import zatrzymał się przed utworzeniem checkpointu: runner archiwum
oczekiwał artifacts/fresh_replay.json, a pakiet przypinał
artifacts/rehearsal/REPLAY_RESULT.json z records expected/actual/match.
Dodano jawną opcję `--replay-receipt` oraz kontrolę tego formatu, bez zmiany
pakietu.11 testów narzędzia i integralność22 wcześniejszych checkpointów PASS.
Adapter zachowuje wymóg sealed receipt, zgodności każdego hasha i exact bytes;
nie zastępuje ich samym napisem PASS.

Import3141 OUTPUTS/901 INPUTS,66678617 bajtów, PASS. Standardowy niezależny
replay z bwrap/network-off, ukrytymi Dokumenty/H i świeżym cache/buildem:
**616/616 matches,239.647s,exit0**, bez timeoutu lub seed omissions.

```sh
python3 -B proofs/ft1536/tools/archive.py import /ABSOLUTE/FROZEN_PACKAGE \
  --manifest-sha b860e5453a7a72716acd8636cc581ff57b1b9c00dff20baa907e4636344d1401 \
  --report-sha 4cd7ab1a6f63256ed6c015f3ba9bbef97597d7a68bb948bfd8c9264bab307662 \
  --replay standard --replay-receipt artifacts/rehearsal/REPLAY_RESULT.json
python3 -B proofs/ft1536/tools/archive.py replay \
  FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001 \
  --run NOWY_ID --timeout 1800 --hide-originals
```

Zachowano960 plików/29751158 bajtów w VALIDATION: pełne znaczeniowe wyniki,
25 nowych driver/executor streams,102 kernel receipts/streams, oba buildy,
po59 native cases, toolchain, COMMANDS z rozliczonym frozen prefixem.
102 moduły/795 twierdzeń,32 nowe,96 inherited; final logs/types/terms/axioms
czyste. Normal i ASan/UBSan dają identyczne outputs,32224 rint words i pełne
pokrycie65536 int16 values w codec/codec_brief vectors.13 meaningful mutations
i noop,4 preflight domain stops oraz10 direct inverse vectors zachowane.

## Co domknięto

Po ACTUAL completed sampling return w legalnym emitted/same-STATIC/canonical/
normalized/context domain: whole-root residual/basis bounds, literal suffix,
source iFFT error<=1/128, actual rint nearest-even/refinement i |w|<=4572095.
Narrowing jest dokładną mapą GCC `(w+32768) mod65536-32768` na mathematical Int.
Norma dotyczy STORED int16 arrays. STATIC byte-value/decoder/footprints i
M0 capacity<=3160 po source norm acceptance są źródłowo związane.
Deterministyczny suffix ma własne zakończenie; sampling completion jest premise.

Mixed kernel/universal analytical source proof: real metric/iFFT induction,
pełna symulacja byte loops i C/compiler binding nie są całkowicie kernelized.
Piny source/evidence, whole-root energy10436770873344, iFFT stage coverage,
rounding cap i true/false flags zostały dodatkowo sprawdzone przy odbiorze.

## Co pozostaje otwarte

**Safe16 pozostaje OPEN_NOT_DISPROVED.** Bound4572095 nie zapewnia int16 range.
Local fixture65536→0 ma determinant0 i nie spełnia required P_key/Emitted/
sampler-history domain. Jest countermodel do nieuprawnionej implikacji
„stored norm acceptance daje Safe16”, nie wykazanym source-domain błędem C.

Joint BadPrecast jest zdefiniowany, bez probability bound lub independence.
Reference integer recovery, Sign→Verify, source sampler law, whole Sign
termination/security/CT pozostają false/open. [FAILED_ROUTES](FAILED_ROUTES.md)
zachowuje luźne bounds, nieudane Lean drafts i wrapping problem pierwszego
interval oracle; poprawiono jego metodę faz, nie produkcyjne C.

## Znaczenie i następny krok

Mamy dokładny model drogi od ukończonego próbkowania do przechowanych
współczynników i bajtów. Pozwala on badać source BadPrecast bez ukrytego
założenia exact casts. [NEXT_INTERFACE](NEXT_INTERFACE.md) wskazuje
SOURCE_SAMPLER_LAW/H6P: actual joint law, joint event/retry bounds oraz osobny
reference-integer/sign-correctness bridge. To wynik częściowy z konkretnym
operacyjnym postępem, bez nowego epsilon lub zmiany programu.

Odbiór nie zmienia historycznych source_changed/owner_accepted flags.
Integracja wcześniej odebranego FLOOR_CT jest osobnym krokiem na main.
