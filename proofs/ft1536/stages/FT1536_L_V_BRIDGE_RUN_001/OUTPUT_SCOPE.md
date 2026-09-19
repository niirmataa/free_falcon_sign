# Zakres zamrożonego wyniku

OUTPUTS.sha256 jest autorytatywną listą plików względem W. Obejmuje dokumenty,
wynik/macierz, INPUTS, TOOLCHAIN, AGENTS oraz source/, inputs/, formal/,
scripts/, checks/, artifacts/ i logs/ istniejące podczas seal.
Obejmuje402 matches oraz artifacts/fresh_replay.json. Publiczne PK i synthetic
payloady bin są zadeklarowanymi wejściami matematycznymi, nie sekretami.

Wyłączone: sam OUTPUTS, dynamiczny COMMANDS.log, executor.lock, tmp/, cache/,
bin/, olean/ilean/pyc. Compiled binaries/cache są odtwarzalne. Późniejszy
standardowy replay zapisuje wyłącznie nowy DEST pod tmp, bez modyfikacji pakietu.

artifacts/COMMANDS.frozen.log jest dokładnym prefiksem COMMANDS.log w chwili
seal; artifacts/command_prefix.json przypina bajty i hash. Receipt seal i
późniejsze kontrole odczytowe nie stają się częścią tego prefiksu.

## Finalne dowody

Aktywne moduły i piny: artifacts/formal_audit.json.73 moduły,570 twierdzeń:
466 konsumowanych,104 nowe. Tylko aktualne źródła, czyste końcowe strumienie
logs/final/ i ich identyczny świeży replay należą do finalnego zakresu dowodu.
BridgeTypes.stdout pokazuje pełne typy, termy oraz wszystkie argumenty.
Dozwolone standardowe aksjomaty: propext, Classical.choice, Quot.sound.

formal/attempts/, scripts/attempts/, wcześniejsze logs i failed rehearsal są
jawną historią prób. Mogą zawierać błędy, ostrzeżenia, zastępcze sorryAx lub
metavariables powstałe przy nieudanej elaboracji. Nie są importowane do finalnych
modułów, nie policzono ich jako PASS i nie ukryto przez filtrowanie linterów.

Manifest nie jest integracją źródeł ani owner acceptance. Import/Git/commit
wykonuje prowadzący sesję po otrzymaniu zewnętrznych hashy.
