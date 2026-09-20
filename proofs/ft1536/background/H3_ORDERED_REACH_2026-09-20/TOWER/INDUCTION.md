# BINARY_TOWER — INIT, source STEP i rzeczywista indukcja 7–1

Autor projektu: Niirmata. P_key/profil/source są dokładnie przypięte.
Argument jest uniwersalny, mieszany analityczny/kernelowy z exact QQ/RBF
certificates. Nie jest dowodem zweryfikowanego GCC. Nie używa aktywnego
FPEMU_AUDIT, przyszłego wyniku tej sesji ani nowego whole-domain assumption.

## 1. Stan liczbowy i niezależny reference

Inv(v;m,M,I,E,R) oznacza dla KAŻDEGO packed complex slot:
finite words, m≤Re(v)≤M, |Im(v)|≤I, m>0 oraz norm error≤E wobec
odpowiedniego niezależnego exact real positive reference r, 0<r≤R.
Imag może być normal, zero lub subnormal. Real jest normal dzięki m.
Zachowujemy moment source read i fizyczną mapę rootów. Stan nie zawiera
założenia o wyniku przyszłej recursion, pivotu lub center.

R_8 pochodzi z exact NODE2 diagonals, a dalsze R_l z exact mean/harmonic
split tych samych ścieżek. Nie jest source projected spectrum H.
Exact mean i harmonic pivot positive i≤max inputs; stąd invariant R
pozostaje stały: R0=2*1536²=4718592, R1=4*18433²=1359101956.
Norm exact binary multiplier≤1.

## 2. Nowy INIT refinement, zamiast iteracji coarse c2

Konsumujemy ROOT: real g00∈[1/2,2^23), real Droot∈(32,2^31); NODE2 nowy
root imaginary theorem |ImDroot|<1. Te premises są udowodnione po P_key,
nie wybrane z kontroli. Dla cubic NODE3 tworzymy comparison spectrum
REALNYCH actual root words. Idealny phased unitary Gram ma eigen lower
1/2 albo32. Imaginary perturbation i source split error delta_top≤1/8192
albo1/16 dają actual-input H3 eigen lower
`rmin-3*(Iroot+delta_top)`.

NODE3 pointwise source bounds względem TEGO SAMEGO actual-input H3
pozostają ważne: real pivot error≤65536U*h (oba pivots), gdzie U=2^-48,
h≤rmax+delta_top. Nie zmienia się H3 ani kodu; wzmacnia się tylko jego
wyprowadzoną dolną granicę. Upper pivot≤(1+65536U)*h.
Zatem exact QQ sprawdza następujący wspólny dla k INIT na source
NODE3 t0/d11/d22:

```
branch0: m3=127/256, M3=2^23+1,
         I3=(0,1/262144,1/262144);
branch1: m3=28, M3=2^31+1,
         I3=(17/16,1089/1024,1089/1024).
```

Imaginary refinement wykorzystuje wspólne tau i64U*h z NODE2/NODE3.
Dla branch0 tau=raw+0. Dla branch1 tau≤1+1/16, a pivots≤tau+64U*(2^31+1/16)
<1089/1024. Real/error certificates historyczne pozostają niezmienione;
nowy INIT jest osobnym lematem w tym W.

E3_{b,k} zachowuje odebrane exact-reference errors NODE3. Wykonanie STEP
poniżej dla q9 daje nowy mocny rekord S8, związany z TYM SAMYM
Node2Slice_C co w poprzedniku. Stare coarse c2 endpoints nie są iterowane.
Branch0 INIT pochodzi z g00 facts dostępnych przed root dim2; nie potrzebuje
wykonania przyszłej branch1 lub zakończenia wcześniejszego niższego tree.

## 3. Parametryczny source step

Dziedziny primitive są przejęte z NODE2/ROOT z pełnymi pinami: finite scalar
operands≤2^100, add/sub error≤U(|x|+|y|)+eta, mul≤U|xy|+eta,
div positive normal denominator[1/16,2^35], eta=2^-900.
Half ma kernelowy finite all-word bound≤2^-1023<eta i jawne e0/e1 classes.
Nie utożsamiamy go z RN(x/2) ani nie zakładamy raw-preservation po half.

Wejście Inv(v;m,M,I,E,R), z I<m. Dla adjacent pair va=ra+i*ta,vb=rb+i*tb:

```
h0=(ra+rb)/2, z=conj(unit)*(va-vb)/2,
h0²-|z|²=ra*rb-(ta-tb)²/4.
```

