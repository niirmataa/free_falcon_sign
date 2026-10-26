# FTKEY_INTEGRATION_MAP — read-only mapa dla P2

**Data:** 2026-10-26 · **Status:** materiał wejściowy do decyzji, **nie odbiór**
**Zakres:** `/home/footfalcon/Muzyka/FTKEY` i `/home/footfalcon/Muzyka/FTKEY-gui`,
odczyt bez modyfikacji. Ten dokument **nie** zmienia tamtejszych repo.
**Cel:** ustalić, co z FTKEY jest realnym budulcem P2, co jest tylko
wzorcem, a co musi zostać napisane od zera. Bez przenoszenia długów.

> **Bezpieczeństwo danych:** w mapie nie ma seedów, PIN-ów, fraz ani
> zawartości pieczęci. Wszystkie obserwacje pochodzą z kodu i raportów.

---

## 1. Piny badanej rewizji

| Repo | HEAD | Gałąź | Stan drzewa | Pliki śledzone |
|---|---|---|---|---|
| FTKEY | `f49384c935f1db2c3230b1022ad36d4bfc3ba5bb` | `main` = `origin/main` | 3 zmodyfikowane, 9 nietrackowanych | 90 |
| FTKEY-gui | `9b5c42d536bf9edda984aa46b0b508f829636b42` | `main` | czyste | 34 |

Kontekst commitów:

- FTKEY: `docs: preserve MPC integration context and owner pause`,
  2026-10-21T11:51:34+02:00, autor `FTKEY`.
- FTKEY-gui: `docs(gui): record owner requirement for seed on token`,
  2026-10-21T11:29:58+02:00, autor `FTKEY`.

Hash-e kluczowych plików (SHA-256):

| Plik | SHA-256 |
|---|---|
| `FTKEY/crates/ftkey-vm/src/qsx.rs` | `4e0b460d9dbbec289b9f37be784553f3c55c409ad3d2864e0271a68ea35e932e` |
| `FTKEY/crates/ftkey-vm/src/main.rs` | `dd02616500444893351ac5c7dffd4b4fa0b123806ba0c12d6f5fae64691d619b` |
| `FTKEY/crates/ftkey-sign-ephemeral/src/lib.rs` | `8b67aa067fb19d6af510b25a55eff46fd2f9ce896d4f6fa19fce6035e9bfe534` |
| `FTKEY/crates/ftkey-core/src/seal.rs` | `8b30810a9285cc740653fdf5b1e0033b38eed8bde4287bb3c41a9581d3d84c19` |
| `FTKEY/crates/ftkey-core/src/backup.rs` | `9004fb19b525db9273795b2f6b9ec7e93881f9ae6ecd9b5379d5c46475d9dfee` |
| `FTKEY/crates/ftkey-core/src/token_seed.rs` (draft) | `39bd9f54127e03c9c54675c5904ff0f2ab16989978843ffaa55e7bc503097842` |
| `FTKEY/crates/ftkey-verify/src/lib.rs` | `00d28265aa90030db079d5268100153ed7ce61921c77e53b0558b82e7f9e4d6e` |
| `FTKEY/crates/ftkey-sys/src/lib.rs` | `d77ac89d51ed7e74f36e0b48e03bdfadd92e8b7a0280101a666c7a270c453935` |
| `FTKEY/README.md` | `0e646c24c65c8eb926e509007dd6a16c2ef152476e3e2d93ac0f200285cc23e6` |
| `FTKEY-gui/crates/ftkey-gui-backend/src/lib.rs` | `ff8e423cd93324d215571784e7c5b4051939961554d950d86911222ddaf3175c` |
| `FTKEY-gui/crates/ftkey-gui-backend/src/vm.rs` | `481600f39147d0b3261fb44a18cdc56b1d730c6729c54303a3f5aedbd952199b` |
| `FTKEY-gui/src-tauri/src/backend.rs` | `4b84790d9e832a8416b7743bea02078f9bb37a85f8fa07dbdd286e2a3e498cbe` |

Toolchain obu repo: Rust `1.94.0` (`rust-toolchain.toml`), edition 2021,
profil release `panic = "abort"`, `overflow-checks = true`.

**Sprzęt sprawdzony 2026-10-26 (odczyt, bez zapisu na tokenie):**
`lsusb` widzi `1050:0406 Yubico.com Yubikey 4/5 U2F+CCID`
(produkt USB: „YubiKey FIDO+CCID”), HID na `/dev/hidraw2`
(`ID_PATH=pci-0000:00:14.0-usb-0:1:1.0`); `libfido2` w wersji `1.15.0`.
To **dokładnie** domyślny `VID:PID` z `qsx.rs:568` (`0x1050:0x0406`),
więc obawa o niedopasowanie domyślnego selektora do tego egzemplarza
zostaje wycofana (patrz F-7).

