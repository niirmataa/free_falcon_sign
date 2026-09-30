# KEYGEN_SOURCE_TO_FIBER_001 — żywy plan T12.1/source3

## Current execution rule — 2026-09-30

The owner authorizes three-own-commit push batches. The latest clarification
reserves review decisions to the owner: automatic batch review applies to
another agent, not this worker. Work subagents are permitted, with one writer
and one proof job at a time; do not start automatic batch reviewers. This
replaces the earlier local-only publication instruction and supersedes the
automatic-review proposal. New text uses English and standard terminology;
historical Polish text is retained.
This change does not alter the package's mathematical acceptance criterion.
Only the worker's own commits may be pushed. Foreign unpublished ancestors
must first be published by their author or the owner; do not push a mixed
range from shared main. Conversation with the owner remains in Polish.

Status: IN_PROGRESS / NOT_REVIEWED. Autor GPT-6 Astra, openai/gpt-6-astra,
sesja ses_f12636605ffeL1FZg4teLUwUf5. Zapis typu przed implementacją.
Właściciel zlecił cały pakiet; domknięcie helpera nie kończy zlecenia.

## 1. Dokładna specyfikacja końcowego eksportu

Poniżej **typ do skonstruowania**, nie deklaracja istniejącego twierdzenia.
`KeygenM0.Exec`, `Arguments`, `LegalEntry`, `ObservedEncoding` i
`FullCertificateWitness` wymagają implementacji i source-adequacy.
Nazwy matematyczne po prawej są rzeczywistymi eksportami zależności.

```lean
-- namespace FT1536.Source3.KeygenSourceToFiber001
open FT1536.Geometry FT1536.Relation
open FT1536.Run2.CoefficientQuotient

theorem emitted_to_actual_fiber
    (args : KeygenM0.Arguments)
    (before after : C99MemoryReference.Memory)
    (events : List KeygenM0.Event)
    (profile : KeygenM0.ProfileM0 args before)
    (legal : KeygenM0.LegalEntry args before)
    (exec : KeygenM0.PinnedExec args before after events (1 : Int)) :
    ∃ (sk pk : List (BitVec 8))
      (f g bigF bigG : Vec) (h fInv : Rq)
      (call : KeygenM0.CallId),
      KeygenM0.ObservedEncoding args after sk pk ∧
      KeygenM0.DecodeSecret sk = some (f,g,bigF,bigG) ∧
      KeygenM0.DecodePublic pk = some h ∧
      KeygenM0.SameFinalAttempt events call f g bigF bigG h ∧
      KeygenM0.FullCertificateWitness events call f g bigF bigG ∧
      ∃ (ntru : multiply f bigG - multiply g bigF =
          constantCoeffs (18433 : Int))
        (public_eq : mulRq h (reduceVec f) = reduceVec g)
        (inverse_eq : mulRq fInv (reduceVec f) =
          constantCoeffs (1 : ZMod 18433)),
        ∀ c : Rq,
          (∀ u : Vec × Vec,
            (FT1536.Run2.ActualNTRUFiber.coordinates
              f g bigF bigG h fInv c ntru public_eq inverse_eq u).val =
            (centerRq c,0) +
              FT1536.Run2.ActualNTRUFiber.coefficientBasis f g bigF bigG u) ∧
          (∀ a : Real,
            (∑' z : {z : Vec × Vec // A h z = c},
              Real.exp (-a * (FT1536.Geometry.Q z.val : Real))) =
            ∑' u : Vec × Vec,
              Real.exp (-a * (FT1536.Geometry.Q
                ((centerRq c,0) +
                  FT1536.Run2.ActualNTRUFiber.coefficientBasis
                    f g bigF bigG u) : Real)))
```

`coordinates` ma typ `(Vec×Vec) ≃ {z : Vec×Vec // A h z=c}`: pełna
równoważność, nie tylko zawieranie obrazu w włóknie. Końcowa implementacja
może pakować świadectwa w strukturę, lecz lista przesłanek ma pozostać ta
sama: profil, legalna pamięć wejściowa, niezależne source execution.

### Znaczenie wejścia i wyjścia

- ProfileM0: odczytane logn10/ter1, STATIC, przypięte makra/profil LP64.
  Attempt cap to **3000000**, nie dowolny parametr. LegalEntry obejmuje
  alignment, rozmiary, odrębność wymaganych buforów i ich żywotność;
  inicjalizację tylko czytanych wejść. Nie obejmuje wartości FFT, g00,
  leaves/scratch, NTRU, positivity, FiniteFlat, delta ani acceptance.
- PinnedExec: skończona derywacja wykonywania źródła, z rzeczywistymi
  load/store, wywołaniami, continue/break/return i scope teardown.
  Ret1 jest obserwacją, nie skrótem dla matematycznych postconditions.
  Brak kontraktu dowolnego callee lub przesłanki completeness w finale.
