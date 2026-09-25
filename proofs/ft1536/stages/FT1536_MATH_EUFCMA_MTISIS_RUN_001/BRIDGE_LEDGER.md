# Mosty i właścicielstwo błędów — T12.1

| ROADMAP / M0 | Ten pakiet | Status pozostałego mostu |
|---|---|---|
| T07 / M0 full Sign outcomes | Finite-box G16/E0, pełne cap/Emit, współczynniki | OPEN: full M0 E, STUCK/nonreturn, PRNG, byte outputs, source retry |
| T08 / M3 geometry | Q, centrowanie modulo q, counterexample, extraction | OPEN: właściwe prawo proposal FT1536, norm/center correctness, source pre-cast transport |
| T09 / M4 image | D^B normalizacja/support, public pushforward, joint factorization | OPEN: pointwise e_img dla właściwego muH; nie podstawiono historycznego boundu |
| T10 / M6 public sampler | public code interface i simSign | OPEN: bounded bit-machine implementation, sampling law, C_pub/W_pub, coin generation |
| T11 / M5 distribution | finite AC/density, adaptive moments, Phi | OPEN: conditional-history law identification z pełną grą, latent key posterior, exact accepted-law comparison |
| T12 / M6 ROM reduction | pure table invariants, indexed extraction, conditional conflict counting | OPEN: probabilistic interpreter dowolnego A(beta), all Bytes* H, stopped-game coupling, targets IID/unseen-prefix law |
| T13 / M6 resources | RESOURCE_BOUND zawiera typowane parametry/spec template | OPEN: machine cost refinement całego B; nie ma twierdzenia Resources(B)≤... |
| T14 / M7 final target | finite_trace_bound i monotonic hardness substitution | OPEN: `exists B : MT_Adversary ...`, game identification i resource theorem |

Finite-box proposal ≠ pełny nieograniczony coset Gaussian. Chociaż Q<B mieści
się w box, masa norm-reject proposal zmienia się przy obcięciu: zmienia to
p(c), a więc pełny law cap16. Nie znosimy tego błędu samym twierdzeniem o
support D^B. Byte Emit/parser również pozostają oddzielnym mostem.

Nie dodano żadnych nowych wartości do historycznego HOP_LEDGER. Gdy ktoś
instancjuje ten tor, musi jawnie wskazać, które wiersze M4–M6 zastępuje.
Nie wolno policzyć tej samej różnicy samplera lub timeout dwukrotnie, ani
przemieścić freshness loss przez Phi bez nowego argumentu.

Warunki silne: finite α, lokalne AC J||P oraz moment≤1+e dla każdej pełnej
historii. Historyczny scalar K||G nie jest przesłanką dla odwrotnego G||K.
Nie wybrano numerycznie e,e_img,e_sign,epsilon_MT,p_K ani parametru bezpieczeństwa.
MT-ISIS jest zewnętrzną hipotezą dla publicznego marginalu właściwego muKey,
T=Q_H+1 i certyfikowanych zasobów. Nie jest hipotezą o samym Verify.
