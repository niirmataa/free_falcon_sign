# RUN_002 — higiena instancji przy boxach i sumach

Wskazówka właściciela przy kontynuacji rachunku radialnego2026-09-24.

## Przyczyna

`PublicSimulation.boxVecFintype` i `boxPairFintype` używają
`Fintype.ofFinite`. Generyczne twierdzenia dla funkcji i iloczynów używają
strukturalnych instancji Pi/Prod i `piFinset`. Matematycznie te enumeracje są
równe, ale próba uzgodnienia ich przez DEFEQ może rozwinąć ogromny produkt
kartezjański. Szczególnie kosztowne są `rw` z otwartymi metazmiennymi funkcji
lub instancji oraz redukowanie pól `Law` przed ustaleniem enumeracji.
Podnoszenie `maxRecDepth` nie usuwa tej przyczyny.

## Wzorzec w nowych modułach radialnych

Po importach:

```lean
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
```

To ta sama metoda co `SigmaMath.nonceFintype` w odziedziczonych modułach.
W Lean4.34 erasure ma składnię `[-instance]`, nie `[local -instance]`.
Usunięcie modyfikuje bieżący stan instancji; powtarzamy je w kolejnych plikach,
które elaborują nowe wyrażenia `Law BoxVec`/`Law BoxPair`. Nie modyfikujemy
deklaracji odziedziczonych instancji ani frozen źródeł.

Preferuj aplikacje o ustalonych typach/funkcjach:

```lean
exact (Fintype.prod_sum f).symm

simpa only [Finset.prod_const, Finset.card_univ, Fintype.card_fin] using
  (Fintype.prod_sum (fun _ : Fin 768 => f)).symm
```

Nie proś elaboratora o odgadnięcie wszystkich parametrów przez otwarte
`rw [← Fintype.prod_sum]`, zwłaszcza na granicy dwóch enumeracji.

## Granica ze starym modelem

`rawBad` i `totalWeight` zachowują pierwotne definicje. Jeden jawny lemat
`RawProductLaw.legacy_box_sum` transportuje sumę po starej choice'owej
enumeracji do strukturalnej. Jego argument `f : BoxPair → ℝ` jest już ustalony.
Za tą granicą product-law, independence i event sandwich pracują ze spójnymi
Pi/Prod instances. Nie wykonujemy `rw` instancji pod zależnymi polami `Law`.

Osobny problem dotyczy `DecidablePred`: dla ogólnych predykatów pomocniczych
`RawIndependence.prob` używa kanonicznego wskaźnika. `prob_eq_event` dowodzi
zgodności z `Law.event` dla każdej podanej instancji rozstrzygalności.

## Sprawdzenie

Zastosowano w RawProductLaw,RawRadialEvents,RawIndependence.
`run/raw_instance_hygiene_002`:3/3 exit0 i accepted=true,czyste logi,
z `-DwarningAsError=true`; bez zwiększania głębokości rekursji tych modułów.
