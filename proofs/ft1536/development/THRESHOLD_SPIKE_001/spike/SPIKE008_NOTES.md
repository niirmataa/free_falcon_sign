# Spike 008 — izolacja procesów (kawałek F-13)

**Status: PROTOTYP.** Osobne procesy: `dealer` / `party`×3 / `mailbox`.

## Twierdzenie (wąskie, prawdziwe po tym spiku)

Po wyjściu procesu `dealer`:
1. seed **nie jest** na dysku (tylko kolumny `col{i}.bin`);
2. każdy `party` ma **tylko własną** kolumnę (`PartyView`);
3. log party zawiera hash kolumny, **nie** treść cudzych kolumn;
4. `mailbox` widzi wyłącznie publiczne d,e i jawne otwarcia.

**To NIE jest** nadal pełne „żaden proces w produkcji nie zna materiału":
- dealer **zna seed** w trakcie `split` (model testowy; DKG — osobno);
- demo G_frag/Beaver jest w koordynatorze cząstkowo (mailbox pusty w logu);
- semi-honest, brak SPDZ-MAC, brak transportu produkcyjnego.

## Użycie

```
cargo run --bin iso -- demo /tmp/iso-work
# ISO_DEMO_OK / DEALER_DONE / PARTY_READY x=1..3

cargo test --manifest-path spike/Cargo.toml
# 34 unit + 1 isolation + 10 integration
```

## Co dalej, żeby domknąć F-13

1. Pełny G_frag **między** procesami (każdy mul: party → mailbox d_i,e_i →
   broadcast d,e → party z_i; ani razu bez udziałów).
2. DKG / distributed input — dealer nie zna seeda.
3. Twarde dowody (strace/seccomp) — brak `read` kolumny innej strony.

## Wynik demo (ślad)

```
ISO_DEMO_OK
dealer: DEALER_DONE
PARTY_READY x=1 fnv=...
PARTY_READY x=2 fnv=...
PARTY_READY x=3 fnv=...
MAILBOX empty
```