Nie zerujemy ta-tb. Complex cap B=M+I. Source add/sub norm error≤eadd=2UB+2eta.
Inherited component CM(M,e,d)=2Md+2e(1+d)+6U(M+e)(1+d)+4eta daje
split norm error≤max(eadd/2+2eta,CM(2B,eadd,eps)+2eta), eps=2^-50.
Oznacz jego outward majorant delta. Adj zachowuje normę błędu i raw sign flip.

Actual H ma diagonal h=Re(s0_C), lower c=Adj(s1_C), upper conj(c).
Ideal paired H0 ma eigen lower≥m-I. Norm perturbation≤2delta daje
H≥lambda I, lambda≤m-I-2delta>0. To proof object; source imaginary words
zostają w programie. hmin=(1-U)m-eta i hmax=(1+U)M+eta są mocniejszymi
real bounds samego add/half. Real add output jest normal z exponent≥2,
więc real half jest exact. Checker potwierdza ten domain PRZED division.

Imag s0 ma I0=(1+U)I+2eta: mean imaginary jest kontrolowane po swoich
operandach, nie po dużym B. Nie trzeba równości ta=tb ani normalności imag.
W każdej instancji I0<hmin i[ hmin,hmax ]⊂[1/16,2^35].

Direct source L=c/h ma norm<2 i error≤2U wobec L_H=c/h. Source muladj,
neg/add daje real pivot error≤eD=64U*hmax oraz imaginary error≤eD wobec
ACTUAL Im(s0_C). Są to te same wyprowadzone coefficient bounds co NODE2,
sprawdzone ponownie dla lambda każdej instancji. Używa się generic finite
add, więc half-created subnormal nie jest po cichu zachowany bitowo.

## 4. Silny real transfer do OBU children

Harmonic lower identity:
`2ra*rb-m(ra+rb)=m((ra-m)+(rb-m))+2(ra-m)(rb-m)≥0`.
Stąd ideal paired pivot

```
P0=2ra*rb/(ra+rb)-(ta-tb)²/[2(ra+rb)] ≥m-I²/m.
```

H0 i H są positive; ich binary LDL multipliers mają norm≤1. Variational
Schur lemma (minimizer norm²≤2 i matrix error≤2delta) daje
|P_H-P0|≤4delta. Nie tracimy całego I ani połowy m na każdym poziomie.
Source transfer przed outward rounding:

```
d00: m0=hmin, M0=hmax, I0=(1+U)I+2eta;
d11: m1=m-I²/m-4delta-eD,
     M1=(1+64U)*hmax, I1=I0+eD.
```

Wszystkie actual scalar operands mają wcześniej cap2^100: split inputs B,
sum/diff≤2B+error, unit rotations, h/c≤hmax po positivity, L<2,
muladj norm<4hmax. Positivity computed d11 jest WNIOSKIEM tej kolejności,
nie premise dzielenia lub pierwszego child.

## 5. Exact-reference errors i jawne rounding directions

Jeżeli e=E+delta, entry error H do independent H_ref≤e. Oba multipliers
mają norm≤1, więc L error≤min(2,2e/lambda)+2U, Schur real error≤4e+eD.
Uwzględniając imaginary source output:
`E0≤e`, `E1≤4e+I0+2eD`.
Można ponadto użyć independently proved positive bounds obu wartości:
complex error≤max(Mchild,R)+Ichild. Checker bierze minimum tych DWÓCH
udowodnionych majorantów, nie przyjmuje małego błędu jako hypothesis.

Wszystkie porównania są exact QQ. Rekordy są zaokrąglane na stałej siatce
2^-40: lower przez floor, upper/I/E/delta przez ceiling. Każde rounding
jest outward i kosztuje<2^-40; nie zaokrąglamy kolejno do rosnących potęg2.
Funkcja step w certificate.py jest wyliczeniem dokładnie powyższych
symbolicznych lemmas, a nie niezależnym testem dodatniości tabelki.

## 6. Instancja level7 i wszystkie paths

Po mocnym S8 wybieramy każde e∈Fin2. LEVEL7 ma12 records na b,k,e i wszystkie
64 frequencies. Następnie obie outputs każdego S_l stają się inputs S_(l-1).
Length(path)=8-l i len(array)=2^l; powtarzamy aż l1. Exact checker odwiedza
1524 node records i potwierdza wszystkie premises/rounding transitions,
strict lower positivity oraz I<m. Nie ma missing level/path.

Source square twiddle rows dla SplitDeep8..2 zostały sprawdzone RBF256:
127 complex pairs, adjacent roots x,-x, child x², właściwe phases/Adj/half.
Przy level l node count6*2^(8-l), physical frequencies2^(l-1), więc768
positions na każdy level — wyprowadzone, nie założone jako poprawność.
Nie wywołuje się terminalnego SplitDeep1/IW1I w tym builderze.

