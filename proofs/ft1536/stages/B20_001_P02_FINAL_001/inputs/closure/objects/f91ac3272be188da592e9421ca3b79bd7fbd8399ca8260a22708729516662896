# M0 — standardowy replay

Końcowy rehearsal: FRESH_REPLAY_PASS,273/273 pliki znaczeniowe zgodne.
Kotwica pre-freeze `artifacts/semantic_manifest.sha256`:
`cc8ae3c2459ec5457e6b510adc126a417c495e647a5ae9de46ef1db8f8603cb6`.
To osobna kotwica, NIE finalny pin OUTPUTS.

Po freeze, ze świeżej kopii pakietu:

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

Przed utworzeniem DEST skrypt wymaga i sprawdza zewnętrzny hash OUTPUTS,
wszystkie jego członki, bezpieczne ścieżki i matches związane z manifestem.
DEST jest nowym podkatalogiem tmp. Standardowy tryb pisze wyłącznie w DEST,
zapisując REPLAY_RESULT.json/FRESH_REPLAY_PASS i tę samą listę matches.
Nie nadpisuje checkpointu ani jego receipts.

Odtwarzane są nowe i konsumowane źródła Lean, C baseline/mutanty, normal
i ASan/UBSan, Sage capacity check, PROFILE/HOP_LEDGER generation, walidator
kontraktu oraz toolchain. Nie kopiowano olean/binariów/cache. Oryginalne
Dokumenty/H i historyczne W nie są potrzebne; używane są lokalne zarchiwizowane kopie.

GAME/DECISIONS/RESOURCE_MODEL/H3_INTERFACE/TARGET_TYPE/CAPACITY i pozostałe
hand-authored spec documents są kopiowanymi definicjami. Ich zgodność bajtowa
i przejście walidatora nie są odkrytym dowodem bezpieczeństwa. To rozróżnienie
jest zapisane także w receipt. PROFILE i ledger są regenerowane z przypiętych
skryptów; mathematical source certificates i native wyniki są rzeczywiście
ponownie wykonywane.

273 matches są w artifacts/fresh_replay.json. Cwd, czasy i pełne strumienie
pozostają w REPLAY_COMMANDS/COMMANDS/logs/artifacts receipts, bez wymogu
deterministycznej równości pól czasu. Włączono je jako osobną ewidencję.

Lean: -j1 -M2048, address space8GiB. Każdy job ma skończony wall/CPU limit.
Osobne procesy C ASan potrzebują nieograniczonej rezerwacji virtual shadow;
kontroler replay nie może dziedziczyć twardego8GiB obejmującego sanitizer.
Zwykłe joby wymuszają FT1536_ASAN=0 i8GiB, sanitizer używa osobno flagi1.
Wszystkie zapisy/cache pozostają w nowym drzewie, source jest read-only.

Były dwa udane rehearsals. Po pierwszym doprecyzowano typ przyszłego celu:
rekord wejściowy zawiera tylko komponenty M1–M6, a M7 jest wnioskiem,
nie przesłanką. Dodano jawne domeny parametrów i TARGET_TYPE; wykonano nowy
seed002. Pierwszy receipt i jego kotwica są zachowane jako historia.
Pełne726 plików strumieni/receipts obu prób: artifacts/replay_evidence.json.

Archiver repo powinien użyć `--replay standard`. Rehearsal jest dostępny
wyłącznie przed freeze; nie twórz cyklu hashowania jego receipt z OUTPUTS.
