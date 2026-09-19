# Standardowy replay H3_RANGE

Pre-freeze rehearsal: **FRESH_REPLAY_PASS**,96/96 plików znaczeniowych zgodnych.
Kotwica semantic_manifest.sha256:
`afd7ed8b5ccd68229d8b0f7ee9af73321f93c811407d873728d2589ef9fa9b19`.
Jest to oddzielny hash rehearsal, nie finalny pin OUTPUTS.

Po freeze, w świeżej kopii pakietu:

```sh
python3 -B scripts/replay.py /ABSOLUTE/COPY/tmp/new-run EXTERNAL_OUTPUTS_SHA256
```

Skrypt przed stworzeniem DEST weryfikuje zewnętrzny pin, wszystkich członków
OUTPUTS, symlinki/ścieżki i powiązanie archived matches. DEST musi być nowym
podkatalogiem tmp tej kopii. Nie czyta historycznych Dokumenty/H lub worktree
i nie zmienia zamrożonych plików. Używa wyłącznie zarchiwizowanego bootstrap,
source, modeli i przypiętego toolchainu. Bootstrap/source są read-only w jobach.

Nie przenosi olean, binariów ani cache. Ponownie:
- kompiluje rzeczywiste FPEMU/CDF/order/leaf-gap probes normal i ASan/UBSan;
- generuje C dump i kernelowe CDF literals z pełnym bindingiem;
- wykonuje exact dyadic oracle, source-dataflow projection i mutanty;
- sprawdza exact algebra w Sage;
- odbudowuje wszystkie nowe Lean i ich pełny audit;
- generuje source binding i ledger z zachowanymi statusami PARTIAL_PROOF.

Sukces zapisuje DEST/REPLAY_RESULT.json ze statusem FRESH_REPLAY_PASS i
identycznym matches(path,sha256). Pełne argv/cwd/limity/exit/strumienie są
w DEST/REPLAY_COMMANDS.json, COMMANDS.log, artifacts/*receipts*, logs/ i
checks/*logs. Dane czasu/cwd nie są deterministycznymi matches.

Lean:4.34.0/Std, -j1 -M2048,8GiB address space. Sanitizer ma osobny job bez
limitu rezerwacji virtual shadow, przy skończonym wall/CPU. Controller nie
może odziedziczyć8GiB limitu obejmującego również ASan; zwykłe child joby
narzucają go osobno. Zapis pozostaje ograniczony do nowego drzewa.

Pierwszy rehearsal001 doszedł przez kontrole i kernel do generowania ledgeru,
które wykryło brak bootstrap_verified.json w seed. Auditor uzupełniono o
niezależną pełną weryfikację bootstrap i generowanie tego deterministycznego
receipt; nowy rehearsal002 odtworzył wszystkie96 plików. Nie było błędu
matematycznego ani zmiany źródeł. Pełną historię zachowano w artifacts/attempts
oraz artifacts/rehearsal, z wykazem replay_evidence.json.

Sukces replayu PARTIAL_PROOF nie dowodzi Reach→CenterClass i nie nadaje
syntetycznym stanom emitted-KeyGen membership. Późniejszy standardowy replay
z finalnym hashem trafia tylko do swojego DEST, bez cyklu hashowania receipts.
