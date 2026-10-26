# impl/ — workspace P2 (THRESHOLD_P2_001)

Szkielet z WP-010 (G1). **Nie ma tu jeszcze kryptografii** — prymitywy
wchodzą w WP-012 z KAT, a protokół w G2.

## Zasady

- **Bez QSX/VM** (D-023): żadna crate nie może zależeć od `ftkey-vm`,
  QSX, KVM ani `qsx-alpine`.
- **Offline**: `cargo build --locked --offline` bez sieci.
- **Bez `unsafe`**: `unsafe_code = "forbid"` na poziomie workspace.
- **Bez zależności zewnętrznych na tym etapie** — port prymitywów i
  vendor `ft1536-sys` przyjdą z pinami (WP-012/WP-048).

## Crates

| Crate | Rola |
|---|---|
| `ft-threshold-core` | arytmetyka, Shamir, `R_q`, NTT, MAC, VSS, PRSS (WP-012) |
| `ft-threshold-protocol` | maszyny stanów DKG/sign/refresh, komunikaty, transkrypt |
| `ft-threshold-transport` | kanały, framing, sesje, replay, timeouty |
| `ft-threshold-node` | binarium strony, konfiguracja, storage adapter |
| `ft-threshold-coordinator` | orkiestracja, polityka, audyt (bez udziałów) |
| `ft-threshold-testkit` | harness, złośliwe strony, oracle, KAT (test-only) |
| `ft-threshold-verify` | wrapper `ft1536-sys` + niezależne kontrole (WP-048) |

## Komendy

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
cargo build --workspace --locked --offline
cargo test  --workspace --locked --offline
./ci/check.sh          # fmt + build + test + clippy + zakaz QSX/VM
```

Toolchain jest pinowany w `rust-toolchain.toml` (1.94.0). `deny.toml`
istnieje od WP-010; egzekwowanie `cargo deny` dołącza WP-011.

## Status

WP-010: szkielet. Bramka G1 **nie jest zamknięta** — brak KAT,
prymitywów, fuzzów i niezależnego odbioru.
