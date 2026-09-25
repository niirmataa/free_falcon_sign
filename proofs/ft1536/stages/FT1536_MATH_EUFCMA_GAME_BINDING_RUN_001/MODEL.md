# MODEL — Sigma_math w tym pakiecie

**Wariant bez zmian wobec zamrożonego MODEL poprzednika**
(SHA-256 `c2a7aa00890e6c90879bbbb41524af1058e17bb15863a33a4efcb83fcc92a37a`):
E0, coefficient-valued finite-box G16, klasyczny direct-output ROM.
Ten plik opisuje wyłącznie DODATKI modelowe tego wykonania; treść bazowa
pozostaje wiążąca w oryginale.

## Obiekty (bez zmian)

`Geometry.Vec = Fin 768 → ℤ×ℤ`, `block(x,y)=x²+xy+y²`, Q suma bloków,
B=2093922385 (ścisły próg), `Relation.Rq` = 1536 współczynników w ZMod18433,
`A(h,z)=reduce(z1)+mulRq(h,reduce(z2))` (reszta wielomianowa modulo
X^1536−X^768+1), centrowanie `(x+9216)%18433−9216`,
`Verify(h,c,s) = signed16(s) ∧ Q(center(c−h*s),s) < B`. Cap16, jednorazowy
Emit (z2 albo POST_ABORT), jedna sól 320-bitowa, ordinary freshness,
`muKey` jednorazowe z marginałem `muH` (nie uniform).

## Dodatki tego wykonania

- **Język nazw**: nazwy tabeli to literalne bajty (`GameByte`); typy nazw
  `short (<40B) | sign (40B-ramka ⊕ m)` w bijekcji z bajtami (`GameNames`).
  Transport podpisu pozostaje wektorem współczynników (`BoxVec` dla alfabetu
  operacji — win-neutralne, bo `Verify` wymaga signed16 ⊂ box).
- **Obserwacje**: `Reply = hval c | sign c o | verdict win c | halt`.
  `o : Option (Nonce × Option BoxVec)` — istniejący typ (PRE_ABORT = outer
  none nie powstaje w E0; POST_ABORT = `some (r, none)`). Jawne `c` w
  odpowiedzi to publiczny stan tabeli (przeciwnik i tak może je odczytać H);
  to czyni jądro płatnego kroku dokładnie certyfikowaną parą `(c,o)`.
  `halt` = STOP wewnętrzny/przekroczenie budżetu; **nie** jest zwracanym
  abortem. Wewnętrzna liczba prób, monety S i czas odpowiedzi nie są
  obserwacjami.
- **Przeciwnik**: `Op = hq nazwa | sq m | fin r m sig`, budżet
  `Budget(Q_H,Q_s,maxSteps,maxName,maxMsg)`; adaptacyjność przez funkcje
  historii odpowiedzi; losowość przez jawne `Env` (świeże c, sól, tablica
  odpowiedzi ciała signBody, wyjście S). Przekroczenie budżetu kończy grę
  `halt` bez zmiany gry dla A w budżecie.
- **Trzy gry**: `real`/`stopped`/`sim` — jeden `step`, patrz GAME_SEMANTICS.
- **Zdarzenie MT**: `B` zwraca `(j, wit)`; `MT = ∃ j<Q_H+1,
  Relation.ShortPreimage h (targets j) wit` — zdefiniowane z wyjścia B.
- **Prawa i jądra**: `LocalCert` (jawny parametr: AC + second ≤ 1+e dla
  pełnej pary (c,o) jednego świeżego S.run), jądra kroków wyprowadzone
  z logiki `step` (`GameLaw`), konstrukcja sekwencyjna celów `Lazy.seqTargets`
  (równa uniform na wektorze — refinement wejściowej listy).

## Czego model NIE zawiera

Nie utożsamiamy z nieograniczonym coset-Gaussian G16, K_seed/PRNG/H2P ani
source Sign. STUCK/nonreturn i ogólne środowisko E pozostają w ledgerze
(poprzednika) — nie dodano ich jako obserwowalnych abortów do skończonego E0.
W E0 brak PRE_ABORT — wykazany w poprzedniku (`pre_abort_has_no_nonce`) i
nietknięty. Bit-cost B pozostaje specyfikacją (osobna oś).