**CTAP2 `getInfo` (bez PIN, bez zapisu, bez tworzenia credentiala):**
`FIDO_2_0`, `FIDO_2_1`, `FIDO_2_3`; rozszerzenia m.in. **`hmac-secret`**,
`largeBlobKey`, `credProtect`, `minPinLength`; opcje `largeBlobs=true`,
`clientPin=true`, `alwaysUv=false`, `makeCredUvNotRqd=true`;
`maxmsgsize=1536`; protokoły PIN `2` i `1`. To potwierdza przesłankę
ADR-001 A1/ADR-004 dla **tego** urządzenia, ale **nie** dowodzi jeszcze
determinizmu `hmac-secret` ani zapisu koperty 4 KB — to wymaga
utworzenia credentiala, PIN-u i dotknięcia (patrz F-8).
Probe: `.build/ftkey_probe/getinfo.c` (ignorowany, poza repo).

**Pin silnika jest wspólny z tym repo.** `FTKEY/docs/pins/FT1536_ENGINE_PIN.md`
wskazuje commit `ad0d0f064a385f3ae7cbb68601139417b8eabb77`, drzewo `Extra/c`
`7a5b493b0fa7f2007ee79c2af10b555d95c0b4d6` i manifest
`provenance/ft1536-candidate.sha256` o SHA-256
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
Ten commit i manifest **istnieją w `free_falcon_sign`** (sprawdzone
`git cat-file`), więc P2 może użyć jednego pinu zamiast drugiego.

Manifest `FTKEY/docs/pins/FT1536_SOURCES.sha256` obejmuje 17 plików C
(`falcon-keygen.c`, `falcon-sign.c`, `falcon-vrfy.c`, `fpr-emulated.c`,
`shake.c`, `ft1536-adaptive-cdf-tables.h` itd.). `ftkey-sys/build.rs`
weryfikuje każdy hash przed buildem i **fail-closed** przy niezgodności.

---

## 2. Co FTKEY faktycznie robi

### 2.1 Produkt i granica

FTKEY to **pojedynczy podpisujący** klucz sprzętowy do 32-bajtowego seeda
FT1536. Seed jest pieczętowany (Argon2id + XChaCha20-Poly1305), a klucz
tokena FIDO2 (`hmac-secret`) jest składnikiem KEK. Z seeda powstaje para
FT1536 (`keygen_from_seed_32`), podpis jest liczony na przypiętym silniku C.

Dwa tryby:

| Tryb | Droga | Granica |
|---|---|---|
| Host v0 | `ftkey` CLI / `LocalCliBackend` | seed w RAM **hosta** podczas podpisu; brak ochrony przed rootem hosta |
| VM QSX v1 | GUI → `ftkey-vm` → efemeryczna VM → `ftkey-sign-ephemeral` | seed tylko w RAM gościa; L1 (root/hypervisor hosta) **nie** jest w modelu; L2 Confidential Computing **niezaimplementowane** |

To **nie jest** threshold signing. Jeden token = jeden pełny seed = jeden
pełny klucz. Nie ma udziałów, kworum ani MPC. Dokument
`docs/evidence/TOKEN_THRESHOLD_INTEGRATION_2026-10-21.md` jawnie zapisuje
pauzę: właściciel powiedział „domykam kompletne MPC sign jak skończę
będziemy kontynuować”, a szkic magazynu seeda na tokenie jest
`UNCOMPILED / NOT_REVIEWED`.

Ważne rozróżnienie z tego dokumentu: spike V2 **rekonstruuje 32 B seeda**
z macierzy udziałów i dopiero potem liczy podpis. To jest próg seeda
z rekonstrukcją, **nie** MPC podpis i **nie** spełnia claimu P2 „klucz nigdy
nie istnieje”. Nie wolno tego licznika ani nagłówków przenosić do P2.

### 2.2 Crates

| Crate | Rola | Kluczowe API |
|---|---|---|
| `ftkey-sys` | FFI do silnika C, pin + fail-closed hash | `keygen_from_seed_32`, `sign_bytes`, `verify_bytes`; `PUBKEY_LEN=2881`, `SIG_MAX=3073`, `NONCE_LEN=40` |
| `ftkey-core` | token bridge, seal, backup, mock | `Token::hmac_secret`, `init_seal`, `unseal_seed`, `init_backup` |
| `ftkey-verify` | publiczna weryfikacja bundla | `SignatureBundle{alg,pubkey,nonce,sig,msg_sha256}`, `verify_bundle` |
| `ftkey-cli` | `init/sign/verify/pub` | wzorzec komend, nie do bezpośredniego reużycia |
| `ftkey-sign-ephemeral` | gość: mlock → unseal → keygen → sign → zapis | `sign_core`, `lock_memory`, `disable_core_dumps` |
| `ftkey-vm` | adapter QSX: provision → sign → destroy | `sign_via_qsx`, `qsx::lifecycle` |

