# Kontynuacja dla GPT-ASTRA — istniejący FT1536 L_V-STATIC RUN_001

## Kontynuuj dotychczasową pracę

To zlecenie jest przeznaczone do tej samej sesji GPT-ASTRA, która przygotowała
raport o celu dowodu i pierwszym brakującym lemacie. Wykorzystaj zachowany
kontekst, ale sprawdź przypięte pliki przed wyciąganiem nowych wniosków.

Właściciel wybrał kontynuację w OpenCode. Poprzednia próba Codex CLI została
przerwana komunikatem usługi przed sporządzeniem wyniku matematycznego.
Istniejące pliki należy zachować. Ten komunikat nie jest dowodem ani
kontrprzykładem do badanego lematu; zlecenie nie zmienia ograniczeń dostępu
ani nie upoważnia do obchodzenia kontroli usługi.

Cel pozostaje jawny: lokalna analiza poprawności własnego weryfikatora FT1536
na źródłach S17 i publicznych danych testowych, z dokładną tezą L_V-STATIC.
Nie dotyczy ona atakowania zewnętrznej usługi ani użycia cudzych kluczy.

## 1. Przeczytaj właściwe zlecenie i stan

```text
DOC = /home/footfalcon/Dokumenty
W = DOC/FT1536_LV_STATIC_RUN_001
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
```

| Dokument | SHA-256 |
|---|---|
| `DOC/FT1536_CODEX_START_2026-09-17.md` | `112f4829c25f16f9cec19b7c58bdf64f86d3edcc3c7e077505fcd6a93b2788f2` |
| `DOC/FT1536_PROMPT_LV_STATIC_2026-09-17.md` | `9788680b76dafa32644ce8fefb5107383fbfc1ec7e87f768b5bf979c935ae386` |
| `DOC/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md` | `5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e` |

Przeczytaj cały prompt L_V oraz potrzebne części własnego raportu, zwłaszcza
§2 i §6. To jest wznowienie, więc zastępuje się wyłącznie polecenie utworzenia
nowego katalogu: **pracuj w istniejącym W po sprawdzeniu jego stanu**.
Pozostałe granice, teza i kryteria ukończenia pozostają takie jak w prompcie L_V.

## 2. Zaobserwowany stan przerwanej próby

W chwili przygotowania tego przekazania:

- istnieją `reference/`, `inputs/`, `scripts/`, `bin/`, `logs/`, `artifacts/`,
  `formal/`, `tmp/` i `cache/`;
- `reference/` zawiera 17 kopii zgodnych bajtowo z H/build — sprawdzono je
  ponownie po przerwaniu próby;
- `scripts/prepare.py` zakończył się kodem 0;
- jedno polecenie przeszukiwania zgłosiło `rg: command not found`, ale po nim
  wykonanie trwało dalej;
- `scripts/build.py shared` skompilował `bin/lv.so` kodem 0, bez stderr;
- `artifacts/` i `formal/` były puste;
- `REPORT.md`, `RESULT.json`, `OUTPUTS.sha256` jeszcze nie powstały.

Piny stanu zastanego:

| Plik względem W | SHA-256 |
|---|---|
| `INPUTS.sha256` | `24041795bde8573373aaf8e26aac793f29257d145eccc9cfb9854017b2c05537` |
| `scripts/prepare.py` | `46e44e92efb2cda7a5812aa5949d4aa68140b95e014948e4519d8249183e2261` |
| `scripts/run.py` | `c094d4021ac85eb61dca0c82b1e79cca0826422ae1bea0a655ef551f16312eab` |
| `scripts/build.py` | `a4905716adacdefff8f728fd6cc5c446e9a237bb7e7e757380f79ecdf42cd9da` |
| `scripts/harness.c` | `d9addfa1ddea67a2fa689b0963755758426cd3ae04df4115b39ff6877af4bd79` |

Pierwotny prefiks `COMMANDS.log` to pierwszych **pięć surowych linii wraz
z końcowymi newline**. Jego SHA-256 wynosi:

```text
7fd844fb21a9a549632d3bc307293948e11d4f3f6049dd26d6aa10b7c3591fc7
```

Podczas przygotowania przekazania zaobserwowano już szósty wpis,
`2026-09-18T11:07:55.045861+00:00`, sprawdzający skrypty i obecność `lv.so`.
Nie traktuj poprawnego dopisania rekordów jako zmiany historycznego prefiksu
i nie wymagaj, aby hash całego rosnącego dziennika nadal był równy powyższemu.

