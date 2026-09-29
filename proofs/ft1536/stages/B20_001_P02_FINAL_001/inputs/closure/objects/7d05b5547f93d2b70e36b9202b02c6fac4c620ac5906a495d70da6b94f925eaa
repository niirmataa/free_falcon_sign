# Zakres freeze M0

OUTPUTS.sha256 jest autorytatywną listą względnych ścieżek i bajtów.
Obejmuje wymagane dokumenty, PROFILE/DECISIONS/GAME/RESOURCE_MODEL/ledger,
TARGET_TYPE/H3_INTERFACE, raport/wynik/macierz, INPUTS/TOOLCHAIN/AGENTS,
source/, inputs/, formal/, scripts/, artifacts/, checks/ i logs/ w chwili seal.
Obejmuje wszystkie273 matches i artifacts/fresh_replay.json.

Wyłączone: sam OUTPUTS, dynamiczny COMMANDS.log, executor.lock, tmp/, cache/,
bin/ oraz olean/ilean/pyc. Binariów/cache nie traktuje się jako dowodu/replayu.
artifacts/COMMANDS.frozen.log zachowuje dokładny prefiks dziennika; jego
długość i hash są w artifacts/command_prefix.json. Receipt samego seal i
późniejsze kontrole odczytowe leżą poza tym prefiksem. Standardowy replay
po freeze zapisuje tylko nowy DEST pod tmp.

Finalne dowody: aktywne źródła i hashe w artifacts/formal_audit.json,
czyste pełne logi logs/final/ oraz identyczny fresh replay.67 modułów,
535 twierdzeń, w tym43 nowe. To dowody capacity/count/framing/936,
nie dowód M1–M7 ani bezpieczeństwa całego schematu.

Spec documents definiują kontrakt; ich skopiowanie/hash match nie dowodzi
otwartych przesłanek ledgera. STATUS/TARGET_TYPE_NOT_PROVED oraz
security_reduction_proved=false pozostają wiążące.

formal/attempts/ i artifacts/attempts/ oraz wcześniejsze logi zachowują
historię. Nieudane Lean mogą pokazywać zastępcze sorryAx/errors/warnings;
nie są importowane ani zaliczane do finalnego zakresu. Starszy ledger/rehearsal
jest historią doprecyzowania kontraktu, nie alternatywnym obowiązującym profilem.

Freeze nie integruje caller4096/r40, nie zmienia tool.c i nie nadaje owner
acceptance. Nie cofa też dwóch jawnych decyzji właściciela ani ukończonego L_V.
