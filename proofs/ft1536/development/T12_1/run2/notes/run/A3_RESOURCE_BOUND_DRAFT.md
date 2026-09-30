# RESOURCE_BOUND — referencyjny wykonawca RUN_002

Wszystkie formuły poniżej są **górnymi oszacowaniami**. Nie są dokładnym
osiągalnym maksimum ani pomiarem runtime. Wiążące definicje i twierdzenia:
`MeteredExecution`, `PrefixResources`, `FinishResources`, `ResourceReduction`.

## Jednostki i model

- **t**: operacje bitowe zadeklarowanych referencyjnych procedur, z portami,
  lokalnym kodem, kopiami, skanami tablic i wejściowym załadowaniem kodu/danych.
- **w**: szczyt liczby rezydentnych/alokowanych komórek bitowych modelu.
  Arena w pojedynczej turze nie odzyskuje pamięci; między turami bierze się
  maksimum. Znaczniki i pełne literalne programy są liczone. Podstawowa
  rekursywna ramka bitowa rezerwuje32 komórki; `BitAllocation` i
  `TableAllocation` składają profile według faktycznych gałęzi procedur.
- **L**: łączny ruch w konwencji portu z jednym bajtem transportu na bit.
  Obejmuje także jawne wewnętrzne kopie; jest majorantą portów pakujących
  bity. Nie oznacza limitu długości jednej wiadomości — ten to `beta.bytes`.

Sterownik ma jawną stałą rezerwę `2^20` komórek w definicji modelu. Nie jest
to ustalony rozmiar binarki C/Lean. Kod wielomianowy jest osobnym, skończonym
AST: `Pcode = ∑ r : Fin1536, expressionCode (coefficientProgram r)`.
Kernel dowodzi `Pcode ≤ 2^50`. To naiwny referencyjny mnożnik, nie NTT.
Ładowanie Pcode jest liczone, a wybór tej reprezentacji czyni granicę bardzo
dużą. Nie ma obietnicy efektywnej instancji samplera lub osiągalności kosztu.

## Parametry

Niech `N = Qs+QH`, `T = QH+1`, `m = beta.bytes`, `bA = beta.coinBits`,
`bS = S.bits`. Niech `cA,cS` oznaczają codeBits wymazanych programów A/S,
a `dA,dS` ich depth. Definiujemy:

```
C  = 3*(N+1)*(9*(m+41)+27000+T)+T+4
ai = 24577+bA+N*(9*m+26440)
ao = 9*m+26120
si = 24900+C+9*m+bS
so = 50689
F  = 2*C+ao
U  = (N+1)*(133*(41+m)+2)+1
H  = U+24577*(T+1)+8*(41+m)+24576+T+8
I  = 24576*T+24576+bA+cA+cS+Pcode+N+1+2^20
```

C obejmuje pełną tabelę, SeenSign, zdarzenia/historię S, indeksy i znaczniki.
ai zawiera tylko zwykłą obserwowalną historię przeciwnika. I zawiera wszystkie
cele, publiczny klucz, coins, oba lokalne kody i publiczny kod arytmetyczny.

Lokalne koszty, wyprowadzone z kodu:

```
At = (dA+1)*(2*ai+3*cA+8)+16*(ai+ao)
Aw = ai+2*cA+dA+8+8*(ai+ao)
AL = ai+ao
St = (dS+1)*(2*si+3*cS+8)+16*(si+so)
Sw = si+2*cS+dS+8+8*(si+so)
SL = si+so
```

## Kompozycja

```
init_t = 16*I+1+5*bA
init_w = I+bA
init_L = I+bA

turn_t = At+St+2*(16*F+1)+H+U+5*(320+bS)
turn_w = I+C+Aw+Sw+32*F+32*(H+U)+320+bS
turn_L = AL+SL+2*F+320+bS

P = H+2*U+m+16
O = T+52226
end_t = 17+2*(16*F+1)+P+2^67+16*O+1
end_w = I+C+16+32*F+32*P+2^72+16*O
end_L = 1+2*F+O

bound_t = init_t+(N+1)*turn_t+end_t
bound_w = max(init_w, max(turn_w,end_w))
bound_L = init_L+(N+1)*turn_L+end_L
```

To dokładne rozwinięcie zapisanych formuł upper bound, nie twierdzenie,
że każda ścieżka wykonuje wszystkie naliczone operacje. Granica per-turn
nalicza nawet sampler na turze hash/done; jest celowo luźna. Liczba czynników
straty probabilistycznej pozostaje **Qs**, co dowiedziono osobno przez paid
steps. Tych dwóch rachunków nie należy utożsamiać.

Finalny eager harmonogram wykonuje publiczne operacje także dla wyniku
odrzucanego. Właściwy wynik nadal jest identyczny z `finishSim`, co dowodzi
`fileFinish_correct`/`terminal_correct`. Verify ma t≤2^66 i profil alokacji
≤2^71; Verify plus ponowne obliczenie reszty do ekstrakcji ma t≤2^67,
alokację≤2^72. Port świadectwa ma długość≤indeks+52226. Wszystkie te stałe
mają kernelowe konsumenty i dodatkowy rachunek exact-ZZ w
`sage/resource_envelope.sage`.

## Forma twierdzenia zasobowego

`run_resources` ogranicza każdą ścieżkę dla każdego wejścia.
`Resources` bierze rzeczywiste maksima profilu po skończonej dziedzinie
wejść/taśm. `resources_bound` dowodzi trzech nierówności jednocześnie.
`run_binding` wymazuje licznik i reprezentację plików do prawa
`Reduction.build`. W końcowej redukcji występuje udowodniony
`ResourceRealization`, ponieważ sam semantyczny `MTAdversary` nie przechowuje
programu ani czasu. To nie jest przesłanka o MachineImplements całego B.

Konsumpcja przez bezpieczeństwo rzeczywistego FT1536 wymaga jeszcze
instancjacji lokalnych certyfikatów i mostów do kodu/PRNG. Te formuły nie
stanowią wyników benchmarku, proofu kompilatora lub oszacowania bit-security.
