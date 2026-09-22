# Rzeczywiste niepowodzenia metody recenzenta

1. Pierwszy patch wpisu ról zawierał niedopasowaną linię STATE („Nowy” versus
   „Nowszy”). Tool nie zmienił żadnego pliku; poprawiono kontekst i zastosowano
   patch. Nie dotyczy matematyki ani źródeł autora.
2. `replay/independent-001`:16 steps exit0,18/18 matches,PDF build/text PASS,
   ale controller exit1 wskutek dodatkowego surowego porównania FFT JSON.
   Jedyny diff to path source_header. Zachowano REPLAY_FAIL i wszystkie raw
   logi; REPLAY_ASSESSMENT osobno sprawdza identyczne pozostałe pola i pin
   nagłówka. Nie zmieniono starego receiptu,nie powtórzono runu dla etykiety.
3. `check_runs/math-001`:Sage Integer0 w Newton support list nie był JSON
   serializable. Po wszystkich asercjach rachunku serialization exit1.
   Stara wersja/partial output/traceback zachowane. Jedyna poprawka to
   `0→int(0)`; nowy math-002 exit0 z nowym source SHA i osobnym receipt.
4. Pierwszy administracyjny skan Lean trafił słowo native_decide w komentarzu
   FTRoots:17 („nie użyto”). Poprawiono skan przez usuwanie blokowych komentarzy
   z zachowaniem numerów linii. To false positive skanera,nie failure kernela;
   rzeczywiste4 buildy i14 wydruków aksjomatów były już czyste.

Nowe dowody/rachunki wykonały się przez SageMath10.9 `sage ... .sage`.
R4 Python jest organizacją kontrolowanego mock backendu/programu; historyczne
check_*.py odtworzono w ich przypiętym,ujawnionym trybie REUSED.
