# ZADANIE: R1 — kernelowy certyfikat seed9 — ciąg dalszy

Cel końcowy: G(seed*) = sukces dla publicznego syntetycznego seeda
(fixture seed9) ⇒ KeygenModelUnlock134.package_of_witness ⇒
KeygenModelBinding134.package odblokowane ⇒ Z ≥ 2^-256 > 0.
Tor analityczny jest formalnie zamknięty (acceptMass_positive_iff:
dodatniość <=> istnienie świadka) — nie szukaj skrótów.

## Wejście (kolejność czytania)

1. notes/run/KEYGEN_SEED9_R1_REPORT.md — meldunek poprzedniego okna
   (regiony 1d.a/1d.b zamknięte; 1d.c: kształty i inwarianty gotowe);
2. notes/run/KEYGEN_PUBLIC_FORWARD_159_NEXT_ROUTE.md — mapa regionów
   i inwarianty Written-zakresów;
3. notes/run/KEYGEN_SUCCESS_BIG_TODO.md — stan programu sukcesu;
4. Moduły bazowe: formal/Source3/PublicGenerate{Table,Index,Row,Upper}159.lean,
   PublicConvertLoop158/SelectedPublicConvert158, KeygenPublicFirstCalls,
   KeygenNttForwardExec, KeygenModelUnlock134 (konsumenci).

## Kolejność regionów (jazda bez przystanków; meldunek po regionie)

1d.c. Ciała i indukcje pętli górnej i kwadratowej (kształty i
      inwarianty UpperInv/CoverUp JUŻ SĄ w PublicGenerateUpper159),
      finalTail, kompozycja initK/initB/initU + remaining;
      wystawić WrittenRange 0 1024 na obu tablicach jako przekazanie
      do regionu 2.
2.    Tail (fragment 1001 61: pass 768, 8 rund pośrednich, tripling
      512) — uniwersalne motyle z okien 140-148 INSTANCJONUJ,
      nie odtwarzaj.
3.    Suffix 1537 10: testy t[u]!=0, mq_div_18433, mq_iNTT,
      return 1 -> emit pakietu (naglowki 0xaa/0x8a).
4.    Root-solver (solve_NTRU_deepest/intermediate) + bramka
      certyfikatu + ogony kodekowe.
5.    Teoremat G(seed*) = sukces wg KeygenByteGame134.evaluate
      + KeygenModelUnlock134.package_of_witness.

## Zasady (bez zmian)

- Wszystko z ciał i pinów; zero założeń semantycznych (obrazy/NTT/
  wartości sukcesu tylko z egzekucji); zero IID/D1/F04/premis RNG.
- Jeden proces Lean naraz; logi 0/0; standardowe aksjomaty
  (propext, Classical.choice, Quot.sound); bez sorry/admit/
  native_decide.
- Małe commity lokalne BEZ push; postseal po regionach; nieudane
  jobi i sondy z przyczynami w FAILURES.json.
- Stop-and-report TYLKO przy realnej ścianie integralności lub nowej
  przeszkodzie matematycznej — nie przy „mógłbym zapytać".
- Jeśli region rośnie powyżej okna — dziel na małe moduły,
  nie rozszerzaj zakresu.

## Raport końcowy

Tabela regionów ze statusami; G(seed*) z pinami; odblokowanie
package (albo nazwana ściana z rekomendacją); liczby/deklaracje/
commity/postseal; trzy zdania (co udowodnione / najbliższy brak /
czego to nie implikuje).

Żelazne zasady: run2/notes/B1_STAGED_ROADMAP.md.