### 2.3 Przepływy

**Init (host v0):** 32 B seed z OS RNG → `init_seal` (token `hmac-secret`
jako składnik KEK, świeża sól/nonce) → `ftkey.seal` (0600) → opcjonalny
`ftkey.backup` (fraza) → `ftkey.pub` + `ftkey.fp`.

**Sign (host v0):** `unseal_seed` → `derive_nonce` =
`SHA-512("ftkey-nonce-v0" ‖ seed ‖ SHA-256(doc))[..40]` → `keygen_from_seed_32`
→ `sign_bytes` → zeroizacja → `doc.sig.json` (tylko materiał publiczny).

**Sign (VM v1):** GUI `VmEphemeralBackend` → `ftkey-vm sign` → single-flight
lock → QSX `doctor/start/import/run` → gość `ftkey-sign-ephemeral`
(mlockall, `RLIMIT_CORE=0`, unseal, keygen, sign, `doc.sig.json`) →
`stop` + wipe stanu → host zbiera **fingerprint** i zapisuje
`sign-result.json`. Szczegóły poniżej: to ostatnie ogniwo jest złamane (F-1).

**Verify:** `ftkey-verify` / GUI `LocalCliBackend.verify` — tylko klucz
publiczny, bez tokena i bez pieczęci. Sprawdza długości, nagłówki `0x8a`/`0xaa`,
`alg == "FT1536-STATIC"`, `msg_sha256` i wywołuje silnik.

### 2.4 Co jest „magią”, którą warto przenieść

1. **Token jako czynnik odszyfrowania** — `hmac-secret` nie jest zwykłym
   hasłem; token musi być obecny i odblokowany (UV/PIN). To realnie wiąże
   pieczęć z fizycznym tokenem.
2. **Pieczęć z AAD i świeżymi parametrami** — solidny, znany format,
   fail-closed parser, zeroizacja.
3. **Efemeryczna VM** — seed nie leży na dysku hosta; po sesji `stop` +
   wipe; `network_cut`; brak współdzielonego FS.
4. **Weryfikator jako osobny, wąski crate** — publiczny, bez sekretów,
   z twardą walidacją kodowań.
5. **Dyscyplina zeroizacji** — `Zeroizing`, brak `Clone`/`Debug` na
   sekretach, `mlockall` jako warunek podpisu, `RLIMIT_CORE=0`.

---

## 3. Macierz reużycia dla P2

Legenda: **REUSE** = wziąć z pinem i testem; **ADAPT** = przepisać
interfejs/ politykę; **REFERENCE** = wzorzec, nie kod; **FORBIDDEN** =
nie przenosić.

| # | Asset FTKEY | Ścieżka | Dispozycja | Zastosowanie w P2 | Warunek |
|---|---|---|---|---|---|
| R-1 | Pin silnika + `ftkey-sys` FFI | `crates/ftkey-sys`, `docs/pins/` | **REUSE** | `verify` w P2, KAT, differential | ten sam commit/manifest; zero zmian w silniku; KAT przed użyciem |
| R-2 | Bundle + weryfikator | `crates/ftkey-verify` | **REUSE** | format wyjścia P2; `ft1536-sys` verify | P2 musi produkować dokładnie 5 pól; `pubkey` 2881 B |
| R-3 | Seal/backup | `crates/ftkey-core/src/{seal,backup}.rs` | **ADAPT** | pieczęć udziałów w spoczynku, backup/recovery | dodać politykę KDF (F-5); rozmiar udziałów > 4 KB |
| R-4 | Token bridge FIDO2 | `crates/ftkey-core/src/token*.rs` | **ADAPT** | odszyfrowanie udziału tokenem per node | jeden token per node; PIN przez FD/pipe, nie argv (F-2) |
| R-5 | Szkic token-resident seed | `crates/ftkey-core/src/token_seed*` | **REFERENCE / BLOCKED** | ewentualnie 32 B udział seeda na tokenie | `UNCOMPILED / NOT_REVIEWED`; błąd `json!([0; 0])`; brak eksportu |
| R-6 | mlock/zeroize/RLIMIT | `crates/ftkey-sign-ephemeral/src/lib.rs` | **REUSE wzorca** | hardening procesu node | logika `seed → keygen → sign` jest single-signer, do zastąpienia |
| R-7 | QSX lifecycle | `crates/ftkey-vm/src/qsx.rs` | **ADAPT** | izolacja node'a / sesji | `network_cut` wyklucza MPC; F-1/F-2/F-3/F-6/F-7 |
| R-8 | GUI `SignBackend` | `FTKEY-gui/crates/ftkey-gui-backend` | **ADAPT** | klient/panel P2 | model „jeden sig_path” nie pasuje do k-z-n; potrzebny stan sesji/koordynatora |
| R-9 | CLI `init/sign/verify/pub` | `crates/ftkey-cli` | **REFERENCE** | kształt komend, UX | nie przenosić logiki seeda |
| R-10 | ADR-003 L1/L2 | `docs/adr/ADR-003-...md` | **REFERENCE** | granica claimu P2 | P2 nie dziedziczy L2; brak CC |

