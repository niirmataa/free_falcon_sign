# FLOOR_CT — kampania10h, start rano przed wyjściem właściciela do pracy

Aktualny plan właściciela2026-09-22: **rano przed wyjściem do pracy**,
**36000s (10h)** kampanii, po zakończeniu Astry/kompilacji/replayów.
Start po jego sygnale, bez timera. Ten plan zastępuje wcześniejsze03:00.
Profil floor-ct, manifest56974571…, pełne12 kontrastów×3 rundy plus controls.
Wcześniejsze przygotowania6h/8h pozostają w attempts/ jako historia.
Aktualny PREPARATION.json musi wskazywać global_seconds36000 i
STATIC_READY_TIMING_DEFERRED przed uruchomieniem poniższego launchera.

**Warunek miejsca został domknięty przez magazyn NVMe.** W jest obecnie
dowiązaniem do `/media/footfalcon/FT1536_DATA/ft1536-dudect/FT1536_FPEMU_DUDECT_RUN_002`.
Partycja ext4 FT1536_DATA: UUID `da38b9e9-0e22-4c55-b3e0-c46b9f293eca`.
Po przeniesieniu około219.6GiB wolnego; wymagane93751083008 bajtów
(87.3125GiB). Pełne compressed raw i stdout mają dotychczasowy limit2MiB/s.
Launcher rozwiązuje W do fizycznej ścieżki i ponownie sprawdza miejsce przed
fizycznym preflightem. Instrukcja ponownego montowania po restarcie jest w
`/home/footfalcon/free_falcon_sign/provenance/FT1536_DATA_STORAGE.md`.

Uruchomienie po zakończeniu Astry/kompilacji/replayów, z zasilaniem AC:

```sh
python3 -B /home/footfalcon/free_falcon_sign/tests/ft1536/dudect/launch.py /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002 --seconds 36000
```

Launcher sprawdza piny/commit i miejsce, następnie wykonuje bounded fresh
build/preflight, wybiera aktualny non-SMT CPU i weryfikuje controls. Dopiero
potem startuje usługę z10h limitem oraz sleep/idle inhibitorem. Preflight jest
osobny, przed dziesięciogodzinną kampanią (do180s plus5s kill grace).
Zakończenie do10h od rzeczywistego startu kampanii po preflighcie;
deadline odczytujemy z RUN.json po starcie. Błąd preflight
pozostawia logi i PREFLIGHT_FAILURE, a długi run nie startuje.

Stan / zatrzymanie:

```sh
systemctl --user status ft1536-dudect-run-002.service
systemctl --user stop ft1536-dudect-run-002.service
```

RUN.json śledzi całość, ACTIVE.json wskazuje próbę/status zakończenia,
campaign/*/status.json aktualizuje partie. REPORT.md/RESULT.json powstają
po zakończeniu. Wszystkie logs/raw są zachowywane. To odrębny run od001.
Brak sygnału nie jest proof CT; wyniki wymagają kontroli hosta i powtórzeń.