- ObservedEncoding: bajty i długości odczytane z publicznych buforów
  wyjściowych po return; DecodeSecret obejmuje **cztery** tablice z G,
  DecodePublic h. Ich zgodność z finalnym attemptem jest wnioskiem.
- FullCertificateWitness: identyfikator tej samej inwokacji, snapshoty
  prefix/g00, accepted Gate00, full suffix i świadectwa wszystkich kontroli;
  1536 słów MIN…MAX, 1024≤decoded<332054; reverse1535-u z source div.
  Snapshot bad przed return, bez odczytu martwego obiektu po teardown.
  Źródłowe f/g/F/G zachowane, frame po powrocie wyprowadzona z wykonania.

## 2. Przypięta baza

Źródło M0 w read-only dawnym RUN_003 `inputs/source/`; nie Extra/c.
PROFILE SHA256 `55dc91b373858ddaab78ac4f125538505279c5f74ac3d4e4569a02164ebb1e56`.
Kontrola startowa wszystkich17 source_files PROFILE: zgodna.

- keygen: `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`.
- suffix REPORT: `7b36b9c4a01056b577e6b60c329646ba5fdee31266b836a42f6d592cc21ed898`.
- suffix CLOSURE: `657b907273f0bda6e9ecfc5bbeae24bf169cd1bc8e6965f8662b6501f97cfd56`.
- top REPORT/CLOSURE i binary004 REPORT/CLOSURE dziedziczone z powyższej
  closure, status PROVED_KERNEL_SCOPED / NOT_REVIEWED.

Matematyczne źródła run2/formal/Run2 tylko do odczytu, pin na wejściu:

| Moduł | SHA256 |
|---|---|
| CoefficientQuotient | e2be27ef2075dca9e72aa84d5aae50ec1242724f52072a8361f1c56e1eb0b727 |
| QuotientOperations | a5dbf99deaeb786059b9c1d2d96cd9d4ded229679f6cf6ec36b1de73ab706bb1 |
| NTRUBasis | ce2d77f4073cafbfda20ed11561a2d89a41b056db949135af2a750a5b6475fdc |
| ActualNTRUFiber | 5ed6ecc1d657ccb58b14c5455dabcf42b21e1f54f0f1116a92564f0ad136e242 |

`ActualNTRUFiber.coordinates`, `coordinates_formula`,
`gaussian_fiber_in_basis` wymagają dokładnie trzech równań w typie powyżej.
Nie potrzebują GramLDL/FiniteFlat/certLo/certHi; tych torów nie przejmujemy.

## 3. Kolejność i obowiązki wspólnej kompozycji

1. Pin source/callee/import graph oraz rzeczywiste typy; oddzielić istniejący
   kernelowy eksport od parsera/bindingu i zadania do wykonania.
2. Pełny certificate7690–7778: scope/layout, smallints→FPEMU, FFT3/polynomial
   operations/raw LDL, Gate00 na bajtach, suffix, teardown. Suffix-entry
   Legal wynika z prefixu; source completeness nie zostaje założeniem.
3. Make7782–8187: parametry/attempt cap, odrzucenia i końcowy attempt,
   przekazanie identycznego materiału do gate i czterech serializerów oraz
   publicznego encodera; zakresy wyjściowe/decoders/lifetime.
4. Równania: sampler MODE1 daje f/g∈{-1,0,1}; poly_big_to_small daje
   |F|,|G|≤2047. Końcowy solve_NTRU check używa **PRIMES3[0]=2147355649**,
   NTT3/Montgomery. Najpierw ścisły bound residualu modulo Phi, potem lift;
   osobno public NTT modulo18433, nonzero test i source division/inverse.
   Samo wykonanie wcześniejszego solvera nie jest dowodem jego poprawności.
5. Złączenie tej samej tożsamości materiału i source równań z istniejącym
   ActualNTRUFiber. Konsumpcja matematyki nie zastępuje punktów2–4.
6. Fresh replay całej nowej closure/finalnej kompozycji, typy/termy/axioms,
   mutacje bramki/attemptów/materialu/lifetime/modułu/boundu/G/h, raport.

Jeżeli obowiązek jest zablokowany: dokładny brakujący typ, zależności i
wynik próby w tym planie/rejestrze. Pozostałe niezależne części kontynuujemy.
Nie wpisujemy brakującego twierdzenia jako pola wejściowej struktury success.

## 4. Wykonanie

Jedna sesja/worker, jeden job Lean/Sage naraz z preflight; limits dziedziczone
z tools/job.py (-j1/-M6144, AS12GiB/RSS8GiB/wall1800s). Sage z preparserem,
ZZ/QQ/rigorous intervals; failed attempts/logs/receipts zachowane. Wyłącznie
publiczne syntetyczne kontrole, bez prywatnego KeyGen/generacji kluczy.
Małe lokalne commity z dokładnymi pathspecami, bez push. Przed commitem
status/staging/diff/log i kontrola pojedynczego writera. Bez migracji,
edycji run2/t5, starego W lub frozen; bez samodzielnego REVIEWED.
