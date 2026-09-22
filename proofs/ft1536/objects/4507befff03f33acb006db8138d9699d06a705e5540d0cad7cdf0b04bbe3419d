# INVALID_FOR_P2 / NOT_RUN — historyczna kopia runnera kampanii estymatora

Plik `INVALID_FOR_P2_run_campaign.sage` w tym katalogu jest **niezmienioną
bajtowo kopią** `run_campaign.sage` z nieodebranego snapshotu CANDIDATE_R2
(`FT_FAMILY_SCALING_2026-09-22_RUN_002`, pin SHA256SUMS
`5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16`,
linia `scripts/estimator_campaign/run_campaign.sage`).
`README_invalid_original.md` to jego oryginalny README, również bez zmian.

Etykiety (TASK S01 R4, decyzja zakresowa — bez uruchamiania estymatora):

- **INVALID_FOR_P2** — linie 58–67 oryginału wywołują `SIS.estimate`
  (homogeneous SIS) i oznaczają wynik jako komórkę P2. P2 w
  `ATTACK_PROBLEMS.md` to niejednorodne wyszukiwanie cosetowe „find any
  vector below B_N" nad celami z tabeli ROM (M0 §3), a nie generyczne SIS.
  To wada modelu, nie wynik pomiaru; żaden artefakt z tego runnera nie jest
  i nie będzie cytowany jako koszt P2.
- **NOT_RUN** — kopia nigdy nie została uruchomiona; `ESTIMATOR_COMMIT=None`
  oryginału i tak blokował wykonanie. Historycznego pliku się nie poprawia
  w miejscu (README §2 mówi wprost o ryzyku SIS-vs-ISIS — pozostaje częścią
  śladu audytowego).

Aktywnym wejściem interfejsu jest teraz `../estimator_campaign/run_campaign.sage`
(guarded): domyślny stan zapisuje jawny `NOT_RUN_MODEL_UNRESOLVED` **przed**
jakimkolwiek wywołaniem backendu; mapping/SHA/premises są wymagane, a routing
SIS→P2 jest odrzucany zanim backend zostanie zaimportowany. Testy
(`../test_r4_routing.py`) wykazują brak wywołania backendu w stanach
zablokowanych oraz wykrycie mutacji fałszywego SIS→P2.

Ta kopia jest materiałem historycznym (reuse z pinem — patrz REUSED_RESULTS.md);
nie jest nowym wynikiem tej pracy.
