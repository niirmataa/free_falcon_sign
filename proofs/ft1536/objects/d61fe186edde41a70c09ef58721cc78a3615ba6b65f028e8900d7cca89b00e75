# EXACT_SKELETON — niezależna referencja całkowita i mapa Z(Y)

FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 (ROADMAP T03). Projekt: Niirmata;
attribution Falcon Project / Thomas Pornin zachowana. Pin source: 56974571…a0985.
Frame: exact-real skeleton z **actual L/basis words jako fixed constants**
(dozwolone przez TASK §3); definicja referencji nie używa source output.

## 1. Definicja niezależna (Z[X]/Phi, Phi = X^1536 − X^768 + 1, q = 18433)

Niech B = [[g, −f], [G, −F]] (dokładne współczynnikowe sekrety; det B = fG − gF = q).
Dla required H niech Y = (Y_1..Y_3072) będą integer returns rzeczywistych scalar
calls w literalnej kolejności (§2). Definiujemy **mapę placementu** Z(Y) = (a, b):

```
Z(Y)[slot] = +1 * Y[wywołanie przypisane do slotu]   (a: 1536 slotów, b: 1536)
v_ref := [c, 0] − Z(Y)·B = (c − a·g − b·G,  a·f + b·F).
```

Z jest signed permutationem zbudowanym WYŁĄCZNIE z kolejności wywołań i konwencji
merge (§3) — niezależnym od c, klucza, targetów, L, sigma i wartości source.
Pełna tabela 3072 wierszy: checks/z_map_full.json (weryfikacja: bijekcja).

## 2. Literalna kolejność wywołań (falcon-sign.c 1616–1839, JOINT/SOURCE_ORDER)

1. Root (ffSampling_fft3, logn=10): najpierw gałąź **t1→(a-side z1 = b)**:
   split_top → depth1(tree1), MergeTop → z1; potem t0b = t0 + z1·L (intercall
   update), gałąź **t0 (z0 = a)**: split_top → depth1(tree0), MergeTop, final
   subtraction tego samego z1·L (recomputed CM: te same operand bits).
2. Cubic (ffSampling_depth1): child **2 → 1 → 0**; child1 target = t1 + z2·l21,
   child0 target = t0 + z1·l10 + z2·l20; po każdej gałęzi odejmowanie tych
   samych recomputed produktów.
3. Binary inner (k>0): najpierw right/tree1 (target t1), potem updated left/tree0
   (t0 + z1·l), final subtraction recomputed z1·l.