### 3.1 Matematyka magazynu udziałów (ważna dla D-021)

Parametry: `N=1536`, `q=18433` (15 bitów na współczynnik), pierścień
`X^1536 − X^768 + 1`.

- Udział wariantu **A** `(f_i,g_i,F_i,G_i)`: 4 polinomy × 1536 × 15 bitów
  = **11 520 B** minimum, bez nagłówków i bez kompresji. W JSON/hex to
  ok. **23 KB** na udział. Nie mieści się w jednej kopercie 4 KB.
- Udział **B/B′** (32 B seed share): **32 B** — mieści się w kopercie
  `MAX_BYTES = 4096` (`token_seed.rs:117`) z ogromnym zapasem.
- Wniosek: **A i B′ (jeśli udziały pułapki są przechowywane) nie mogą
  twierdzić „udział na tokenie” w obecnym profilu 4 KB.** Mogą być
  pieczętowane na dysku/HSM kluczem pochodnym od tokena — to model FTKEY v0
  (`seal.rs`), nie model `token_seed` (blob na tokenie).
- B (czysty) i ewentualny wariant „seed-share na tokenie + regeneracja
  pułapki na sesję” zachowują przewagę 32 B. To trzeba rozstrzygnąć razem
  z D-021, bo wpływa na to, czy token jest nośnikiem udziału, czy tylko
  bramą do odszyfrowania.
- **Transport:** `getInfo` tego tokena zwraca `maxmsgsize=1536`, więc
  koperta 4 KB nie mieści się w jednej ramce CTAP2. `largeBlobs` musi być
  czytane i zapisywane fragmentami; libfido2 obsługuje fragmentację, ale
  szkic `token_seed` **nie ma testu** takiego przebiegu (F-4). To trzeba
  zmierzyć przed deklaracją „udział 32 B na tokenie działa”.

---

## 4. Findings z mapowania (read-only)

Severity: **krytyczne** = blokuje claim lub psuje wynik; **wysokie** =
realny wektor lub brak funkcji; **średnie** =-operacyjne/integracyjne.

### F-1 — VM „sign” nie zwraca podpisu (krytyczne, funkcjonalne)

**Dowód:**

- Gość zapisuje `out_dir/doc.sig.json`
  (`ftkey-sign-ephemeral/src/lib.rs:293`), ale na stdout drukuje tylko
  `fingerprint=<hex>` (`sign_and_report`).
- `ftkey-vm` `collect_result` (`qsx.rs:712–744`) parsuje **tylko**
  fingerprint i zapisuje `sign-result.json` z polami
  `{fingerprint, doc, usb}`; nie kopiuje `doc.sig.json` z gościa.
- GUI akceptuje `sig_path`, jeśli plik **istnieje**
  (`FTKEY-gui/.../vm.rs:287`), a `sign-result.json` istnieje. Zwraca
  sukces z `sig_path` wskazującym metadane, nie bundle.
- Konfiguracja VM ma `network_cut` i brak współdzielonego FS, więc podpis
  nie ma innej drogi wyjścia.

**Skutek:** tryb VM „podpisuje” tylko pozornie; `ftkey-verify` na tym
pliku nie przejdzie. To nie jest drobny bug — to brak deliverable’u v1 VM.

**Znaczenie dla P2:** nie budować na `VmSignResult` jako na podpisie.
Kanał wyjściowy trzeba zaprojektować jawnie (np. base64 bundla na stdout
z limitem, albo read-only montowany katalog wyjściowy) i przetestować
na żywym QSX. Fingerprint to nie podpis.

