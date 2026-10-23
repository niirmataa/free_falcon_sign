# PROMPT — T12: naprawy z audytu bezpieczeństwa (P0/P1)

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** łańcuch F2→…→T10 PASS, suite **400/400**.  
**Nowe wejście:** **audyt bezpieczeństwa 16 findings** —
`spike/SECURITY_AUDIT_T11_REPORT.md` (pełny raport + podsumowanie).

---

## Cel T12

Naprawić **P0/P1 z audytu** (znaleziska medium, wpływ na poprawność
i poufność). Nie psuć złota (engine verify, pin F2).

### Kolejność (P0 → P1)

1. **#1 Shamir mul — quorum `n ≥ 2k−1`**  
   `mul_shamir_reshare` / analogi Z_q / Z_P: walidacja `n >= 2k-1`
   (stopień iloczynu 2(k−1)). Dziś `n>=k` daje **cichy zły wynik**.
2. **#6 Pedersen blinds — pełna entropia**  
   Byte-sized blinds w `pedersen.rs` (VSS) — obserwator odzyskuje sekret.
   Zwiększyć blindy / użyć pełnych losowych z `shamir`/`curves`;
   test: commitment nie ujawnia secret byte.
3. **#2 Auth mul — sprawdzenie Beaver `c`**  
   `i_poly_mul_ring_shares_auth` / U4: triple (a,b,c) musi mieć
   c = a·b zweryfikowane (MAC / sacrifice) przed użyciem.
4. **#3 Typestate DKG → sign**  
   Signing ma wymagać **zweryfikowanego** stanu DKG + **uwierzytelnionego**
   NTRU check (T10) — nie opcjonalnego `validate` obok.
5. **#9 Jawny δ G2 → ukryte / skorelowane tagi**  
   `delta_known` + post-hoc MAC = skorelowane fałszerstwa (audyt #9).
   Zgodność z modelem Y6 (ukryte δ) albo jawne retained + test skorelowany.

**P2–P3 (maski, Eflipy, workdir iso, zeroizacja, SHAKE bitness, panic,
mailbox, bias)** — jeśli starczy czasu; inaczej retained w notce T12.

---

## Obowiązkowe ft-skills (właściciel — NA STARCIE)

1. **`/ft-tryb-pracy`** — role, raporty z dowodami, retained.
2. **`/ft-historia`** — **wczytaj historię toru z akt** (commity, meldunki,
   TABLICA_TOROW, SERCE, MPS_*_NOTES, SECURITY_AUDIT_T11_REPORT) —
   nie odtwarzaj z domysłu; **zaktualizuj historię po zadaniu**.
3. `/ft-prawda-przed-tempem` — statusy uczciwe, trzy zdania.
4. `/ft-window-discipline` — stop-and-report przy drift.
5. `/ft-secrets-hygiene` — brak sekretów w aktach.
6. `/ft-suplementy-i-pulapki` — retained przez suplementy (księga pułapek:
   dodaj #1/#6/#2 do pułapek).
7. `/ft-sage-lean` — Extra/c, KEYGEN_* **read-only**.

**Po zadaniu:** `MPS_T12_NOTES.md`, `TESTS.md`, `REPORT.md`,
`PACKAGE_INDEX.md`, `Y13_MALICIOUS_MAP.md`, **historia** (ft-historia).

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów → s1,s2 → engine verify==true | `ishare.rs`, `mpc_sign.rs` |
| Pin F2 `n=103747771` | nietknięty |
| Weighted DKG, offline NTRU, MAC s1,s2 | T9, T10 |
| SPDZ-MAC ukryte δ (Y6–Y10), auth triples (U4) | `lib.rs` |
| Pedersen VSS | `pedersen.rs` |
| Pełny audyt 16 findings | `SECURITY_AUDIT_T11_REPORT.md` |

**q=18433, N=1536, ternary** — `FT1536_IDENTITY.md`.  
**Konwencja złota:** `s2·h − s1 = t`, `encode_sig_static(s2)` → engine verify.

---

## Kryteria odbioru

1. **#1:** `n < 2k−1` → `Err` (nie cichy zły iloczyn); test algebraiczny
   (iloraz iloczynu poprawny przy n≥2k−1, błąd przy n=2k−2).
2. **#6:** Pedersen VSS — blindy pełnoentropyjne; test: commitment
   nie ujawnia secret (np. brute-force małego secretu nie działa /
   blind ≥ 32 B / losowy z securerandom).
3. **#2:** niezweryfikowany Beaver `c` → abort/MacFail; zweryfikowany → OK.
4. **#3:** signing bez zweryfikowanego DKG/NTRU → `Err` (typestate lub
   jawny parametr `validated: bool` wymuszony).
5. **#9:** skorelowane fałszerstwo MAC → wykryte (lub jawne retained +
   test skorelowany, niezależny).
