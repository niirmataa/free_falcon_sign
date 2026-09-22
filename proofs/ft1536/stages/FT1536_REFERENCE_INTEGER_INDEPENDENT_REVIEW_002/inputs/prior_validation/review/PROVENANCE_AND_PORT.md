# PROWENIENCJA I PORT v3→v4 — notatka recenzenta

Szczegóły maszynowe: PROVENANCE_AND_PORT.json.

## Metoda

Porównano wpis po wpisie `checks/py_crosscheck/OUTPUTS_v3_superseded.sha256`
(SHA `daf45e8a…`) z v4 `OUTPUTS.sha256` (SHA `0cafdbb2…`): 17 dawnych ścieżek o
zmienionym hashu lub nieobecnych pod tą samą nazwą (w tym 3 przeniesione
skrypty `scripts/*.py → scripts/py_crosscheck/*.py` i zmienione
`scripts/replay.py`), 24 nowe ścieżki w v4. Pięć wyników checks ma nowe hashe;
`checks/constants_extract.json` bez zmian. Cztery py_crosscheck JSON zachowują
piny dawnych wyników (70b59d5a…/263cf498…/8542f402…/eac0808a…) — to kopie
dawnych bajtów, nie dowód zachowania całego v3.

## Ustalenia

1. Regeneracja 5 plików checks w miejscu jest odstępstwem proceduralnym od
   zamrożenia v3, jawnym w rekordzie portu (stary manifest zachowany, nowy
   receipt `fresh_replay_sage.json` oddzielony od nietkniętego
   `fresh_replay.json`). Poprawność v4 dowiedziona niezależnie (mój replay);
   stare receipty nie dowodzą nienaruszenia freeze — i nie są tak używane.
2. „3 należące do freeze v3" (PORT_PY_TO_SAGE.md): manifest v3 zawiera
   wszystkie 5 regenerowanych plików — poprawnie 5 (uwaga low, poprawka jednej
   linijki).
3. Tabela Z: 3072 wiersze identyczne (niezależny checker), całe pliki różne
   (v4 dodaje `"engine": "sage-10.9"`). Słowo „bajtowo" dotyczy wierszy, nie
   plików (uwaga low; oba hashe jawne).
4. 12/16 terminów gap różni się wyłącznie reprezentacją enclosure sqrt
   (py: skalowane isqrt; sage: RIF256-upper + exact assert) — obie outward,
   float ≤1e-9 rel (niezależnie potwierdzone).
5. Fixtures ring/skeleton: MT→LCG (werdykty i mutacje zgodne; nie porównanie
   bajtowe instancji). `tie_odd_case` = 0 w py, usunięte w sage (schema-only).
6. INPUTS-alias: `TASK_DOCUMENT_provenance` nie jest plikiem w SOURCE_W; hash
   = kanoniczne TASK. Własny seed ma kopię transportową z notą (adaptacja
   transportu z receipt/diffem — ten plik), oryginał i manifest nietknięte.

Ocena poprawności v4 i ocena zgodności proceduralnej v3→v4 to osobne pola
(REVIEW_RESULT.json): v4 POPRAWNE w zakresie PARTIAL; v3 ZMIENIONE.
