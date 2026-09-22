# T02.1 — mały kontrakt layoutu i licznika PRNG

Autor projektu: **Niirmata**. Data2026-09-22. Zachowaj Falcon Project /
Thomas Pornin attribution i licencje. Jeden model wybrany i uruchomiony
ręcznie przez właściciela. Prowadzący przygotowuje zadanie; odbiór wyniku
i replay wykonuje później inny niezależny model.

## 1. Nowy W i mały zakres

```text
ROADMAP_ID=T02.1 (podzadanie T02 PRNG_REAL_TO_IID_BUFFER)
TASK_ID=FT1536_PRNG_LAYOUT_COUNTER_RUN_001
REPO=/home/footfalcon/free_falcon_sign
W=REPO/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_001
IN=W/inputs/bootstrap
BASE=c90233c171265e050930958fb29bafa9338f81ff
```

Przeczytaj REPO/AGENTS,START_HERE,proofs/ft1536/CURRENT_SMALL_TASK.md,W/AGENTS
i ten TASK. Potem tylko wskazane source i dependencies. S01 Family i T03
integer recovery mają innych wykonawców/W; nie wznawiaj ich ani Astry/T01.
Przed zapisem sprawdź, że ten W nie jest już prowadzony/zamrożony przez kogoś.

**Cel:** deterministyczny kontrakt dokładnego source
`falcon_prng_init` / `refill_chacha20` / `falcon_prng_refill` z `frng.c`,
layout `prng` z `internal.h` oraz mały consumer odebranego budżetu T01.
Nie rozszerzaj tego zadania do kryptograficznego dowodu całego T02.

## 2. Piny

Bootstrap39 członków/37 Git origins/5750423 bajtów.
IN/MANIFEST.sha256 SHA-256:
`03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2`.
Sprawdź exact member set/hashes, brak symlinków/escapes i source17.
ORIGINS przypina kopie do Git BASE; stare prompty/runners to dane historyczne.

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| source/frng.c | `4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644` |
| source/internal.h | `512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5` |
| T01/OUTPUTS.sha256 | `3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074` |
| T01/RESOURCE_BOUND.json | `4fc5e10ba15ae5fe806282fc29ccac70311e9803ef23c3d049ce2a8e6859b085` |

Required reading: frng.c189–339,internal.h759–803,T01/RESOURCE_BOUND.md/.json,
T01/PRNG_NEXT_INTERFACE.md oraz IID/PRNG_GAP_INTERFACE.md. Gettery u64/u8
są już odebrane w IID/BYTE_SCHEDULE; użyj ich interfejsu, nie nowego zamiennika.
Całego JOINT/H6P nie przebudowuj dla tego lokalnego zadania.

## 3. Kontrakt deterministyczny A — init i layout

Wejście: poprawny aligned prng i legalny SHAKE-extract interface zwracający
DOWOLNY konkretny ciąg56 publicznych bajtów. Rozkład tych bajtów nie jest
przesłanką. Oddziel actual SHAKE function od kontrolnego fixture provider.

Wyprowadź source-bound mapę little-endian bytes→12 Word32 state words oraz
Word64 counter, source offsets, wymagania rozmiarów/alignment i initialized
ranges w pinned GCC/C99/x86_64 LP64 modelu. Rozlicz type0→PRNG_CHACHA20,
type1 oraz unsupported type return0, kolejność56-byte extract→type→initial
refill→return. Podaj frame dla pozostałej pamięci. Nie zakładaj counter start0.

Wskaż actual FALCON_LE_U branch w tym buildzie. Przenośność drugiej gałęzi
możesz opisać analitycznie; uruchomienie jej na LE hoście nie jest testem
hardware big-endian. Publiczne fixtures mają własny jawny tag.

## 4. Kontrakt B — exact block/refill i counter

Zdefiniuj Word32 core niezależnie jako constants+12 words,20 rund według
source quarter-round schedule,feed-forward i LE serialization. Zwiąż KAŻDĄ
operację/indeks z literalnym C; unsigned adds modulo2^32 i shifts/rotates
mają określone domeny. Testy pomagają wykrywać błędy bindingu, ale nie zastępują
argumentu dla wszystkich legalnych56-byte inputs.

Ustal dokładnie, do których IV words/bajtów XORowany jest cc i jak wygląda
feed-forward tych lanes. Sprawdź zgodność komentarza z instrukcjami źródła;
rozbieżność komentarza zachowaj jako finding, bez zmiany C lub zakładania
standardowego IETF nonce/counter layoutu przez samą nazwę ChaCha20.

Udowodnij dla pojedynczego refill4096:
-64 kolejne64-byte blocks,liczniki cc0+k modulo2^64 dla0<=k<64;
-post counter=cc0+64 modulo2^64,first48 state bytes zachowane,ptr0;
-dokładny write/read frame dla state,buf,ptr,type i scratch.

Wyprowadź również q-refill corollary. Rozróżnij możliwość wrap od ponownego
użycia counter input: starting cc blisko2^64 może wrapować mimo małego budżetu.
Dla fixed context i mniej niż2^64 kolejnych bloków uzasadnij brak powtórzeń
counter values także przez wrap. Nie przenoś tego na różne context initializations.
Pokaż publiczny deterministic przykład identycznych init56→identycznych
buforów; to ograniczenie przyszłej gry, nie statystyczny atak/Emitted witness.

