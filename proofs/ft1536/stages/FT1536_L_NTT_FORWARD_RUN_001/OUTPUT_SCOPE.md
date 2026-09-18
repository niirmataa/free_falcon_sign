# Zakres freeze

Autorytatywna lista bajtów to OUTPUTS.sha256, ze ścieżkami względem W.
Obejmuje dokumenty główne, wynik/macierz, instrukcje startowe i INPUTS,
TOOLCHAIN, source/, inputs/, formal/, scripts/, artifacts/, logs/ i checks/.
Włączone są wszystkie217 plików matches i artifacts/fresh_replay.json.
Pełne receipts/strumienie rehearsal są pod artifacts/rehearsal/.

Wyłączone są sam OUTPUTS, dynamiczny COMMANDS.log, executor.lock, tmp/,
cache/, bin/ i kompilowane olean/ilean. Testowe symlinki protokołu pozostają
wyłącznie w wyłączonym tmp. Nie czyta się ich jako danych dowodu.
Source C jest niezmienioną kopią, binaria i cache są odtwarzalne.

`artifacts/COMMANDS.frozen.log` jest dokładnym prefiksem COMMANDS.log z chwili
seal; liczbę bajtów i hash określa artifacts/command_prefix.json. Receipt
samego seal i późniejszych odczytowych kontroli nie zmienia tego prefiksu.
Późniejszy standardowy replay zapisuje wyłącznie w nowym DEST pod tmp.

## Końcowy zakres matematyczny

Lista aktywnych modułów i ich hashy: artifacts/formal_audit.json.
63 moduły,472 twierdzenia:351 z GLOBAL,12 z L_RHO i109 nowych w tym etapie.
Końcowe logi: logs/final/, pełne typy i proof terms: AuditTypes.stdout.
Ich czystość i aksjomaty sprawdzono bez filtrowania lub wyciszania logów.
Główne nowe tezy nie mają nierozliczonych globalnych przesłanek.

formal/attempts/, wcześniejsze logi i diagnostyka prefiksów są zachowaną
historią. Nie są importowane jako finalne moduły. Mogą zawierać errors,
warnings i sorryAx generowane przez nieudaną elaborację, co nie jest dowodem
ani kontrprzykładem. Do wyniku liczą się tylko aktualne źródła, czyste końcowe
receipts i identyczny świeży replay. Żaden failed attempt nie został wyciszony.

Freeze nie jest integracją źródeł ani owner acceptance. Git/index/stages
obsługuje prowadzący sesję po otrzymaniu hashy.
