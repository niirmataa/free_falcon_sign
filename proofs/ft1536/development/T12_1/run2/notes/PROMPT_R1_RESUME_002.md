# ZADANIE: R1 — wznowienie od środka regionu 2 (tail NTT)

Poprzednie okno padło bez meldunku (brak procesów; praca zachowana
na dysku). Wznawiasz od ŻYWEGO stanu, nie od zera.

## Wejście (w tej kolejności)

1. notes/run/KEYGEN_R1_TAIL_TODO.md — ŻYWY TODO poprzedniego okna
   (ostatni plik roboczy, 18:30) — to jest Twoje miejsce postoju;
2. notes/run/KEYGEN_SEED9_R1_REPORT.md + PROMPT_R1_CONTINUE_001.md —
   pełny kontekst regionów 2-5 i zasad;
3. Ostatnie commity (16 sztuk, HEAD ~566b82d0): firstBody chain
   (split steps, reads2a/2b, writes2, thin step composition) —
   sprawdź `git log --oneline -16` i stan modułów NTT taila;
4. notes/run/KEYGEN_PUBLIC_FORWARD_159_NEXT_ROUTE.md — mapa regionów.

## Cel (bez zmian)

G(seed*) = sukces dla seed9 ⇒ KeygenModelUnlock134.
package_of_witness ⇒ KeygenModelBinding134.package ⇒ Z > 0.
Kolejność: dokończyć region 2 (tail: pass 768, 8 rund, tripling 512
— motyle uniwersalne 140-148 instancjonuj), potem 3 (suffix 1537 10
+ emit), 4 (solver/certyfikat/codec), 5 (teoremat + package).

## Zasady (bez zmian — patrz PROMPT_R1_CONTINUE_001.md)

Zero założeń semantycznych; jeden proces Lean; logi 0/0; standardowe
aksjomaty; małe commity bez push; postseal po regionach; porażki
z przyczynami; stop-and-report tylko przy realnej ścianie;
meldunek po regionie, jazda bez przystanków.

## Na końcu

Raport zbiorczy: tabela regionów, G(seed*) z pinami (lub nazwana
ściana), commity/postseal, trzy zdania.
