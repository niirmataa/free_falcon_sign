# ERRATA v2.1 — naprawa escape w RESULT.json (decyzja wlasciciela 2026-09-25)

Pakiet v2 (freeze autora, W=/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001,
kopia w repo: work/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001_OBRAZY/output):
zawieral RESULT.json bedacy NIEPOPRAWNYM JSON-em.

## Wada (dokladnie)

- Plik: RESULT.json, wiersz 46, kolumna 170, offset 3608.
- String: "...their statement has B = build /\ AdvEUF<=... but NO Resources clause yet..."
  zawieral surowego backslasha (sekwencja `\ ` - niepoprawny escape JSON).
- Hash RESULT.json v2: 2f09e77682ca88cefca03a7f4951a1407162c063681fd9423cfac0db2ad59154
  (zgodny z pinem OUTPUTS v2 - bajty v2 byly nienaruszone, wada jest w pakiecie autora).
- Objaw: `json.loads` rzuca `Invalid \escape`; archive.py import v2 niemozliwy bez naruszenia rygoru.
- Skan wszystkich JSON-i v2: to JEDYNY defekt.

## Naprawa (dokladnie 1 bajt)

- `\` -> `\\` w tym jednym stringu (escape samego backslasha; tresc stringa po parsowaniu IDENTYCZNA).
- Hash RESULT.json v2.1: d603455d6c7716bb27c7d6776d80b7af14a426ca0558d7562e4af1bf9058798f
- Zadnych innych zmian bajtowych; REPORT.md bez zmian (e593d91ed0e827bd240a145a31d2767407c4ea55eafd34e9a07252b49cd10d7c).
- Czlonkowie: v2 mialo294; v2.1 ma 295 (dodany ten plik ERRATA.md).
- Status: PARTIAL_PROOF - NIEZMIENNY (fix jest skladnia JSON, nie twierdzeniem).

## Piny v2 (zachowane jako historia, NIE importowane)

- OUTPUTS v2: cc01337d093029458d07946088066b1ffeae93ac59a0896b8e26968d8c215269 (294 czlonkow)
- REPLAY_SEED v2: 375e14a322808d81309c0ba123839854325e7580044534ed1e2f1ea0b1f0b630
- v1 (293 czlonkow, poprawny JSON) tez pozostaje historia: OUTPUTS 6f0d4f42f1a71526070864f162252e4105d012786104d50ef1ed16eca7975e7f.

## Rozliczenie originow INPUTS

6 plikow bootstrapu zlecenia (gole nazwy w INPUTS.sha256) nie ma kopii w OUTPUTS;
import rozlicza je z originow = <source>/<nazwa>. Tu leza jako jawne kopie plikow
z W/inputs/bootstrap/ (hash-zgodne z INPUTS). Oryginalne piny bootstrapu:
MANIFEST fad15f37..., TASK 407c4f8d..., PREVIOUS_PACKAGE_PINS e6193285...,
PREV_VERIFICATION eac59909..., README f016becc..., START_DLA_MODELU 1d548f6b...
