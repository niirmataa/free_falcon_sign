# MAP — share-native G(seed*): architektura, kolejka, koszt, ryzyka

**Status:** mapa robocza spike. Źródła nadrzędne: `K1_R1_ANSWERS_PRELIM.md` (właściciel),
`I3_SHAKE_MPC_COST.md`, `I1_COST_NOTES.md`, `R5_R1_INTERFACE_NOTES.md`, `H5_PAPER_SKETCH.md`, `TODO.md`.
Liczby kosztów = rząd wielkości (szacunek), nie benchmark.

## 1. Architektura share-native G(seed*) (ans 1: XOF/SHAKE w środku + algebra NTT/root/CRT)

| # | Warstwa | Rola | COST (I1/I3) | STATUS |
|---|---------|------|--------------|--------|
| L0 | seed shares | 32 B seed w udziałach (DKG/re-deal); brak `seed.bin` | reshare-deal ~O(n·k) gf_mul; brak rekonstrukcji | **spike istnieje** (010/013, TT-20) |
| L1 | PRNG/XOF na udziałach | seed→PRNG→SHAKE/XOF; absorpcja + squeeze na udziałach | 1 perm SHAKE256 ≈ 4×10⁴ AND/triple ≈ **10³ × G_frag**; multi-blok liniowo w blokach; głębokość ~24 → 25–50 rund MPC | **open** — jest tylko liniowy stand-in `G_frag`/`native` (I1: 1 reshare-mul/B) |
| L2 | sampler | Klein / dyskretna Gaussa + rejection; accept-bit bez otwierania | accept_bit 255 Beaver/bit (I1/I2); Klein-lite TT-40; ATMACA <180 rund | **częściowe** — probed select/accept_bit są; pełny sampler 73-bitowy **open** |
| L3 | algebra (regiony 2–4) | NTT / pierwiastki / CRT; f,g,F,G, fG−gF=18433 | tańsza w MPC (mnożenia na udziałach — ans 3 **zezwala** na ten model kosztu) | **open** — brak kodu; mapa regionów **do potwierdzenia przez R1** (ans 3) |
| L4 | packet | pk 2881 B, sk ≤ 10370 B (bufor 12289) | emit = serializacja; koszt dominuje L1 | **open** — **brak pinu artefaktu** (ans 4), region 5 / świadek niedomknięty |

Kontrakt wejścia (ans 2): seed 32 B → `KeygenByteGame134.evaluate` → `some (.inr packet)`
(R5 §1). `G_frag` 32→64 B ≠ `G(seed*)` — nie mieszać historii.

## 2. Kolejka robocza (M1..M8)

| ID | Cel | IN | OUT | Kryteria | Zależności |
|----|-----|----|-----|----------|------------|
| **M1** | Domknąć mapę warstw L0–L4 jako notatkę/ADR robocze | K1 ans 1–3, R5, ten MAP | warstwy z COST/STATUS | brak warstwy bez statusu | **NOW** |
| **M2** | Rząd wielkości XOF na pk+sk (bloki/permutacje/triple) | ans 2 (2881+10370 B), I3 §1–2 | przedział kosztu z jawnymi założeniami | założenia (rate 136 B, czynnik odrzuceń) opisane; brak fałszywej precyzji | **NOW** (rozmiary od właściciela) |
| **M3** | Sampler share-native: rejection bez otwierania bitów accept | I2 accept_bit/probed, TT-40/41, SPIKE005–007 | koszt rund/triple vs t_max; bias vs target rozliczony | brak jawnych bitów accept w transkrypcie; wektory syntetyczne | **NOW** (spike tools); parametry celu = część M4 |
| **M4** | Model kosztu regionów 2–4 (NTT/root/CRT) na udziałach | ans 3 (model OK), R5 §2 bramki akceptacji | licznik muls/region; mapa regionów | mapa oznaczona jako niepotwierdzona do czasu R1 | **BLOCKED** na mapę regionów R1 (ans 3) |
| **M5** | Schemat pinów packet/env (`ENTRY_PINS`) | ans 4 (brak pinu), ans 6 (wzór ENTRY_PINS) | draft schematu; wektory **syntetyczne** | brak twierdzenia „kanoniczny packet" | **BLOCKED** na R1 region 5 + witness (ans 4–5; evaluate OPEN) |
| **M6** | Failure → abort: zmapować `.inl Failure` na `SpikeError`/abort | ans 7, R5 §3 | nota semantyki fail-closed + test abortu | abort = odmowa/rozłączenie; zero cichej kontynuacji | **NOW** (spójne z istniejącym `SpikeError`) |
| **M7** | Wiązanie dołu bezpieczeństwa: 2⁻²⁵⁶ vs `certified_set_lower` | ans 8, R5 §1 (`success_lower_of_witness`) | zdanie wiążące po świadectwie R1 | oba doły **otwarte**; twierdzenie w zakresie świadectwa | **BLOCKED** na świadectwo R1 (ans 8) |
| **M8** | Procedura stop-and-report przy rozjeździe pinów/semantyki | ans 9, TT-55/TT-42 | nota procesu | tory raportują; **decyzja właściciela**; zero cichych napraw | **NOW** (proces) |

