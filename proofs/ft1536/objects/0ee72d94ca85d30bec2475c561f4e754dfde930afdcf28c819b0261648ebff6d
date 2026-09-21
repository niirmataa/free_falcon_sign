# Dokładne rejection kernel i conditional IID zakończenie

Każda probability/expectation w tym dokumencie jest w **IID_BUFFER**, warunkowo
względem legalnej PAST historii z fixed mu/sigma i entry ptr p. Uniform product
assumption i filtracja są określone w RANDOMNESS_MODEL, a positivity source
normalizatora jest WYPROWADZONA w ACCEPTANCE_FLOOR, nie wstawiona do definicji.

## One-iteration finite weights

Po guard exclusion jedna iteration zawsze czyta tuple
(hi64,lo64,byte8,mask64,threshold64), czyli264 świeże uniform bits. Jej source
output candidate to y=s+z(k,b), gdzie s=floor_C(mu); U128 wybiera k w fixed
bank j, b jest low bit byte. Source x_C jest literalnym gap/tail expression,
przez13-coefficient expm/word transducer daje e,Z. Wszystkie te quantities są
deterministyczne z entry mu/sigma,k,b, nie z Bernoulli words.

Jeśli e>=64 accepted count M_(k,b)=0. W przeciwnym razie:

```
M_(k,b)=n_j,k * 128 * 2^(64-e) * 2^9 * min(Z,2^55),
D=2^264,
w_y=M_(k,b)/D = n_j,k/2^129 * min(Z,2^55)/2^(e+55).
```

Wartości y dla różnych(k,b) są rozłączne/injective; można równoważnie sumować
po wszystkich pairs z danym y. Rejected tuple count to D−ΣM. Count/partition
argument daje 0≤A=ΣM/D≤1. Source positive atom daje A≥1/256>0. Zeros po
cutoff/quantization pozostają w returned support jako zero weights, nie są
usuwane przez zmianę tables. 54 publiczne examples odtwarzają wszystkie atomy,
exact numerator/denominator PMF i mass conservation; nie są proofem law supremum.

## Geometric finite-prefix induction

Rejected iteration zmienia buffer/ptr i local proposal values, lecz mu/sigma,
s,r,dss,bank i tables pozostają fixed. Fresh-byte invariant zachodzi także
warunkowo po REJECTION_STUTTER: rejection jest eventem wyłącznie na odczytanym
tuple, future cells pozostają niezależne. Dlatego następna iteration ma tę
samą conditional accepted mass w_y i rejection mass1−A, dla każdego legalnego
prefixu; nie zakładamy ich bez dowodu z buffer coupling.

Indukcja daje dla n≥1:
Pr[N=n,Y=y|PAST]=(1−A)^(n−1)w_y,
Pr[N>m|PAST]=(1−A)^m. Integer common-denominator count to
(D−a)^(n−1)M_y/D^n, a=ΣM. Kernel finite_geometric_count sprawdza finite
telescope: a*Σ_{k<m}(D−a)^k D^(m−1−k)+(D−a)^m=D^m; normalized_mass_integer
sprawdza sumowanie wag. Source probability instantiation jest analityczna.

Ponieważ1−A≤255/256<1, geometric limit to0. Countable continuity from above
daje Pr[N=∞|PAST]=0. Sumując disjoint return events:
Pr[Y=y|PAST]=Σ_{n≥1}(1−A)^(n−1)w_y=w_y/A. Tail-sum theorem dla positive
integer-valued N daje E[N|PAST]=Σ_{m≥0}(1−A)^m=1/A≤256. To standardowe,
jawne kroki measure-theoretic poza Lean/Std; nie ukryty aksjomat desired PMF.

## Post-state i zasoby

Dodanie do eventu N=n informacji final ptr=q_p(n),refills=R_p(n),drops=D_p(n)
nie zmienia jego masy, bo te wartości wynikają deterministycznie z schedule.
Zatem eksport obejmuje joint(output,N,resource/post-pointer), nie tylko marginal.
RANDOMNESS_MODEL stopping-time argument zapewnia fresh unread tail po return
także po ujawnieniu całej dotychczasowej read history; następny adaptive call
może użyć tego conditional kernel po dowodzie nowego entry invariant.

BYTE_SCHEDULE zawiera tail/mean budgets. Ghost truncation N≤m ma IID cost
≤(255/256)^m, lecz source nie dostaje nowego timeout/abort/capu. Infinite
rejection jest możliwą ścieżką: dla local mu0,sigma=RN(4/3),all-zero refill
continuation daje k29,b0 i e>=64 w każdej iteration. Deterministyczne pola
powtarzają się, więc nie wraca; ta konkretna nieskończona taśma ma IID mass0.
Fixture obserwuje jej bounded prefix z tagiem HARNESS_EXHAUSTED/NONE. Nie
nazywamy tego return0 ani required emitted-history counterexample.

Powyższe a.s. dotyczy tylko scalar IID game. Nie dowodzi all-tapes termination,
real PRNG equivalence, full ordered joint law/Gaussian comparison/H6P,
Safe16, Sign→Verify lub whole Sign/H2P/KeyGen termination/security/CT.
