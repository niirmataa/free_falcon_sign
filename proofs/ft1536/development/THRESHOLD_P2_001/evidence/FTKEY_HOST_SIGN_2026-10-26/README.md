# FTKEY host-path — żywy `sign` + `verify` (2026-10-26)

**Status:** **PASS** dla pojedynczego podpisującego FTKEY (host-path, bez VM).
**To NIE jest:** threshold signing, P2 E2E, VM/QSX, ani claim bezpieczeństwa.
**Cel:** domknięcie F-8 z [`../../FTKEY_INTEGRATION_MAP.md`](../../FTKEY_INTEGRATION_MAP.md) —
żywy łańcuch `token FIDO2 → unseal → keygen → sign → verify` na tym samym
kluczu, który powstał 2026-10-19.

## Pin

- FTKEY `HEAD` = `f49384c935f1db2c3230b1022ad36d4bfc3ba5bb` (drzewo robocze
  brudne — bez zmian w silniku; szczegóły w mapie, §1).
- Token: `1050:0406 Yubico YubiKey 4/5 U2F+CCID`, `hmac-secret` + PIN/UV;
  PIN wpisał właściciel lokalnie — nie ma go w argv, logach ani repo.

## Artefakty

| Plik | Rozmiar | SHA-256 |
|---|---|---|
| `doc.txt` (syntetyczny dokument) | 63 B | `f9093339ee2dd02a5f72e77321c8f31b7e8fbaea3e8c287b8129966431a89145` |
| `doc.sig.json` (publiczny bundle) | 10 778 B | `0f00500dca56b10afc7881c847c3ee5c2d30ec4a0d46a6ed1b68ccad6d7d812a` |

`doc.txt` zawiera jawny marker `synthetic: true`; nie jest to dokument
operacyjny. Rozszerzenie `.txt` (nie `.bin`) wynika z lokalnej reguły
`*.bin` w `proofs/ft1536/development/.gitignore`; bajty są bez zmian
(63 B, hash wyżej).

Bundle ma dokładnie 5 pól:

| Pole | Wartość |
|---|---|
| `alg` | `FT1536-STATIC` |
| `pubkey` | 2 881 B |
| `nonce` | 40 B |
| `sig` | 2 390 B |
| `msg_sha256` | zgodny z `doc.txt` |

`fp` = SHA-256(`pubkey`) =
`eb61b8afc072c1e450753ee9aa7dda5d8d12ca7a3aa545f69a7574b22c3348b6`
= `ftkey.fp` z 2026-10-19. Ten sam klucz odtworzyły wcześniej `pub`
(2026-10-26) i teraz `sign` — brak rotacji/rozjazdu.

## Przebieg

Podpis (przebieg historyczny; PIN wpisany lokalnie w terminalu
właściciela; plik podpisany wówczas jako `doc.bin`, bajty identyczne
z `doc.txt`):

```sh
cd /home/footfalcon/Muzyka/FTKEY
./target/debug/ftkey sign \
  --seal ftkey.seal \
  --in  /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FTKEY_LIVE_001/doc.bin \
  --out /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FTKEY_LIVE_001/doc.sig.json \
  --token fido
# -> "signed .../doc.sig.json"
```

Weryfikacja (bez tokena, bez PIN-u; reviewer może powtórzyć na tym
artefakcie):

```sh
cd /home/footfalcon/Muzyka/FTKEY
./target/debug/ftkey verify \
  --in  doc.txt \
  --sig doc.sig.json
# -> OK, rc=0
```

## Zakres i ograniczenia

- **PASS** dotyczy jednego pełnego seeda i jednego tokena; nie ma udziałów,
  progu, kworum ani MPC. To nie jest P2.
- VM/QSX E2E pozostaje `NOT_RUN` — po D-023 to dług FTKEY, nie blocker P2.
- Zapis koperty 4 KB (`largeBlobs`, F-4) pozostaje `NOT_RUN`; nie dotyczy
  B′, gdzie udział pułapki (~11,5 KB) leży w pieczęci, a token jest bramą KEK.
- Test nie zapisywał tokena: `sign` odpieczętowuje seed, podpisuje i zeruje
  materiał; bundle zawiera wyłącznie materiał publiczny.
