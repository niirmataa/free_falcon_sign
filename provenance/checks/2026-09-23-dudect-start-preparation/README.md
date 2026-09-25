# 2026-09-23 — weryfikacja startu dudect RUN_002

Material zrodlowy: `work/DUDECT_START_PREPARATION_2026-09-23/` (przeniesiony
do archiwum 2026-09-25 przez koordynatora, za zgoda wlasciciela).

- `LAUNCH_VERIFIED.json` — weryfikacja uslugi po starcie 07:53:08 CEST
  (MainPID 288543, RuntimeMaxUSec=10h, inhibitor sleep:idle, budget 36000s,
  cpu 11, harness_git_commit 20aeb28).
- `preflight.stdout` / `preflight.stderr` — surowe logi preflightu (exit 0).
- `PREFLIGHT_RECEIPT.json` NIE jest tu powielony — identyczny bajt-w-bajt
  (sha `423d0d049b350a95c0bd5d321c3e1fafa700ed4193678a4e1cbfe433e3eccdc9`)
  jest juz zacommitowany w `provenance/checks/2026-09-23-dudect-ready/`.
- Wejscie kampanii (argv, RUN, COMPLETION) w `provenance/checks/2026-09-23-dudect-completed/`.