## 3. Koszt rząd wielkości: XOF vs G_frag (szczere estymaty)

- Wyjście: 2881 + 10370 = **13 251 B**; SHAKE256 rate 136 B/perm ⇒ **~98 bloków squeeze** ≈ **10²** perm na samą ekspansję; absorpcja + powtórki samplera (Klein) × rzędu 10⁰–10¹ ⇒ **10²–10³ perm** łącznie.
- 1 perm ≈ 4×10⁴ AND ≈ 4×10⁴ Beaver-triple ⇒ **~4×10⁶ triple** (dolny rząd) do **~4×10⁷** z powtórkami.
- vs `G_frag`: 64 reshare-muls (64 B, 1 mul/B) — 1 perm ≈ **10³ × G_frag** (I3); pełny XOF KDF ≈ **10⁵–10⁷ × G_frag**. Liniowy `derive_key_material_native` na 13 251 B ≈ 1.3×10⁴ reshare-muls — XOF jest **3–5 rzędów droższy w triple'ach**.
- Uczciwie: to I3-ballpark (bit-blast + XOR-count), **nie pomiar**; 10⁸ bramek z TODO/H5 = pełny `G(seed*)` w boolean, nie jedna perm. Dominacja kosztu = preprocessing/pasmo, nie latency (batch, I3 §3). Preferowana ścieżka: hibryd — tani łańcuch liniowy + SHAKE tylko gdy kontrakt R1 go wymaga.

## 4. Ryzyka

- **Fail-closed abort (ans 7):** `Failure` = abort protokołu; ryzyko: semantyka abort vs retry przy dużym `t_max` (TT-51) i przy powtórkach samplera nie jest domknięta — brak cichej kontynuacji w stanie niepewnym.
- **2⁻²⁵⁶ vs `certified_set_lower` (ans 8):** oba **otwarte**; wiążące = świadectwo z R1. Do tego czasu przy `G(seed*)` oba traktujemy jako cele, nie twierdzenia. Droga analityczna ε>0 = STOP_AND_REPORT (R5 §1) — nie domykać jej w spiku.
- **Ownership (ans 9):** przy rozjeździe pinów/seed/packet/hash tory raportują, **decyzja właściciela** — brak samodzielnego rozstrzygania (TT-42/TT-55). Brak pinu packet (ans 4) i brak owner-accepted `evaluate` (ans 5, cel ACTIVE/NOT_COMPLETE) = każda zgodność G(seed*) z G_frag jest dziś **nie do odbioru**.
- **Zakres twierdzeń:** spike ≠ threshold signing, ≠ bezpieczeństwo progu, ≠ standard Falcon (`BOUNDARY_*`, TODO §D). Trusted dealer = „moment" (H5).

## 5. Trzy zdania

Share-native `G(seed*)` to pięć warstw (seed shares → XOF → sampler → algebra → packet), z czego tylko L0 i szczątki L2 mają dziś pokrycie w spiku; koszt MPC zdominuje XOF/SHAKE (rzędy 10⁵–10⁷ × G_frag, 10²–10³ perm na pk+sk), a regiony 2–4 są tańsze, lecz czekają na mapę R1. Od razu da się robić M1–M3, M6, M8 (mapa, estymat XOF, sampler, abort, proces); M4, M5, M7 są zablokowane na piny/świadectwo R1 (ans 3–6, 8), a evaluate pozostaje OPEN. Do czasu pinu packet i świadectwa R1 każda zgodność z formalnym `G(seed*)` jest syntetyczna i nie podlega odbioru — rozjazdy idą stop-and-report do właściciela.
