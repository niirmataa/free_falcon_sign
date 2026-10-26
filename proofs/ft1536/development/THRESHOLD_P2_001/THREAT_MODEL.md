# THREAT MODEL — THRESHOLD_P2_001

**Wersja:** 0.1 (2026-10-26) · **Status:** G0, do potwierdzenia przez właściciela
**Zakres:** protokół progowego podpisu FT1536 (P2), implementacja referencyjna
i docelowa usługa. Nie obejmuje bazy FT1536 ani silnika C jako przedmiotu dowodu.

---

## 1. Aktywa

| Aktywo | Gdzie żyje | Skutek kompromitacji |
|---|---|---|
| `sk` / trapdoor `f,g,F,G` | wyłącznie udziały u stron | pełne sfałszowanie podpisu |
| seed 32 B (jeśli używany) | udziały / DKG | odtworzenie klucza |
| udziały Shamir | sealed storage strony | k−1 udziałów = brak klucza; k = klucz |
| MAC δ / klucze auth | strony, DKG | fałszerstwo otwarć |
| PRSS seeds | pary stron | przewidzenie masek |
| nonce/salt 40 B | publiczny | replay/fault, nie sekret |
| `pk`, transkrypt setupu | publiczne | podmiana pk = utrata wiarygodności |
| polityka podpisu, audyt | koordynator | nadużycie uprawnień |
| kod i binaria | release | supply chain |

---

## 2. Napastnik

**Model podstawowy (v1):**

- **static corruption** do `t = k−1` stron,
- **malicious** (dowolne odstępstwo od protokołu),
- **rushing** (widzi wiadomości uczciwych w rundzie przed wysłaniem swoich),
- kontrola sieci: opóźnienia, reorder, drop, replay, podmiana,
- odczyt dysku skorumpowanego hosta (ale nie HSM uczciwej strony),
- wybór komunikatów adaptacyjny do widoku.

**Poza modelem v1 (jawne):**

- physical access / fault injection na uczciwym hoście (dojdzie w G4),
- side-channel na uczciwym hoście (dojdzie w G4),
- quantum,
- coercion/coercion-resistance,
- traffic analysis,
- kompromitacja PKI/CA,
- złamanie SHAKE256, Ristretto DL, TLS 1.3,
- kompromitacja `ft1536-sys` (traktowany jako TCB do czasu audytu),
- operator celowo publikujący sekrety.

---

## 3. Granice zaufania

| Granica | Zaufanie | Co musi być prawdą |
|---|---|---|
| Klient → koordynator | klient autoryzowany, koordynator nieufny dla sekretu | koordynator nie widzi udziałów |
| Koordynator → strony | kanał uwierzytelniony | mTLS, sesja, replay-window |
| Strona ↔ strona | kanał uwierzytelniony | mTLS/Noise, transkrypt |
| Strona ↔ storage | HSM/TPM | seal/unseal, attestation |
| Protokół ↔ silnik verify | TCB | pin wersji, KAT, audyt |
| Człowiek ↔ ceremonia | proces | kworum custodians, nagranie, hash transkryptu |

**Uwaga (D-023):** model **nie zawiera QSX/VM ani enclave**. Kompromitacja
jednego hosta jest modelowana jako corruption jednej strony; bezpieczeństwo
opiera się na progu i honest majority, nie na hypervisorze. Nie ma
założenia „L1/L2”, które trzeba by dowodzić dla VM.

---

## 4. Założenia kryptograficzne

| ID | Założenie | Status |
|---|---|---|
| A-01 | FT1536 jest EUF-CMA (baza) | **OPEN** — tor T12.1, nie zakładać |
| A-02 | SHAKE256 = FIPS 202 | przyjęte |
| A-03 | Ristretto255 DL/DDH dla Pedersen | przyjęte |
| A-04 | TLS 1.3/mTLS zapewnia auth+confidentiality | przyjęte |
| A-05 | OS CSPRNG uczciwych stron | przyjęte |
| A-06 | honest majority `k ≤ (n+1)/2` | przyjęte dla v1/v2 |
| A-07 | synchroniczne rundy z timeoutem | przyjęte dla v1 |
| A-08 | brak side-channeli w v1 | **do usunięcia w G4** |

