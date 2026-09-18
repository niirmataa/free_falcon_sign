# Deterministyczny replay L_V-STATIC

## Wymagania

- GCC 14.2.0 / C99 / LP64, Python 3, SageMath 10.9 przez
  `/home/footfalcon/miniforge3/envs/sage/bin/python`;
- Lean 4.34.0 / Std przez
  `/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean`;
- `/usr/bin/bwrap`; nie ma instalacji, sieci ani mathlib;
- istniejący pakiet W, z weryfikowalnym finalnym `OUTPUTS.sha256`.

To nowy checker L_V, nie replay historycznych certyfikatów Sage 9.5 / Lean 4.30.0.

## Pełny replay w nowej kopii

Ustaw cwd na:

```text
/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001
```

Weź oczekiwany hash OUTPUTS z zewnętrznego przekazania wyniku. Nie zastępuj
uwierzytelnienia digestem dopiero co odczytanym z dowolnej zmienionej kopii.
Wykonaj jedno polecenie, podstawiając hash jako ostatni argument:

```sh
python3 -B resume_001/run.py python3 -B resume_001/replay_fresh.py /home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/tmp/replay_002 EXPECTED_OUTPUTS_SHA256
```

`replay_002` musi nie istnieć. Przy zajętej nazwie wybierz następny numer;
skrypt odmawia nadpisania istniejącego celu. Podane polecenie tworzy wyłącznie
nowy podkatalog W/tmp i dopisuje log wykonania. Nie uruchamia prepare.py,
KeyGen ani żadnego historycznego runnera. Reference i publiczne wejścia
są kopiowane bajtowo do nowego katalogu.

Program przed utworzeniem destination sprawdza zewnętrzny digest i wszystkie
wpisy OUTPUTS. Potem odtwarza:

1. cztery kompilacje (base/observed shared, normal i sanitizer standalone);
2. 10 dodatnich kontroli, 6 granic normy, 35 przypadków dekodera i cały świadek;
3. niezależny checker Sage, oba replaye C i 11 mutacji;
4. generowanie i sprawdzenie `formal/WitnessBlocks.lean`;
5. bindery, wszystkie 768 par A2 i porównanie 10 plików matematycznych.

Nowy wynik jest w `tmp/replay_002/REPLAY_RESULT.json`, a nowe command receipts
w `tmp/replay_002/COMMANDS.log` i jego logs. Samodzielny normalny proces C ma
zwrócić verify/raw/loader/point_calls równe 1, machine_norm=400000000,
payload_bytes=1931 i decoded_bytes=1930. Checker Sage ma dać Ext0_Q=43058711057.
Lean ma sprawdzić 26 deklaracji bez dodatkowych aksjomatów poza propext.

`formal/Witness.lean` i `lean_array_timeout.json` są kopiowane wyłącznie jako
zachowany ślad wcześniejszej próby. Domyślny replay nie uruchamia ponownie
tej kosztownej, niezakończonej wersji; sprawdzanym certyfikatem jest
`formal/WitnessBlocks.lean`.

## Kontrola oryginałów na maszynie właściciela

Po ustawieniu tego samego cwd można odczytowo porównać także przypięte
oryginały H/DOC. Wybierz nową, nieistniejącą nazwę receipt:

```sh
python3 -B resume_001/run.py python3 -B resume_001/verify_bundle.py --originals --out tmp/verification_after_freeze.json
```

Ten dodatkowy check wymaga obecności oryginalnych ścieżek i binariów bieżącego
runu. Pełny replay wyżej odbudowuje własne binaria i używa kopii publicznych
wejść, więc nie potrzebuje oryginałów H. Nie należy uruchamiać build.py,
probe.py ani exporterów bezpośrednio w sfinalizowanym głównym W: celowo
odmawiają nadpisywania swoich wyników.

## Zakres weryfikacji

C jest obserwowanym verifierem. Python oraz Sage niezależnie obliczają
matematyczny ekstraktor; Lean certyfikuje konkretny rachunek normy. To nie
pełna formalizacja C ani dowód EUF-CMA. Dla zmiennego c nie szuka się
wiadomości/nonce i nie deklaruje rozwiązania HashToPoint preimage.

Mutable COMMANDS i cache/tmp/bin nie są bezwarunkowo „całym katalogiem
wyjściowym do podpisania”. Dokładny zakres manifestu oraz niezmienny
snapshot dziennika określa `OUTPUT_SCOPE.md`.