6. Regresja złota: pin F2, `t10_*`, `t9_*`, `t8_gold_*`, `t6_`, `mps4h` zielone.
7. Suite ≥ 400 + nowe, 0 warningów.
8. Retained w aktach; **nie kasować** F2-1, G-*, H-*, T6–T10, ani
   findings z audytu (dopisać status naprawy do `SECURITY_AUDIT_T11_REPORT.md`).

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/{mul,ishare,pedersen,mpc_sign,lib}.rs`, testy, `MPS_T12_NOTES.md`, `SECURITY_AUDIT_T11_REPORT.md` (statusy), `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure” / „próg FT gotowy”.

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 400/400, 0 warnings (po naprawach więcej testów).

---

## Trzy zdania na start

1. **Złoto + T10 działa** — nie psuć pin F2 / engine verify.  
2. **Brak** — naprawy P0/P1 audytu (#1 quorum mul, #6 blinds, #2 triple,
   #3 typestate, #9 jawny δ).  
3. **NIE implikuje** — malicious-secure / UC / „próg FT gotowy”.

---

## Aneks — dokładne root cause z audytu (linie)

### #1 Shamir mul quorum (P0) — `mul.rs:45-74`, `ishare.rs:142-161`
`check_xs_p` akceptuje `n>=k`; iloczyn ma stopień **2(k−1)** → trzeba
**`n >= 2k−1`**. Przy `k<=n<2k-1` interpolacja daje **zły iloczyn bez błędu**.
**Fix:** guard `n >= 2k-1` w `check_xs_p` / `mul_shamir_reshare` / Z_q / Z_P.

### #2 Beaver `c` nie sprawdzony (P1) — `ishare.rs:1848-1872`, `1722-1729`
`mul_auth_zp_with_triple()` uwierzytelnia tylko `x-a`, `y-b`;
**`c.mac` ignorowane**, `c.share` wchodzi w wynik, dostaje **nowy**
MAC. Złośliwy preprocessing offsetuje `c` → fałszywy iloczyn przechodzi.
**Fix:** sacrifice / check `c=a*b` (MAC na c), albo jawne retained +
test skorelowanego fałszerstwa.

### #3 Typestate DKG→sign (P1) — `ishare.rs:2881-2898`, `3153-3189`
`dkg_trapdoor_from_weighted_contributions` zwraca `G2Trapdoor`
**bez** wymuszenia `fG−gF=q`; `mps4h_sign_shares_g2()` bierze typ wprost.
Osobny checker jest **opcjonalny** (caller-optional), z re-derowanym
`delta`. **Fix:** typestate / `ValidatedTrapdoor` wymagany przez sign,
albo jawny parametr + test „sign bez check = Err”.

### #6 Pedersen blinds (P0) — `pedersen.rs:39-45, 97-115, 119-141`
`Poly { coeffs: Vec<u8> }` — **secret i blind to u8** → 2^16 par do
brute-force commitmentu. Pipeline: `bin/iso.rs:1407` commituje `seed[0]`.
**Fix:** blindy ≥ 32 B losowe (Scalar z pełnej entropii); test:
odzyskanie secretu z commitmentu nie działa.

### #9 Jawny δ + post-hoc MAC (P1) — `ishare.rs:2671-2685`, `1748-1757`
`G2Trapdoor { delta_known: u64 }` — **klucz MAC jawny**; tagi liczone
liniowo z bieżących udziałów (także po ring-mul). Skorelowana zmiana
wartość+MAC o Δ i `delta_known·Δ` **przechodzi** zero-check.
**Fix:** ukryte δ (jak Y6) albo retained + test **skorelowanego**
fałszerstwa (nie value-only / MAC-only).

### #4/#5/#7/#8/#10 (P2) — patrz `SECURITY_AUDIT_T11_REPORT.md`
