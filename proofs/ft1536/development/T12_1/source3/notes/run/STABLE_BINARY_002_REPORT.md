# T12.1 / RUN_003 — STABLE_BINARY_002, wynik po kontynuacji

**Status: PARTIAL_PROOF / WORKING_NOT_FROZEN.** Autor: GPT-6 Sol
(`openai/gpt-6-sol`, ta sama sesja `ses_f12636605ffeL1FZg4teLUwUf5`).
Poprzedni raport `_001` SHA256
`5506e59eb94fa83cd718140edf78c3da03d46223998c9de5546e44edace93c7b`
pozostał niezmieniony. Wcześniejszy stan `_002` przed niniejszym domknięciem
bajtowego mostu zachowano w `run/STABLE_BINARY_002_BEFORE_BYTE_REFINEMENT.md`
SHA256 `a8188062350ba7075be571f8ae274429644c400dcef11727f840d616db8e5c3d`.
To rezultat autora, bez niezależnego odbioru, freeze, owner acceptance i Git/push.

## Źródła i łańcuch wiązania

| M0 input w `inputs/source/` | SHA256 | Zakres |
|---|---|---|
| `falcon-keygen.c` | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` | cały helper 7491–7514; stable-positive 7478–7489 |
| `fpr-emulated.c` | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` | add 449–554, mul 681–774, div 916–1000, norm 21–54 |
| `fpr-emulated.h` | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` | typedef `fpr=uint64_t`, inline FPR/ulsh/ursh/half/double |
| `Makefile` | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` | profil M0, `FALCON_ASM_CORTEXM4=0`, brak override |

Przypięty Sage (`sage pin_fpr_c_source.sage`, standardowy preparser,
`stable_binary_fpr_transport_003`, receipt SHA256
`d9160bf2ac9d0d63b82c5637c10e91c1cf2b874a2374e605b5c210f0a8081390`)
przeniósł 1259 linii C do `Source3/FprCSource.lean` SHA256
`cf1e1703a7611f47efc640ffc4f994421511c3c4c2412036e4f630f234ae7072`.
`FprPrimitives.m0_active` sprawdza #if/#else/#endif, default0 i typedef M0.
Nie użyto nowszego nagłówka P02 jako zamiennika źródła.

`StableBinarySourceSyntax.pinned_source` parsuje *cały* fragment helpera:
sygnaturę, bazę `n=1`, pętlę, dwa wyrażenia indeksów, operacje add/mul,
half/double/div, sześć kontroli, oba zapisy scratch, `memcpy` i lewą/prawą
rekurencję z `values+hn`. Otrzymany AST steruje oddzielnym wykonaniem
`StableBinaryCExec` na pamięci bajtowej. Zmiana wywołania add→mul daje
**inny AST**, a zła prawa rekurencja jest odrzucana. To krok wykraczający
poza poprzedni tokenowy `StableBinary.source_parses`.

Trzy FPEMU są parsowane jako kompletne aktywne C AST, wykonane w typowanym
fragmencie C99/GCC-LP64 `B20.C`/`CLogic`; `fpr_div` sprawdza warunek i
wykonuje wszystkie55 iteracji, z poprawnym zakresem życia lokalnego `b`.
`FPR_NORM64` przechodzi substytucję makra i wykonanie, `FPR`, `fpr_ulsh`
oraz `fpr_ursh` są parsowane z literalnego M0 headera. Operacje unsigned
mają dokładne słowa 32/64; signed-overflow i błędne przesunięcia zwracają
`none` jako niezdefiniowany przebieg, nie wynik0. Dla **zdefiniowanych**
wykonań `FprCFrame.add_byte_frame/mul_byte_frame/div_byte_frame` dowodzą
identyczności całej caller-owned `B20.C.Byte.Memory` (contents, length,
writable), uwzględniając lokalne obiekty i inline helpery. `FprCErasure`
wyprowadza bez przesłanki o wynikach dokładny Word64 i zgodność z
`StableBinaryFpr.boundOps`; to nie jest już `callerCall := map (·,heap)`.

`StableBinaryByteView` wiąże LE64 i cztery bajty `bad` z typed-object
`values`/`scratch`/`bad`. W szczególności zapis scratch jest dozwolony przy
początkowo niezainicjalizowanych bajtach; są one zapisywane przed odczytem.
`StableBinaryMemcpySpec.source_copy_is_byte_memcpy` daje extensional
kontrakt C99 `memcpy`: niepokrywanie, **każdy bajt** wyniku równy bajtowi
źródła sprzed kopii, rama poza celem oraz zachowanie metadanych.

