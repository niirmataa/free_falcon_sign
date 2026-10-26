# SPEC — protokół progowego podpisu FT1536 (P2)

**Wersja:** 0.1 (2026-10-26) · **Status:** G0, szkic normatywny
**Zakres:** protokół k-z-n dla FT1536, implementacja referencyjna i docelowa.
**To NIE jest dowód bezpieczeństwa, NIE jest deklaracja produkcji.**
Sekcje oznaczone **OPEN** nie są normatywne dla profilu `PROD`, dopóki nie
zostaną zamknięte decyzją i dowodem.

Słowa **MUST**, **MUST NOT**, **SHOULD**, **MAY** mają znaczenie normatywne.
Wszystkie liczby są dokładne; „rząd wielkości” jest tak oznaczony.

---

## 1. Cel i zakres

Specyfikacja definiuje **widoczne na drucie** zachowanie protokołu progowego
podpisu FT1536:

1. setup bez ujawniania klucza (docelowo bez dealera),
2. podpis k-z-n na komunikacie,
3. odświeżanie i odzyskanie udziałów,
4. transkrypt, sesje, epoki, abort i rozliczanie winy,
5. profile zgodności `TEST-ORACLE` i `PROD`.

**Poza zakresem:** bezpieczeństwo bazy FT1536 (tor T12.1), P1 seed-custody,
produkt FTKEY, **QSX/VM i `ftkey-vm` (D-023)**, `[N]`, UI, FIPS 140-3, QROM,
produkt sprzętowy.

**Zasada nadrzędna:** podpis wyjściowy jest **zwykłym podpisem FT1536**.
Weryfikator nie wie o progu, stronach ani udziałach. Wszelkie metadane
progu są w transkrypcie/receipcie, nie w bajtach podpisu.

---

## 2. Parametry i notacja

| Symbol | Wartość | Uwaga |
|---|---|---|
| `q` | 18433 | ciało `Z_q` |
| `N` | 1536 | `logn=10` |
| `R` | `Z_q[X]/(X^1536 − X^768 + 1)` | pierścień negacykliczny |
| `f,g` | ternarne, krótkie | rozkład wg klucza FT1536 |
| `F,G` | krótkie, `fG − gF = q` | relacja NTRU |
| `h` | `g · f^{-1} mod q` | publiczny klucz wielomianowy |
| `pk` | 2881 B | encode 18433 |
| `sk` | 7681–10369 B | bufor 10370 B |
| `nonce` | 40 B | sól podpisu, publiczna |
| `sig` | `0xAA || compress_static(s2)` | j=8, Golomb-Rice |
| `B_norm` | 2 093 922 385 | `FALCON_FT1536_NORM_BOUND2` |
| `H` | SHAKE256 | FIPS 202 |
| `G` | Ristretto255 | Pedersen VSS |
| `k,n` | v1: 2-of-3 (D-003) | `2 ≤ k ≤ n`, `k ≤ (n+1)/2` |
| `x_i` | niezerowe, różne w `Z_q` | współrzędne Shamira |
| `sid` | 32 B | unikalny identyfikator sesji |
| `epoch` | u64 | epoka klucza |
| `party_id` | 16 B | losowy/pochodny, nie nazwa |

**Hash-to-point** (zgodnie z silnikiem):

```text
t = HTP(SHAKE256(nonce || msg))
HTP: kolejne 2 B big-endian; przyjmij w < 55299; t_i = w mod 18433
```

`pk` **nie** wchodzi do tego SHAKE. `t` jest publiczne i wszystkie strony
MUSZĄ uzyskać identyczne `t`; rozjazd = abort.

**Równanie weryfikacji:** `s2 · h − s1 = t` w `R`. Silnik sprawdza
dodatkowo formę kwadratową `Q(s1,s2) < B_norm` (FFT embedding, cross-terms),
nie tylko `L2`. Patrz §7.6.

**Postać klucza w v1:** wariant **B′** (D-024) — setup dzieli 32-bajtowy
`seed*`, jednorazowo liczy w MPC `G(seed*)` i otrzymuje udziały pułapki
`(f_i,g_i,F_i,G_i)`; seed jest zeroizowany po setupie. Podpis używa
A-style MPC ffSampling; token jest bramą KEK pieczęci, nie nośnikiem
udziału. Czysty **B** (udział seeda + `G(seed*)` per podpis) jest
odrzuconą alternatywą; A pozostaje w historii jako D-021 `SUPERSEDED`.
Spec jest niezależny od reprezentacji w miejscach, gdzie to możliwe,
ale profile `PROD` i wektory KAT odnoszą się do B′.

---

## 3. Role i granice zaufania

| Rola | Ma udziały? | Może podpisać? | Odpowiedzialność |
|---|---|---|---|
| Klient / requester | nie | nie | autoryzacja komunikatu, pin `pk_hash` |
| Koordynator | **nie** | nie | sesje, polityka, kolejność, audyt, fan-out |
| Node `P_i` | tak, `share_i` | tak, w kworum | przechowywanie, obliczenia, abort |
| Weryfikator | nie | nie | `ft1536-sys`, KAT, niezależny check |
| Obserwator/audytor | nie | nie | transkrypt, blame, dowody |
| Kuratorzy setupu | chwilowo, w ceremonii | nie | kworum, nagranie, hash transkryptu |

**Granice:**

- Klient → koordynator: klient uwierzytelniony; koordynator nieufny wobec
  sekretu. Koordynator nie może odczytać udziałów ani `s1`.
- Koordynator → node: mTLS + envelope MAC; koordynator nie może podrobić
  wiadomości node bez wykrycia.
- Node ↔ node: mTLS/Noise + envelope MAC; transkrypt wiąże sesję.
- Node ↔ HSM/TPM: seal/unseal; klucz udziału nie leży plaintext na dysku.
- Protokół ↔ `ft1536-sys`: TCB, pin wersji, KAT, differential.
- Człowiek ↔ ceremonia: kworum, nagranie, `pk_hash` w publikacji.

**Koordynator może:** odmówić, opóźnić, wybrać kolejność, ubić sesję.
**Koordynator nie może:** poznać udziału, `s1`, `f`, `g`, `F`, `G`, seeda;
wytworzyć podpisu bez kworum; zmienić `pk` bez wykrycia.

