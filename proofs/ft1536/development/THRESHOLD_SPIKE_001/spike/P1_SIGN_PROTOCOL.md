# P1 — szkic protokołu progowego podpisu FT1536 (k-z-n)

**Status: SZKIC PROTOKOŁU. To NIE jest threshold signing. Nie deklarujemy bezpieczeństwa progu.**
Źródła: `DESIGN.md` (wariant B + A-kontrola), `MAP_GSEED_SHARE_NATIVE.md`, `M4_REGION_MAP.md`,
`TT43_F04_vs_2026_1300.md`, `I1_COST_NOTES.md`, `spike/src/{pedersen,cmp,select}.rs`, `M6_FAILURE_ABORT.md`.
COST = rząd wielkości (I1/I3/M4), nie benchmark. OPEN = brak w spiku.

## 1. Model

- Próg **k-z-n**, k≥2, n>k (tolerancja padającego; k=n = „obaj albo nikt", patrz DESIGN).
- Strony progu P_1..P_n; po dealerze/DKG żadna nie widzi pełnego sekretu.
- **Udziały (zamek):** seed* (32 B) w Shamir-udziałach s_i — wariant B (rekomendacja toru);
  tor A = udział pułapki τ_i=(f_i,g_i,F_i,G_i) jako kontrola porównawcza. Pełny klucz
  prywatny **nigdy nie istnieje w całości** (własność konstrukcyjna, nie dowód redukcji).
- Wyprowadzanie klucza: share-native `G(seed*)` (L0–L4, MAP); w spiku tylko liniowy stand-in
  `G_frag` (32→64 B) / `derive_key_material_native` (128 B) — **to nie jest** `G(seed*)`.
- **Weryfikacja:** jeden zwykły podpis FT1536 (F04/F05); weryfikator nie uczy się progu
  ani udziałów — widzi wyłącznie bajty podpisu (§4).

## 2. Protokół (szkic) — rundy

| # | Runda | Robótka | COST | OPEN / w spiku |
|---|-------|---------|------|----------------|
| R0 | **Setup (Pedersen / VSS)** | Shamir na seed*; zobowiązania `C_j=g^{a_j}·h^{r_j}`; strona i: `g^{s_i}·h^{t_i}=Π C_j^{x_i^j}` w przestrzeni wykładników | ~O(n·k) gf_mul + 1 runda deal | **w spiku (prototyp):** `pedersen.rs` (Ristretto, zeroize H-31); NIE pełne DKG — dealer = model testowy |
| R1 | **Derive key shares** | materiał klucza na udziałach: `G_frag`/`native` (MPC-add + reshare-mul) | 1 reshare-mul/B (I1: G_frag 64 muls, native 128) | **w spiku: stand-in liniowy**; obwód `G(seed*)` (L1 XOF/SHAKE ~10²–10³ perm, L3 algebra) = **OPEN** |
| R2 | **Nonce shares** | krótkie v / nonce powstaje w udziałach; brak rekonstrukcji pełnego nonce | jak R1 + próbkowanie; XOF dominuje (I3: 10⁵–10⁷ × G_frag) | **OPEN** — brak toru nonce w spiku; zakłada ten sam sampler co R3 |
| R3 | **Sampler / Klein-lite** | dyskretna Gaussa + rejection; accept-bit bez otwierania u; „pierwszy przyjęty" na udziałach | accept_bit **255 Beaver/bit** (I1, Horner P_w); select ≈ **259/bit** okna; lit. ATMACA <180 rund | **częściowo w spiku:** `cmp.rs` (P_w, tylko maski d,e), `select.rs` (sel+found); **OPEN:** Klein ~73 bit, bias |
| R4 | **Arytmetyka podpisu na udziałach** | domknięcie F04/F05 fixed-point na udziałach (montymul; fG−gF=18433) | M4: R2 NTT ~1.3×10⁴ muls, R3 ~10³–10⁴, R4 solver **UNKNOWN** | **OPEN** — brak kodu; mapa regionów 2–4 **niepotwierdzona przez R1** (ans 3) |
| R5 | **Otwarcie: TYLKO podpis** | quorum k stron składa udziały wyniku → bajty podpisu FT1536 | 1 reconstruct | **szkic kontraktu** (§4); brak pinu artefaktu (M5) |

Preprocessing: trójki/PRSS (w spiku dealerski = model testowy). Dominacja: preprocessing/pasmo
(I3), nie latency.

## 3. Fail-closed (M6)

- Błąd = **abort** (odmowa/rozłączenie): MAC fail, VSS/spójność, pin — zero cichej kontynuacji.
- `Failure` → `SpikeError`/`Err`; sukces = `evaluate = some (.inr packet)`.
- Fałszywy udział → `InconsistentShare` → derive **blokowany** (nie cichy zły — wynik spike 001/002).
- `AllRejected` = nowe okno (TT-51), nie „cichy sukces"; bias odrzucania = wyciek → stop-and-report.
- Rozjazd pinów/semantyki (M8): tory raportują, **decyzja właściciela** — brak samodzielnego rozstrzygania.

## 4. Kontrakty jawności

| PUBLICZNE (OPEN) | NIGDY publiczne |
|------------------|-----------------|
| **bajty podpisu FT1536** (jedyny output) | seed*, pełny klucz prywatny |
| μ, parametry jawne, zobowiązania C_j, piny R1 | pełny nonce / wektor v |
| ewentualnie jawny `found` (czy okno trafiło) | accept-bity, maski d/e, udziały, stany pośrednie |

Weryfikator widzi jeden zwykły podpis FT1536; nie dowiaduje się o progu, liczbie stron ani o sekretach.

## 5. Braki do pełnego FT

1. **Klein ~73-bit** MPC dla F04/F05 (nie standardowego Falcona) + budget precyzji (TT-43).
2. **Obwód `G(seed*)`**: L1 XOF/SHAKE na udziałach + L3 NTT/root/CRT (regiony 2–4) — `G_frag` ≠ `G(seed*)`.
3. **Kontrola rejection** bez otwierania accept-bitów i rozliczenie biasu (P0.1; pomiary TV ≠ dowód).
4. **Piny R1**: packet 2881 B / sk ≤ 10370 B, region 5, witness, owner-accepted `evaluate` — bez tego brak odbioru.
5. Złośliwe bezpieczeństwo (SPDZ-MAC), DKG (nie dealer), reshare/refresh/dropout, UC — **nie wykazane**.

## 6. Trzy zdania

Model k-z-n na wariancie B: strony trzymają udziały seeda, wyprowadzają materiał klucza i nonce na udziałach, a na zewnątrz wychodzi wyłącznie pojedynczy podpis FT1536. Szkielet rund (Pedersen → derive → nonce → sampler/Klein-lite → arytmetyka na udziałach → open-sig) ma dziś pokrycie tylko w setupie Pedersena, liniowym stand-inie `G_frag`/`native` oraz probed accept-bit/select; Klein 73-bit, obwód `G(seed*)` i rejection są OPEN. Do pełnego FT brakuje Klein 73-bit, obwodu `G(seed*)`, kontroli rejection i pinów R1 — deklaracje bezpieczeństwa progu pozostają celami, nie twierdzeniami.
