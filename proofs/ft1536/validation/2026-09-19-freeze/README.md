# Kontrola zamrożenia dokumentacyjnego po M0

Pakiet `FT1536_POST_M0_FREEZE_RUN_001` jest związany z opublikowanym aktywnym
buildem na commicie `2959064e8132443649de50600b20bfc32ed618cb`.

- REPORT SHA-256: `5c59b414c78511743118bca67b95a11f4d78718902f1ca5f1902756937017fa6`.
- OUTPUTS SHA-256: `c3efdcff510983a143946d43ab456656090061cd5b9b4b6847abc7f141c0cfa3`.
- 211 członków OUTPUTS i 198 publicznych wejść Git zweryfikowane.
- Każdą kopię INPUT_BINDINGS niezależnie porównano z blobem wskazanej bazy Git.
- Potwierdzono 17 aktywnych źródeł względem manifestu kandydata.
- Graf sprawdzono na unikalność/występowanie węzłów i brak cykli.
- Sprawdzono lokalne odsyłacze głównego README, archiwum i raportu zamrożenia.

To sprawdzenie integralności oraz przegląd dokumentu stanu; nie nowy replay
dowodów lub twierdzenie bezpieczeństwa. Osiem etapów badawczych zachowuje
własne raporty, piny i zakresy. Zamrożenie ma protokół `none`; jego
podstawowa odczytowa kontrola po pobraniu repo:

```sh
python3 -B proofs/ft1536/tools/archive.py verify FT1536_POST_M0_FREEZE_RUN_001
```

Input locators `git:<commit>:<path>` są proweniencją; po imporcie weryfikator
korzysta z zachowanych obiektów w repo, bez historycznych Dokumenty/H.
