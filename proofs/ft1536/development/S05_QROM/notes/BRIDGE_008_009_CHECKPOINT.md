# S05 — checkpoint 008/009: od kolejności LDL do jednego liścia

Baza naukowa: `1659efc0ce752874887e3ff7e31f204a76293220`.
Status: **PARTIAL_PROOF / CONDITIONAL**, pełny nowy most tekstowy.
Dwanaście elementarnych lematów ma świeży kernel Lean z czystymi logami.
Nie ma pełnego kernela mostu ani deklaracji bezpieczeństwa FT1536 w QROM.

## Co zmieniło wiedzę

1. **Finding008:** `BasisLeafAlgebra.ldl_shape` ma niemożliwą kolejność
   pierwszych pivotsów przy aktualnych definicjach. Rzeczywisty Gram daje
   `(λ,3λ/4)`, a przesłanka wymaga `(3ℓ/4,ℓ)` z ℓ>0. Nie jest to błąd C
   ani obalenie samplera007. Ten interfejs nie może dostarczyć jego instancji.
2. **Most009:** z dokładnego NTRU, odwracalnego f moduloq, ternarności f/g
   i średniej harmonicznej widma ≥991 wynika potrzebny górny bound LDL.
   Dowód używa Parsevala i dodatniego dopełnienia Schura, bez równości list.
3. **Jeden liść:** ostatni pierwotny liść (indeks767) jest dokładnie średnią
   harmoniczną. Wystarczają błąd każdego g00 ≤1/128 i wskazane kontrakty
   względnego błędu operacji. To nowe konkretne przesłanki do instancjonowania,
   nie jeszcze dowód ich spełnienia przez cały rzeczywisty KeyGen.
4. **Niepusta instancja:** jawne ternarne f/g stopnia<1536, dokładne NTRU,
   max|F|=49, max|G|=50, płaskie widmo2048. Faktyczna funkcja certyfikatu C
   zaakceptowała ten publiczny fixture. Dokładny odczyt768+1536 słów dał
   max błąd g00=3/2^40. To jedna instancja funkcji, nie prawo emitted keys.

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Algorytm, capy, koszt i pełny moment007 | Zachowane; moment pod (M) |
| Odziedziczone `ldl_shape` jako droga do instancji | REFUTED w obecnej postaci; finding008 |
| Harmoniczne widmo → górny bound dokładnych pivotsów → (M) | Nowy dowód tekstowy009 |
| Drobna algebra i próg liczbowy źródłowy | 12 nowych lematów kernelowych, ograniczony scope |
| Niepustość nowej klasy przy n=1536 | Dokładny świadek algebraiczny i jedna akceptacja C |
| Uniform g00 error≤1/128 i kontrakty dodatniej arytmetyki | OPEN dla wymaganego prawa kluczy |
| Source NTRU/ternarity/public law i wszystkie emitted keys | OPEN; wymagana identyfikacja z μ_H |
| Kernelizacja całego nowego mostu, Q-BIND, Q-COMPOSE | OPEN |
| Q-HASH-LOG, Q-COLL/Q-EMBED, Q-RESC reduktora | OPEN, bez zmiany statusu |
| Deklaracja EUF-CMA w QROM | Wyłącznie po domknięciu świadków |

## Historia i walidacja

Źródła, receipty i piny: `BRIDGE_008_009_RECEIPT.json`,
`KEY_BASIS_008_INPUTS.json`, `HARMONIC_BRIDGE_009_INPUTS.json`,
`BRIDGE_008_009_OUTPUTS.sha256`. Małe źródła nieudanych prób są w
`notes/attempts/`; surowe logi i generowane artefakty w `.build/bridge_008/`
oraz `.build/bridge_009/`. Nie nadpisano wyników003–007 ani źródeł T12.
Zachowano błędy uruchomienia Lean, serializacji Sage, asercji długości
fixture'u i brakującego środowiska macierzy LaTeX. Finalne sprawdzenia przeszły.

**Własna ocena:** błędny most został wykryty przed ogłoszeniem instancji.
Nowa droga wymaga mniej informacji: wystarczy bound z jednej średniej
harmonicznej. Konkretna instancja pełnego rozmiaru pokazuje wykonalność
tego warunku, lecz nie zastępuje uniwersalnego związku z programem.

## Następny krok i decyzja właściciela

Właściciel polecił ponownie przejrzeć bogatą ścieżkę ROM. Następnie czytamy
konkretne eksporty i piny ROM dotyczące g00, FFT/FPEMU, ostatniego liścia,
źródłowego KeyGen i właściwego μ_H. Celem jest wykorzystanie istniejących
dowodów przed tworzeniem dalszych interfejsów. Nie przejmujemy workerów,
nie zmieniamy statusów T12.1/B20 i nie traktujemy nazwy twierdzenia jako
spełnienia jego przesłanek. Alternatywny bezpośredni błąd liścia<33 pozostaje
otwartą drogą, jeżeli ROM ma silniejszy gotowy eksport.
