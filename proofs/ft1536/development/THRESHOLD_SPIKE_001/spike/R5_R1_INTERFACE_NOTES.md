# R5 — R1 interface notes for TT-55 appendix (read-only research)
**Status: notka badawcza.** Źródła: KEYGEN_* (T12_1/source3/notes/run) + formal/Source3. Spike `G_frag` ≠ `G(seed*)` (TT55:9).

## 1. G(seed*) w torze formalnym
- `G(seed*) = KeygenByteGame134.evaluate env input seed* = some (.inr packet)` — KEYGEN_PUBLIC_FORWARD_159_REPORT.md:79-81; krok 5 OPEN :163.
- Lean: `evaluate (env : Env) (input : Input env) (seed : Seed) : Option Outcome` z `Execution env input seed` (KeygenByteGame134.lean:31); sukces=`some (.inr packet)` (…:59-65).
- Z := `KeygenProbability134.successMass env input` (KeygenProbability134.lean:49).
- Świadek ⇒ atom `1/2^256 ≤ Z`: `KeygenSuccessMass134.success_lower_of_witness` / `positive_iff_witness` (SuccessMass134.lean:27-38,46-48; atom KeygenSuccessMass112.lean:17; SUCCESS_112_REPORT.md:31-35).
- Region 5 R1: `evaluate` na seed9 = sukces + `KeygenModelUnlock134.package_of_witness` ⇒ `Z ≥ 2⁻²⁵⁶` (KEYGEN_R1_TAIL_TODO.md:974,1073-1076).
- Droga analityczna ε>0: STOP_AND_REPORT / nie domknięta (KEYGEN_Z_LOWER_134_REPORT.md:137-151) — R1 = jedyna konstruktywna.

## 2. Symbole/obiekty potrzebne z R1
- `Seed` = `Fin 32 → BitVec 8` (KeygenSeedEntry089.lean:18); fixture `seed9` (SEED9_R1_REPORT.md:1-4).
- `Env`/`Input env` (KeygenMakeInvocation.Env; Input=KeygenSeedPrefix092.Input (canonical env), KeygenWholeStages109.lean:14); `Execution env input seed`.
- `Outcome` = `Failure ⊕ Packet`; `Packet` = `Secret × List.Vector (BitVec 8) 2881` (Secret ≤10370 B) (KeygenWholeBytes088.lean:27-28,88).
- Z / `successMass`; `package_of_witness` → `KeygenModelBinding134.package` (KeygenModelUnlock134.lean:152-156); `certified_set_lower` |seeds|/2^256 ≤ Z.
- Bramki akceptacji: 1/1/2047/2047 + fG−gF=18433 + cert/codec (Z_LOWER_134_REPORT.md:~85-95).
- Minimalny zestaw z R1: (a) sygnatura `evaluate`/`Outcome`/`Packet`, (b) postać `packet` po emit (secretBytes/publicBytes, 2881 B pk), (c) relacja `Accepted env input seed` + seed9 świadek, (d) dowód `package_of_witness` na seed9, (e) zgodność pinów/hashi.

## 3. Pytania do toru R1
- Czy `seed9` jest w relacji źródłowej (publiczny syntetyczny)? Jaki bajtami?
- Który artefakt = kanoniczny `packet` po Region 3 (secretBytes/publicBytes, 2881 B pk)?
- Czy `evaluate = some (.inr packet)` jest już zaakceptowane (job/commit)?
- Koszt brakujących regionów 2–4 (rundy/trójki) — czy wolno liczyć na udziałach?
- Czy `Failure` (`.inl`) ma domkniętą postać fail-closed dla obwodu MPC?
- Czy `env`/`input` można zamrozić jako pin interfejsu?
- Czy 2^-256 atom jest jedynym dołem, czy wolno `certified_set_lower`?
- Stop-and-report: przy rozjeździe seed/packet/hash — kto w R1 rozstrzyga?

## 4. Czego NIE ma lokalnie (w spike/)
- Brak `.lean` w spike/; formal/Source3 = tor R1/s3, nie spike. Brak świadka seed9=sukces, `packet`, `Execution`.
- Brak obwodu `G(seed*)` (mnożenia/addycje na udziałach) — jest tylko `G_frag` 32→64 B.
- Brak f,g,F,G / fixed-point 73-bit (SPIKE014_NOTES.md:24); brak Klein/F04 (TT43:29).
- Brak Z>0 / p_accept / p_K; tor R1: osobne W — nie mieszać historii (TT55:8).
