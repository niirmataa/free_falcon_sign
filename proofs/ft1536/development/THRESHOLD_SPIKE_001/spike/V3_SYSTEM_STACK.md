# V3 — mapa systemu: FTKEY (YubiKey) + FT1536 + próg seeda

**Data:** 2026-10-21. Właściciel: system działa z **FTKEY** — seed 32 B
w **FIDO2 hmac-secret na YubiKeyu** (`/home/footfalcon/Muzyka/FTKEY/`,
ADR-004 token-resident seed).

## Stapka (prawdziwy system)

```
┌─────────────────────────────────────────────────────────┐
│ YubiKey (FIDO2) — FTKEY ADR-004                         │
│   seed 32 B: hmac-secret + largeBlob (PIN + dotknięcie) │
└───────────────────────────┬─────────────────────────────┘
                            │ unseal (hmac-secret)
                            ▼
┌─────────────────────────────────────────────────────────┐
│ seed 32 B (RAM, krótko)                                 │
│   ├─ FTKEY: keygen_from_seed_32 → sign_bytes            │
│   └─ T-THRESHOLD: Shamir k-z-n → ceremony V2            │
│        → ft1536-sys::generate_from_seed → sign          │
└───────────────────────────┬─────────────────────────────┘
                            ▼
              realne bajty podpisu FT1536
              verify = Ft1536Signature::verify / verify_bytes
```

## Zgodność ścieżek

| Ścieżka | API | Seed |
|---|---|---|
| FTKEY Host v0 | `keygen_from_seed_32` (ftkey-sys) | z pieczęci / tokenu |
| FTKEY token | unseal hmac-secret → `keygen_from_seed_32` | **z YubiKeya** |
| T-THRESHOLD V2 | `generate_from_seed` (ft1536-sys) | z udziałów k-z-n |

Wszystkie idą przez **`falcon_keygen_set_seed(..., replace=1)`** →
ten sam seed = **ten sam pk** (determinizm V2 potwierdzony).

## Co to daje

1. **Seed w spoczynku:** na YubiKeyu (PIN+touch, nie dysk).
2. **Próg (opcjonalnie):** ten sam seed dzielony Shamir k-z-n —
   reconstruct tylko w ceremonii V2 (`sign_ceremony_v2_from_matrix`).
3. **Podpis:** realne bajty FT1536; verify publiczny.
4. **Kasowanie:** seed/key zeroizowane po ceremonii (Drop).

## Granice (szczerze)

- Host v0 widzi seed w RAM podczas operacji (ADR-004 — nie sprzętowy signer).
- V2 = próg na poziomie **seeda**; pełne MPC-sign (klucz nigdy) = F04/F05.
- Utrata YubiKeya bez backupu = utrata seeda (fail-closed).
- Równoległy zapis largeBlob innego klienta = poza gwarancją libfido2.

## Pliki

- FTKEY: `docs/adr/ADR-004-token-resident-seed.md`, `ftkey-sys::keygen_from_seed_32`
- Spike: `sign_ceremony_v2_from_matrix`, `ft1536-sys::generate_from_seed`
- Testy: `v2_ceremony_*`, `v1_engine_*`, `keygen_from_seed_deterministic`
