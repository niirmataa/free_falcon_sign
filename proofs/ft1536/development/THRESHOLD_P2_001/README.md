# THRESHOLD_P2_001 — progowy podpis FT1536 (P2)

**Status: IN_PROGRESS — G0 (kontrakt, plan, spec v0).**
**To NIE jest produkcja, NIE jest threshold signing, NIE jest deklaracja bezpieczeństwa.**

Cel programu: progowy podpis FT1536 **k-z-n** w modelu **złośliwym**,
w którym **klucz nigdy nie istnieje w całości** — ani w setupie, ani w podpisie —
a wynikowy podpis jest **bajtowo zgodny** z weryfikatorem `ft1536-sys`.

## Wejście

`proofs/ft1536/development/THRESHOLD_SPIKE_001/` (414/414) jest dla tego toru:

- **specyfikacją zachowania** (co ma być liczone),
- **oracle/testkit** (złoty łańcuch, piny, differential vs silnik C),
- **checklistą retained failures i audytu**.

Spike **nie** jest kopiowany 1:1. Dealerzy, stand-iny, fail-openy i plikowy
mailbox zostają w spiku jako materiał badawczy, nie jako fundament produkcji.
Mapa dyspozycji: [`SOURCE_MAP.md`](SOURCE_MAP.md).

## Dokumenty wejściowe

| Plik | Rola |
|---|---|
| [`PLAN.md`](PLAN.md) | master plan: cel, zakres, architektura, workstreamy, kamienie milowe |
| [`SPEC.md`](SPEC.md) | specyfikacja protokołu v0 (szkic, punkty otwarte jawne) |
| [`THREAT_MODEL.md`](THREAT_MODEL.md) | aktywa, napastnik, granice zaufania, założenia |
| [`DECISIONS.md`](DECISIONS.md) | decyzje właściciela i propozycje do potwierdzenia |
| [`CLAIMS_REGISTER.md`](CLAIMS_REGISTER.md) | co wolno twierdzić, z jakim dowodem, a czego nie |
| [`GATES.md`](GATES.md) | bramki G0–G5: wejście, wyjście, artefakty, recenzent |
| [`WORK_PACKAGES.md`](WORK_PACKAGES.md) | konkretne pakiety WP-001…WP-066 z kryteriami odbioru |
| [`RISKS.md`](RISKS.md) | rejestr ryzyk z wyzwalaczami i mitigacjami |
| [`SOURCE_MAP.md`](SOURCE_MAP.md) | co przejąć ze spike'a, co przepisać, czego zakazać |

## Zasady

1. **Prawda przed tempem.** Każde twierdzenie ma status w `CLAIMS_REGISTER.md`.
   Brak dowodu = `OPEN`/`ASSUMED`, nigdy `PROVEN`.
2. **Bramki nie są dekoracją.** Nie przechodzimy do G(n+1) z otwartym
   warunkiem G(n); wyjątek wymaga jawnej decyzji właściciela w `DECISIONS.md`.
3. **Jeden writer Git naraz.** Małe commity z dokładnymi pathspecami;
   bez amend/force-push; push wyłącznie po słowie właściciela.
4. **Autor ≠ recenzent.** Niezależny odbiór przed każdym `REVIEWED`.
5. **Brak dealerów i stand-inów w ścieżce produkcyjnej.** Tylko `#[cfg(test)]`.
6. **Sekrety nie trafiają do logów, testów ani repo.** Dane syntetyczne.
7. **Zero cichych napraw.** Retained failures zachowane z przyczyną i datą
   przeglądu; korekta = nowy wpis, nie nadpisanie.

## Czego ten katalog NIE jest

- nie jest dowodem bezpieczeństwa FT1536 (baza ma osobny tor),
- nie jest gotowym SDK ani usługą,
- nie jest miejscem na publikację lub integrację z `[N]`/FTKEY bez odbioru,
- nie zastępuje `THRESHOLD_SPIKE_001` ani jego historii.

## Następny krok

G0 jest domknięty dokumentacyjnie (SPEC v0 istnieje). Właściciel potwierdza
sześć decyzji z [`DECISIONS.md`](DECISIONS.md) (D-003/010/011/013/016/021;
D-022 przed G2), potem startuje WP-010/011 (workspace + hermetyczne CI)
i WP-012 (port prymitywów z KAT). G2 buduje signing plumbing na
`TEST-ORACLE`; G3 dopiero wprowadza bezdealerowy setup NTRU i realny
Klein/ffSampling.
