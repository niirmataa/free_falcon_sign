# Publiczne wejścia startowe H3_RANGE — 2026-09-19

To niezmienny zestaw odczytowy dla nowego zadania H3, a nie nowy dowód ani
nowa akceptacja dawnych wyników. `MANIFEST.sha256` obejmuje dokładnie jego
pliki, z wyłączeniem siebie. `ORIGINS.json` wiąże każdą kopię z oryginalną
ścieżką/commitem i SHA-256.

- `source/` to dokładny aktywny kandydat z main na f526676, manifest2553358f….
- `M0/` i `FREEZE/` są kopiami wybranych dokumentów opublikowanych checkpointów.
- `legacy/H3/`, `legacy/H4/`, `legacy/T5/` są jawnymi publicznymi materiałami
  historycznymi. Zachowują statusy i ograniczenia z czasu wykonania.
- Stare manifesty są tu proweniencją, nie deklaracją pełnego eksportu każdego
  historycznego pakietu. Ich pierwotne bazy nie są zmieniane na ten katalog.
- H4 stored widths, terminal scaling i T5 exact leaves są odrębnymi obiektami.
  Historyczny endpoint replay fpr-double nie jest sam w sobie kontrolą FPEMU.
- Użycie dawnego checkera wymaga własnej świeżej kopii, jego pełnych potrzebnych
  wejść i właściwego source bindingu. Nie uruchamiać runnerów w archiwach.

Zestaw zawiera publiczne dokumenty/certyfikaty oraz źródła. Nie zawiera kluczy
prywatnych, seedów, prywatnych współczynników ani cache/binariów. Kopia tego
samego zestawu jest przygotowana pod `W/inputs/bootstrap/` dla Astry.