### F-2 — PIN na argv w dwóch miejscach (wysokie, bezpieczeństwo)

**Dowód:**

- `ftkey-vm` ma ukryty argument `--fido_pin` (`main.rs:50–53`,
  `hide = true`). Komentarz „Never appears on the process argv — only
  FTKEY_PIN env” jest **nieprawdziwy**: `hide` ukrywa tylko help.
- `qsx.rs:507–513` wstawia `env` i `FTKEY_PIN=<pin>` do argv
  `qsx-alpine run`, mimo komentarza „never on argv”. Host widzi to w `ps`.
- GUI → `ftkey-vm` przekazuje PIN przez env (`vm.rs:270–275`) — ten hop
  jest bezpieczniejszy, ale env też jest czytelne dla tego samego użytkownika
  przez `/proc/<pid>/environ`.

**Skutek:** PIN FIDO wycieka do listy procesów na hoście. PIN nie jest
seedem, ale jest czynnikiem UV; wyciek ułatwia użycie tokena.

**Znaczenie dla P2:** zakazać sekretów w argv **i** preferować przekazanie
przez dziedziczony FD/pipe z `PR_SET_DUMPABLE=0`, nie przez env. Test
`ps`/`/proc` jako bramka.

### F-3 — `ftkey-vm` nie ma `init` (wysokie, funkcjonalne)

**Dowód:** `ftkey-vm/src/main.rs` ma tylko `enum Command::Sign`. GUI
`VmEphemeralBackend.init` spawnuje `ftkey-vm init ...` (`vm.rs:210–225`)
i fail-closed zwraca `GuiError::Vm`.

**Skutek:** w trybie VM nie da się utworzyć klucza; działa tylko host v0.
Raport V1c to przyznaje („adapter jeszcze bez podkomendy init”).

**Znaczenie dla P2:** setup/DKG musi być pełnoprawnym przepływem, nie
ukrytym hostowym `init`. W P2 „init” to wielostronny protokół, więc
i tak nie da się go reużyć 1:1 — ale brak komendy pokazuje, że ścieżka
VM nie była domknięta end-to-end.

### F-4 — Szkic token-resident seed jest niezbudowany (średnie, integralność)

**Dowód:** `token_seed.rs` (331 linii) i `token_seed/fido.rs` (658 linii)
są **nietrackowane**; `ftkey-core/src/lib.rs` **nie** eksportuje
`token_seed`; test zawiera `json!([0; 0])` (`token_seed.rs:285`), co jest
błędem składni makra. Dokument źródłowy: `UNCOMPILED / NOT_REVIEWED`.

**Skutek:** nie ma dowodu, że ten kod się kompiluje, a tym bardziej że
działa z tokenem. Nie wolno go traktować jako gotowego magazynu udziałów.

**Znaczenie dla P2:** jeśli P2 chce udział 32 B na tokenie, trzeba ten
moduł doprowadzić do kompilacji, testów i niezależnego odbioru — albo
napisać własny, prostszy kontener. Nie dziedziczyć statusu „draft”.

### F-5 — Polityka KDF bez ograniczeń (wysokie, bezpieczeństwo)

**Dowód:** `seal.rs` `derive_kek` czyta `m_kib`, `t`, `p` z pliku pieczęci
i przekazuje do `argon2::Params::new` (`seal.rs:111–131`). Sprawdzane są
tylko `alg`, `out_len` i długość soli. Nie ma minimów/maksimów profilu.
ADR-004 pinuje `m=65536, t=3, p=4` **tylko** dla szkicu token-seed, nie
dla `seal.rs`.

**Skutek:** zmodyfikowany `ftkey.backup` może obniżyć Argon2id (np.
`m=8, t=1, p=1`) i przyspieszyć offline brute-force frazy; z drugiej
strony ogromne `m_kib` daje memory DoS przy odszyfrowaniu.

**Znaczenie dla P2:** pieczęć udziałów musi mieć **profil parametrów**
(wersjonowany, z policy bounds), a nie „params z pliku”. To musi być
test: downgrade i oversize → `Err` przed alokacją.

### F-6 — `/tmp` jako runtime i stale lock (średnie, operacyjne)

**Dowód:** lock `"/tmp/ftkey-vm.sign.lock.d"` (`main.rs:108`), log
`/tmp/ftkey-vm.log` (`qsx.rs:28`), XML USB w `std::env::temp_dir()`
(`qsx.rs:592`). Po crashu katalog locka zostaje i blokuje kolejne sesje.

**Skutek:** brak odzyskiwania po crashu; dane runtime w systemowym tmp.

