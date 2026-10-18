# ZADANIE: R1 — wznowienie od środka suffixu 1537 (modular NTT)

Poprzednie okno (GPT) skończyło się na limicie; praca jest
zachowana na dysku i w commitach. Wznawiasz od ŻYWEGO stanu.

## Wejście (w tej kolejności)

1. `git log --oneline -40` — ostatnia robota: generator mq_mkgm3
   (kompletny, kontrakty tablic), 768 motyli pierwszego przebiegu
   modularnego NTT, wejście wywołania forward + prolog, seal
   pierwszego passa modularnego NTT z dokładną ramką pamięci
   (piny: notes/run/KEYGEN_NTT_FIRST_182_PINS.md);
2. notes/run/KEYGEN_R1_TAIL_TODO.md + KEYGEN_SUCCESS_BIG_TODO.md —
   żywy stan programu sukcesu;
3. notes/run/KEYGEN_PUBLIC_FORWARD_159_NEXT_ROUTE.md — mapa regionów;
4. PROMPT_R1_CONTINUE_001.md — pełne zasady i kolejność regionów.

## Cel (bez zmian)

G(seed*) = sukces dla seed9 ⇒ KeygenModelUnlock134.
package_of_witness ⇒ KeygenModelBinding134.package ⇒ Z > 0.

## Miejsce postoju i dalsza droga

Region 3 (suffix 1537 10) W TOKU: modular NTT pierwszy pass
zamknięty; zostało dokończyć dalsze przebiegi/iNTT, mq_div_18433,
testy t[u]!=0, return 1 → emit pakietu. Potem region 4 (root-solver
solve_NTRU_deepest/intermediate + bramka certyfikatu + ogony
kodekowe 0xaa/0x8a) i region 5 (teoremat G(seed*) + package).

## Zasady (bez zmian)

Zero założeń semantycznych (wszystko z egzekucji ciał); jeden
proces Lean naraz; logi 0/0; standardowe aksjomaty; bez sorry/
admit/native_decide; małe commity BEZ push; postseal po regionach;
nieudane joby z przyczynami w FAILURES; stop-and-report tylko przy
realnej ścianie integralności lub nowej przeszkodzie matematycznej;
meldunek po regionie; dzielenie dużych regionów na małe moduły.

## Na końcu

Raport zbiorczy: tabela regionów, G(seed*) z pinami (lub nazwana
ściana + rekomendacja), commity/postseal, trzy zdania
(co udowodnione / najbliższy brak / czego nie implikuje).

Żelazne zasady: run2/notes/B1_STAGED_ROADMAP.md.
