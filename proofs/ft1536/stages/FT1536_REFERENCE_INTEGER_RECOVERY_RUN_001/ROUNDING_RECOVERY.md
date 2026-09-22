# ROUNDING_RECOVERY — nearest-even rint i znaczenie Safe16

FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001. Konsumuje literalny rint refinement
z POST/RINT_REFINEMENT (fpr-emulated.h 99–115): dla raw word z encoded
ex ≤ 1072 fpr_rint = nearest-even z symetryczną rekonstrukcją znaku (nie floor).
Rint NIE jest floor; signed zero/subnormals dają 0 (dokładnie w refinement).

## 1. Lemma rounding-gap — PROVED (kernel + controls)

Jednostki półcałkowite (słowo T = wartość T/2; podniesienie na dowolny mianownik
2^-e to dokładna skala kernel-checkowana w RINT_REFINEMENT):

- **strict gap**: |t − v| < 1/2 i v ∈ Z ⟹ rint(t) = v
  (formal/RintGap.lean `rint_strict_gap`; postać T = 2v).
- **equality 1/2 — rozliczenie parzystości (tie)**: dla t = v + 1/2 dokładnie
  rint = v gdy v parzyste, a rint = v+1 (sąsiad parzysty) gdy v nieparzyste
  (`rint_tie_even_low`, `rint_tie_odd_up`, `rint_tie_odd_never_low`). Pokrywa
  oba znaki (T = 2v+1 biegnie po wszystkich nieparzystych) i −0.
- uniqość obrazu w strict gap (`rint_strict_unique`) i postać parowa
  (`rint_pair_recovery`).
- Czysty log, bez sorry/admit/native_decide/ukrywania ostrzeżeń; aksjomaty
  tylko standardowe [propext, Quot.sound] (logs/07).

Kontrole niezależne: checks/gap_composition.py `rint_tie_controls` — 1078 cases
(880 strict + 198 tie, granice ±1/2, ±3/2, −32768.5, 32767.5, znaki obustronnie)
modelu bitowego vs dokładny oryginał Fraction: 0 mismatch; recovery_fail = 0.
Kontrola źródłowa: checks/c_slice (3×20128 cases, normal/ASan/UBSan, byte-identic,
preflight ex ≤ 1072 przed native call) vs niezależny oryginał QQ: **0 mismatch**
(oracle_result.json). Scope fixtures jawny (brak kluczy/Emitted — synthetic).

## 2. Zastosowanie do actual words — WARUNKOWE (B otwarte)

Dla każdego z 3072 actual slow pre-rint zachodzi implikacja:

```
|pre_rint − v_ref,r| < 1/2   ⟹   w_r = v_ref,r          (obiekt 1536+1536)
|pre_rint − v_ref,r| = 1/2   ⟹   w_r = v_ref,r ↔ v_ref,r parzyste (tie)
```

Przesłanka |gap| < 1/2 **nie jest wykazana uniformnie** (SOURCE_ERROR: bound
6086.4 ≥ 1/2). Zatem equality wide-rint (w1, w2) = v_ref pozostaje
**niezamknięta** — brakujący typ = uniform source-instantiated gap bound z
SOURCE_ERROR §3. Zbyt luźny bound nie jest kontrprzykładem równości (TASK §5).

## 3. Rozdzielenie wide/narrow/stored — Safe16 pozostaje OPEN

1. **wide ints** (fpr_rint, int64, |w| ≤ 4572095, margin int64 = 9.22e18):
   rint refinement + lemma powyżej; tu działa recovery.
2. **narrow16** (PRECAST): `(int16_t)w` — implementation-defined decode
   (PRECAST_DISPOSITION); uniform bound 4572095 **nie** zawiera się w
   [−32768, 32767] — Safe16 wymagane PRZED 1931/1932 nie jest wykazane
   (POST precast.Safe16_proved = False; mój zakres nie zamyka go — nie ma
   też required-domain witnessa; brak = missing proof, nie atak).
3. **stored norm Q<B** (CheckNorm po 3388): nie wolno używać jako przesłanki
   Safe16 ani recovery (kolejność wymagań zachowana).

## 4. Consumer warunkowy (bez kompozycji nieuprawnionej)

`recovery (gap<1/2 dla obu wektorów) AND joint Safe16 (PRECAST przed cast)`
⟹ stored pair = v_ref ⟹ congruence (CONGRUENCE.md) dla stored pair.
H6P kontroluje BadPrecast w grze IID, ale bez recovery nie daje tego consumeru;
kolejność nie jest odwracana. Dalsze zobowiązania Verify: VERIFY_NEXT_INTERFACE.md.
