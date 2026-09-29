# VERIFY_NEXT_INTERFACE — co daje recovery i czego brakuje do Sign→Verify

Warunkowy consumer (ROUNDING_RECOVERY §4):
  recovery (|gap|<1/2 obu wide wektorów) AND joint Safe16 (precast PRZED narrow16)
  ⟹ stored pair = v_ref ⟹ v1 + h·v2 = c mod (q,Phi) dla stored pair.

Pozostały typ do Sign→Verify (jawny, nie zamknięty):
1. Uniform pre-rint gap < 1/2 (B, SOURCE_ERROR §3).
2. Safe16: uniform |w| ≤ 32767 dla obu wektorów przed castem (POST: OPEN;
   bound 4572095 nie implikuje int16; brak required-domain witnessa).
3. **center/norm compatibility lemma**: Verifier rekonstruuje s1' = center_q(c − h·s2);
   source s1 nie musi być coefficient-centered. Congruence i Q(s1,s2)<B NIE
   pociągają Q(s1',s2)<B dla formy A2 z cross terms — lokalny kontrprzykład
   (COUNTERMODELS.md); potrzebny lemma kompatybilności dla dokładnej formy
   CheckNorm, nie monotonicity postulowana.
4. Bytes/encoder path (STATIC 4096) poza zakresem one-root; retries/PRNG/M0
   eta_pre poza zakresem (TASK §6).

Eksport dla T01/T05/T06: INTEGER_RECOVERY_CERTIFICATE.json (status PARTIAL_PROOF,
flagi whole_Sign/real_PRNG/security/retry/Sign_to_Verify = false, new_M0_eta_pre
= null) — bez zmiany ich pracy lub nazw statusów.
