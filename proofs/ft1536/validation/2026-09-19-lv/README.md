# Odbiór L_V_BRIDGE — 2026-09-19

**Odtworzenie: PASS. Zachowany wynik: L_V_PROVED_FOR_PINNED_MODEL.**

## Tożsamość i zakres

Etap `FT1536_L_V_BRIDGE_RUN_001`, piny z przekazania właściciela:

| Artefakt | SHA-256 |
|---|---|
| REPORT.md | `81702fa89ee516f162a37db86e2abb03ae0bb57a49a5723ed63eab5a17a69296` |
| OUTPUTS.sha256 | `13fa5a9f706a962434c8ac479212af5ef33d91e1ececd6c948d68ed42871a74e` |

Sprawdzono wszystkie **2397** członków OUTPUTS, dokładny zakres archiwum
i **124** publiczne wejścia. Import używa protokołu `standard`.
Badany verifier ma SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`;
manifest 17 źródeł: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

Odtwarzanie wykonano przed commitem nowego etapu, z przypiętych bajtów
zaimportowanych do worktree `/tmp/opencode/ft1536-noreply-history`.
Rodzic Git: `9e97c3a30050029598b55080055709533b8afa5e`.
Zakres kontroli dotyczy tego archiwum i jego wejść; pozostałe robocze pliki
worktree nie są przedmiotem deklaracji czystego checkoutu.

## Niezależne odtworzenie

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_L_V_BRIDGE_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

- **FRESH_REPLAY_PASS, 402/402** pliki znaczeniowe zgodne z zamrożonym receipt.
- Exit 0, bez timeoutu, 190.094 s; pusty stderr kontrolera.
- **73 moduły, 570 twierdzeń, 104 nowe**; wszystkie ponownie zbudowane ze źródeł.
  Końcowe strumienie Lean czyste, tylko standardowe aksjomaty
  `propext`, `Classical.choice`, `Quot.sound`.
- **59** odziedziczonych modułów bajtowo identycznych z poprzednim checkpointem.
  Zbiór 570 twierdzeń zawiera 466 odziedziczonych i 104 nowe; sześć poprzednich
  twierdzeń z `CheckerControls.lean` nie należy do tej konsumowanej zależności.
  Ich lista jest w `review_checks.json`; poprzedni checkpoint zachowuje je.
- Kontrole: **55** przypadków bajtowych, **8** normowych i **4** centrowania;
  zgodność C/Lean/Sage, decyzji plain/observer i normal/ASan/UBSan.
- Pięć rzeczywistych mutacji wykrytych, no-op bez różnic.
- Rzeczywiste wektory B-1/B/B+1 dają **1/0/0 w obu kompresjach**.
  Historyczny świadek S17: decyzja kandydata **0**, norma **43058711057**.
- Sieć odłączona, root read-only, zapis w świeżym seed. Dokumenty i historyczny
  Szablon ukryte pustymi tmpfs; bez wcześniejszych olean/binariów/cache.
- Lean i zwykłe joby używają limitu 8 GiB address space. Oddzielny job ASan
  rezerwuje shadow bez tego limitu, z ograniczonym CPU/wall time.
  Przypięty runner ustawia `detect_leaks=0`; to kontrola ASan/UBSan, nie LSan.
- Po replayu weryfikacja wszystkich **siedmiu** checkpointów repo: PASS.

Pełne `git diff --cached --check -- proofs/ft1536` zwróciło kod 2:
90 uwag whitespace, wszystkie w przypiętych plikach importowanego etapu
(65 spacji przed tabulatorem we wcięciu, 20 końcowych spacji, 5 pustych
końcowych linii). Zachowano oryginalne bajty objęte OUTPUTS.
Kontrola nowej dokumentacji, katalogu, obiektów i zapisów validation jest
czysta. Uwagi Git nie są ostrzeżeniami Lean ani błędami replayu.

`VALIDATION.sha256` przypina dwanaście plików: receipts wykonania i porównań,
stdout/stderr, komendy, audit formalny, receipts 73 kompilacji, wykonania
natywne, wyniki kontroli i dodatkowe sprawdzenia odbioru. Strumienie wskazane
przez receipts zostały sprawdzone względem ich hashy. Zgodne końcowe pliki
znaczeniowe są również w niezmiennym archiwum etapu; cache pozostaje lokalne.

## Przegląd tezy i źródłowych modeli

Przejrzano `VerifyBytes`, `Initialization`, `RawBridge`, `Norm64`,
`BridgeWords`, `ByteCursor`, `DecodeStatic`, `DecodeNone`, `PublicKey`,
`MachineBindings`, `ParserRefinement`, audyt typów oraz C/model binding.

`L_V_BYTES`, `L_V_LOADED` i `L_V_SOURCE` mają jawne przesłanki canonical
wektorów, legalnych długości i akceptacji źródłowo związanego modelu.
Nie znaleziono dodatkowej przesłanki poprawności parsera, normy lub centrowania.
`V_CAND` wywołuje guards, parser i raw verifier; nie jest zdefiniowane przez
żądany wniosek o normie Ext0. `unary_terminates` wiąże fuel z liczbą pozostałych
bitów, nie z arbitralnym limitem długości. Loader zachowuje rzeczywiste
zwracanie len i akceptowanie nieczytanych końcowych bajtów PK.

Rezultat jest twierdzeniem o przypiętym modelu GCC14.2.0/C99/Linux x86_64 LP64
z jawnym powiązaniem z kodem i legalnym API. Nie jest formalną weryfikacją
kompilatora C. `full_L_V_proved=true` dotyczy wyłącznie pinu kandydata powyżej.
`source_integrated=false`, `owner_accepted=false`. Dalsze interfejsy samplera,
rozkładu kluczy, gry bezpieczeństwa i redukcji pozostają odrębnymi obowiązkami.
