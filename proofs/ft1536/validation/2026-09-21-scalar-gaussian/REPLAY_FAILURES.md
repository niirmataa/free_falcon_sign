# Zachowana pierwsza nieudana próba fresh replay

rehearsal_001 zakończył się na job0/toolchain: wrapper Sage --version nie
zakończył się w limicie45s. Obliczenia matematyczne w tej kopii nie zostały
rozpoczęte. Child REPLAY_RESULT ma FRESH_REPLAY_FAIL_JOB; nie przemianowano go
na PASS i nie usunięto stderr/receipts.

Następny bounded diagnostic mamba -vvv run -n sage sage --version w tym fresh W
zwrócił10.9. Zachowano pełny trace/stdout/stderr. Nie ustalono przyczyny
pierwszego opóźnienia; nie traktujemy samego timeoutu jako wyniku matematycznego.
Nie zmieniono wersji,source,proof bounds,runnera lub limitów w celu obejścia
niepowodzenia.

Niezależny NOWY absent DEST rehearsal_002, bez cache/olean/bin, użył tego samego
zewnętrznego anchoru i recipe. Cały build oraz kontrole zakończyły się
**FRESH_REPLAY_PASS516/516**. Jego rzeczywisty receipt jest sealed w
artifacts/fresh_replay.json. Failed job i późniejszy diagnostic są w
artifacts/attempts/rehearsal_001 z FILES.json i actual fresh command receipts.
Historyczny failed wynik pozostaje zachowany obok poprawnego odtworzenia.