---

## 4. Niezmienniki systemu

| ID | Niezmiennik | Egzekucja | Test |
|---|---|---|---|
| I-01 | Pełny klucz nigdy nie istnieje w jednym procesie/hoscie | brak API reconstruct w `PROD`; audyt symboli | test + `grep` + audyt |
| I-02 | Brak częściowego podpisu | każdy błąd = `Err`/abort; `s2` otwierane tylko po checku | negative tests |
| I-03 | Fail-closed | każdy check zwraca `Err`; zero „best effort” | fuzz + tamper |
| I-04 | `pk` związany z transkryptem | `pk_hash` w transkrypcie i receipcie | KAT |
| I-05 | Bajtowa zgodność z silnikiem | `0xAA`, `compress_static`, nonce 40 B | differential |
| I-06 | Brak replay/rollback | `sid`, `epoch`, `round`, `seq`, replay-window | replay tests |
| I-07 | Brak sekretów w logach/repo | redakcja, `ft-secrets-hygiene` | skan logów |
| I-08 | Deterministyczny transkrypt | sortowanie po `(sender,seq)` w rundzie | cross-run hash |
| I-09 | Brak dealera/stand-inu w `PROD` | feature `testkit` wyłączony; brak symboli | build check |
| I-10 | Niezależna weryfikacja wyniku | `ft1536-sys` + drugi check | KAT + audyt |

Naruszenie któregokolwiek = **stop-and-report**, nie „obejście”.

---

## 5. Profile zgodności

### 5.1 `TEST-ORACLE` (tylko testkit)

Służy do sprawdzenia **plumbing** przed badaniami G3:

- setup: znany klucz testowy dzielony na wkłady (dealer w testkicie);
- sampler: deterministyczny/stand-in (np. zaokrąglenie), jawnie oznaczony;
  testkit MAY użyć znanego `f,F` do wygenerowania `z`, ale `protocol`/`core`
  **MUST NOT** mieć API reconstruct;
- build: `#[cfg(test)]` lub feature `testkit`; **MUST NOT** linkować do
  binarium `PROD`;
- transkrypt: `profile = 0x01`, wpis w receipcie;
- twierdzenia: wyłącznie „plumbing działa na wektorach testowych”, nigdy
  „bezpieczny”, „bez dealera”, „produkcyjny”.

### 5.2 `PROD`

- setup: MPC `G(seed*)` B′ → ważny NTRU bez dealera i bez rekonstrukcji,
  publiczna weryfikowalność (OPEN: O-16/O-04);
- sampler: realny Klein/ffSampling z budżetem precyzji (OPEN: O-02/O-03);
- brak symboli testkit/dealer/`xof`/`iso`;
- wszystkie checki fail-closed, zeroizacja, HSM (G3+);
- KAT + differential + audyt.

**Reguła:** `TEST-ORACLE` nie może być podstawą claimu `PROD`. Bramka G2
może zamknąć signing plumbing na `TEST-ORACLE`; G3 wymaga `PROD`.

---

## 6. Setup (DKG)

### 6.0 Profil B′ (v1, D-024) — nadrzędny

Setup v1 ma dwie fazy:

**Faza A — seed-share DKG (normatywna dla G2/G3).** Strony wykonują
Pedersen VSS nad 32-bajtowym `seed*` jako wektorem 32 wartości
w `Z_q` (każdy bajt < q; 32 równoległe instancje Shamir stopnia `k−1`,
wspólny `sid`). Zobowiązania: `32·k` punktów, nie `4·N`. Wyjście:
`seed_share_i` (32 elementów `Z_q`) i `seed_commit_root`.

**Faza B — MPC `G(seed*)` (O-16, research; blocker G3).** Strony liczą
w MPC funkcję `G` = `keygen_from_seed_32` (pin silnika) na udziałach
`seed*`, otrzymując udziały `(f_i,g_i,F_i,G_i)` i publiczne `pk`.
`seed*`, `f`, `g`, `F`, `G` nie są rekonstruowane. Po sukcesie
`seed_share_i` jest zeroizowane i **nie** wchodzi do `PartyState`.

W `TEST-ORACLE` (G2) Faza B jest zastąpiona deterministycznym stand-inem
testkit na znanym seedzie testowym; stand-in jest `#[cfg(test)]`/`testkit`
i nie istnieje w buildzie `PROD` (D-009).

**Zakres §6.1–§6.4:** wspólne ramy (wejście, rundy, adjudykacja, wyjście,
punkty OPEN). Tabela S1–S6 i zobowiązania `4·N` opisują **ścieżkę
A-style** (historia D-021) i nie są normatywne dla B′; implementacja B′
używa tej samej maszyny rund z 32 wartościami zamiast `4·N`
i Fazy B w miejsce agregacji NTRU.

### 6.1 Wejście i stan

`SetupInit` (koordynator):

```text
version=1, sid, epoch, k, n, parties[], xs[], policy_hash,
mode ∈ {TEST_ORACLE, PROD}, setup_nonce
```

Walidacja każdej strony (MUST):

- `2 ≤ k ≤ n`, `k ≤ (n+1)/2`, `n ≤ 16` (v1),
- `xs` niezerowe, różne, w `Z_q`,
- `parties` różne, `party_id` 16 B,
- `sid` świeży (brak w replay cache),
- `epoch` > ostatniej epoki dla tego klucza (lub `epoch=0` dla nowego),
- `policy_hash` zgodny z lokalną polityką,
- `mode` zgodny z buildem (`PROD` odrzuca `TEST_ORACLE`).

### 6.2 Rundy

| Runda | Komunikat | Treść | Publiczne? |
|---|---|---|---|
| S0 | `SETUP_ACCEPT` | `party_id`, `state_hash`, świeży `setup_nonce_i` | tak |
| S1 | `CONTRIB_COMMIT` | `H(contribution || vss_blind || sid)` | tak |
| S2 | `CONTRIB_REVEAL` | pełne zobowiązania Pedersen VSS dla `f,g,F,G` | tak |
| S3 | `VSS_SHARE` | udziały i blindy dla każdej strony (poufne) | nie |
| S4 | `COMPLAINT` | zarzut + otrzymany udział/blind | tak |
| S4′ | `COMPLAINT_RESPONSE` | poprawny udział/blind albo brak | tak |
| S5 | `SETUP_FINAL` | `pk`, `pk_hash`, `TH_final`, lista przyjętych/odrzuconych | tak |
| S6 | `SETUP_CERTIFY` | podpis strony na `TH_final` | tak |

