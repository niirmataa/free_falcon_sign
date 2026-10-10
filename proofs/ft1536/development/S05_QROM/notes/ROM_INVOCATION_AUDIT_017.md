# S05 — nieosiągalna gałąź Invocation.encoded w pinie BATCH_060

Status: **PROVED_OBSTRUCTION**, klasa: obowiązek dowodowy Q-BIND/Q-KEY.
To lokalna kontrola konkretnego warunku, nie niezależny odbiór całej kampanii.

Sprawdzony commit źródłowy: `18a3ffe37cf21e53f2da5e58781775aef956d9b3`.
Zamknięcie okna: `69989f77ace156035fa75667b1b85bb824eaca10`.
Plik: `T12_1/source3/formal/Source3/KeygenMakeInvocation.lean`, SHA256
`c644d0edd5eeb23dd7893bc88e83a0d9560b8ee899d54318c65baadc1ffbf2d2`.
Bajty robocze odpowiadały obiektowi Git w chwili kontroli.

## Dokładna przeszkoda

Wiersze103–105 definiują `VirtualLegal (vb : Nat → Nat)` przez:

```lean
bounded : ∀ block, vb block < 2^64
distinct : ∀ b c : Nat, vb b = vb c → b = c
```

Kwantyfikatory obejmują wszystkie liczby naturalne. Są sprzeczne: funkcja
`n ↦ ⟨vb n, bounded n⟩ : Nat → Fin (2^64)` byłaby iniekcją z nieskończonego
zbioru do skończonego. Komentarz mówi o żywych blokach, ale typ nie zawiera
ograniczenia do takich bloków.

Niezależny kernelowy świadek: `formal/BoundedAddressObstruction017.lean`,
eksport `no_global_virtual_legal`, bez dodatkowych przesłanek poza dokładnie
tymi dwoma polami. Ogólny `no_bounded_nat_injection` obejmuje każdy skończony
limit. `finite_map_control` pokazuje, że ograniczenie dziedziny do zbioru
skończonego usuwa tę konkretną przeszkodę. Nie dowodzi jeszcze poprawności
jakiejkolwiek naprawionej semantyki pamięci.

## Skutek i zakres

Konstruktor `Invocation.encoded` wymaga `legal : VirtualLegal env.vb`
(wiersz574), zatem ta gałąź jest nieosiągalna w przypiętym typie. Dotyczy to
także wniosków o udanym wykonaniu z `invocation_gate` i
`invocation_certificate`: ich udana ścieżka ma pustą przesłankę.
Gałąź `capped` nie wymaga `VirtualLegal`; nie ogłaszamy całego typu pustym.
Dowody szkieletu instrukcji, np. `tail_source`, pozostają osobnymi wynikami.

Przed użyciem udanej gałęzi jako świadka Q-BIND trzeba poprawić dziedzinę
legalności mapy (np. odpowiednio wskazane bloki pamięci), przenieść dowody
jednoznaczności i zbudować świadki osiągalności. Sama kompilacja twierdzeń
warunkowych nie testuje niesprzeczności ich przesłanek. Nie zmieniono źródeł,
statusów ani receiptów T12.1 i nie uruchomiono jego replayów.

Pozostałe granice BATCH_060 zachowane: jawne TailCells/chronologia,
Dimensions/LegalWorkspace, ciała kodeków i ich frame, prawo pełnej emisji,
harmoniczny warunek źródłowy oraz Sign/PRG pozostają poza dostarczoną instancją.
To przeszkoda w modelu dowodowym; nie jest kontrprzykładem bezpieczeństwa C.

Dowód uruchomiono w `.build/local_leaves_017/runs/address001`, czysty log,
trzy eksporty; piny źródła/artefaktu/logów zapisuje `receipt.json`.