4. Terminal (logn=0): pierwszy callback **Y1** (mu1, sigma·IW1I) → z1; rx = half;
   drugi callback **Y0** (updated mu0' = old mu0 + rx, sigma) → z0; na końcu
   r0 = (mu0' − Y0) − rx (anulowanie rx).

Zliczenie: 2·3·2^8 bloków terminalnych = 1536 bloków × 2 = **3072 wywołania**
(I(0)=2, I(k+1)=2I(k), D(9)=1536, R(10)=3072 — JointOrder); 768 bloków na
gałąź root. Kontrola kolejności i parowania: checks/skeleton_cancellation.json
(E2_call_order_*, E2_terminal_pair_mu1_then_mu0).

## 3. Konwencje merge i placement (signs/permutations zachowane)

Źródło (falcon-fft.c merge_fft/merge_deep_fft3/merge_top_fft3) realizuje w domenie
evaluation dokładnie te odwzorowania, których exact reference (H6P
SOURCE_NOISE_MAP) jest:

```
binary/cubic-child merge:  out[2i] = u0[i], out[2i+1] = u1[i]   (f = u0(X^2)+X u1(X^2))
top cubic merge:           out[3i+c] = v_c[i]                   (f = v0(X^3)+X v1(X^3)+X^2 v2(X^3))
```

Konkatenacje X są modulo Phi z wraparound X^1536 = X^768 − 1 (w merge pełnego
stopnia wraparound nie występuje: deg ≤ 1535). Stąd każdy merge jest
**±-placementem współczynników ze znanymi indeksami** (znaki +1 przy tych
konwencjach; twiddle/rev8 i layout 4608-root są rzeczywistością slotów
evaluation i nie zmieniają placementu współczynników — fizyczny slot ↔ indeks
współczynnika wg SOURCE_ORDER.json/H6P, „root r_(3v+k) = 1+6rev8(v)+1536k,
slot 3v+k"). Formuły indeksów implementuje scripts/skeleton_cancellation.py
(resolve); kontrola: bijekcja 3072 wywołań → 2×1536 slotów.

## 4. Tożsamość anulowania — residual = target − Z(Y)

**Teza (per-slot):** w exact skeleton (dokładna arytmetyka, actual L jako
dowolne stałe, recomputed products równe bitowo) zwracane residua spełniają
dokładnie z0 = t0 − M0(Y_lewej), z1 = t1 — M1(Y_prawej), gdzie M0/M1 są
kompozycjami placementów z §3; czyli (x, y) = t − Z(Y).

Dowód (indukcja po drzewie; kernel dla kroku: formal/SkeletonCancel.lean):
- terminal: z1 = t1 − Y1; z0 = (t0 + rx − Y0) − rx = t0 − Y0 (terminal_rx_cancel).
- binary: z1 = t1 − M1 (ind.); t0b = t0 + z1·l; lewa gałąź daje z0m = t0b − M0;
  final: z0 = z0m − z1·l = t0 − M0 — **zależność od l znika dokładnie**
  (binary_node_residual).
- cubic: dwa produkty l21/l10/l20 anulują się tak samo (cubic_node_residual,
  cubic_node_residual_c1, compose_step2).
- root: jw. z Lroot (root_node_residual).
Merge jest liniowy i merge∘split = identity (współczynnikowo: interleave/deinterleave),
więc zastosowanie merge do (t_child − m_child) daje t_parent − M(...) — stąd
forma „t − Z(Y)" przechodzi przez poziomy; Z jest dokładnie placementem §3.

Kontrole (checks/skeleton_cancellation.json, dokładne liczby wymierne):
- E1 (K=3, rationalne L, wymierne targety, całkowite Y): residual == t − Z(Y)
  **dokładnie**; E1b: suffix(t − Z) == [c,0] − Z·B dla syntetycznego klucza
  z det B = q (tożsamość §5).
- E2 (K=9, pełny kształt 1536/3072, całkowite dane): jw. + bijekcja mapy +
  kolejność literalna.
- Mutacje wykryte: drop final subtraction, swapped terminal pair order, wrong
  sign mapping, swapped root branch order, source-output-as-reference (w modelu
  z jitter zaokrągleń; w czystym exact skeleton mutacja jest **równoważna**
  — wykazane wprost zamiast symulowanego wykrycia, TASK §7). NOOP nietrafiony.

## 5. Suffix i postać v_ref (POST/POSTPROCESSING_MAP, do_sign 1902–1932)

Suffix (exact words): out0 = x·b00 + y·b10 = x·g + y·G, out1 = x·b01 + y·b11 =
−(x·f + y·F). Dla (x, y) = (t0 − a, t1 − b) i exact targetu t = (−cF/q, cf/q):
t0·g + t1·G = c·(fG − Fg)/q = c oraz −(t0·f + t1·F) = 0 (checks C2).
Stąd exact-skeleton pre-rint = (c − a·g − b·G, a·f + b·F) = **v_ref** — definicja
§1 jest więc exactly wartością exact-skeleton suffixu, nie source output.

## 6. Granica (mixed boundary, jawna)

Kernel Lean (formal/SkeletonCancel.lean) dowodzi per-slot kroków anulowania dla
abstrakcyjnych wartości Int; przeniesienie na współczynnikowe parę (a,b) ∈ R^2
(wiektory) i exact sprawdzenia pierścieniowe/QQ są w checks/skeleton_cancellation.py
i checks/exact_ring_checks.py (dokładna arytmetyka, niezależna od FFT portu).
Liniowość merge i merge∘split = id w ramach R = Z[X]/Phi: exact controls (E1/E1b).
Nie jest to kernelizacja kompilatora/C ani whole-Sign. Różnica actual source ↔
exact skeleton (rounding) jest przedmiotem B (SOURCE_ERROR.md) i NIE jest
pominięta — patrz ERROR_LEDGER.md.
