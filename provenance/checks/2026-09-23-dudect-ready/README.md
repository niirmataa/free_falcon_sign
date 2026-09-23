# Dudect RUN_002 — gotowość na sygnał właściciela

2026-09-23. **PREFLIGHT_PASS,attempt006,CPU11,36000s (10h).**
Długi pomiar nie został uruchomiony. Właściciel potwierdził: dopiero na jego
znak przy odejściu od komputera; pozostałe prace wracają po kampanii/pracy.

PREPARATION SHA `2621ed0121f981c1149236de98a00261e3b55cb651f55fec7dfe7d6e9ccff74c`.
Profil floor-ct,source17 `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
Oficjalny dudect i progi bez zmian.33 sealed files zgodne; świeże buildy,
28672 fixture checks,truncated-record controls oraz6 krótkich kontroli PASS.

- Dodatnia kontrola:LEAKAGE_FOUND,zgodnie z oczekiwaniem.
- Ujemna kontrola i3 floor contrasts:NO_LEAKAGE_EVIDENCE_YET,
  około1.05 miliona próbek na klasę w każdym teście.
- Timebox:0.503s; wszystkie6 raw replays PASS.
- Całe przygotowanie:13.35s,exit0. Pełne logi/raw w NVMe attempts/006;
  wcześniejsze attempts zachowane.

Magazyn:ext4,UUID `da38b9e9-0e22-4c55-b3e0-c46b9f293eca`,
`/media/footfalcon/FT1536_DATA/ft1536-dudect/FT1536_FPEMU_DUDECT_RUN_002`.
Wolne235815215104 bajty,wymagane93751083008. AC online; aktywnych proof/build
jobów i usługi dudect nie stwierdzono. Stan środowiska trzeba sprawdzić przy starcie.

## Uruchomienie wyłącznie po sygnale

```sh
python3 -B tests/ft1536/dudect/launch.py /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002 --seconds 36000
```

Launcher akceptuje ten świeży PREFLIGHT_PASS. Ponownie sprawdza piny,
czystość repo,dysk i zasilanie. Gdy warunki zmieniły się przed startem,
potrzebne jest jawne nowe przygotowanie; nie retunuje się progów po wyniku.
Start/deadline podać z rzeczywistego RUN.json po uruchomieniu usługi.
W czasie kampanii bez równoległych proof/replay/build/estimator jobs.

Za zgodą właściciela zachowano zastany nano.42829.save w
`proofs/ft1536/work/OWNER_EDITOR_BACKUPS_2026-09-23/`,SHA
`07d39e89fc897aca048add195d8ed003d8b1e577335c6da0010058937a4f6f1c`.
Bajty i mtime identyczne; ORIGIN.json zapisuje pierwotną ścieżkę.
Pozwala to spełnić istniejący clean-Git gate bez pomijania go.
