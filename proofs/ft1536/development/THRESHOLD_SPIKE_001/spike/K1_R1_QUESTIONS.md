# K1 — pytania do toru R1 (gotowe do przekazania)

Właścicielu: to jest lista do R1/s3 (osobny tor). Nie odpowiadamy tu za R1.

## Kontekst
Spike T-THRESHOLD ma share-native `G_frag` (syntetyczny). Formalny
`G(seed*) = KeygenByteGame134.evaluate env input seed* = some (.inr packet)`
(za `KEYGEN_PUBLIC_FORWARD_159_REPORT.md:79-81`, `R5_R1_INTERFACE_NOTES.md`).

## Pytania

1. **Czy `G(seed*)` jest algebraiczne czy SHAKE/XOF?** (wyznacza koszt MPC —
   `I3_SHAKE_MPC_COST.md`: 1 perm ≈ 10³–10⁵ × G_frag).
2. **Ile bajtów wyjścia** produkuje `evaluate` (pk 2881 B + secret ≤10370 B z R5)
   — ile bloków XOF / ile kroków algebraicznych w torach 2–4?
3. **Czy wolno liczyć mnożenia na udziałach w regionach 2–4** (mq_NTT, root solver)
   jako model kosztu share-native?
4. **Kanoniczny artefakt `packet`** po `some (.inr packet)` — pin/hash do testów?
5. **Czy `evaluate = some (.inr packet)` jest gdzieś zaakceptowane** (owner accept)
   czy to nadal OPEN w regionie 5 (`KEYGEN_R1_TAIL_TODO.md`)?
6. **`env` / `input`** — czy można je przypiąć (pin) dla powtarzalnych wektorów?
7. **`Failure`** — domknięta forma fail-closed dla ścieżki MPC?
8. **2^-256 atom vs `certified_set_lower`** — które jest wiążące dla progu?
9. **Stop-and-report przy rozjeździe** pinów/hashy G(seed*) vs nasze `G_frag` —
   czyj jest ownership decyzji?

## Co dostajemy od spiku (do testów po odpowiedziach)
- `derive_key_material_native` / `G_frag` jako baseline kosztów
- Pedersen VSS, procesy (`iso`), piny (`VECTOR_PINS.md`)
- Wątek: `K1_R1_QUESTIONS.md` → odpowiedzi → osadzenie obwodu
