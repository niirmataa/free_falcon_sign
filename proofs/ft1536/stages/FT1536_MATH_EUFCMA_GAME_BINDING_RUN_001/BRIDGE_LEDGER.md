# Mosty i właścicielstwo błędów — INTERACTIVE_GAME_AND_RESOURCE_BINDING

| ROADMAP / M0 | Ten pakiet | Status pozostałego mostu |
|---|---|---|
| T07 / M0 full Sign outcomes | E0 cap/Emit/POST_ABORT w interpreterze; atomowy Sign, SeenSign na abort | OPEN: full M0 E, STUCK/nonreturn, PRNG, byte outputs, source retry |
| T08 / M3 geometry | Q/centrowanie/Verify/extract w werdykcie; kontrprzykład centrowania zachowany; win-neutralność BoxVec | OPEN: właściwe prawo proposal FT1536, norm/center correctness, pre-cast transport |
| T09 / M4 image | publicJoint/signBody jako jądra płatnych kroków; certyfikat (c,o) jako parametr | OPEN: pointwise e_img dla właściwego muH; historycznego boundu nie podstawiono |
| T10 / M6 public sampler | `Env.simOut` = pushforward S; koszt/prawo S parametrem | OPEN: bounded bit-machine implementation, sampling law, C_pub/W_pub |
| T11 / M5 distribution | paid-step counter lemma (1+e)^Q_s; transfer Phi; Q_s=0 | OPEN: game_kernel_identification, lazy_sampling_refinement, one_key_lift, exact accepted-law comparison |
| T12 / M6 ROM reduction | jeden interpreter 3 gier, byte front-end, dyscyplina celów, eps_coll z realnych rozmiarów | OPEN: kernel identification dla pełnych gier; wektor-vs-leniwa wyrocznia na poziomie praw |
| T13 / M6 resources | RESOURCE_BOUND spec + shape sumy; liczniki kroków z maszyny | OPEN: cost_interpreter, cost_composition, reducer_bit_cost_bound |
| T14 / M6→M7 final | postać `min 1 (eps + Phi)` kernelowo; MT zdefiniowane jako wyjście B | OPEN: `exists B` w pełnym typie — wymaga pozycji z T11/T13 |

Nie dodano wartości do historycznego HOP_LEDGER. Strata konfliktów pozostaje
poza Phi (sprzęgnięcie przez `remove_bad_bound` + równość praw na ¬Bad);
nie przemieszczono freshness loss przez Phi. Nie podwojono żadnej różnicy
samplera ani timeoutu. Warunki silne: lokalne AC/moment dla właściwych
historii; historyczny scalar K||G nie jest przesłanką dla G||K. Nie wybrano
liczbowo e, e_img, e_sign, epsilon_MT, p_K ani parametru bezpieczeństwa.
MT-ISIS jest odrębną hipotezą dla marginału muKey, T=Q_H+1 i certyfikowanych
zasobów — nie hipotezą o Verify.
