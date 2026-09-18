# Daybreak Blue-latest — niezależny odbiór wyniku GPT-ASTRA

## Karta zadania dla autora

- **Cel:** niezależnie sprawdzić ukończony kontrprzykład do L_V-STATIC.
- **Po co:** potwierdzić wynik Astry przed wyborem dalszej pracy matematycznej.
- **Zakres zapisu:** tylko `FT1536_LV_STATIC_ODBIOR_BLUE_001`.
- **Oczekiwany wynik:** raport odbioru z wykonanymi kontrolami i ich granicami.
- **Koniec:** jeden werdykt odbioru; dalsza praca wraca do użytkownika i Astry.

To jawne, lokalne badanie poprawności własnego weryfikatora FT1536. Zakres
obejmuje istniejące publiczne dane testowe, źródła i matematyczny świadek.
Nie rozszerzaj go do atakowania zewnętrznych systemów lub pozyskiwania sekretów.
Model i przyznany dostęp wybiera użytkownik w kliencie; plik nie nadaje
uprawnień usługi.

## Uruchomienie przez użytkownika

Uruchom klienta bez początkowego polecenia wykonania zadania:

```bash
/home/footfalcon/.local/bin/codex \
  --cd "/home/footfalcon/Dokumenty/FT1536_LV_STATIC_ODBIOR_BLUE_001" \
  --sandbox workspace-write \
  --ask-for-approval on-request \
  -c 'sandbox_workspace_write.writable_roots=[]' \
  -c 'sandbox_workspace_write.network_access=false' \
  -c 'sandbox_workspace_write.exclude_tmpdir_env_var=true' \
  -c 'sandbox_workspace_write.exclude_slash_tmp=true'
```

W selektorze modelu wybierz **Daybreak Blue-latest**, a następnie wklej:

```text
Wykonaj niezależny odbiór zgodnie z /home/footfalcon/Dokumenty/FT1536_DAYBREAK_BLUE_ODBIOR_LV_STATIC_2026-09-17.md. Zacznij od instrukcji AGENTS.md i sprawdzenia uprawnień bieżącej sesji.
```

Ustawienia dotyczą sandboxa narzędzi wykonujących zadanie; klient Codex
korzysta osobno z usługi modelu i własnych plików sesji. Przed kompilacją
utwórz katalogi tymczasowe i cache pod W oraz jawnie ustaw TMPDIR, DOT_SAGE
i XDG_CACHE_HOME na te katalogi. Nie polegaj na możliwości zapisu do `/tmp`.

Kontrola przygotowania z 2026-09-18: w lokalnym `codex sandbox` z powyższymi
ustawieniami i `sandbox_mode="workspace-write"` otwarcie `W/AGENTS.md`
z `O_RDWR` było dozwolone. Takie otwarcie nadrzędnego AGENTS.md,
`R/REPORT.md` i `H/build/falcon-vrfy.c` zwróciło `EROFS`; odczyt wszystkich
czterech plików był dostępny. Próba nie zapisywała danych do plików.
Hashe REPORT.md i OUTPUTS.sha256 odpowiadały pinom poniżej. Jest to kontrola
przygotowania, nie wynik odbioru ani potwierdzenie uprawnień przyszłej sesji.

## 1. Start i korzenie

Przeczytaj `/home/footfalcon/Dokumenty/AGENTS.md`.

```text
R = /home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001
W = /home/footfalcon/Dokumenty/FT1536_LV_STATIC_ODBIOR_BLUE_001
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
```

W jest przygotowanym katalogiem roboczym z AGENTS.md. Jeśli zastaniesz w nim
wcześniejsze wyniki, najpierw ustal ich stan; niczego nie nadpisuj w celu
uzyskania świeżego startu. R jest ukończonym, zamrożonym wejściem.

Piny:

```text
R/REPORT.md
SHA-256: c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd

R/OUTPUTS.sha256
SHA-256: 0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87
```

Najpierw zweryfikuj te dwa hashe, następnie przeczytaj REPORT.md, RESULT.json,
OUTPUT_SCOPE.md i REPLAY.md. Zapisz, które elementy rzeczywiście sprawdzono.
Nie uznawaj deklarowanego wyniku za oczekiwany z góry werdykt własnej kontroli.

## 2. Co dokładnie sprawdzamy

Zachowany raport deklaruje `COUNTEREXAMPLE_REQUIRED_DOMAIN` dla:

```text
Ext0(h,c,b) = (center_q(c-h*s(b)), s(b)),
V_S17(h,c,b)=1 => Q(Ext0)<B,
N=1536, q=18433, Phi=X^1536-X^768+1, B=2093922385.
```

`s(b)` jest faktycznie zdekodowanym wektorem int16_t. Zachowaj definicje:

```text
Q0(a) = sum_{i=0}^{767}(a_i^2 + a_i*a_{i+768} + a_{i+768}^2),
Q(z1,z2) = Q0(z1) + Q0(z2).
```

