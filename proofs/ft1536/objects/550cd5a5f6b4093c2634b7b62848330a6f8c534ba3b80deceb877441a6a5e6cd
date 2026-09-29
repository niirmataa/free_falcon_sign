# Dokładny zakres OUTPUTS.sha256

Manifest obejmuje wszystkie pliki inputs (publiczny bootstrap + read-only
supplemental provenance), formal/scripts/checks, artefakty, top-level raporty
oraz zachowane źródłowe snapshoty/raw logs/receipty zakończonych runów.
Obejmuje także packaging/seal.py (raportująca korekta parsera nazw aksjomatów,
bez udziału w producerach semantic outputs). Oryginalny failed finalizer
pozostaje byte-exact w scripts i snapshotach; jego nieudane wykonania są jawne.
Manifest nie obejmuje siebie. Dla run/build obejmuje tekstowe dowody,
matematyczne JSON/NDJSON i C inputs/harness/provenance/logi, nie binaria.

Wyłączone celowo: home,tmp,cache,config,data,sage, .olean/.ir/executables,
preparsed tymczasowe .sage.py i pozostałe working caches. Żaden wyłączony
plik nie stanowi dowodu lub required semantic result; własne formalne
moduły i C harness są odbudowywane przez replay. Biblioteki to external RO
pinned closure, z pełnymi source/build/runtime manifests i pochodzeniem;
pakiet nie duplikuje wielu GiB bibliotek. Nie zawiera nowych sekretów.

Nieudany initial_001 nie ma zmyślonego internal exit/receipt: jego source/logs
oraz zewnętrzny timeout record są objęte manifestem. Po freeze żadna
przypięta zawartość nie jest modyfikowana. Nowe replaye mają osobny DEST
i nie są automatycznie dodawane do tego frozen manifestu.
