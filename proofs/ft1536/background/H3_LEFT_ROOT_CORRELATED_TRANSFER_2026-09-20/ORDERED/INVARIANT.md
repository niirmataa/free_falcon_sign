# Ordered invariant — udowodniona prawa gałąź, otwarta lewa gałąź root

Autor projektu: Niirmata. Status całego celu **PARTIAL_PROOF**. P_key,
Emitted, K_seed/M0, kod i parametry nie są zmienione. Nie zakładamy przyszłej
norm acceptance, fault-free trace lub NumericCenter wszystkich calls.

## 1. Stan i kwantyfikacja

Stan dowodu ma source PC, stack node/path, read-time snapshots bieżących
t0/t1/t2 i L, pamięć/initialized ranges, monotonic fault flag i zakończone
callback outcomes. NormalResult(mu,a) znaczy tylko
`exists z in[-365,366], a=floor_C(mu)+z`. Definicja NIE zawiera NumericCenter.
Source refinement SCALAR_OUTCOMES uzasadnia tę relację dopiero po ustaleniu
domeny bieżącego call. Stutter nie dodaje caller return ani residual update.
Fault return0 ma inny tag i nie konsumuje ZERO closeness.

Root entry pochodzi z TARGETS i resetu source3357. Przy aktywnym pre-floor
PC2864 fault musi byćNONE. Ponieważ source nie kasuje fault wewnątrz recursion,
wszystkie wcześniejsze ZAKOŃCZONE calls w tej invocation były normal; rejected
proposals mogły występować dowolnie długo bez zmiany caller state. To WNIOSEK
ze sticky source flag, nie globalna premise fault-free execution.

Indukcja dotyczy finite prefixes, po liczbie source steps i stack depth.
Nigdy nie zakłada powrotu nieskończonej rejection loop. Jeśli scalar nie
wraca, nie ma następnego caller center. Jeśli fault wystąpi, dalsze calls
omijają floor, a faulted arithmetic ma jawnie osobny nierozstrzygnięty zakres.

## 2. Nowe signed transfer contracts

ROOT primitive contracts obejmują signed finite operands≤2^100, nie tylko
positive diagonals. Half ma finite all-word error≤2^-1023; nie jest RN/identity
na wszystkich klasach. transfer_certificate sprawdza511 actual twiddle pairs,
terminal IW1I/W1R/W1I oraz error-polynomials na dowolnym cap M≥0.

Używamy G=1+2^-32 i bezpiecznego additive1. Dla complex-modulus caps a,b:
add/sub cap ceil(G(a+b))+1; CM cap ceil(Gab)+1. Deep split k≥2 ma cap
ceil(Ga)+1; top split także. Merge cap ceil(G(sum child caps))+1.
Terminal SplitDeep1: exact reference `(re-im/sqrt3,2im/sqrt3)`, każdy
scalar≤2|input|. Source cap ceil(2Ga)+1. MergeDeep1 ma exact reference
`a+b/2+i sqrt3*b/2`, cap ceil(G(|a|+|b|))+1. Finite/zero/subnormal classes
i coefficient rounding są objęte absolute floors. Wszystkie użyte w PRAWEJ
gałęzi operands/results mieszczą się przed instrukcjami w2^100.

Actual binary L może zostać ciaśniej ograniczone z odebranego TOWER:
jego H=[[h,conj(c)],[c,h]] jest positive i |c|<h; source direct component div
ma norm error≤2U, U=2^-48. Stąd |L_C|<1+2U<1+2^-40. Dotyczy S8 i wszystkich
lower records, nie jest nowym key premise. Node3 używa zachowanych bounds
L10/L20<2,L21<4. Root L<2^25 pozostaje znacznie większy.

## 3. Terminal order bez koła

Przy wejściowych scalar caps A,B najpierw mu1 ma capB. Dopiero po sprawdzeniu
NumericCenter dla B source NORMAL_RETURN i ZERO dają |r1|≤366+2^-20<367.
Half daje |rx|<184. NOWY mu0 ma capceil(G(A+184))+1; trzeba sprawdzić go
przed drugim floor. Po tym drugim normal return scalar residual<367, ale
returned z0 zawiera dalsze subtraction rx: |z0|<552, |z1|<367.
Z arrays są residuals, nie sampled integers. Model i kernel consumer utrzymują
tę różnicę. Signed −0 pozostaje w NumericCenter; nie przepisano old CenterClass.

## 4. Rekurencyjna majoranta actual order

bounds.py jest exact rational/outward instancją następującej source indukcji:
- binary: split t1 → recurse right → merge z1; form product z1*L, add t0;
  split updated t0 → recurse left → merge → subtract product;
- cubic: child2 → child1(updated by z2 L21) → child0(updated by z1 L10,z2 L20),
  z1 po jego subtraction jest tym samym snapshotem konsumowanym przez child0;
- root first branch to source branch1 z t1, nie branch0 buildera.

W każdej recursive recurrence zachowane są ODDZIELNE caps zwróconych z0/z1,
więc merge bierze ich sumę, zamiast mnożyć max przez nadmiarowe factors.
Recomputed CM products mają identyczne operand words przez frame, więc ich
rounding nie staje się niezależnym noise przy każdym ponownym użyciu.
Nie zakłada się bitowego cancellation rounded add/sub: ich errors są osobne.

Initial t1 cap2359169, potem source SplitTop. Po dokładnym przejściu wszystkich
768 terminal blocks prawej gałęzi dostajemy dla jej1536 active pre-floor calls:

```
|val(mu)| <= 156276714
lower margin = 2147483283-156276714 =1991206569
upper margin = 2147483282-156276714 =1991206568.
```

Każdy bound sprawdzono przed ZERO/subsequent call. Ten wniosek jest dla
WSZYSTKICH required emitted/canonical entries i source finite histories
zawartych w pierwszej root branch, nie wyłącznie fixtures. Normal-return
superset jest sound bez probabilistic independence. Wrong support/typical
sample założenie nie jest użyte. Artefakt zawiera per-path mu1/mu0 caps.

## 5. Dokładna otwarta granica

Po powrocie prawej gałęzi bez fault mamy jej source residual cap i input frame.
Root mul/add1818–1820 jest defined (operand caps daleko od2^100). Z aktualnego
L<2^25 dostajemy root updated-target cap3864968087959271. To PROVED bound tej
konkretnej operacji, ale za szeroki do następnego scalar-domain theorem.
Próba kontynuowania norm-recursion daje candidate majorant7729936365272004;
nie jest zamkniętym safety proofem, bo ZERO na późniejszych calls wymagałoby
już brakującego NumericCenter. Tę failed route zachowano, nie ogłoszono UB.

Pierwszy brakujący transfer to correlated/weighted bound źródłowego
`SplitTop_C(t0 + CM_C(z1,Lroot))` oraz jego dalszych left-branch centers,
z actual normal-return residual history prawej gałęzi. Potrzebne są raw L /
actual Gram / stable D metric defect i roundoff bounds, nie podstawienie
idealnego LDL. Candidate bank-weighted budget ma duży zapas w modelu idealnym,
ale jego source instancja pozostaje OPEN (FAILED_ROUTES).

W konsekwencji cały ordered_root_reach/all_reached_mu_numeric pozostają false.
Nie przenosimy parcialnego prawa1536 calls na drugą połowę3072 traversal.