## Kernelowy wynik o całym helperze w formalnej semantyce fragmentu

`StableBinaryRecursionRefinement.execute_refines` jest indukcją po `k`:
rozlicza bazę, pełną pętlę, kopię, całą lewą rekurencję, potem prawą na
`values+8*hn`. Lemat `byte_interpreter_refinement` składa ją z legalnymi
adresami, LE view i bajtową ramą. Finalny eksport odnosi się do
**`StableBinaryCExec.run` uruchamiającego AST sparsowany z przypiętego C**,
nie do `run l ops k m` dla arbitralnych operacji. Jego dokładny typ:

```lean
theorem pinned_byte_source_outcome (l : StableBinary.Layout) (k : Nat)
    (before : B20.C.Byte.Memory) (final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l before)
    (hs : StableBinaryCExec.run l k before=some final)
    (hclear : StableBinaryByteView.flagRead final.heap l.bad=some 0#32) :
    StableBinaryByteView.flagRead before l.bad=some 0#32 ∧
    (∀ w∈final.checks,
      Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) ∧
    (∀ q, ¬StableBinaryRefinementGoal.allowedByte l q →
      final.heap.contents q=before.contents q)
```

`l.wellFormed k` oznacza `length=2^k`, `k≤8`, wyrównanie, disjoint
values/scratch/bad i brak overflow wskaźników. `Legal` wymaga jedynie
czytelnych/pisalnych obiektów values, pisalnych (niekoniecznie uprzednio
zainicjalizowanych) scratch oraz czytelnego/pisalnego bad. Nie ma selekcji
kluczy ani tezy o liściach/Gram/delcie. `final.checks` zapisuje każdą
rzeczywiście wykonaną kontrolę; równość `stableWord w=w` przy clear
wyklucza fallback do `fpr_one`. Pamięć *bajtowa* poza dokładnie dozwolonymi
trzema regionami jest zachowana. Drugi eksport
`pinned_byte_source_prior_nonzero` mówi dla **każdego** początkowego
`bad≠0#32`, także7, że końcowy bad nie wynosi0. Cztery bajty flagi są
odczytywane i zapisywane przez przypięty stable-positive RMW.

`#check` typów, `#print` termów i transitive `#print axioms` eksportów są w
surowym `Source3_StableBinarySourceProof.stdout` finalnego jobu. Lista
aksjomatów: wyłącznie `propext`, `Classical.choice`, `Quot.sound`. Logi są
czyste (`warningAsError`, `lean -j1 -M6144`, bez wyciszania), bez
`sorry/sorryAx/admit/native_decide` w zaakceptowanych dowodach.
Środowisko: Lean4.34.0 i Mathlib `5ed2965256430c3649e86755f9576b54eca72435`.

## Ścisła granica: C99-defined → interpreter (pozostaje OPEN)

Nie udowodniono jeszcze, że **każde** wykonanie przypiętego tekstu,
zdefiniowane niezależnie według pełnego C99/LP64/GCC, daje `some` w
ograniczonym scalar-C interpreterze. Formalne `CExec.run=some` oznacza
zdefiniowane wykonanie *tego źródłowo sparsowanego fragmentu*; nie wolno
zamienić go bez dowodu na kwantyfikację po osobnej, pełnej semantyce C.
W `Source3/StableBinaryRefinementGoal.lean` zapisano nieprzyjęte, **nieużyte
jako przesłanki** typy `allPinnedFprWordsDefined` (uniwersalne Some dla
add/mul/div) i `allLegalHelpersDefined` (wszystkie legalne pamięci i k).
Pierwszy byłby wystarczającym składnikiem dowodu braku dodatkowego filtra
callee; potrzebne jest też sprawdzenie frontendu/konwersji i fuel wobec
niezależnej semantyki C99. `positive_total`, `base_total` dla `n=1` oraz
`half_total/double_total` są już kernelowe. Skończone publiczne próby nie
udowadniają brakujących twierdzeń uniwersalnych. To **brak dowodu**, nie
kontrprzykład C, błąd kodu ani oszacowanie błędu rzeczywistego FPEMU.
Z tego powodu status całego żądanego standard-C source PASS pozostaje
`PARTIAL_PROOF`, mimo domkniętego wyżej silniejszego wyniku w formalnym
źródłowym fragmencie. Następny krok: kernelowy dowód wyżej wskazanych
definedness/domain obligations i niezależny odbiór source semantics; dopiero
potem ewentualny freeze/owner acceptance. Błąd względem liczb rzeczywistych,
IEEE RN, FFT/exact Gram, T5, M6 oraz C Sign pozostają osobnymi zadaniami.

