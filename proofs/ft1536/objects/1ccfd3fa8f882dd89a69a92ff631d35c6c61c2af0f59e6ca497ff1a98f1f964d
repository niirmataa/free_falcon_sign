# Doprecyzowanie minimalnego brakującego typu P02 (odczyt definicji)

To kontrola interfejsu potrzebnego T03, nie niezależny odbiór P02 ani jego
zmiana. `inputs/dependency_types/P02_Domain.lean13–14` definiuje:

```lean
structure PrimObligation (fn : Name) (args : List Val) (res : Val) : Prop where
  eval : shiftCalls fn args = some res
```

AddCallObligation/MulObligation/DivObligation/SqrtObligation z42–52 podstawiają
nazwy fpr_add/fpr_mul/fpr_div/fpr_sqrt. Zamrożony `ScalarCalls.lean6–10`
(byte-exact kopia obok) ma jednak tylko3 gałęzie: fpr_ursh, fpr_irsh,
fpr_ulsh, a dla pozostałych nazw zwraca none.

Dlatego następny krok **nie polega na postulowaniu instancji tych frozen
obligations**. Potrzebny jest nowy, source-refined dispatcher/interpreter
obejmujący rzeczywiste ciała operatorów, a następnie theorem łączący jego
wynik z val i konkretnym real-error/caller-domain boundem. Użycie obecnego
warunkowego sub theorem z nieosiągalnym AddCallObligation nie dostarcza
wykonania source sub. RUN_002 nie konsumuje tej przesłanki.

Ta obserwacja z definicji zawęża P02_ARITH w EXPORT_DEPENDENCIES.json.
Nie jest nowym kernel theorem tego pakietu;15 twierdzeń RUN_002 pozostaje
wyłącznie lokalną algebrą, z niezmienionymi print/replay receipts.
