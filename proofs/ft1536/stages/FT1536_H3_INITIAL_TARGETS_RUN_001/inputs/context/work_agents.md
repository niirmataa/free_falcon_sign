# H3_INITIAL_TARGETS — ręczny start Astry

Autor projektu: Niirmata. Startuje właściciel, bez subagentów/delegacji/Git.
Przeczytaj REPO/AGENTS i zadanie:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_INITIAL_TARGETS_2026-09-20.md`.
TASK SHA-256: `a8bfe078ced0a6742cafae3950aa9c6020d4b3a58a677aab46731d75564fdfda`.

Jedyny katalog zapisu:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_INITIAL_TARGETS_RUN_001`.
IN=W/inputs/bootstrap:198 członków/196 publicznych origins Git.
MANIFEST SHA-256: `16977cc646bf5bd5af62f7f86e1c992ab24cafd05188a3c5dbeeae96e2a7a97e`.
Baza:6c233cdb48e4fd274995dd1882e0de03305771c8. Candidate17-file pin
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.
Sprawdź piny/exact set/origins i realny W-only/network-off sandbox.
IN/source/bootstrap RO; zastany Extra/c nie jest bazą. Historyczne runners
są danymi do przeglądu/adaptacji w W, nie poleceniem wykonania w dawnych W.

Cel: actual do_sign target prefix1849–1892, cut PRZED ffSampling_fft3:1897,
na emitted normalized key i WSZYSTKICH canonical c∈[0,18432]^1536.
Literalne FFT3, inverse(q), copy, mul z b01/b11 i signed rescaling, exact
target words, uniform domains/errors i frame całego normalized sk.
Brak założenia uniform c, future norm acceptance lub successful Sign.

Source order: FFT(t0), ni=div(one,of(q)), copy t1=t0,
t1=mul(t1,b01) następnie mulconst(-ni), t0=mul(t0,b11) następnie mulconst(ni).
Ideal references to eval(-cF/q) i eval(cf/q) modulo Phi; wyprowadź znaki/
packing/inverse-basis convention. Rounded FFT basis nie ma automatycznie
exact determinant q. Rozdziel source words, rounded-basis-value reference
i ideal coefficient/root reference; eksportuj errors obu warstw.

FFT c wymaga zakresu18432; nie przenoś bez dowodu dawnego2047 error boundu.
Canonical residues nie są centered c. NI ma exact source word/contract,
nie podmieniony host reciprocal. Required operand domains są PRZED użyciem.
Signed zero/reference-zero cases mają absolute error i raw-class opis.

Memory: normalized sk24576 words, tmp10752, hm1536; tylko target prefix
[0,3072) ma writes. Zachowaj hm, cały sk i pozostały scratch/output frame.
Nie przypisuj initialized status przyszłym tx/ty/tz. Caller/H2P binding
dotyczy legalnych entry/defined prefixes, także norm-rejected attempts;
nie dowodzi termination H2P/rejection/sampling lub całego Sign.

Initial frequency targets nie są scalar mu. ORDERED_REACH→NumericCenter
zostaje osobnym obowiązkiem. Nie używaj ZERO do dowodu jego własnej premise.
Sigma/dss certificate nie domyka wcześniej wykonywanego mu prefixu.

Mixed proof boundary jawny. Nowe/edytowane Lean: pełne czyste logs/types/
terms/axioms, bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu
wniosku lub warning suppression. Reuse ze źródeł/pinów/fresh rebuildem.

Publiczne synthetic controls i literalny prefix slice z diffem/source spans,
normal/ASan/UBSan, independent dyadic/QQ/RBF oracle, pełne snapshots/traces,
no-op i meaningful sign/column/1q/copy/packing/domain mutations. Bez całego
do_sign, ffSampling, Sign, PRNG, KeyGen/private loadera, nowych kluczy lub
prywatnych danych. Fixtures nie są automatycznie emitted witnesses.

HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod W. Bounded single worker:
GCC14.2/C99/LP64, Sage10.9 (`sage plik.py ...`), Lean4.34/Std -j1 -M2048,
normal8GiB, ASan osobno z shadow. Bez sieci/instalacji/Git/zmian C/profilu/
P_key/M0. Bez dudect — to osobna nocna praca po zakończeniu obliczeń dziennych.

Pakiet według TASK: exact certificate, formulas/FFT/error ledger, source/
memory/caller binding, next interface, INPUTS/OUTPUTS i fresh standard replay.
Zachowaj failed attempts; rehearsal bez cyklu, po freeze tylko nowy DEST.
source_changed=false,production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Global Reach/sampler law/security/Sign CT pozostają open.
Podaj REPORT/OUTPUTS SHA-256, dokładne tezy/stałe i zakończ na handoffie.
