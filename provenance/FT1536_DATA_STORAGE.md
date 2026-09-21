# FT1536 — magazyn danych dudect na NVMe

2026-09-22 właściciel wskazał i potwierdził sformatowanie dokładnie
`/dev/nvme0n1p3` (poprzednio NTFS/Windows-SSD) jako ext4 do danych FT1536.

| Pole | Wartość |
|---|---|
| Dysk | Samsung MZVLB256HBHQ-000L7, NVMe256GB |
| Partycja | `/dev/nvme0n1p3`,253672554496 bajtów |
| System plików / etykieta | ext4 / `FT1536_DATA` |
| UUID | `da38b9e9-0e22-4c55-b3e0-c46b9f293eca` |
| Punkt montowania | `/media/footfalcon/FT1536_DATA` |

Format przez UDisks potwierdzono odczytem ext4/label/nowego UUID; metadane
pozostałych partycji NVMe pozostały zgodne z odczytem sprzed operacji.
Montowanie powiodło się po ponowieniu autoryzacji systemowej przez właściciela.
Pełne lokalne zapisy operacji są w
`proofs/ft1536/work/FT1536_NVME_DATA_PREPARATION_2026-09-22/`.

## Bieżąca kampania

Kanoniczne repozytorium/Git: `/home/footfalcon/free_falcon_sign`, gałąź main.
Dotychczasowe W:

```text
/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002
```

jest dowiązaniem do fizycznego katalogu na NVMe:

```text
/media/footfalcon/FT1536_DATA/ft1536-dudect/FT1536_FPEMU_DUDECT_RUN_002
```

Przeniesienie objęło440 plików/9517892 bajty. Porównano pełne SHA-256, rozmiary,
tryby i mtime obu kopii oraz wszystkie wcześniejsze sealed preparations.
Oryginalny katalog zachowano dodatkowo pod
`proofs/ft1536/work/FT1536_NVME_DATA_PREPARATION_2026-09-22/original-run-002/`.
Nowe pliki kampanii zapisują się na NVMe. Historyczne absolutne ścieżki
i zamrożone manifesty zachowują swoje bajty.

Launcher rozwiązuje W do fizycznej ścieżki, więc kontroler, HOME/TMPDIR,
przygotowania i logi używają tego samego magazynu. Jego statvfs/disk gate
sprawdza NVMe: wymagane93751083008 bajtów (87.3125GiB) dla36000s.
Po migracji dostępne było235833212928 bajtów (około219.6GiB).

Dowiązanie jest aliasem lokalnego magazynu, nie członkiem frozen proof inputs.
Przy użyciu `archive.py`/jego funkcji odczytu najpierw sprawdź UUID i rozwiąż
W do powyższej fizycznej ścieżki. Zachowaj strict no-symlink policy archiwów.
Zakończony baseline RUN_001 jest nadal w swoim dotychczasowym katalogu.

## Montowanie i nocny start

Po ponownym uruchomieniu systemu zamontuj wskazany UUID, jeśli potrzeba:

```sh
udisksctl mount --block-device /dev/disk/by-uuid/da38b9e9-0e22-4c55-b3e0-c46b9f293eca
findmnt --source UUID=da38b9e9-0e22-4c55-b3e0-c46b9f293eca --output SOURCE,TARGET,FSTYPE,UUID
```

Wymagany punkt montowania: `/media/footfalcon/FT1536_DATA`.
Przed startem sprawdź aktualny dysk/UUID, wolne miejsce, zasilanie AC i koniec
prac proof/build. Właściciel zaplanował ręczny sygnał około03:00 CEST,
**10h kampanii po świeżym fizycznym preflight**. Polecenie z kanonicznego repo:

```sh
python3 -B tests/ft1536/dudect/launch.py /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002 --seconds 36000
```

Stan statycznej gotowości nie oznacza startu. Rzeczywiste start/deadline i wynik
zapiszą RUN/RESULT/REPORT; odczyt możliwy przez obie ścieżki W.
