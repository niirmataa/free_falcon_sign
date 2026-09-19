# FT1536 H3_ROOT_LDL — aktywne zadanie Astry

Autor projektu: Niirmata. Kontynuuj tę samą rozmowę po odebranym ZERO_SCALAR.
Wykonaj jedno zlecenie:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ROOT_LDL_2026-09-19.md`.

SHA-256 TASK:
`792e4f012e3fd2c0a744d1d6cd8449858386f1c19958c6a8a4ceabdeca561693`.

Jedyny katalog zapisu:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ROOT_LDL_RUN_001`.
Gotowy bootstrap `inputs/bootstrap/`:106 członków,104 publiczne oryginały Git.
Zewnętrzny SHA-256 `inputs/bootstrap/MANIFEST.sha256`:
`f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73`.
Baza: `9a76ecfd72d83e131d79299f0249bca1efdf9468`.

Przeczytaj REPO/AGENTS i TASK. Potwierdź manifest/dokładny zbiór wejść,
cwd i rzeczywisty sandbox tylko W. Bootstrap i skopiowane źródła C są
read-only; modele/kontrolery twórz osobno. REPO/Extra/c nie jest wejściem
tego zadania. Nie operuj na Git lub zastanym indeksie.

Zakres: FFT/Gram oraz source root LDL_dim2 dla emitted-KeyGen support;
ściśle dodatnie root divisors/real pivots, finite multiplier i konkretne
błędy względem exact NTRU/Schur. RootSlice musi zachować realne operacje,
nie zastąpić subtractive d11 przez idealny reciprocal. Rozlicz frame:
rzeczywisty kod wykonuje pierwsze subtree przed root dim2. Dowód korzenia
nie nadaje całej wcześniejszej rekurencji statusu proved.

E2^-20 z ZERO ma domenę exponent<=1054; nie przenoś go bezwarunkowo do
root g11. Legacy T5/FFT wymaga sprawdzenia konsumowanych backend premises.
Zero/subnormal/underflow analizuj według FPEMU, nie nazwy IEEE. H4 liście
nie ograniczają automatycznie16896 wewnętrznych słów. NumericCenter, małe L,
Babai<=1/2 lub mały błąd nie mogą być ukrytym założeniem pełnego wyniku.

Dalsze internal tree, initial targets, global Reach i sampler law pozostają
osobnymi obowiązkami. Zachowaj zakres mixed analytic/kernel, pełne typy,
termy i axioms. Nowe/edytowane Lean: czyste logi, bez sorry/admit/native_decide,
lokalnych aksjomatów wniosku i wyciszania ostrzeżeń. Dziedziczone źródła
z pinami, zmiany w nowych kopiach z diffem i ponownym rebuildem.

HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod W; skończone limity;
Lean4.34/Std -j1 -M2048/8GiB, ASan z osobnym shadow mode. AGENTS nie jest
sandboxem. Bez instalacji/sieci badawczej/innych agentów/sekretów/prywatnych
seedów/współczynników/.private/private_extraction/nowych kluczy/KeyGen/Sign.
Kontrole wyłącznie publicznych syntetycznych lokalnych arrays/polinomów.

Nie zmieniaj C, parametrów lub guards. Zachowaj wszystkie próby i pełne
command/stdout/stderr receipts. Dostarcz dokumenty z TASK, INPUTS/OUTPUTS,
raport z rzeczywistym statusem i standard replay z finalnym zewnętrznym pinem.
Po freeze zapisuj tylko do nowego DEST. Podaj REPORT/OUTPUTS SHA-256.
Prowadzący wykona odbiór/import/commit; nie rozpoczynaj następnego etapu.