**Znaczenie dla P2:** runtime per node w trwałym katalogu W, `flock`
z PID/epoch, sprzątanie idempotentne, zero sekretów w logach. Nie używać
`/tmp` jako miejsca stanu.

### F-7 — Sztywne USB i globalne zabijanie VM (niskie/średnie, operacyjne)

**Dowód:** `UsbSpec::Auto` → `("0x1050","0x0406")` (`qsx.rs:568`);
`destroy_other_ftkey_vms` zabija **wszystkie** VM pasujące do `ftkey*`
(`qsx.rs:607,636`), żeby zwolnić USB.

**Weryfikacja sprzętowa 2026-10-26:** podłączony Security Key C NFC
enumeruje się jako `1050:0406` („YubiKey FIDO+CCID”), czyli **zgadza się**
z domyślnym `auto`. Wcześniejsza obawa o niedopasowanie VID:PID do tego
egzemplarza jest **wycofana**; pozostaje sztywność na inne modele/tokeny.

**Skutek:** `auto` działa dla tego egzemplarza, ale każdy inny token
wymaga jawnego selektora; równoległa praca innych sesji FTKEY jest
przerywana przez globalny kill. To nie jest zachowanie, które P2 może
przyjąć dla wielu nodów.

**Znaczenie dla P2:** jawny selektor urządzenia per node, brak globalnego
kill; izolacja zasobów na poziomie konfiguracji, nie „zabij wszystko”.
Nie uruchamiać żywego testu FIDO bez zgody właściciela: test
`fido_live_create_and_hmac_secret` **tworzy discoverable credential**
na tokenie i może zniszczyć istniejące pieczęcie po resecie.

### F-8 — Brak żywego E2E (wysokie, dowodowe)

**Dowód:** raporty mówią wprost:

- v0: `53 passed, 0 failed, 1 ignored (live hardware)` — niezależny
  rerun w `REVIEW_E1_E4.md`, ale **bez żywego tokena**.
- GUI backend: `21 passed, 0 failed, 0 ignored` — bez Tauri/okna.
- VM/gość: `14 passed, 0 failed, 1 ignored` — `e2e_sign_mock_via_qsx`
  (`#[ignore]`) wymaga prawdziwego KVM/QSX; `NOT_RUN`.
- Live FIDO w VM: `NOT_RUN`, checklista ręczna.
- Token: `getInfo` **PASS** (2026-10-26, bez PIN, bez zapisu);
  `hmac-secret` live **NOT_RUN** — test tworzy discoverable credential
  i wymaga PIN-u oraz dotknięcia.

**Skutek:** wszystkie testy VM używają fake QSX/mock. Nie ma dowodu, że
prawdziwy QSX + token + gość kończą podpis. To jest spójne z F-1: gdyby
E2E był uruchomiony, F-1 by wyszedł.

**Znaczenie dla P2:** nie dziedziczyć „PASS” z mocków. P2 potrzebuje
własnego E2E na trzech nodach i własnego retained `NOT_RUN`, dopóki
nie ma żywego przebiegu.

### F-9 — Brak udziałów i kworum (krytyczne dla P2, nie bug FTKEY)

FTKEY nie ma pojęcia udziału, progu, epoki, koordynatora ani transkryptu.
`TOKEN_THRESHOLD_INTEGRATION_2026-10-21.md` opisuje wyłącznie odczyt spike’a
i pauzę. Nie ma kodu, który można „włączyć” jako P2.

**Znaczenie:** P2 to nowy protokół i nowe crate’y. FTKEY daje kryptografię
tokena, pieczęć i weryfikator — nie daje threshold.

---

## 5. Szwy integracyjne P2 (konkret)

### S-1 — Wspólny pin silnika

P2 `verify` ma używać **tego samego** commita `ad0d0f0…` i manifestu
`56974571…`. `ftkey-sys` jest gotowym, wąskim FFI (bez surowych wskaźników
w API, `Drop` → `*_free`). Nie kopiować `build.rs` bez zrozumienia:
`FT1536_C_SRC` jest jawnym wejściem operatora, brak implicit fetchu.

**Zgodność źródeł sprawdzona 2026-10-26:** `sha256sum -c
FTKEY/docs/pins/FT1536_SOURCES.sha256` uruchomione w
`free_falcon_sign/Extra/c` daje **17/17 OK**. Domyślne
`/opt/ft1536-source` **nie istnieje** na tej maszynie, więc build
`ftkey-sys` trzeba oprzeć jawnie na
`FT1536_C_SRC=/home/footfalcon/free_falcon_sign/Extra/c`.
To nie jest nowy pin — to ten sam manifest, tylko wskazany na lokalne,
zweryfikowane bajty.

