# OUTPUT_SCOPE.md — zakres sealed outputs tego pakietu

`OUTPUTS.sha256` uszczelnia **wszystkie pliki regularne tego katalogu**
(katalogu pakietu = trwałego W `proofs/ft1536/work/FT_FAMILY_SCALING_
CORRECTIONS_RUN_003`) z wyjątkami:

1. samego `OUTPUTS.sha256`;
2. `inputs/**` — bootstrap jest materiałem wejściowym (RO); jego pin to
   `inputs/bootstrap/MANIFEST.sha256` (`6294e782…`), a kompletna lista wejść
   z hashami jest w `INPUTS.sha256`;
3. `home/**`, `tmp/**`, `.build/**` — roboczy cache/toolchain build (olean),
   zgodnie z zasadą „cache/olean/binaria nie są outputami";
4. `postfreeze/**` — jawny katalog dopisków PO freeze (receipt freeze z
   hashami REPORT/OUTPUTS dla prowadzącego); nigdy nie wchodzi do manifestu.

Wszystko pozostałe (dokumenty, skrypty `.sage`/`.py`, `lean/`, `paper/`
z PDF, `results/`, `proof/` w tym checkers/receipts/diffs/drafts,
`supplements/`, `artifacts/fresh_replay.json`) wchodzi do manifestu.

Znaczenie:

- **To jest gotowość autora do niezależnego odbioru** (`COMPLETE_FOR_REVIEW`),
  nie oświadczenie o bezpieczeństwie, nie owner acceptance, nie gotowość
  FT768/FT3072. Statusy z `CLAIMS.md/.json` są rozstrzygające.
- Wejścia i źródła (`inputs/`, `Extra/c`) są niezmienione
  (`source_changed=false`, `production_source_changed=false`).
- Estymator nie był uruchamiany (`estimator_campaign_executed_in_this_task=false`);
  wszystkie komórki kosztów = `NOT_RUN`.
- Zewnętrzny pin `sha256sum(OUTPUTS.sha256)` podaje prowadzący poza pakietem
  przy odbiorze (standard: `scripts/replay.py ABSENT_DEST
  EXTERNAL_OUTPUTS_SHA256`); hash samego manifestu nie może być zakotwiczony
  w jego wnętrzu (brak cyklu hashy).
- Wymagana zasada rachunku SageMath: kopia w `supplements/` wchodzi w sealed
  outputs (wymóg TASK).
- Historyczne ścieżki/etykiety są proweniencją; zamrożonych pakietów nie
  przepisujemy.
