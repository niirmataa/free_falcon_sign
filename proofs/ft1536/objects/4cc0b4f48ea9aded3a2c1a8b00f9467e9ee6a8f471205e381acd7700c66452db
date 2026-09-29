# RUN_002 — pełny ledger algebraiczny i jawna granica source proofu

## Status rachunku i domeny

Pełny source-bound gap pozostaje OPEN. Nowe tożsamości w `formal/Ledger.lean`
nie zakładają małych błędów, ale same nie są refinementem wykonania C.
Historyczna suma ≈6086.40076165 jest tutaj odtworzonym rachunkiem majorant,
**nie nowym kernelowo wykazanym boundem błędu źródła**. Przedstawione niżej
warunkowe poprawy rachunku także nie otrzymują statusu source theorem.

Wszystkie referencje wejściowe są związane w `INPUTS.sha256`. Per-term ścieżki,
SHA całego pliku i SHA literalnego zakresu znajdują się w
`LEDGER_TERM_BINDINGS.json` oraz `artifacts/SOURCE_SPANS.json`.

## B0 — ramy i dokładna tożsamość

Na jednym z768 physical complex roots oznaczamy exact coefficient basis
przez B, stored basis przez Bw, DeltaB=Bw−B. Znaki są zawarte w w01,w11:
odpowiadają −f,−F. C=eval(c), Cw=val(FFT3_C(c)), lambda=Cw/q.
Actual initial targets spełniają definicyjnie
`t=(lambda*w11,-lambda*w01)+rho`. Nie zakładamy det(Bw)=q.

Niech x,y oznaczają **snapshot przed1902**, Z=(a,b) będzie niezależnym
placementem tych samych Y. Wprowadzamy terminalny transport tau i pełny
pozostały defekt kappa przez `(x,y)=t−Z+kappa+tau`. To równanie definiuje
kappa dla zadanego tau, a nie ustanawia boundu. Udowodnienie, że tau pochodzi
ze wszystkich3072 właściwych defektów i że kappa ma dany bound, jest osobnym
brakującym typem `INTEGER_DEFECT_TRANSPORT`.

| Term | Wyrażenie w physical-root frame |
|---|---|
| A1 | (Cw−C,0) |
| A2 | (lambda(det(Bw)−q),0) |
| A3 | rho Bw |
| A4 | −t DeltaB |
| B | (t−Z) DeltaB |
| C1 | kappa B |
| C2 | tau B |
| C3 | (kappa+tau) DeltaB |
| D | F_C−(x,y)Bw |
| E | val(pre_rint_C)−I(F_C), już w coefficient frame |

W kernelu wyprowadzono pierwszą i drugą współrzędną tożsamości, a także
`A4+B=−Z DeltaB`. Dla faktycznego I należy zastosować tożsamość z e=0,
przenieść A1…D przez dokładną liniowość I i dodać E. `inverse_sum` dowodzi
samej własności dla additive hom; fizyczny I, jego A2 norm i eval-inverse
wymagają instancji P06/P10. Nie zamieniamy tych braków w założenie celu.

**Uwaga o historycznych etykietach:** powyższe B jest `(t−Z)DeltaB`, żeby A4
i B tworzyły dokładną dekompozycję. Stare SOURCE_ERROR nazywało B przez Z
i jednocześnie sumowało A4. Nie utożsamiamy termów tylko na podstawie nazwy,
nie przenosimy automatycznie historycznych caps. `A_total`, crosschecki i
failed routes nie są jedenastym składnikiem. Potencjalny box na Z musi też
rozliczyć kappa+tau; sam zapis `|Z|<=tcap+Xcap` wymaga dodatkowego discharge.

Jednostki są jawne: błędy real/imag component nie są complex modulus.
Z `|Re e|,|Im e|<=eps` wynika dopiero `|e|<=sqrt(2)*eps`. Dokładny checker
wykrywa próbę pominięcia tego czynnika; nowy ledger nie promuje starych nazw
`fft_component_error` do modulus theorem.

## B1 — literalny suffix D

Source `falcon-sign.c1902–1912`:

```
t0=x_old; t1=y_old
tx=CM_C(x_old,w00); ty=CM_C(y_old,w10)
tx=add_C(tx,ty)
ty=x_old                     // memcpy(ty,t0), NIE tx!
ty=CM_C(ty,w01)
t0=tx; t1=CM_C(y_old,w11)
t1=add_C(t1,ty)              // y*w11 przed x*w01
```

`falcon-fft.c77–93,1041–1057` zachowuje read-time ar,ai,br,bi.
Kernelowe `cm_real_defect`, `cm_imag_defect`, `suffix_defect` wyprowadzają
dokładny residual jako sumę rzeczywistych operator defects. Brakuje boundów
tych residuals z literalnych FPEMU oraz caller domains. Cancellation małej
sumy nie ogranicza samych dużych produktów; nie zmniejszono U ani gamma.