**Bramka:** KAT `pk`/`sig` + differential 10⁴ przed G1.

### S-2 — Format bundla

P2 musi zwracać dokładnie `SignatureBundle` z `ftkey-verify`
(`alg`, `pubkey`, `nonce`, `sig`, `msg_sha256`). To jest publiczny kontrakt
dla usług. Nie wymyślać nowego formatu „przy okazji P2”.

**Bramka:** `ftkey-verify` na podpisie P2; 10³ KAT + 10⁵ differential
(G3/WP-043).

### S-3 — Pieczęć udziałów

`seal.rs` nadaje się po dodaniu polityki KDF (F-5). Udział A/B′ ma
~11.5 KB binarnego / ~23 KB JSON-hex, więc:
- pieczęć na dysku z KEK od tokena (model FTKEY v0) — **dobra droga**;
- blob 4 KB na tokenie — **nie dla A/B′**, tylko dla 32 B seed share.

**Bramka:** test downgrade/oversize; test braku plaintextu na dysku;
zeroizacja przy każdym błędzie.

### S-4 — Token per node

Każdy node ma własny token i własną pieczęć udziału. Koordynator **nie
ma** tokena do udziałów (D-007). Token jest bramą UV/KEK, nie „głosuje”
za node’a.

**Bramka:** test, że bez tokena node nie odszyfruje udziału; test, że
koordynator nie ma ścieżki do udziałów.

### S-5 — Proces node’a

Wzorzec `ftkey-sign-ephemeral`: `mlockall` przed sekretem, `RLIMIT_CORE=0`,
`Zeroizing`, brak `Debug`, fail-closed przy braku mlock. Ale logika
`seed → keygen → sign` **nie** jest logiką P2. Node P2 dostaje udział,
nie seed; podpis jest interaktywny.

**Bramka:** testy braku kopii, `mlock` fail = odmowa, brak sekretu w logach.

### S-6 — Izolacja QSX

QSX nadaje się na **izolację pojedynczego node’a** (jeden proces, jedna
sesja), ale `network_cut` blokuje MPC. Trzy nody muszą mieć kanały
sieciowe (mTLS), więc nie można ich włożyć do obecnego profilu VM bez
zmiany profilu i ponownego dowodu. Nie ogłaszać „P2 w QSX”, dopóki
nie ma testu trzech nodów.

**Bramka:** trzy instancje, mTLS, chaos/partition, brak cichych błędów.

### S-7 — GUI/klient

`SignBackend` zakłada jeden `sig_path` i jeden wynik. P2 potrzebuje stanu
sesji (rundy, wkłady, abort, `pk_hash`, epoka), więc GUI wymaga nowego
interfejsu. Nie rozszerzać `sig_path` na siłę.

**Bramka:** UI nie widzi udziałów/seedów; pokazuje tylko status i wynik.

### S-8 — Koordynator

FTKEY nie ma koordynatora. P2 musi go zaprojektować jako proces bez
udziałów, z transkryptem, autoryzacją i audytem (D-007). To nowy crate,
nie funkcja `ftkey-vm`.

### S-9 — Bezpieczeństwo operacyjne

F-2/F-6/F-7 to nie „dług FTKEY do spłaty później” — to wzorce, których
P2 **nie może powtórzyć**. PIN/sekret przez FD, runtime w trwałym
katalogu, jawne selektory urządzeń, brak globalnego kill.

---

## 6. Czego FTKEY nie daje P2

- Brak DKG, VSS, complaints, kworum, epok, refreshu.
- Brak MPC ffSampling/Klein; jest tylko `keygen_from_seed_32` + `sign_bytes`.
- Brak bezdealerowego setupu NTRU (O-01).
- Brak dowodu threshold EUF-CMA; brak audytu P2.
- Brak sieciowego transportu między nodami; VM jest `network_cut`.
- Brak trwałego, niezawodnego kanału wyjścia podpisu z VM (F-1).
- Brak żywego E2E; statusy „passed” pochodzą z mocków/raportów.

---

## 7. Wnioski dla decyzji D-021 (A vs B vs B′)

1. **A** (udziały pułapki) jest najbliższe istniejącemu złotemu łańcuchowi
   `shares → s1,s2 → engine verify`, ale wymaga O-01 (bezdealerowy ważny
   keygen NTRU) i O-02 (realny MPC ffSampling). Udziały są duże (>4 KB),
   więc token może być tylko bramą KEK, nie nośnikiem.
