# Niezależny odbiór SCALAR_GAUSSIAN_COMPARISON — 2026-09-21

Autor projektu: Niirmata. Rodzic56700dd136690226deeb79a66daf4c632fc8835e.
Status: **H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

## Piny i odtworzenie

| Artefakt | SHA-256 |
|---|---|
| REPORT.md | `4c39d1ae9690b6dbc7926f4c169f8728b460d7f34c7dd3dd19aeb167da037842` |
| OUTPUTS.sha256 | `c20ea0c260fc5fcb6aec06ed8287335ebceacd31776f3da8633d91e399930f1a` |
| SCALAR_GAUSSIAN_CERTIFICATE.json | `204b63ba87315ef35eecea608dc7f00c9c2bc400d0bb595512738dd32257ea8c` |
| VALIDATION.sha256 | `ec7237d69491de6cfba834b0c7a9287e9acf860860425b8ace98b4017092e965` |

Import:1960 OUTPUTS/493 INPUTS,144990400 bajtów, integralność PASS. Niezależny
replay w kanonicznym trwałym repo: bwrap/network-off, ukryte Dokumenty/H,
świeże project cache/olean/bin, **516/516 matches,117.386s,exit0**. Bez timeoutu
lub seed omissions w tym odbiorze. Pierwszy timeout Sage wykonawcy jest zachowany
w zamrożonym pakiecie i opisany w [REPLAY_FAILURES](REPLAY_FAILURES.md).

VALIDATION zachowuje736 plików/95003149 bajtów: pełne znaczeniowe wyniki,
27 driver/executor streams,36 kernel receipts, po30 native batches dla normal
i ASan/UBSan, oba buildy/toolchain oraz negative-result dokumenty.
36 modułów,234 twierdzenia,26 nowych,30 inherited; final logs/types/terms/axioms
czyste. Kontrole obejmują394 buckets,63 nominal overruns,36464 scalar atoms,
101 rigorous Gaussian examples i3 native scalar witnesses. LSan nie deklarowany.

## Co oznacza PROVED

W jawnej grze **IID_BUFFER**, warunkowo względem legalnej PAST, dla D_cert
i wyprowadzonego nadzbioru D_env, exact source K_C porównano z niezależnym
NIEODCIĘTYM Gaussianem G na Z, m=val(mu),v=val(sigma)^2:

```text
TV(K_C,G) <=2^-36
chi2(K_C||G) <=2^-60
chi2(G||K_C) = infinity.
```

To lokalna sigma, nie sigma_sign768. Proof rozlicza first-bank constraints,
source normal-mul/RNE/Sterbenz refinement, center error<=2^-51, precision
error<=2^-45, exact CDF quantization, source correction/reduction/expm,
cutoff/infinite tails i accepted normalization. Nowe A>=1/8 wynika z tego
samego source normalizatora, nie z assumed9/20. Product-measure/source/real
Gaussian/Taylor arguments są analityczne; kernel wspiera wskazane integer/
interval/normalization/support lemmas. Fully-kernelized/compiler flags sąfalse.

Odbiór sprawdził evidence/source pins, native word equality, scope flags i
exact rational normalization/TV ledger. Forward chi2 sprawdzono dodatkowo
z niezależnym konserwatywnym rational exp(ep)<=1/(1-ep), nadal dającym<2^-60.
Same101 point maxima nie zostały użyte jako uniform bound.

## Niewygodne wyniki pozostają jawne

-63 source exponent buckets wychodzą powyżej literalnego log2. Trzy witnesses
 należą do local scalar/standalone-normalizer D_env; Emitted membership OPEN.
 Naprawiono zakres dowodu expm, nie program. Actual reduction daje rB>=0.
-Ujemny extended input expm ma błąd>3/5; jest poza proved actual remainder domain.
-Reverse chi2 jest∞, ponieważ G ma dodatnią masę poza finite support K_C.
 Mały forward bound nie pozwala odwrócić kierunku change-of-measure.
-Usunięcie saturation jest równoważne na proved source Z<=2^55; zachowano ten
 wynik zamiast fikcyjnego wykrycia mutacji.12 innych mutations wykryte, no-opPASS.

[COUNTERMODELS](COUNTERMODELS.md) i [FAILED_ROUTES](FAILED_ROUTES.md) zachowują
membership i ograniczenia. Nie zgłoszono required-domain kontrprzykładu do
podanych granic ani nowego błędu produkcyjnego.

## Znaczenie i następny krok

Teraz znamy zarówno exact source kernel w IID_BUFFER, jak i jawny błąd jego
lokalnego porównania z G. To nie whole-call loss, poziom bezpieczeństwa lub η_pre.
Realny PRNG bridge, ordered joint law/H6P, Safe16, joint BadPrecast, reference
integer recovery i Sign→Verify pozostają otwarte; POST nadal PARTIAL_PROOF.

[NEXT_INTERFACE](NEXT_INTERFACE.md) wymaga actual adaptive/shared-history
kompozycji. Rekomendowany następny etap: ORDERED_JOINT_KERNEL, z wyprowadzoną
legalnością wspólnych prefixów i jawnym rozliczeniem Gaussian support/domain
exits. Referencja może użyć G_S na source support lub zatrzymanej G z osobnym
znacznikiem wyjścia, ale jej normalizacja/mass/cost muszą pozostać widoczne.
Samo mnożenie independent marginals nie daje takiej kompozycji.
