# RESOURCE_INTERFACE — deterministyczny consumer budżetu T01

Maszyna: `model/prng_model.sage` sekcja F/G (exact `ZZ`), checker
`resources.*` (niezależna rederywacja). Eksport: RESOURCE_INTERFACE.json.

## Wejście (odebrane, nie re-dowodzone)

Wspólny event H z T01: każda reached próba ma `T_j ≤ 49152`,
`r_j ≤ ⌊(33T_j−8)/4087⌋` ADDITIONAL refills, `J ≤ 16` (T01/RESOURCE_BOUND.json,
`3d68249f…`; ghost budget `4fc5e10b…`). `Pr(H^c) < 2^−1020` w `G_retry_IID`
pozostaje daną T01 — nie przenoszona na realny PRNG bez hopu (T02 OPEN).

## Wyprowadzenia (exact ZZ)

- `r_max = ⌊(33·49152−8)/4087⌋ = ⌊1622008/4087⌋ = 396`.
- `64·(1+r_j) ≤ 25408` block evaluations na reached context
  (monotoniczność dla r = 0..396 asercja).
- `64·6352 = 406528` block evaluations na region na H
  (6352 = 16 initial + 16·396 additional — spójne z ghost budget T01:
  proposals 786432, returned 25952256, additional 6336, blocks 6352,
  generated 26017792, drops 57024, abandonments 15·4088 = 61320, tail 4088).
- `56·J ≤ 896` requested parent-SHAKE bytes w cut; `+40` nonce = 936
  (nonce poza regionem).

## Zakres

Implikacje deterministyczne z podanego eventu. 56 bajtów NIE jest
independent 448-bit key; mały block count NIE dowodzi pseudorandomness;
repeated-context possibility NIE ma tu miary prawdopodobieństwa.
U8/u64 getter drops kryje T01 (D_j); nie re-derywujemy schedule.
