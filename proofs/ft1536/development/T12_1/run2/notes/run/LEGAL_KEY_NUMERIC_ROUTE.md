# Bieżąca droga do gwarantowanych cyfr (bez freeze)

Właściciel doprecyzował: WSZYSTKIE klucze dopuszczone przez KeyGen FT1536,
nie wszystkie elementy Rq. Nie dopisujemy nowej selekcji dobrych kluczy.
Trzeba związać istniejący mandatory gate z exact-leaf/T5 i zachować quantifier.
T5 context został przypięty w inputs/legal_key_context,manifest
1fdf82136da325eec6727eae14a89f31be368af113a8210170b7d3c339084bab.

## Co zmienia ten zakres

Historyczny T5 daje punktowo dla successful outputs sumę niezerowych
graph-dual theta weights<2^-40 (rzeczywisty jego dyadyczny bound≈2^-51.83).
Poisson daje z tego pointwise relative mass comparison KAŻDEGO cosetu i
KAŻDEGO realnego przesunięcia. To nie jest dopiero chi² odwrócone do TV.

Stąd można wyprowadzić uniform MGF i Chernoff norm/coordinate tails:
- norm reject przy B ma upper<2^-24;
- wyjście poza proposal box±65535 ma niewspółmiernie mniejszą masę;
- inverse coset-normalizer zmienia raw Gaussian event probability tylko
  przez wąski mnożnik względny;
- cap16 przy reject≤r zmienia daną positive bad-event mass o czynnik w[1,1/(1-r)].

Nowy LegalKeyErrorTransfer formalizuje skończoną algebraiczną część tego
mostu. FiniteFlat jest pośrednim CERTYFIKATEM, nie definicją wybranego zbioru
kluczy. Obowiązek forall successfulKeyGen→FiniteFlat/rejection pozostaje
jawny i musi być oparty na rzeczywistych bramkach/T5, bez nowego conditioning.
Nie potrzeba w tej drodze przyjmować starego niespójnego accepted-image R5T.

## Dyskretny radialny rachunek referencyjny

1. CenteringTriangle kernelowo klasyfikuje WSZYSTKIE wzrosty jednego bloku
   A2 jako cztery rozłączne trójkąty. Kanoniczny ma dokładnie21233664 pary.
2. Dla jednej zmienionej pary z1 pozostały norm jest sumą1535 IID bloków A2.
3. GeneratingFunction dowodzi n-fold PGF power. Binning dowodzi dokładnego
   probabilistycznego sandwich przy floor(Q/w), bez założenia ciągłego gamma.
4. Sage arb_radial.sage ma wyliczyć exact integer multiplicities do cut,
   potem FLINT/Arb interval DFT, potęgę1535 i inverse DFT. Każdy współczynnik
   ma przedział. Cython jest wygenerowanym z tej .sage cienkim sterownikiem
   pętli integer/Arb; nie jest floating-point FFT ani niezależnym .py rachunkiem.
5. Binning, omitted block tail, cyclic aliases,≥2 changed blocks, signed16
   Emit loss i finite proposal-box tail muszą być osobno rozliczone w
   końcowym interwale. Finalne cyfry muszą być wspólne obu końcom.

Diagnostyczny locate_centering_value.sage wskazał około1.2669465e-24, lecz ma
certified_digits=0 (używał continuous radial locator). NIE konsumować go jako
wyniku; służy tylko wyborowi precyzji pełnego dyskretnego rachunku powyżej.

## Limity i zależności techniczne

Plan pełnego DFT:2^25 elementów acb128, bin16; vector≈3GiB, roots≈1.5GiB,
counts≈288MiB, plus Sage/runtime — poniżej normalnego8GiB. Najpierw test64
punktów versus dokładne QQ i benchmark2^18. Jeden compute worker, wall1800s.
Sage cython_import nie działa z powodu braku distutils/setuptools. Użyto
istniejącego Cython.Compiler.Main i GCC bez instalacji; stdout/stderr oraz
pełny argv kompilatora zapisuje engine_build_receipt.json. Sam top-level
rachunek nadal uruchamiany jest `sage arb_radial.sage ...` z preparserem.

To nadal WORKING. Snapshot34/34 nie obejmuje wszystkich nowych badań i nie
stanowi końcowego handoffu. Pełny replay dopiero po domknięciu nowych produktów.
