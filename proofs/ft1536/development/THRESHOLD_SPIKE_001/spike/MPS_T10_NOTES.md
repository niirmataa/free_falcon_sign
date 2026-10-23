# MPS_T10_NOTES — offline NTRU fG−gF=q na ważonej sumie + domknięcie H1

Data: 2026-10-22. Wejście: suite **394/394** (F2→T9 PASS).
Wyjście: suite **400/394+6** (patrz Regresja).

## Cel T10 (z PROMPT_T10_OFFLINE_NTRU_H1.md)

1. Ważny NTRU `fG − gF = q = 18433` na ważonej sumie (Σ w_i·wkład_i)
   — procedura offline.
2. Domknięcie H1: `g2_deal_trapdoor` = retained / test-only.
3. Matrix fałszerstw + notki retained.

**NIE** jest to malicious-secure / UC / EUF-CMA / CDI proof.

## Co powstało

### T10.1 — offline NTRU na udziałach ważonego DKG

| API | Rola |
|---|---|
| `ntru_fg_gf_open_delta` | otwarcie **wyłącznie** różnicy fG−gF (wartość kontrolna) |
| `ntru_fg_gf_check_weighted_shares` | `true` ⇔ różnica == stała q=18433 |
| `trapdoor_contribution_digest` | zgoda na wkłady (SHA3-256) przed DKG |

Procedura offline (analog U2/W1 `ntru_fg_gf_check_shares` /
`ntru_relation_check`, ale na i16-poly Z_P):

1. Strony mają udziały f,g,F,G z ważonego DKG (T9.1) + zobowiązania VSS.
2. (Opcjonalnie) zgoda na digesti wkładów (`trapdoor_contribution_digest`).
3. Ring-mul na udziałach: f⊗G oraz g⊗F (`i_poly_mul_ring_shares`).
4. Różnica na udziałach → **open tylko różnicy** (nie f,g,F,G).
5. Wynik == `[18433, 0, …, 0]` ⇒ relacja trzyma; inaczej fail-closed.

Koszt: 2× ring-mul O(N²) reshare-muls (G-3) + open N wartości kontrolnych.

### T10.2 — domknięcie H1 (co jest „momentem”, co nie)

| Jest „momentem” (jawne / retained) | NIE jest momentem (tor produkcyjny) |
|---|---|
| Open różnicy fG−gF (kontrola 18433) | Brak open f,g,F,G |
| `g2_deal_trapdoor` (clear f,F w dealu) | `dkg_trapdoor_from_weighted_contributions` |
| Reconstruct w testach (oracle / pin F2) | VSS + range proof F na udziałach |
| `delta_known` (model MAC G-2) | MAC na s1,s2 (T9.3) |
| Digest wkładów (jawny, nie sekret) | Udziały f,g,F,G po DKG |

**H1 domknięte w sensie spiku:** tor klucza = ważony DKG + offline NTRU
check. `g2_deal_trapdoor` zostaje **retained / test-only** (nie kasować).
To **nie** jest pełna ceremonia keygen NTRU ani „brak dealera klucza”
w sensie UC — wkłady wciąż powstają per partia i muszą sumować się
do poprawnego NTRU (sprawdzane offline).

### T10.3 — pełne Beaver w ring-mul (opcjonalnie)

**Retained + pomiar.** Wariant `i_poly_mul_ring_shares_auth` (pełne
auth triples na 4N²) jest API z T9.3; złoto używa tańszego `*_mac`.
Nie włączono go do toru złota (koszt ≈ 3× ring-mul w auth modelu).
Suite time baseline ~144 s (369 lib); T10 dodaje ~28 s na 6 testów
(2 ring-mul × 3 ciężkie). **Nie przekracza 2×.** Pełny Beaver w złocie
zostaje retained do osobnego pomiaru (R-G2-2 koszt).

### T10.4 — matrix fałszerstw

| Atak | Detekcja | Test |
|---|---|---|
| Zepsuta relacja NTRU (tamper udział f) | check `false` | `t10_ntru_bad_relation_detected` |
| Zepsuty wkład G w ważonej sumie | check `false` | `t10_ntru_wrong_contribution_detected` |
| Tamper ważonego wkładu (VSS) | `CommitmentMismatch` | `t9_tamper_weighted_contribution_vss_detected` |
| F ≥ q/2 w sumie DKG | `FBoundViolation` | `t9_fbound_violation_aborts` |
| Brak zgody na wkład (digest) | `digest ≠` | `t10_contribution_digest_agreement` |
| Dealer clear f,F w produkcji | brak wywołania / retained only | `t10_h1_g2_deal_retained_test_only` |

## Testy T10

- `t10_ntru_weighted_shares_ok` — ważony DKG klucza NTRU → check true.
- `t10_ntru_open_delta_is_constant_q` — różnica = [18433,0,…,0].
- `t10_ntru_bad_relation_detected` — tamper f share → false.
- `t10_ntru_wrong_contribution_detected` — zepsuty wkład G → false.
- `t10_contribution_digest_agreement` — ten sam wkład = ten sam digest.
- `t10_h1_g2_deal_retained_test_only` — produkcja bez `g2_deal_trapdoor`.

## Regresja złota

Pin F2 `n = 103747771` **nietknięty**. `t9_*`, `t8_gold_*`, `t7_gold_*`,
`t6_`, `mps4h` zielone (pełna suite w REPORT/TESTS).

## Czego T10 NIE implikuje (scope prawdy)

- **NIE** malicious-secure / UC / EUF-CMA / CDI proof.
- **NIE** „próg FT gotowy" ani pełna ceremonia publicznego keygen NTRU
  (koordynacja wkładów do Σ = poprawny NTRU jest poza zakresem —
  offline check weryfikuje wynik, nie generuje go).
- **NIE** „brak dealera klucza" w pełnym sensie (H1 = moment setupu
  wkładów; `g2_deal_trapdoor` retained).
- **NIE** pełne Beaver-triples w torze złota (retained, `*_auth` API).

## Retained (NIE kasować)

F2-1, G-1..G-3, H-1..H-4, T6, T7, T8, T9.1–T9.4, T10.1–T10.4.
`g2_deal_trapdoor` = retained / test-only (H1).
`delta_known` = retained model G-2.
`i_poly_mul_ring_shares_auth` = retained koszt (pełny Beaver).

## Powiązane

`PROMPT_T10_OFFLINE_NTRU_H1.md`, `MPS_T9_NOTES.md`,
`MPS_T8_PRSS_CDI_NOTES.md`, `Y13_MALICIOUS_MAP.md`, `FT1536_IDENTITY.md`.
