# Zakres zamrożonego wyniku

Autorytatywna lista bajtów: `OUTPUTS.sha256`, ścieżki względne wobec W.
Manifest obejmuje istniejące podczas seal pliki regularne w:

- dokumentach głównych, AGENTS.md, INPUTS.sha256 i TOOLCHAIN.txt;
- source/, inputs/, formal/ (bez olean), scripts/, artifacts/, logs/, checks/;
- odpowiadających wejściach/źródłach/logach/receipts świeżego replay/.

Wyłączone: sam OUTPUTS.sha256, dynamiczny nadrzędny COMMANDS.log,
executor.lock, bin/, cache/, tmp/, pliki olean i niezaklasyfikowany historyczny
`hs_err_pid39.log`. Plików wyłączonych nie usuwano i nie nadaje się im mocy dowodu.
Źródła fixture i skryptów oraz pełne stdout/stderr są włączone, binaria są odtwarzalne.

`artifacts/COMMANDS.frozen.log` jest dokładną kopią prefiksu nadrzędnego dziennika
z chwili seal. `artifacts/command_prefix.json` przypina liczbę bajtów i hash.
Dopisany później receipt samego seal oraz odczytowego sprawdzenia manifestu
nie wchodzą do tego prefiksu ani do listy wcześniejszych logów manifestu.
Nie zmienia to przypiętych bajtów; audit weryfikuje zachowanie prefiksu.
Wewnętrzny replay/COMMANDS.log jest już kompletny i mieści się w manifeście.

## Finalny zakres dowodu

Wyłącznie moduły wymienione w `artifacts/formal_audit.json`, ich aktualne hashe
i czyste logi `logs/final/` oraz odpowiadający świeży replay.
351 twierdzeń: 186 konsumowanych i165 nowych. Liczba nie jest werdyktem L_NTT.
`L_NTT_pending_forward` jest twierdzeniem WARUNKOWYM i ma jawną otwartą przesłankę.

`formal/attempts/`, `scripts/attempts/`, `artifacts/attempts/` oraz wcześniejsze
logi zachowano jako historię prób. Zawierają błędy taktyk, ostrzeżenia i wyniki
zastępczych sorryAx generowanych przez Lean przy błędach elaboracji. Nie są
importowane do finalnego dowodu, nie są ukrywane ani liczone jako PASS.
W finalnych źródłach nie ma sorry/admit/native_decide/lokalnych aksjomatów,
finalny audit dopuszcza tylko propext, Classical.choice i Quot.sound.

Manifest nie jest podpisem właściciela, integracją ani owner acceptance.