**A-01 jest warunkiem jawnym.** Bez dowodu bazy każde twierdzenie o progu
jest warunkowe. Nie wolno wpisywać A-01 jako przesłanki dowiedzionej.

---

## 5. Cele bezpieczeństwa

| ID | Cel | Miara |
|---|---|---|
| O-01 | **Unforgeability** | żaden koalicja ≤ t nie vytworzy podpisu na nowy komunikat, nawet z oracle signing |
| O-02 | **Key secrecy** | żaden proces/host nie ma pełnego `sk`/trapdoora; k−1 udziałów nie odtwarza klucza |
| O-03 | **Identifiable abort** | każda odmowa wskazuje winnego; brak częściowego podpisu |
| O-04 | **Public verifiability setupu** | wszystkie uczciwe strony zgadzają się na `pk` i transkrypt |
| O-05 | **Refresh** | po refresh stare udziały bezużyteczne, `pk` bez zmian |
| O-06 | **Replay/rollback resistance** | stara sesja/epoka nie może być powtórzona |
| O-07 | **No silent corruption** | każdy błąd = `Err`/abort, nigdy „prawie dobry" wynik |

---

## 6. Klasy ataków i kontrole

| Atak | Kontrola | Gdzie test |
|---|---|---|
| Fałszywy udział DKG | Pedersen VSS + complaints | W4 |
| Fałszywy wkład NTRU | publiczny check `fG−gF=q` na udziałach | W4 |
| Zepsute auth triple | `c=a·b` + MAC przed użyciem | W3 |
| Skorelowane fałszerstwo MAC | ukryte δ, MAC na każdej linii | W3 |
| Replay rundy | sesja + epoka + licznik rundy + transkrypt | W11 |
| Podmiana pk | hash transkryptu + pin `pk` w kliencie | W4 |
| Malformed wire | `TryFrom`, limity, fuzz | W2 |
| Panic/overflow | brak `unwrap` na wejściu, fuzz, `panic=abort` + supervisor | W2 |
| Side-channel | CT, dudect/TVLA, masking | W12 |
| Fault | detekcja, redundancy, testy | W12 |
| Supply chain | vendor, pin, SBOM, reproducible | W13 |
| Operator error | ceremonia, kworum, checklist | W13 |

---

## 7. Co łamie model (stop-and-report)

Natychmiast zatrzymać i zaraportować, jeśli:

1. Uczciwa strona musi odtworzyć pełny klucz, żeby dokończyć protokół.
2. Jakikolwiek check jest fail-open albo „best effort".
3. `pk` nie jest wiązany z transkryptem setupu.
4. Abort nie jest identyfikowalny.
5. Test wymaga dealera lub stand-inu w ścieżce produkcyjnej.
6. Pojawia się zależność od niepinowanego artefaktu lub zewnętrznej ścieżki.
7. Wynik side-channel/fault jest niejednoznaczny, a ktoś chce go „zaliczyć".

---

## 8. Otwarte pytania do właściciela

1. Czy v1 ma być **2-of-3** (rekomendacja), czy od razu 3-of-5?
2. Czy wymagamy **identifiable abort** już w v1, czy wystarczy abort?
3. Czy koordynator może być osobą prawną/trzecią stroną, czy tylko orchestratorem?
4. Czy klucz ma być **per-tenant**, czy jeden pk na instalację?
5. Czy dopuszczamy **soft-seal** (bez HSM) w G2–G3, czy HSM od G2?
6. Jaki jest budżet latencji/rozmiaru podpisu dla produktu?
