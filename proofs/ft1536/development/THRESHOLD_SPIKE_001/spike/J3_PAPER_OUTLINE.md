# J3 — outline paperu

**Tytuł roboczy:** *Share-native key derivation for threshold FT1536:
from G(seed*) map to MPC circuits*

## 1. Problem
Trusted dealer = „moment" (klucz istniał w całości). Cel: klucz urodzony z udziałów.

## 2. Nasza przewaga
Formalna mapa `G(seed*)` (R1 / `R5_R1_INTERFACE_NOTES.md`) — instrukcja
przebudowy wyprowadzania na share-native (kernelowo udokumentowane).

## 3. Konstrukcja (spike)
- Shamir GF(256) + `mul_shamir_reshare` (Lagrange re-deal, bez reconstruct a,b)
- `H_fold` → `G_frag` (64 B) → `derive_key_material_native` (128 B)
- Pedersen VSS: weryfikacja udziału bez interpolacji (`verify_exp_share`)
- Accept-bit `u<w` bez reconstruct(u) (`P_w` Horner, deg 255)
- Select first-accepted bez otwierania accept-bits
- Harness: osobne procesy (`iso dkg` / `ped-demo`)

## 4. Koszty (`I1_COST_NOTES.md`, `I3_SHAKE_MPC_COST.md`)
| | |
|---|---|
| H_fold | 16 Beaver |
| G_frag 64 B | 64 reshare |
| native 128 B | 128 reshare |
| accept bit | 255 Beaver |
| SHAKE256 w MPC | ~10³–10⁵ × G_frag |

## 5. Własności / dowody
139+ testów (`TESTS.md`); piny wektorów; mutacje G_frag; H3 reconstruct=FAIL.

## 6. Granice
Dealer w keygenie zostaje do pełnego share-native keygen; Klein/F04 otwarte;
nie threshold-FT-product; R1 formalne ≠ `G_frag`.

## 7. Dalsza praca
Osadzić `G(seed*)` (pytania R5); SHAKE-gadget; pomiar rund; porównanie wariant A.