## 5. Kontrakt C — wąski consumer zasobów

Skonsumuj bez ponownego dowodzenia H6P/T01 **wspólny event H** z T01:
każda reached próba ma T_j<=49152, r_j<=396 ADDITIONAL refills,J<=16,
razem6352 initial+additional buffers. Przelicz i wyeksportuj:
-64*(1+r_j)<=25408 ChaCha block evaluations na reached context;
-64*6352=406528 block evaluations na region na H;
-56*J<=896 requested parent-SHAKE bytes w cut; nonce40 jest poza tym regionem.

To deterministyczne implikacje z podanego eventu. Pr(H^c)<2^-1020 pochodzi
z T01 w G_retry_IID. Nie przenoś tej probability do realnego PRNG bez hopu.
Nie traktuj56 bytes jako independent448-bit key,small block count jako
proof pseudorandomness ani repeated-context possibility jako jego probability.

## 6. Małe kontrole i dowód

Przygotuj niezależny executable integer/Word model oraz harness original C
slice z publicznymi stałymi fixture bytes. SHAKE-extract fixture jest jawnym
stubem granicy, nie realnym losowaniem. Bez falcon_get_seed/OS entropy,
rzeczywistych sekretów,KeyGen,private loadera lub pełnego Sign/do_sign.

Normal GCC14.2/C99/literalne Makefile-O i ASan/UBSan: public all-zero,
ascending bytes,asymetryczne IV lanes,counter0,2^32−1,2^64−1 oraz okolice
2^64−64. Porównaj całe4096 bytes,post state,ptr,type i canaries; init oraz
dwa kolejne refills. Kilkanaście celowych fixtures wystarczy; bez benchmarku,
bruteforce lub kryptograficznej kampanii losowej.

No-op i meaningful mutations: counter w złych IV lanes,XOR→add,32-bit counter,
pominięty initial refill,wrong feed-forward/byte order. Zachowaj naprawdę
wykonane wyniki i ewentualne równoważności. Same zgodne sample outputs nie
uzasadniają uniform theorem; source proof i jego model assumptions są jawne.

Mixed source/analytical/finite-word proof dopuszczalny. Lean opcjonalny dla
lokalnej algebry licznika/layoutu; jeśli użyty:4.34/Std,j1/-M2048,clean
logs/types/terms/axioms,bez sorry/admit/native_decide/Lean.ofReduceBool lub
warning suppression. Nie wymagamy rozbudowy starej bazy formalizacji.

## 7. Wykonanie, wynik i niezależny odbiór

Wszystkie zapisy,HOME/TMPDIR/cache/olean/bin/logs/replaye pod trwałym W;
zakaz systemowego /tmp,/tmp/opencode,tmpfs. Input/source RO,network-off,
bounded single-worker jobs,normal8GiB,ASan osobno z shadow. Bez sieci/instalacji,
Git/push,subagentów,relay,dudect,przejmowania cudzych W. W razie konfliktu
z kampanią timingową poczekaj na decyzję właściciela.

Wymagane REPORT.md,RESULT.json,CLAIM.md,PRNG_LAYOUT_CERTIFICATE.json,
LAYOUT.md/.json,BLOCK_SPEC.md,COUNTER_AND_FRAME.md,RESOURCE_INTERFACE.md/.json,
SOURCE_MODEL_BINDING.md,FAILED_ROUTES.md,NEXT_INTERFACE.md,INPUTS.sha256,
TOOLCHAIN.txt,COMMANDS.log,OUTPUT_SCOPE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUTS.sha256,model/harness/checkers/receipts i ewentualne formal/*.lean.
Eksportuj assumptions,from-state/to-state,quantifiers,source pins i zakres.

Standard scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA: zweryfikuj
manifest PRZED utworzeniem nowego DEST,fresh project build/cache,source RO,
network-off,deterministic semantic matches. Sealed artifacts/fresh_replay.json
i child REPLAY_RESULT.json:FRESH_REPLAY_PASS,matches[{path,sha256}],mismatches=[].
Po freeze pisz tylko do nowego DEST; oddaj zewnętrzne REPORT/OUTPUTS SHA.

Pełny status **PRNG_LAYOUT_COUNTER_PROVED_FOR_PINNED_SOURCE_MODEL** tylko przy
A+B+C z uniwersalnym source bindingiem i udanym replayu. Same fixtures dają
PARTIAL_PROOF; blocker/kontrprzykład musi mieć dokładny zakres i evidence.
Flagi: real_prng_to_iid_bridge_proved=false,SHAKE_security_proved=false,
ChaCha_security_proved=false,whole_real_Sign_proved=false,source_changed=false,
owner_accepted=false. **T02 pozostaje OPEN po ukończeniu T02.1.**

Handoff po polsku: status,A/B/C,co proved versus checked,findings/failed routes,
kontrole/replay counts i receipt,REPORT/OUTPUTS SHA,W,koniec własnych jobów.
Consumer: przyszły T02 game/hybrid proof otrzyma dokładny layout,blokowe
koszty i counter/repeated-context facts. Prowadzący przygotuje prompt
odbioru; inny niezależny model wykona review/replay przed checkpointem wyniku.
