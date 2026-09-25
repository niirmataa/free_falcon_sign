# RESOURCE_BOUND — zasoby reduktora (Etap E)

Status: **OPEN_TYPED_MACHINE_BINDING** — to jawna specyfikacja i shape
dowodu, nie wykazany bound. Ten pakiet nie dowodzi kosztu wykonania B;
brak kernelowego twierdzenia `Resources(B) ≤ derivedResourceBound(beta, S)`.

## Maszyna i jednostki (wg M0 RESOURCE_MODEL, bez zmian)

t — bit steps, w — bits, L — bytes wszystkich portów.
M ≤ Q_H + Q_s + 1 wpisów; L_key ≤ L + 40·(Q_s+1). Lista porównuje dokładne
nazwy bajtowe (nie hasze). Model listy celów: **wejściowa lista** Q_H+1
elementów — jej storage i odczyt są liczone; nie łączymy zalet bezkosztowego
streamingu i darmowej pełnej listy.

## Kod, którego koszt trzeba policzyć (właściwy kod reduktora)

`GameMach.step` w trybie `sim` + `verdict`: tabela (lookup przez dokładne
porównanie nazw bajtowych, insert, kopie danych), SeenSign, framing nazw
(40+|m| bajtów), odczyt `targets[used]` z całej listy Q_H+1, programowanie
przez S, końcowy `Verify` (`Relation.Verify`: signed16 + `extract` +
Q + porównanie z B) i ekstrakcja świadka, kodowanie indeksu/świadka.
Koszty obliczenia nieobliczalnego `signBody` należą do semantyki wyroczni
gry, nie do kodu B. Koszt `A` i sterowanie symulacją liczone osobno
(`C_simulate_A(beta)` z certyfikatu A). Bez podwójnego doliczania A_h/Emit
wewnątrz certyfikowanego S (`C_S(beta)` obejmuje swoje).

## Docelowy shape (SPEC, nie eksport)

```
t_B ≤ C_simulate_A(beta)
      + Q_s·C_S(beta)
      + C_nonce(320) + C_table(M, L_key) + C_seen(Q_s)
      + C_targets_read(Q_H+1)
      + C_verify(L) + C_extract(L) + C_IO(index_bytes(Q_H+1) + wit_bytes)
w_B ≤ w_A + W_table(M, L_key) + W_pub + W_targets(3072·(Q_H+1)) + W_extract
L_B ≤ L + 40·(Q_s+1) + 3072·(Q_H+1) + 8·1536 + index_bytes(Q_H+1) + sampler_port_bytes
```

Konkretne funkcje w `RESOURCE_BOUND.json`. Prosta lista z dokładnym
porównywaniem nazw i zwykłe mnożenie współczynnikowe; bez AVX/NTT —
konserwatywny bound wystarczy. `PublicSampler.run` pozostaje parametrem;
`uniform (Fin coinCount)` nie daje automatycznie exact bounded sampling
z bitów — dopuszczalny nowy wariant: skończona taśma b bitów i
coinCount = 2^b z jawnym refinementem (osobny koszt exact-uniform).

## Dlaczego status jest otwarty — dokładne brakujące typy

1. `cost_interpreter` — formalny interpreter kosztowy/refinement do maszyny
   bitowej dla `GameMach.step`+`verdict` (t, w, L).
2. `cost_composition` — złożenie lokalnych kosztów w powyższą sumę z
   licznikami kroków z budżetu (kernelowo; elementy: `used_le_of_step`,
   `signStep_table`).
3. `reducer_bit_cost_bound` — teza `Resources(B) ≤ derivedResourceBound(...)`
   dla zdefiniowanego B.

Certyfikaty kosztu kodu A i S mogą być założeniami metatwierdzenia (dotyczą
wykonania tych programów i budżetów, nie całego B). Koszty proof/replay są
osobne (EXECUTION_RECEIPTS).