Otrzymane uniform summaries dla WSZYSTKICH outputs levels7–1:

```
branch0: Re>49/100, Re<8388610, |Im|<1/32768, reference error<32768;
branch1: Re>27, Re<2147483650, |Im|<9/8, reference error<4294967296;
norm L<2, norm L-reference<3.
```

Actual records są ciaśniejsze i pozostają w TOWER_CERTIFICATE. Wszystkie
real denominators/pivots normal; d00 imaginary może być subnormal po half,
d11/L components normal/zero. Primitive div[1/16,2^35] jest RE-ESTABLISHED
przez nowy INIT/STEP; nie wynika automatycznie ze starego c2 upper2^36.

## 7. Warstwa B: terminating actual execution, nie sam frame

Niech Good(d,e) opisuje entry level d+1 z konkretnego(b,k,path), jej exact
immutable input snapshots i odpowiedni numeryczny rekord warstwy A.
Nie zawiera completed child execution. Kernel TowerExecution.execute
modeluje partial source operations w kolejności first split → first child
→ local LDL → second split → second child. Jego successful_execution
wyprowadza some tree z base/step domains, nie przyjmuje gotowego całego tree.
Poniższe rozlicza premises tego theorem na source, dla d≤6; Good poza tym
zakresem można przyjąć false. Frame jest osobnym source-memory bindingiem.

**Base inner1.** Inputs są SplitDeep2/Adj entry z A. Local LDL2 ma już
wykazany positive h/domain; wszystkie loops i primitive instructions są
finite/defined, kończą się. Dwa L words trafiają do tree[0:2], następnie
literalne source stores tree[2]=g00[0],tree[3]=tmp[0] zapisują real positive
raw leaves. Return4. Nie ma fikcyjnego inner0 lub SplitDeep1.

**Step inner(k),k>1.**
1. g00=d00 input pochodzi z wcześniejszego split i ma Inv dla child0
   niezależnie od jeszcze niewykonanego parent LDL. Wykonujemy source split
   g00/Adj, uzyskując Good(k-2,first entry). Wszystkie domains są wcześniejsze.
2. IH daje ordinary defined terminating first child, jego numerical facts,
   tree consistency i write footprint. Child tree/scratch są disjoint od
   parent inputs, więc IH-frame zachowuje g00/g10/g11 rodzica.
3. Dopiero teraz wykonujemy local LDL2 na niezmienionych inputs, używając
   wyprowadzonego local-domain theorem. Determinizm wiąże L,d11 z A.
4. Teraz d11 ma proved Inv child1. Source split/Adj czyta je zanim scratch
   zostanie użyty ponownie. IH daje terminating second child i właściwe tree.
5. Source return n+size(first)+size(second) jest ordinary defined return.

Recursive rank k ściśle maleje i kończy na1. Source loops mają skończone
znane długości; restoring div ma55 iteracji i norm64 sześć steps. Nie ma
unproved operation, UB, y0 lub NaN/overflow w required domain. Totalność
tych12 specified subtrees wynika z powyższej indukcji, nie z obserwacji C.

## 8. Memory, layout i matching A/B

API: legal aligned buffers i lifetimes, disjoint tree/scratch od input
arrays; repeated g00=g11 read alias jest dozwolony. Source inner(k) ma
n=2^k, tmp first half/sibling prefix[0,n), child scratch od n; parent d11
także w tmp+n. First child outputs do tree+n, drugi do tree+n+size(k-1).
Input snapshots nie są destinations. Lower child działa na własnym suffixie,
więc current inputs są zachowane; generic Tower.frame jest instantiated
przez source destination inspection i loop bounds.

Tree size T1=4,Tk=n+2T(k-1)=(k+1)2^k. Scratch base2, dalej max(n+S(k-1),2n)
≤2n. Blocks L/first/second są rozłączne i pokrywają dokładnie tree; raw leaf
stores są osobną base końcówką. Source-order trace różni się od layout:
first subtree pisze przed local L, mimo że L leży w prefixie. Kernel trace/
partition/size lemmas i scalar proof są wspierające; pełne C binding jest
analityczne, bez deklaracji zweryfikowanego GCC.

Dla inner7:1024 tree,256 scratch,896 internal L i128 raw leaves. Dwanaście
entries daje10752 L i1536 leaves. Native observer wrappers wywołują każdą
oryginalną operation raz; unchanged body, alias checks, exact traces i
leaf observations sprawdzają binding. Nie zastępują uniwersalnej B proof.
Pełne wcześniejsze loader/tree assembly i normalize pozostają osobne.
