# CERTIFICATE_SUFFIX_001 — niezależny odbiór

Status materiału: **PREPARED_OWNER_START**. Autor: GPT-6 Astra,
sesja `ses_f12636605ffeL1FZg4teLUwUf5`. Recenzenta nie uruchomiono.
Właściciel wybiera model; koordynator prowadzi review/import/stages/tag.

## Kotwice względem source3

| Plik | SHA256 |
|---|---|
| `notes/run/CERTIFICATE_SUFFIX_001_REPORT.md` | `7b36b9c4a01056b577e6b60c329646ba5fdee31266b836a42f6d592cc21ed898` |
| `notes/run/CERTIFICATE_SUFFIX_001_CLOSURE.json` | `657b907273f0bda6e9ecfc5bbeae24bf169cd1bc8e6965f8662b6501f97cfd56` |
| `formal/Source3/CertificateSuffix001Outcome.lean` | `53edbc41fa59f7270efea3f29e5261425f00329cbd8fc62ddc2b65b4f6bbd3ec` |
| `.build/jobs/certificate_suffix_fresh_001/RECEIPTS.json` | `085b3aeb9f256654d7d5b13e87e46f72115e1b4d1951e2401a3eafc27b8aa8d0` |
| `.build/jobs/certificate_c_mutations_002/CERTIFICATE_SUFFIX_MUTATIONS.json` | `8c29fedfbb3853415d9865ca09ea8a3be7c0a95c2eaafe7ca3ed449bce8f6d18` |

Zależności TOP_001 i BINARY_004 pozostają PROVED_KERNEL_SCOPED /
NOT_REVIEWED z pinami w raporcie i closure. Odbiór suffixu nie nadaje
im milcząco REVIEWED. Poprzedni W i wszystkie stare raporty są RO.

## Przedmiot niezależnej oceny

Zakres: source M0 keygen7757–7776, jawny stan po prefixie, n1536/hn768,
snapshot na return edge. Nie cały certificate/prefix/KeyGen.

1. Sprawdź parser20 linii, makro7446, source fpr_of/scaled/norm/FPR,
   konwersję int→int64, actual Word64 i kernelowe real decode339775489.
2. Sprawdź leaves=t3/scratch=leaves+n, t3 backing1792 fpr, byte offset12288,
   views/alignment/extents/separation oraz Legal bez initial leaf/scratch
   reads i bez warunków positivity/Gram/exact leaves/delta.
3. Reverse:768 true guards + false guard, size_t n-1-u, dokładnie1535-u,
   first-half snapshot D, coverage/injectivity drugiej połowy, actual
   source div i stable-positive/uint32 RMW/store. Written musi wiązać
   wynik z faktycznie wykonanym eventem, nie idealnym ilorazem.
4. Scan: niezależny C99 scalar range-tail, typowane macro globals,
   fresh bits/valid, store i ponowny load przed bitcastem, oba inclusive
   checks, live bad read/write oraz dokładny return int0/int1.
5. Przeczytaj byte-memory→list projection i użycie starych LeafScan,
   LeafCertificateSuffix oraz LeafWordBounds. Accepted scan ma zachować
   pełne1536 słów/byte representation i dać literalne oraz realne bounds.
   Nie przyjmuj samego twierdzenia o liście za dowód byte execution.
6. Zbadaj A/B/C/D z dokładnych końcowych typów. W szczególności czy:
   - niepustość obejmuje cały Legal bez zakładania return1;
   - complete zachowuje wszystkie bytes/metadata/trace/return;
   - source_outcome daje roots/frame, sticky any initial bad i wszystkie
     good checks przy return1;
   - reverse_order zachowuje indeks1535-u i snapshot przed reverse,
     a przyjęty scan całą wejściową listę i jej bajty.
7. Oceń adekwatność wyspecjalizowanej autorskiej semantyki, rozpoznanej
   formy AST, by-value locals/pointer views i dozwolonych effect orders.
   Szczególnie jawnie rozlicz granicę **return-edge snapshot vs enclosing
   frame teardown**. To statement-suffix, nie automatyczny dowód całej
   normy ISO lub kompilatora. Jeśli zakres lub normalizacja nie wystarcza,
   wskaż konkretną regułę/typ/brak; nie zakrywaj go nową przesłanką.

## Replay i mutacje

Użyj osobnego trwałego runtime W; źródła autora i archiwa RO.
Odtwórz20 modułów w kolejności z `tools/certificate_suffix_closure.py modules`
z dokładnymi dependency/library pins. Nie podmieniaj M0 headera i nie
uruchamiaj innych modeli. Zachowaj dotychczasowe limity, warningAsError
i raw logs. Autor:20/20 clean,113 typów/termów/axioms,137.946s,maxRSS5342740KiB.
Aksjomaty tylko propext/choice/Quot.sound albo brak.

Sage standard preparser i168 publicznych syntetycznych C normal/UBSan
probes wykryły26/26 mutantów. Są return0/return1, varying roots, bad7,
zero/one roots i standalone inclusive endpoints. Porównywano pamięć,
trace kind+word, bad i return. Pierwszy mutator `_001` miał niedopasowanie
tabulatorów przed kompilacją; zachowano go i poprawiono w `_002`.
Testy skończone oraz hashe nie zastępują proofu i source-adequacy review.

Werdykt oddzielnie A/B/C/D, replay/integrity oraz source adequacy.
Zachowaj dalsze obowiązki Gate00/FFT/LDL prefix, cały certificate/KeyGen,
real-error FPEMU, exact Gram, T5, M6 i C Sign. Nie wykonuj publikacji,
migracji/scalania, freeze całej pracy ani samodzielnego stages/tag.