Teza dotyczy wszystkich h z successful KeyGen support, kanonicznych c
i akceptowanych payloadów. Uczciwe podpisywanie pozostaje COMP_STATIC,
a teza obejmuje pełny język wejść rzeczywistego Verify. Przynależność
publicznego h do successful support opiera się na wskazanych historycznych
publicznych zapisach KeyGen.

Dane istniejącego świadka znajdują się w `R/artifacts/witness.json`,
`witness.bin`, `witness_c.txt` oraz w publicznych wejściach `R/inputs/key/`.
Sprawdź je w zakresie potrzebnym do oceny raportu. Nie generuj nowego klucza
ani nowego świadka; przedmiotem jest już ukończone wykonanie.

## 3. Kontrole odbiorcze

1. Sprawdź hashe członków i dokładny zakres manifestu według OUTPUT_SCOPE.
   Odrzuć duplikaty, ścieżki absolutne, ucieczki i symlinki. Rozróżnij
   zamrożony prefiks COMMANDS od późniejszego dopisywalnego ogona.
2. Zweryfikuj tożsamość S17, publicznego klucza i publicznego h oraz pochodzenie
   danych świadka. Nie utożsamiaj zgodnego commitmentu z nowym prywatnym replayem.
3. Przejrzyj wierność harnessu: rzeczywiste przygotowanie h przez NTT/Montgomery,
   kontrole nagłówka, pełne dekodowanie, ścieżkę normy i podmianę wyłącznie
   HashToPoint na jawne c, zgodnie z badaną tezą.
4. Niezależnie zdekoduj istniejący payload i oblicz dokładne c-h*s oraz normę
   Ext0 w ZZ/GF(q). Nie importuj modelu/checkera Astry jako własnej niezależnej
   implementacji. Porównaj wynik z utrwalonym świadkiem i wartościami raportu.
5. Odtwórz źródłową decyzję C na hash-sprawdzonej kopii w W, po przeglądzie
   skryptów i kontraktu ich wyjść. Nie uruchamiaj runnera, który zapisze coś do
   oryginalnego R. Wybrane dodatkowe kontrole ASan/UBSan dokumentuj oddzielnie.
6. Sprawdź certyfikat `formal/WitnessBlocks.lean`, jego powiązanie z wektorami,
   rzeczywiste tezy i zależności. Jeśli wykonasz Lean, zapisz wyjście i wersję.
   Nie nazywaj tego formalizacją całego C lub całego schematu.
7. Oceń deklarowaną niezależność Sage, C, Lean oraz granice świeżego replayu.
   Rozróżnij własny replay od odczytu receipt wcześniejszego replayu.

## 4. Izolacja i zakres

Kopiuj do W tylko hash-sprawdzone publiczne wejścia potrzebne do kontroli.
Wszelkie nowe cache, pliki przejściowe, źródła pomocnicze, binaria i logi mają
powstać w W. Referencję trzymaj oddzielnie od własnego kodu odbiorczego.

Korzystaj z sandboxa klienta ograniczającego zapis do W. Nie wyłączaj go i nie
proś o zapis do źródłowych katalogów. W razie blokady narzędzia opisz
niewykonaną kontrolę zamiast przypisać jej sukces lub matematyczny FAIL.
Nie zmieniaj źródeł S17, Q, B, Phi, profilu, ekstraktora, manifestów ani
historycznych statusów. Nie instaluj oprogramowania i nie korzystaj z sieci
w obliczeniach tego zadania.

## 5. Raport końcowy

Zapisz w W:

- `DAYBREAK_REVIEW.md` — wynik, własne kontrole, znalezione rozbieżności,
  niewykonane kontrole i zakres wniosku;
- `DAYBREAK_RESULT.json` — maszynowy wynik odbioru;
- `INPUTS.sha256`, `TOOLCHAIN.txt`, `COMMANDS.log` i logi;
- własne checkery, ewentualne wyjścia replayu i `OUTPUTS.sha256` z jawnym zakresem.

Werdykt odbioru ma odróżniać: potwierdzenie zadeklarowanego kontrprzykładu,
konkretną rozbieżność, częściową kontrolę lub problem wykonania. Nie jest
decyzją właściciela ani zmianą statusu projektu.

Zachowaj granice wyniku: ujemne L_V dla Ext0 nie dowodzi braku każdego innego
ekstraktora, znalezienia preimage HashToPoint, efektywnego fałszerstwa EUF-CMA
ani obalenia T2C3/T5.

Na końcu podaj pełną ścieżkę DAYBREAK_REVIEW.md i jego SHA-256. Po tym jednym
odbiorze dalsza praca wraca do użytkownika i GPT-ASTRA; nie zaczynaj naprawy
kodowania lub nowego lematu automatycznie.