Checker odtwarza **dokładnie** `suffix.each_source_CM_add_error` ze wzoru
`6U(Xbs+YbL)+16eta+U(Ps+PL)+2eta`, przy Ps=(1+6U)Xbs+8eta,
PL=(1+6U)YbL+8eta, U=2^-48, eta=2^-900. Sprawdza też coarse finite domain
X<2^35,Y<2^27,Ps+PL<2^49. Są to liczby z mixed certyfikatu, nie świeży
proof powszechnej source-domain membership.

Warunkowo, jeżeli każdy output ma modulus error<=epost i jego pojedyncza
forma A2 jest związana z I, można liczyć sqrt(4/3)*epost zamiast joint
sqrt(8/3)*epost. To redukuje **majorantę** D z≈15.6675 do≈11.0786,
nadal daleko od udziału1/20. Formal/source instancja pozostaje otwarta.

## B1 — initial targets A3

`rho0,rho1` są błędami od `(Cw*w11/q,-Cw*w01/q)`, a nie od exact basis.
TARGETS podaje pełne rational `rounding_only_error_norm` oraz luźniejsze
dyadiki1/8192 i2^-24. Checker liczy wariant pełnych rationals z **modulus**
caps bs,bL; wynik nadal przekracza1/20. Oba warianty i dokładne liczby są
w `BUDGET_ANALYSIS.json`. Same zmiany outward dyadics nie rozwiązują B1.

Nowa algebra zachowuje wspólny reciprocal nu: target bez CM/scale defects
`(nu*Cw*w11,-nu*Cw*w01)` ma image `(nu*Cw*det(Bw),0)`.
`common_reciprocal_image/second` dowodzi tego w kernelu. Nie wolno liczyć
niezależnych losowych reciprocal errors; błąd wspólnego nu anuluje się w
drugiej współrzędnej. Ilościowy bound CM/scale defects wymaga P02.

## B2 — stored basis

`correlated_basis_transfer` pozwala grupować A4+B przed trójkątem. Nie daje
uniform residuals dla wszystkich emitted keys i wszystkich Y. Brak P07
kernel/source proofu FFT/twiddle/normalization oraz P06 placementu. Nie
wykonano KeyGen, prywatnego loadera ani per-key promocji do all-keys theorem.

## B3/B4 — istotny brak mostu do starego targetu

H6P `SOURCE_NOISE_MAP.md11–20` definiuje xi0 przez **actual updated mu0**.
Jego `ERROR_LEDGER.md28–39` rekonstruuje actual terminal pairs ku górze.
LEFT `ERROR_LEDGER.md30–35` jawnie rozdziela reconstruction od source
splitting/target updates. Dlatego δ/eroot oraz Eterminal z H6P nie
stanowią same w sobie boundu `(x,y)−(t−Z(Y))`.

Na terminalu1640–1646, po definicji błędów względem actual operands:

```
r1 = old_t1 - Y1 + e1
rx = half_C(r1)               // TEN SAM zapisany word
mu0 = old_t0 + val(rx) + eadd
sub0 = mu0 - Y0 + esub
z0 = sub0 - val(rx) + elast
z0 - (old_t0-Y0) = eadd + esub + elast
```

Ostatnia równość jest kernelowa. W tej konkretnej tożsamości stored rx,
łącznie z jego half rounding, anuluje się dokładnie. **Nie znika eadd1643.**
W innovation frame ten eadd był ukryty w actual mean; jego uwzględnienie
wymaga nowego mostu. Także root/binary recomputed CM może algebraicznie
anulować swój identyczny wynik; pozostają update-add/final-sub i child
defects oraz obowiązek równości operand snapshots. `stale_product_defect`
pokazuje dokładny dodatkowy człon, jeśli snapshots nie są takie same.

Kontrola literalnego C używa publicznych syntetycznych terminali. Nie ma
membership emitted/full history i nie jest kontrprzykładem celu. Kontrola
ma wykazać, że nie można odrzucić update-add w przejściu między dwiema ramami.

Wspólna nierówność drzewa dla proponowanej starej pary δ=33/10^7,
eroot=37/10^6 nadal daje C1≈0.14172287>0.1. Nie przyjęto lepszych parametrów.
C2 musi transportować3072 defekty w odpowiedniej ramie; bound innowacji
≈0.0867 pozostaje boundem innej mapy. Tu B3/B4 są BLOCKED.

## B5 i minimalny następny krok

Kernel potwierdza wyłącznie rachunek proponowanego budżetu
6557/16000<1/2. Nie ma source-instantiated sum boundu ani actual recovery.
P02 word-level rint nie zapewnia jeszcze nearest-even real refinement;
lokalne C tie/±0/subnormal controls tego nie zastępują.

Najpierw dostarczyć konkretny odebrany/lokalnie zbudowany P02 theorem
literal add/mul z caller domains i real residual bounds, a P06 — source-call
placement/ring inverse. Potem udowodnić `INTEGER_DEFECT_TRANSPORT` z
update-add/downward split obligations i dopiero komponować B1–B5. Dokładne
brakujące typy i piny dowodów ich braku: `EXPORT_DEPENDENCIES.json`.