## Kontrole i receipty

- `StableBinaryCExecAudit`: publiczne syntetyczne n=1,n=2, początkowe
  bad0 i bad7; scratch miał `none` w obszarze wejściowym. Diagnostyczny
  wynik n=2 miał8 kontroli, clear pozostało0, a prior7 pozostało7.
- Kernelowe mutanty: reset `*bad=0`, zły adres prawej rekurencji, zmiana
  callee add→mul (zmienia AST), ulsh<<32→<<31, normalizacja mul i55→54
  iteracji div. Mutant add bez korekty znaku zmienia wynik w publicznym
  wykonaniu diagnostycznym; pełna redukcja tego przykładu w kernelu
  przekroczyła limit pamięci i jej raw log zachowano. To nie przesłanka proofu.
- `FprTotalityProbe`: 12 publicznych skrajnych słów ×12, zero wykrytych
  `none` dla każdego add/mul/div; **diagnostyka, nie universal proof**.
- Nieudane próby i odmowy preflight podczas obcych jobów zachowują swoje
  źródła/receipty/logi w W. Wznowienie nie ruszało innych W ani frozen.

Wszystkie **37** bieżących modułów mają accepted, clean, aktualny SHA
źródła, `.olean`, stdout i SHA receiptu w
`run/STABLE_BINARY_002_CLOSURE.json` SHA256
`f013bd471f4b7bda4eccca1748c5517e3c9c45d04816122558d5230872d5ff51`.
Został on wygenerowany i zweryfikowany przez
`run/stable_binary_closure.py` (hashy nie zgadywano). Główne punkty:

| Moduł | SHA256 Lean | SHA256 receipt |
|---|---|---|
| `FprPrimitives` | `221220c948d003d4896e2a4b7bf1779c2f3be83c626b3ae98185a99fd953da14` | `8baa1c0555b725489ba77871176470c982c0812e64d7343de9529fd698c5d2c5` |
| `FprCFrame` | `83977953163d66a89301f7c10b050a28b5c197601cd1b56cad9ed3408019c247` | `c1273ddd5991d38345c032f2ed8910011276e952b1752147ea88bca50c268e9a` |
| `FprCErasure` | `041c92bffb02bd7639a085ea6613c86112c89b61ab9ce8b16be6ba11d8ed019d` | `f65a21ff3c709272c58baa95af9f728f8e9d2d92a11bd71d740182f78715276d` |
| `StableBinarySourceSyntax` | `951bc1fcfd796345e2069447b05f85529c12b388cd56faf619af26f8e1c7120e` | `609484879c0eb11ba9a0409390a8617dfb125f89e193f6b599dcedbe77ba62d5` |
| `StableBinaryCExec` | `b76d84ebd95cb65ee0adbe5ec9c42c8f231c93f867f01f924b74b3bdf56a5d5e` | `466f551831634afb811bdbc7d1a0522dde505470ec93e28593dcf6fa9223050d` |
| `StableBinaryRecursionRefinement` | `603463a82fbd96bd78d3f671da1f08eb8032682ff6193fad065e29c977bdac46` | `cbcd0b115c452a02d8eb53371e4eb6027b8d1fc1c8194fbd0c066ecb5ad713ac` |
| `StableBinaryByteFrameRecursion` | `abf0e4181b07655ba10b34b26d6a1326ca11904fa105b7bff23ecbebae93ea7e` | `e897e654351a74a2f136896293c968ba1268b09cb54cb462c9ecec726e7572f1` |
| `StableBinaryMemcpySpec` | `5793d91510564a5643773452c890ef173f89d06e1bb0a8b8b71e014ec8fb7082` | `c7b7429f4c587e0767b4d396aa3a35f563309116ca62b9364b73a53b09f91725` |
| `StableBinarySourceProof` | `21c1c776ea5297e745b15a8a0c3113160a55b5ab1333bb46cb8426e3c5c2081a` | `eb1c08039d2fea75c17ae2aca9a36b585c25f30956311c1e00c6b3f22ff82de1` |

Nie commitowano ani nie puszowano. Sprawdzenie wyników tego W nie stanowi
samodzielnego niezależnego odbioru całego RUN_003.
