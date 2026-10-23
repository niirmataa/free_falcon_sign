# K1 — odpowiedzi wstępne właściciela (2026-10-20)

| # | Pytanie | Wstępna odpowiedź |
|---|---|---|
| 1 | algebraiczne czy SHAKE/XOF? | **SHAKE/XOF w środku** (seed→PRNG→sampler) + algebraika (NTT/root/CRT) — koszt MPC **zdominowany przez permutacje XOF** |
| 2 | ile bajtów wyjścia | pk **2881 B**, sk ≤ **10370 B** (bufor 12289), seed 32 B |
| 3 | mnożenia na udziałach w regionach 2–4 jako model kosztu | **tak**, ale mapa regionów do potwierdzenia przez R1 |
| 4 | pin artefaktu packet | **NIE MA** — świadek jeszcze nie domknięty (region 5 otwarty) |
| 5 | evaluate owner-accepted? | **NIE** — nadal OPEN (cel ACTIVE/NOT_COMPLETE) |
| 6 | pin env/input | możliwe wzorem **ENTRY_PINS** — do zdefiniowania przez R1 |
| 7 | forma Failure dla MPC | **fail-closed = abort protokołu** (u nas fail-closed w silniku) |
| 8 | 2⁻²⁵⁶ vs certified_set_lower | wiążące będzie **świadectwo z R1**; oba otwarte — przyjmujesz przy G(seed*) |
| 9 | ownership stop-and-report przy rozjeździe | **Ty** — tory raportują, decyzja właściciela |

## Implikacje (do mapowania)
- Koszt: XOF/SHAKE dominuje (I3: 10³–10⁵ × G_frag / perm; ~10² bloków na pk+sk ⇒ **10⁵–10⁷ × G_frag** rząd wielkości).
- Regiony 2–4 (NTT/root/CRT) = algebraika — tańsza w MPC; mapa do potwierdzenia.
- Brak pinów packet/env — wektory spike zostają syntetyczne do R1 region 5.
- Failure = abort (fail-closed) — spójne z naszym `SpikeError`.