Sprawdź piny plików i historyczny prefiks przed pierwszym zapisem. Jeśli stan
jest nowszy, najpierw ustal i opisz różnicę; nie nadpisuj cudzej pracy.
Jeśli pracuje już inna sesja, nie uruchamiaj drugiego wykonawcy zapisującego
do W. Ten plik należy przekazać pojedynczej sesji wybranej do kontynuacji.
Zachowaj kopię zastanego dziennika i spis zastanych hashy w nowym podkatalogu
wznowienia w W. Dziennik rozszerzaj tylko przez dopisywanie nowych rekordów.

Nie uruchamiaj ponownie inicjalizującego `prepare.py`: kopie już istnieją.
Zweryfikuj `INPUTS.sha256`, manifest S17 i kopie referencyjne odczytowo.
Brak `rg` nie wymaga instalacji — użyj dostępnego narzędzia odczytu lub
wyszukiwania przez standardową bibliotekę Pythona.

## 3. Dokładny dalszy krok

Zachowaj COMP_STATIC jako profil uczciwego Sign. Zbadaj pełny język wejść
rzeczywistego Verify, który obsługuje także NONE.

Lemat dotyczy implikacji:

```text
V_S17(h,c,b)=1
  => Ext0(h,c,b)=(center_q(c-h*s(b)),s(b))
     jest krótkim świadkiem przy niezmienionych Phi,q,Q i B.
```

`s(b)` to rzeczywiste wartości int16 zapisane przez dekoder. Teza obejmuje
required successful public-key support i wszystkie akceptowane payloady.
Nie zakładaj centered s2 ani uczciwego pochodzenia payloadu.

Najpierw przejrzyj istniejący harness jako **kod testowy do weryfikacji**, a nie
gotowy dowód. Zastępuje HashToPoint jawnym c, zgodnie z definicją lematu.
Sprawdź, że przygotowanie h przez NTT/Montgomery i reszta badanego Verify
pozostają wierne S17. Użyj dodatnich kontroli, a dokładną normę i iloczyn
modulo `(q,Phi)` licz również niezależnie od badanego NTT.

Potem wykonaj zakres §5–§8 oryginalnego promptu L_V. Celem jest dowód albo
pełny odtwarzalny kontrprzykład do tej dokładnej tezy, nie powtórzenie
lokalnego przykładu `-20000` ani samego rezultatu kompilacji.

Wykorzystaj SageMath 10.9, Lean 4.34.0/Std i GCC według zapisanej notatki
środowiskowej. Odróżniaj nowy checker od historycznego replayu innych wersji.
Nie instaluj dodatkowych pakietów i nie uruchamiaj innego agenta.

## 4. Zakres zapisu i zakończenie

Wszystkie nowe artefakty zadania zapisuj wyłącznie w W. Oryginały H i USB,
historyczne manifesty oraz lokalny checkout `free_falcon_sign` pozostają
tylko do odczytu. Nie generuj kluczy, nie odczytuj prywatnych współczynników,
nie zmieniaj źródeł S17, B, ekstraktora ani profilu dla uzyskania PASS.
Nie wykonuj commita, podpisu, push ani publikacji.

Zachowaj istniejące skrypty jako etap poprzedniej próby. Jeśli wymagają
poprawy, utrwal ich wcześniejsze bajty i uzasadniony diff przed użyciem nowej
wersji. Nie traktuj binarium bez weryfikacji/rebuild bindingu jako oracle.

Wyniki końcowe pozostają takie jak w oryginalnym zadaniu:
`REPORT.md`, `RESULT.json`, checkery/formalne fragmenty, logi, świadek jeśli
występuje, `REPLAY.md` i `OUTPUTS.sha256` z jawnym zakresem.

W odpowiedzi podaj pełną ścieżkę W/REPORT.md, SHA-256 oraz dokładne
rozstrzygnięcie. Błąd narzędzia lub komunikat usługi opisuj jako problem
wykonania, a nie matematyczny FAIL. Nie wymuszaj wyniku pozytywnego ani
negatywnego. Zachowaj rozróżnienie kontrprzykładu do Ext0/L_V od efektywnego
fałszerstwa EUF-CMA.