2. **B** (seed share + `G(seed*)` per podpis) likwiduje O-01, ale wymaga
   kosztownej kompilacji `G(seed*)` do MPC **na każdy podpis**; udział
   32 B mieści się na tokenie. To najmocniejszy claim „klucz nigdy nie
   istnieje”, ale najdroższy.
3. **B′** (seed share + jednorazowy MPC `G(seed*)` w setupie + A-style
   MPC ffSampling) likwiduje O-01 **w setupie**, ale nadal wymaga O-16
   (`G(seed*)` w MPC) — raz, nie per podpis. Jeśli udziały pułapki są
   przechowywane, wracają duże udziały i pytanie o nośnik; jeśli są
   regenerowane per sesja, wracają koszty `G(seed*)` per sesja.
4. **Wspólny blocker:** O-16 (MPC `G(seed*)`) jest potrzebny w B i B′.
   B′ nie jest „darmowym” obejściem — jest amortyzacją tego samego
   kosztu. To trzeba powiedzieć wprost w decyzji.

**Rekomendacja techniczna (do potwierdzenia, nie decyzja):** jeśli celem
jest najpierw **dowód i protokół**, a nie produkt na tokenie, to B′ z
udziałami pieczętowanymi na dysku/HSM (token jako brama) jest najkrótszą
drogą do sensownego claimu; czysty B odłożyć jako „token-resident,
per-signature”, bo jego koszt (`G_frag` × 10²–10³ na podpis) nie jest
znany. Jeśli celem jest **udział na tokenie**, trzeba najpierw zmierzyć
koszt `G(seed*)` per sesja i zdecydować, czy token ma być nośnikiem,
czy bramą. To jest pytanie do właściciela, nie do implementacji.

---

## 8. Pytania do właściciela (blokują część G1/G2)

1. **D-021:** B′ (jednorazowy `G(seed*)` w setupie, duże udziały w
   pieczęci) czy czysty B (32 B seed share, `G(seed*)` per podpis)?
   Albo świadomie A (O-01 + O-02) i token tylko jako brama?
2. **Nośnik udziału:** token ma **przechowywać** udział (tylko 32 B),
   czy tylko **odblokowywać** pieczęć na dysku/HSM? To zmienia format
   i claim.
3. **F-1/F-2 w FTKEY:** naprawiamy teraz (małe commity w FTKEY), czy
   zapisujemy jako `P2-BLOCKER` i nie dotykamy FTKEY do czasu decyzji?
   Bez zgody właściciela nie modyfikuję tamtejszych repo.
4. **Zakres E2E:** czy P2 ma wymagać żywego QSX/tokena już w G2, czy
   G2 może zostać na `TEST-ORACLE` + mockach (z jawnym `NOT_RUN`)?
5. **D-003/010/011/013/016/022:** bez zmian; nadal `PROPOSED`.

---

## 9. Jak zweryfikować ten dokument (read-only)

```sh
cd /home/footfalcon/Muzyka/FTKEY
git rev-parse HEAD
git status --porcelain=v1
sha256sum crates/ftkey-vm/src/qsx.rs crates/ftkey-vm/src/main.rs \
  crates/ftkey-sign-ephemeral/src/lib.rs crates/ftkey-core/src/seal.rs \
  crates/ftkey-core/src/backup.rs crates/ftkey-core/src/token_seed.rs \
  crates/ftkey-verify/src/lib.rs crates/ftkey-sys/src/lib.rs README.md

cd /home/footfalcon/Muzyka/FTKEY-gui
git rev-parse HEAD
git status --porcelain=v1
sha256sum crates/ftkey-gui-backend/src/lib.rs \
  crates/ftkey-gui-backend/src/vm.rs src-tauri/src/backend.rs README.md

cd /home/footfalcon/free_falcon_sign
git cat-file -t ad0d0f064a385f3ae7cbb68601139417b8eabb77
sha256sum provenance/ft1536-candidate.sha256
```

**Uwaga:** hashe i numery linii dotyczą wskazanego HEAD. Każda zmiana
w FTKEY/FTKEY-gui wymaga nowego pinu i nowego przeglądu; ten dokument
nie jest manifestem.

---

## 10. Status dowodowy

- Ten dokument: **analiza źródeł read-only**, nie test i nie odbiór.
- Testy FTKEY: **nie były ponownie uruchamiane w tym oknie**; liczby
  pochodzą z raportów (`REVIEW_E1_E4.md`, `V1d_001/REPORT.md`).
- Żywy KVM/FIDO: **NOT_RUN**.
- P2: nadal G0 `IN_PROGRESS`; żadna bramka nie jest zamknięta.
- D-021: nadal `PROPOSED`; ten dokument dostarcza argumentów, nie decyzji.