**S1 — zobowiązanie.** Każda strona losuje wkład `(f_i,g_i,F_i,G_i)`
z rozkładu określonego w WP-030/WP-041 (OPEN: dokładny rozkład wkładu)
i publikuje `H(contribution || vss_blind || sid)`. Zobowiązanie wiąże
wkład z sesją; brak związania = replay.

**S2 — VSS.** Dla każdego z czterech wielomianów strona publikuje **pełny**
zestaw zobowiązań per współczynnik: `C_{j,l} = a_{j,l}·G + r_{j,l}·H`
(dla `l=0..N-1`). `PROD` **MUST NOT** używać próbki `8` współczynników
(audyt #7). Rozmiar: `4·N·32 B ≈ 196 kB` na stronę; dla `n=5` ~1 MB.
Dopuszczalne; mierzone w WP-030.

Generatory: `G = RISTRETTO_BASEPOINT_POINT`;
`H = RistrettoPoint::from_uniform_bytes(SHA3-512("FT1536/threshold/v1/pedersen-h"))`
(nothing-up-my-sleeve, pin w `vss.rs`). Dla B′ Faza A: 32 wartości `Z_q`,
`k` zobowiązań na wartość (32·`k` punktów zamiast `4·N`).

**S3 — udziały.** Dla każdej strony `j`: `s_{i→j} = Σ_l a_l·x_j^l`
i analogicznie blind. Wysyłka poufna, uwierzytelniona, związana z `sid`.
Strona `j` weryfikuje:

```text
s·G + t·H = Σ_l C_l · x_j^l
```

Niezgodność → `COMPLAINT {dealer=i, accused=i, share, blind}`.

**S4 — adjudykacja.** Każdy może zweryfikować complaint z publicznych
danych. Jeśli complaint jest poprawny, dealer może odpowiedzieć poprawnym
udziałem; jeśli odpowiedź weryfikuje się, complaint jest odrzucany,
a accuser traci wiarygodność (nie jest karany w v1, ale jest oznaczony).
Jeśli dealer nie odpowie albo odpowiedź nie weryfikuje się — dealer jest
**dyskwalifikowany**, a jego wkład wykluczony. Głosowanie: decyzja wynika
z transkryptu, nie z „większości głosów” koordynatora.

**S5 — agregacja i `pk`.**

- Suma udziałów: `share_j = Σ_{i∈A} share_{i→j}` (wagi `w_i=1` w v1;
  ważenie tylko po jawnej decyzji; dotyczy ścieżki A-style).
- Zobowiązania agregowane addytywnie; `C_agg = Σ C_i`.
- Relacja NTRU: na udziałach policz `fG − gF`; sprawdź zero-testem
  (open tylko bit `accept`), **bez** otwierania różnicy (OPEN: O-04).
  W `TEST-ORACLE` dozwolone jawne sprawdzenie różnicy na wektorze testowym.
- `pk`: policz `h = g·f^{-1}` w MPC; otwórz **tylko** `h` (OPEN: O-05).
  W `TEST-ORACLE` `pk` może pochodzić z wektora testowego.
- `pk_hash = H("FT1536/threshold/v1/pk" || pk)`.
- `TH_final` = hash transkryptu setupu (§10).
- `SETUP_FINAL` zawiera `pk`, `pk_hash`, `TH_final`, listę przyjętych
  i odrzuconych. Wszystkie uczciwe strony MUSZĄ uzyskać identyczne
  `pk_hash` i `TH_final`; inaczej abort.

**S6 — certyfikat.** Każda strona podpisuje `TH_final` swoim kluczem
tożsamości. Klient dostaje `SetupCertificate` z podpisami; weryfikuje
`pk_hash` względem pinu. Brak kworum podpisów = setup nieukończony.

### 6.3 Wyjście setupu

```text
PublicSetup {
  sid, epoch, k, n, parties[], xs[], pk, pk_hash, TH_final,
  accepted[], disqualified[], profile
}
PartyState {
  party_id, sid, epoch, k, n, xs[], pk_hash, TH_final,
  share_f, share_g, share_F, share_G,          // sekret
  vss_agg_root, mac_key_epoch,                  // sekret
  state_version
}
```

`PartyState` **MUST** być zapisany w sealed storage; `Debug`/`Clone`
zabronione; `ZeroizeOnDrop`; brak serializacji plaintext.

### 6.4 Co jest jawnie OPEN w setupie

1. **MPC `G(seed*)` (B′)** — obwód keygenu `keygen_from_seed_32`
   (rejection sampling + NTRU solve) w MPC; wynik musi być ważnym NTRU
   bez rekonstrukcji `seed*`. Spike tego nie robi. To jest **główny
   problem badawczy P2**, nie „implementacja do napisania”. Ścieżka
   A-style (bezdealerowy, ważny keygen NTRU z sumy wkładów) jest
   `SUPERSEDED` przez D-024 i pozostaje referencją.
2. **`pk` bez reconstruct** — MPC inversion `f^{-1}` i mnożenie przez `g`.
3. **Zero-test relacji NTRU** bez otwierania różnicy.
4. **Pełny VSS** i koszt 196 kB/stronę; alternatywy (commitment schemes)
   tylko z dowodem.
5. **Dystrybucja wkładów** i zakresy `f,g,F,G`; range proof `|F| < q/2`
   (spike ma wersję na udziałach; wymaga audytu).
6. **Dyskwalifikacja** a bezpieczeństwo: jeśli dealer zostanie wyrzucony,
   suma pozostałych wkładów musi nadal być poprawna; protokół nie może
   „naprawiać” przez odtworzenie klucza.

**Do czasu zamknięcia O-16 setup `PROD` nie istnieje.** G2 używa
`TEST-ORACLE` (Faza B = stand-in testkit); G3 jest bramką realnego setupu.

---

## 7. Podpis

### 7.1 Wejście

```text
SignRequest { sid, epoch, msg, policy_hash, request_id, participants[], nonce_mode }
```

Walidacja (MUST):

- `msg` ≤ 1 MiB, `sid` świeży, `epoch` aktualna,
- `participants` ⊆ parties, `|participants| ≥ k`,
- `policy_hash` dopuszcza `msg` i limit,
- `request_id` unikalny; retry z tym samym `request_id` zwraca zapisany
  wynik albo `ABORT`, nigdy drugi podpis,
- stan `PartyState` zgodny z `pk_hash` i `TH_setup`.

### 7.2 Nonce

Cel: nonce 40 B, nieprzewidywalny dla koordynatora i mniejszości,
unikalny per sesja/komunikat.

| Runda | Komunikat | Treść |
|---|---|---|
| N1 | `NONCE_COMMIT` | `c_i = H(".../nonce-commit" || sid || epoch || P_i || n_i || salt_i)` |
| N2 | `NONCE_REVEAL` | `n_i` (40 B), `salt_i` (32 B) |
| N3 | lokalnie | `nonce = H(".../nonce" || sid || epoch || msg || n_1 || ... || n_k)[0..40]` |

- `n_i` **MUST** pochodzić z OS CSPRNG i być świeże; `salt_i` wiąże
  zobowiązanie.
- Koordynator **MUST NOT** wybierać nonce sam.
- Jeśli choć jedna uczciwa strona wnosi entropię, nonce jest nieprzewidywalny.
- Nonce **MUST NOT** być ponownie użyty dla innego `msg`/`sid`/składu.
  Rejestr `nonce_used` trwały; kolizja = abort.
- `nonce` jest publiczne; nie jest sekretem.

### 7.3 Hash-to-point

Wszystkie strony liczą `t` lokalnie z `(nonce, msg)`; porównują
`t_hash = H(".../t" || t)`. Rozjazd = `ABORT {code=HTP_MISMATCH}`.
Brak MPC na tym etapie.

### 7.4 Sampler `z` (OPEN: O-02/O-03)

Cel matematyczny: dla celu `(t,0)` i bazy `B = [[g,−f],[G,−F]]` wylosować
`z = (z0,z1)` z rozkładu dyskretnego Gaussa nad kosetem
`Λ + (t,0)`, tak aby:

```text
s1 = z0·g + z1·G − t
s2 = z0·f + z1·F
Q(s1,s2) < B_norm
```

W `PROD` sampler **MUST**:

- używać realnego ffSampling: FFT3 + LDL tree + Klein (lub równoważny
  algorytm z dowodem), precyzja ≥ 73 bity,
- nie otwierać współczynników `z`, drzewa LDL ani bitów akceptacji,
- mieć budżet odrzuceń `T_max` i fail-closed `AttemptsExhausted`,
- mieć policzoną odległość statystyczną od celu (TV/CI), nie „test
  wygląda dobrze”,
- być niezależny od sekretu w rozkładzie akceptacji (dowód/analiza).

W `TEST-ORACLE` dozwolone jest deterministyczne zaokrąglenie
(`z1 = round(t·f/q)`, `z0 = round(−t·F/q)`) **tylko** jako oracle
plumbing; wynik jest oznaczony `test-oracle` i nie może wejść do KAT
`PROD` jako „poprawny kryptograficznie”.

`ff_lite` z `z0 = −z1·F/f` w `R_q` jest **odrzucony** (retained F2-1:
nie obniża normy). Nie wracać do niego bez nowego dowodu.

### 7.5 Obliczenia i otwarcie

| Runda | Komunikat | Treść |
|---|---|---|
| C1 | `SIGN_ROUND` | rundy MPC: mnożenia, sumy, check normy (schemat w WP-041) |
| C2 | `SIGN_OPEN` | otwarcie **tylko** `s2` (i MAC); `s1` nigdy nie jest otwierane |
| C3 | `SIGN_FINAL` | `sig = 0xAA || compress_static(s2)`, `nonce`, `pk_hash`, `TH_final` |

Checki przed otwarciem `s2` (MUST):

1. `s2` zgodne z udziałami (MAC/commitment),
2. `Q(s1,s2) < B_norm` — **forma silnika**, nie tylko `L2`; jeśli MPC
   liczy konserwatywne górne ograniczenie `Q ≤ c·L2`, to `c·L2 < B_norm`
   (OPEN: O-06),
3. `s1 = s2·h − t` (na udziałach lub po otwarciu `s2`),
4. brak duplikatów/nieznanych stron,
5. `s2` w zakresie encodera; `compress_static` bez przepełnienia.

Po otwarciu `s2` każda strona i koordynator MAY policzyć `s1` i sprawdzić
`ft1536-sys`. **Weryfikacja silnika jest obowiązkowa przed wydaniem**
sygnału klientowi (I-10). Jeśli verify = false — `ABORT {code=VERIFY_FAIL}`,
sygnał nie jest wydawany; `s2` jest publiczne, ale niedokończony podpis
nie może być reklamowany jako sukces.

### 7.6 Norma: dlaczego `L2` nie wystarcza

Silnik `falcon_is_short` używa formy kwadratowej z cross-terms
(`Σ s_i s_{i+hn}`), a nie `Σ s_i²`. Protokół MUSI sprawdzić formę
silnika albo udowodnione górne ograniczenie. Spike mierzy `L2` i dodatkowo
wywołuje engine verify (F2); to jest test, nie dowód dla MPC. W `PROD`
check normy musi być **nie luźniejszy** niż silnik; może być stricter
(bezpieczny abort). Dokładna forma i współczynnik `c` = O-06.

### 7.7 Odrzucenie (rejection)

- Każda próba `z` zużywa świeżą losowość; `t` i `nonce` pozostają te same
  w ramach sesji (Falcon retry).
- `T_max` (v1: 1000) prób; po wyczerpaniu `ABORT {code=SAMPLER_EXHAUSTED}`.
- Rozkład zaakceptowanych `z` MUSI być niezależny od sekretu; inaczej
  odrzucenie = wyciek. To jest warunek dowodowy, nie test.
- Nie wolno „naprawiać” przez zwiększanie `T_max` bez analizy.

### 7.8 Wyjście

```text
Signature { nonce: [u8;40], bytes: Vec<u8>, pk_hash, TH_final }
SignReceipt { request_id, sid, epoch, participants[], TH_final, pk_hash,
              profile, timestamp, abort? }
```

Klient weryfikuje `bytes` przez `ft1536-sys` i `pk_hash`. Receipt nie
wchodzi do podpisu; może być logowany/audytowany.

---

## 8. Refresh, recovery, revocation

### 8.1 Refresh (proactive)

- `REFRESH_INIT { new_epoch, sid }`; stare `epoch` pozostaje ważne do
  `REFRESH_FINAL`.
- Każda strona dodaje świeży sharing zera do `share_f/g/F/G`; suma
  sekretu bez zmian, `pk` bez zmian.
- Nowe zobowiązania/transkrypt; `REFRESH_FINAL` z `pk_hash` i nowym
  `TH_final`; po final stare udziały **MUST** być zeroizowane, stara
  epoka unieważniona.
- Dwufazowo: jeśli ktokolwiek padnie przed final, stara epoka zostaje;
  po final nie ma rollbacku.
- Test: `pk` identyczne, stary udział nie tworzy podpisu, nowy tworzy.

### 8.2 Recovery

- Utrata strony: kworum `k` stron re-share'uje swoje udziały do nowej
  strony (suma zero-sharingów), bez reconstruct klucza.
- Nowa strona dostaje świeży udział; stare udziały unieważnione.
- Wymaga `k` uczciwych stron i nowej tożsamości; nie może ujawnić
  pełnego klucza.
- Procedura i dowód: G5 (WP-061).

### 8.3 Revocation

- `epoch`/`party_id` unieważnione; lista w `RevocationList` podpisana
  przez kworum; klient sprawdza przed użyciem `pk_hash`.
- Brak unieważnienia = stara strona może próbować replay; replay-window
  i epoch to łapią.

---

## 9. Wire protocol

### 9.1 Transport

- `PROD`: TLS 1.3, mTLS, pinned certs/raw public keys, ALPN
  `ft1536-threshold/1`; brak fallbacku do TLS 1.2.
- Alternatywa Noise XX tylko po decyzji D-010; envelope bez zmian.
- Jeden kanał per para (node–node) lub node–koordynator; koordynator
  fan-outuje, ale nie widzi sekretów.
- Framing: `u32` big-endian length + `u8` frame type + payload;
  max 16 MiB; `length=0`/nadmiar = `Err`.
- Keepalive poza transkryptem; timeout per runda (v1: 30 s, setup 120 s,
  sign 120 s; konfigurowalne, ale nie „nieskończone”).

### 9.2 Canonical CBOR

- RFC 8949 deterministic encoding: shortest form, no indefinite length,
  map keys sorted bytewise, no duplicate keys, no tags unless schemas
  allow, max nesting 8, max bstr 16 MiB.
- Dekoder **MUST** odrzucić non-canonical bytes (nie tylko znormalizować).
- Schematy w `wire/schema/*.cddl`; v0 jest szkicem, freeze w WP-027.

### 9.3 `body` i `envelope`

```cddl
body = {
  1: uint,            ; version = 1
  2: bstr .size 32,   ; sid
  3: uint,            ; epoch
  4: uint,            ; round
  5: uint,            ; seq (per sender, strictly increasing)
  6: uint,            ; msg_type
  7: bstr .size 16,   ; sender
  8: bstr,            ; payload (canonical CBOR)
}

envelope = {
  1: body,
  2: bstr .size 16,   ; recipient
  3: bstr .size 32,   ; mac
}

msg_id = SHAKE256("FT1536/threshold/v1/msgid" || canonical(body))[0..32]
mac    = HMAC-SHA256(K_mac(sender,recipient,sid,epoch),
                     "FT1536/threshold/v1/mac" || canonical(envelope \ {3}))
```

- `msg_id` jest niezależny od odbiorcy; transkrypt jest wspólny.
- `mac` jest per para; koordynator nie może podrobić bez klucza pary.
- `K_mac` z TLS exporter + HKDF-SHA256 z tagiem, `sid`, `epoch`,
  `sender`, `recipient`; w `TEST-ORACLE` dozwolony pre-shared test key
  (jawnie oznaczony).
- Brak `mac`/zły `mac` = `DROP` + incydent; nie „loguj i kontynuuj”.

### 9.4 Typy komunikatów (v0)

| Kod | Nazwa | Runda | Publiczny? |
|---|---|---|---|
| 0x01 | `SETUP_INIT` | S | tak |
| 0x02 | `SETUP_ACCEPT` | S0 | tak |
| 0x03 | `CONTRIB_COMMIT` | S1 | tak |
| 0x04 | `CONTRIB_REVEAL` | S2 | tak |
| 0x05 | `VSS_SHARE` | S3 | nie |
| 0x06 | `COMPLAINT` | S4 | tak |
| 0x07 | `COMPLAINT_RESPONSE` | S4′ | tak |
| 0x08 | `SETUP_FINAL` | S5 | tak |
| 0x09 | `SETUP_CERTIFY` | S6 | tak |
| 0x10 | `SIGN_INIT` | N0 | tak |
| 0x11 | `SIGN_ACCEPT` | N0 | tak |
| 0x12 | `NONCE_COMMIT` | N1 | tak |
| 0x13 | `NONCE_REVEAL` | N2 | tak |
| 0x14 | `SIGN_ROUND` | C1 | zależy od rundy |
| 0x15 | `SIGN_OPEN` | C2 | tak (s2) |
| 0x16 | `SIGN_FINAL` | C3 | tak |
| 0x17 | `SIGN_ABORT` | any | tak |
| 0x20 | `REFRESH_INIT` | R | tak |
| 0x21 | `REFRESH_ACCEPT` | R | tak |
| 0x22 | `REFRESH_FINAL` | R | tak |
| 0x23 | `RECOVERY_INIT` | R | tak |
| 0x24 | `RECOVERY_FINAL` | R | tak |

Payloady kontrolne (v0, pola normatywne; pełny CDDL w WP-027):

- `SETUP_INIT`: `sid, epoch, k, n, parties, xs, policy_hash, mode, setup_nonce`.
- `SETUP_ACCEPT`: `party_id, state_hash, setup_nonce_i`.
- `CONTRIB_COMMIT`: `commitment(32), vss_root(32), contrib_len`.
- `CONTRIB_REVEAL`: `vss_f[], vss_g[], vss_F[], vss_G[]` (po `N` punktów),
  `contribution_digest(32)`.
- `VSS_SHARE`: `dealer(16), share_f, share_g, share_F, share_G, blind_f,
  blind_g, blind_F, blind_G` (każdy `bstr` = `N·8` B little-endian).
- `COMPLAINT`: `accused(16), dealer(16), share, blind, index`.
- `COMPLAINT_RESPONSE`: `dealer(16), share, blind`.
- `SETUP_FINAL`: `pk(2881), pk_hash(32), TH_final(32), accepted[],
  disqualified[]`.
- `SETUP_CERTIFY`: `TH_final(32), signature`.
- `SIGN_INIT`: `sid, epoch, msg, policy_hash, request_id, participants[],
  nonce_mode`.
- `SIGN_ACCEPT`: `party_id, state_hash, session_nonce(32)`.
- `NONCE_COMMIT`: `commitment(32)`.
- `NONCE_REVEAL`: `nonce_share(40), salt(32)`.
- `SIGN_ROUND`: `sub_round(uint), payload(bstr)` — schemat per runda
  w `wire/schema/sign_round_*.cddl`; payload MUSI być canonical CBOR.
- `SIGN_OPEN`: `s2_share`/`s2` + MAC; dokładny format w WP-041.
- `SIGN_FINAL`: `sig(1..), nonce(40), pk_hash(32), TH_final(32)`.
- `SIGN_ABORT`: `code(uint), blame[], evidence_hash(32), round(uint)`.
- `REFRESH_*`: analogicznie do setupu, z `new_epoch` i `pk_hash`.

### 9.5 Limity i walidacja

- `msg` ≤ 1 MiB; `payload` ≤ 16 MiB; `VSS_SHARE` ≤ 512 kB;
- `N` dokładnie 1536; `pk` dokładnie 2881 B; `nonce` 40 B; `sig` ≤ 10370 B;
- `k,n,xs,parties` zgodne z `SetupInit`; duplikat `party_id` = `Err`;
- `round`/`seq` monotoniczne; stara runda = replay (chyba że retransmisja
  identycznego `msg_id` — wtedy idempotentnie zignoruj);
- nieznany `msg_type` = `Err`, nie „ignore”.

---

## 10. Transkrypt i separacja domen

### 10.1 Inicjalizacja

```text
participants_hash = H(".../participants" || sort(party_id))
TH_0 = H(".../transcript" || sid || epoch || kind || participants_hash
         || setup_transcript_hash || pk_hash)
```

`kind ∈ {setup, sign, refresh, recovery}`; `setup_transcript_hash` =
`TH_final` setupu (dla sign/refresh); `pk_hash` wiąże klucz.

### 10.2 Aktualizacja

Dla każdej rundy `r`:

```text
bodies_r = sort({ body : body.round = r }, by (sender, seq))
TH_r = H(".../round" || TH_{r-1} || H(".../bodies" || canonical(bodies_r)))
```

- Kolejność odbioru nie wpływa na `TH`; wszystkie uczciwe strony liczą
  identycznie.
- `body.round` MUSI być zgodny z bieżącym stanem; brakujące ciało =
  `ABORT {code=MISSING_ROUND}` po timeoucie.
- `TH_final` = `TH_r` po ostatniej rundzie; wpis w `SETUP_FINAL`/
  `SIGN_FINAL`/receipcie.
- Retransmisja tego samego `msg_id` nie zmienia `TH`.

### 10.3 Tagi domenowe (v1, dokładne)

```text
FT1536/threshold/v1/msgid
FT1536/threshold/v1/mac
FT1536/threshold/v1/transcript
FT1536/threshold/v1/round
FT1536/threshold/v1/bodies
FT1536/threshold/v1/participants
FT1536/threshold/v1/pk
FT1536/threshold/v1/nonce-commit
FT1536/threshold/v1/nonce
FT1536/threshold/v1/t
FT1536/threshold/v1/vss
FT1536/threshold/v1/abort
FT1536/threshold/v1/receipt
```

Zmiana tagu = nowa wersja protokołu; brak „cichej” zmiany.

---

## 11. Abort, wina, brak częściowego podpisu

### 11.1 Kody

| Kod | Znaczenie | Wina |
|---|---|---|
| `BAD_SCHEMA` | malformed/non-canonical | sender |
| `BAD_MAC` | zły MAC | sender/transport |
| `BAD_ROUND` | zła runda/seq/replay | sender |
| `BAD_VSS` | niezgodność VSS | dealer |
| `BAD_NTRU` | relacja NTRU fail | setup |
| `BAD_PK` | `pk_hash` mismatch | setup/coordinator |
| `BAD_HTP` | `t` mismatch | sender |
| `NORM_FAIL` | norma poza bound | protokół (nie wina) |
| `VERIFY_FAIL` | engine verify false | protokół/bug |
| `SAMPLER_EXHAUSTED` | `T_max` | protokół |
| `TIMEOUT` | brak wiadomości | unresponsive (nie dowód) |
| `POLICY_DENIED` | polityka | klient/koordynator |
| `INSUFFICIENT` | < k stron | konfiguracja |
| `INTERNAL` | błąd implementacji | operator |

### 11.2 Identyfikowalny abort

- Każdy `ABORT` zawiera `blame[]` i `evidence_hash`; dowód = podpisane
  `body` winnego (VSS share, zły MAC, zła runda).
- Dla `TIMEOUT` `blame` może być puste; to nie jest dowód złośliwości.
- Koordynator publikuje `AbortReport` z transkryptem; klient może
  zweryfikować.
- Jeśli dwie strony zgłaszają sprzeczne dowody, transkrypt rozstrzyga;
  brak rozstrzygnięcia = `INTERNAL`/stop-and-report, nie „większość”.

### 11.3 Brak częściowego podpisu

- `s2` otwierane tylko po checkach §7.5; jeśli check fail — brak open.
- Po `SIGN_FINAL` i verify sygnatura jest ważna; jeśli verify fail —
  `ABORT`, sygnatura nie jest wydawana.
- `request_id` idempotentne: retry zwraca ten sam wynik albo abort;
  nigdy drugi podpis na ten sam `request_id`.
- Crash po `SIGN_OPEN` przed `SIGN_FINAL`: nowa sesja z nowym `sid`
  i nowym nonce; stary `s2` nie może być wydany.

---

## 12. Maszyny stanów i trwałość

### 12.1 Setup

```text
INIT → ACCEPTED → COMMITTED → REVEALED → COMPLAINTS → FINALIZED → CERTIFIED
  └───────────────┴──────────────┴────────────┴────────────┴──► ABORTED
```

- Każde przejście zapisane trwale **przed** wysłaniem następnej
  wiadomości (write-ahead).
- Po restarcie: wczytaj stan; jeśli runda oczekuje na wiadomości —
  retransmisja/idempotencja; jeśli nonce ujawniony — abort, nowy `sid`.
- Stan `CERTIFIED` = `PublicSetup` + `PartyState`; inaczej brak.

### 12.2 Sign

```text
INIT → ACCEPTED → NONCE_COMMITTED → NONCE_REVEALED → SAMPLING
     → COMPUTING → OPENING → VERIFIED → RELEASED
  └──────────────┴──────────────┴────────────┴─────────┴──► ABORTED
```

- `SAMPLING` ma pętlę prób; każda próba zapisuje licznik i zużytą
  losowość (nie sekret) — do audytu.
- `RELEASED` = podpis + receipt; retry z `request_id` zwraca to samo.
- Jeden aktywny sign per `(party, epoch)` w v1; konkurencja = `BUSY`.

### 12.3 Refresh

```text
INIT → ACCEPTED → COMMITTED → FINALIZED → SWITCHED
```

- `SWITCHED` = nowa epoka aktywna, stara zeroizowana; przed `SWITCHED`
  stara epoka ważna.

---

## 13. Bezpieczeństwo: definicje i założenia

### 13.1 Definicje (cele, nie twierdzenia)

- **Threshold EUF-CMA:** adversarz korumpuje ≤ `k−1` stron, ma oracle
  podpisu na wybrane komunikaty, wygrywa, jeśli wytworzy ważny podpis
  na nowy komunikat. Przewaga mierzona w grze.
- **Key secrecy:** ≤ `k−1` udziałów nie pozwala odróżnić klucza od
  losowego ani wytworzyć podpisu; gra z udziałami i transkryptem.
- **Identifiable abort:** jeśli uczciwa strona abortuje, istnieje
  efektywny algorytm wskazania skorumpowanej strony (lub timeout),
  z soundness.
- **Public verifiability setupu:** wszystkie uczciwe strony uzgadniają
  `pk_hash` i `TH_final`; klient weryfikuje certyfikat.

### 13.2 Założenia

| ID | Założenie | Status |
|---|---|---|
| A-01 | FT1536 jest EUF-CMA | **OPEN** (tor T12.1) |
| A-02 | SHAKE256 = FIPS 202 | przyjęte |
| A-03 | Ristretto255 DL/DDH | przyjęte |
| A-04 | TLS 1.3/mTLS | przyjęte (D-010) |
| A-05 | OS CSPRNG uczciwych stron | przyjęte |
| A-06 | honest majority `k ≤ (n+1)/2` | przyjęte |
| A-07 | synchroniczne rundy z timeoutem | przyjęte (v1) |
| A-08 | brak side-channeli | **do usunięcia w G4** |

**A-01 jest warunkiem jawnym.** Bez dowodu bazy każde twierdzenie
o progu jest warunkowe. Nie wpisywać A-01 jako przesłanki dowiedzionej.

### 13.3 Czego nie twierdzimy

- „malicious-secure” przed G4,
- „UC-secure” przed dowodem,
- „post-quantum threshold” bez QROM,
- „produkcyjne” przed G5,
- „klucz nigdy nie istnieje” dla `TEST-ORACLE`/P1,
- „bezpieczne” bez A-01 i audytu.

---

## 14. Zgodność, KAT, testy

### 14.1 Profile

| Profil | Setup | Sampler | Build | Claim |
|---|---|---|---|---|
| `TEST-ORACLE` | znany klucz testowy | deterministyczny | `testkit` | plumbing |
| `PROD` | MPC `G(seed*)` B′ (ważny NTRU, bez rekonstrukcji) | Klein/ffSampling | release | dopiero po G4/G5 |

### 14.2 Wektory

- `KAT/` zawiera: `vector_id`, `profile`, `sid`, `epoch`, `msg`, `nonce`,
  `pk`, `pk_hash`, `sig`, `TH_final`, `expected_verify`.
- Wektory sekretne **MUSZĄ** być syntetyczne i publicznie oznaczalne;
  brak realnych kluczy.
- Pin F2 `n = 103747771` (seed 0x42, msg `gold-ff`, nonce `[0;40]`)
  pozostaje regresją `TEST-ORACLE`; nie jest claimem `PROD`.
- Nowe wektory `PROD` powstają po zamknięciu O-01/O-02; do tego czasu
  `PROD` nie ma KAT.

### 14.3 Testy obowiązkowe

- **Pozytywne:** 2-of-3, 3-of-5; wszystkie pary; engine verify; `pk`
  zgodne; refresh; recovery.
- **Negatywne:** < k stron; duplikat; zła runda; replay; zły MAC;
  zły VSS; zły NTRU; `pk` mismatch; `t` mismatch; norma fail;
  sampler exhausted; malformed CBOR; oversized; non-canonical.
- **Złośliwe:** ≥10 strategii (fałszywy wkład, equivocation, drop,
  tamper MAC, podmiana `pk`, replay, zła runda, selektywne otwarcie,
  crash/restart, sybil).
- **Differential:** 10³ KAT + 10⁵ przypadków vs `ft1536-sys` (G3).
- **Fuzz:** wire, CBOR, `hash_to_point`, `decode_sk`, VSS parser (G1).

---

## 15. Otwarte punkty (normatywne dla `PROD`)

| ID | Punkt | Domyślnie | Bramka | WP |
|---|---|---|---|---|
| O-01 | Bezdealerowy, ważny keygen NTRU (ścieżka A) | **subsumowany przez O-16 w B′**; A = `SUPERSEDED` | G3 (przez O-16) | WP-037 |
| O-02 | Realny ffSampling/LDL w MPC | FFT3+Klein | G3 | WP-041 |
| O-03 | Klein 73-bit, TV, brak fail-open | parametry z 2026/1300 | G3 | WP-040 |
| O-04 | Zero-test NTRU bez otwierania różnicy | bit `accept` | G3 | WP-037 |
| O-05 | `pk` bez reconstruct (`f^{-1}` w MPC) | MPC inversion | G3 | WP-038 |
| O-06 | Check normy wierny formie silnika | konserwatywne `c·L2` | G3 | WP-041 |
| O-07 | Nonce: dokładna pochodna i hedging | hash commit/reveal | G2 | WP-033 |
| O-08 | Complaint/blame: format i soundness | jak §6.2 | G2 | WP-032 |
| O-09 | Transport: TLS vs Noise | TLS 1.3 (D-010) | G1 | WP-046 |
| O-10 | CBOR/CDDL freeze | canonical CBOR | G1 | WP-027 |
| O-11 | HSM/TPM: interfejs i attestation | od G3 (D-013) | G3 | WP-048 |
| O-12 | Refresh: atomowość i crash | two-phase | G3 | WP-047 |
| O-13 | Budżet wydajności | pomiar, nie szacunek | G3 | WP-045 |
| O-14 | Dowód threshold EUF-CMA | game-based/UC | G4 | WP-050 |
| O-15 | Side-channel/fault | CT + testy | G4 | WP-052/053 |
| O-16 | MPC `G(seed*)` w setupie (B′) | w zakresie v1 (D-024); research | G3 | WP-037 |
| O-17 | Pełny VSS: rozmiar/alternatywa | pełne `N` | G1 | WP-016 |
| O-18 | Ukryte δ / MAC na otwarciach | `dkg_zp_delta_shares` | G1 | WP-013 |
| O-19 | Polityka koordynatora | limity, approvals | G5 | WP-062 |
| O-20 | Tenant/key lifecycle | per-installacja v1 | G5 | WP-060 |
| O-21 | Recovery w B′ po utracie udziału | backup pieczęci albo nowy setup z nowym `pk`; bez rekonstrukcji `f,g` | G5 | WP-061 |

**Reguła:** punkt `OPEN` nie może być prezentowany jako `PASS`. G3 nie
zamyka się, dopóki O-01…O-06, O-16, O-11…O-13 nie są `PASS` z dowodem.

---

## 16. Kontrola zmian

- Wersja specu rośnie przy każdej zmianie normatywnej; wpis w
  `DECISIONS.md` z datą i powodem.
- Kod i spec MUSZĄ być zgodne; rozjazd = `stop-and-report`.
- Testy odwołują się do sekcji specu (`SPEC §7.5`), nie do „implementacji”.
- Zamrożone raporty historyczne pozostają; korekta = nowy wpis.

---

## Dodatek A — mapowanie spike → spec

| Spike | Spec | Dyspozycja |
|---|---|---|
| `pedersen.rs` | §6.2 | koncept; przepisać pełny VSS, zeroize |
| `ishare.rs` (Z_P) | §6/§7 | arytmetyka i KAT; API bez `delta_known`, pełny VSS |
| `mpc_sign.rs` codec/HTP/verify | §2/§7 | reuse; KAT byte-exact |
| `mpc_sign.rs` `ff_lite`/Babai | §7.4 | **odrzucone** w `PROD`; `TEST-ORACLE` tylko |
| `trapdoor_sign_ffsampling_share_ceremony` | §7.4 | **zakazane** (reconstruct `f,F` do `z`) |
| `sign_ceremony_sk_shares` | §7 | **zakazane** (reconstruct `sk`) |
| `g2_deal_trapdoor` | §6 | test-only, `#[cfg(test)]` |
| `G2_VSS_SAMPLE=8` | §6.2 | zastąpić pełnym VSS |
| `delta_known` | §6/§7 | usunąć z API `PROD`; ukryte δ |
| `klein.rs`, `rejection.rs`, `select.rs`, `cmp.rs` | §7.4 | badania; port z CT i budżetem |
| `shake.rs` | §7.5 | reuse bit-SHAKE; mierzyć koszt |
| `xof.rs` | — | **zakazane** w `PROD` |
| `bin/iso.rs` | §9 | testkit, nie produkcja |
| `lib.rs` GF(256) | §2 | tylko MAC/bytes; nie arytmetyka `q` |
| `PROMPT_T14_HIDDEN_DELTA_G2.md` | — | poza lane (obcy, untracked) |

---

## Dodatek B — słownik

- **Udział** — wartość Shamira `share_i`; sama nie odtwarza klucza.
- **Kworum** — `k` stron; mniej = brak podpisu.
- **`pk_hash`** — hash publicznego klucza; pin klienta.
- **`TH_final`** — hash transkryptu; wiąże sesję i `pk`.
- **`TEST-ORACLE`** — profil testowy; nie produkcja.
- **`PROD`** — profil docelowy; wymaga G3–G5.
- **Identyfikowalny abort** — wskazanie winnego na podstawie transkryptu.
- **Zero-test** — check `x=0` na udziałach bez otwierania `x`.
- **`B_norm`** — bound formy silnika; nie mylić z `L2`.

---

## Trzy zdania

Spec v0 definiuje pełny kontrakt: role, setup, podpis, nonce, transkrypt,
wire, abort, refresh i profile `TEST-ORACLE`/`PROD`, z jawnym rozdziałem
na to, co jest dziś wykonalne, a co jest badaniami. Największe otwarte
punkty to MPC `G(seed*)` (ważny NTRU bez rekonstrukcji), realny
ffSampling/Klein w MPC i wierny check normy silnika — bez nich nie ma
`PROD`, tylko protokół referencyjny. Ten dokument nie jest dowodem bezpieczeństwa; jest
kontraktem, względem którego kod, testy i audyt mogą być sprawdzane.
