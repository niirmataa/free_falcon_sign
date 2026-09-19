# Niezależny odbiór H3_RANGE — 2026-09-19

**Odtwarzanie PASS; zakres matematyczny nadal PARTIAL_PROOF.**

Odebrano `FT1536_H3_RANGE_RUN_001` na bazie main
`68c0f9be3d00ca97510fa0c415ea5943b30823f6`. Przypięty raport:
`e808b0ecd9d39b575c075bf64056df93586d6fad60a0932866d673d0b45abb8c`;
OUTPUTS: `911276514089b86e72173d4260aede980bb4497bcfce2789df5fbd56b8f1ce6e`.
Import sprawdził 2095 członków OUTPUTS i 56 publicznych wejść INPUTS.

## Wykonanie

Z głównego katalogu repo:

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_RANGE_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia archiwum, bez odziedziczonych olean/bin/cache, z odłączoną siecią
i ukrytymi Dokumenty/H. Zapis był ograniczony przez bwrap do kopii roboczej.
Kod zakończenia 0; 41.657 s; **96/96 plików znaczeniowych zgodnych** z
zamrożonym receipt, nie tylko z nowo wypisanym PASS.

- 8 modułów Lean 4.34.0/Std, **49 nowych twierdzeń**, czyste finalne logi;
  odczytano rzeczywiste typy i aksjomaty, w tym warunkowe `CenterClass`.
- 112 primitive/guard/table/width jobs w każdym trybie. Receipt normal ma
  114 wpisów (także kompilacja i dump tabel), sanitizer 113 (także kompilacja).
- 83 kontrole z niezależnym exact-dyadic oracle; 18 słów granicznych floor
  i 15 endpointów selektora; 2560 wierszy CDF.
- 12290 callback comparisons na tryb normal/ASan/UBSan dla publicznych
  sztucznych drzew, w tym no-op, sticky fault i terminal negative zero.
- Wykryte zmiany terminalnej skali, znaku korekty, granic floor i CDF;
  osobny świadek niewystarczalności samych stored leaves.

Wszystkie strumienie wskazane przez receipts i drivery sprawdzono po SHA-256
i zachowano obok receipts pod ich względnymi ścieżkami. `toolchain_receipts`
zawiera strumienie inline. [VALIDATION.sha256](VALIDATION.sha256) obejmuje
600 plików; jego SHA-256:
`0235a83eeab0b823a01f81134c03a344242a619fc60f6cb7e1de334f7ba086dc`.
Metadane: [execution](execution.json), [review_checks](review_checks.json),
[formal_audit](artifacts/formal_audit.json), [REPLAY_RESULT](REPLAY_RESULT.json).
Pełne historyczne logi pierwszych prób pozostają w niezmienionym etapie.

## Dokładny zakres odbioru

Potwierdzono lokalne floor/proposal/ordered-residual lematy, ich przypięte
powiązanie z C oraz odtwarzalność diagnostyki. Source-order projection i lokalny
bit-field model nie są pełnym kernelowym interpreterem KeyGen/loader/Sign.

`fpr_floor(-0)=-1` przy mathematical floor(0)=0 i przechodzących lokalnych
guardach. Jednocześnie s+z pozostaje w int32 dla z∈[-365,366]. Przykłady
underflow obalają nieograniczony model IEEE `u*abs(x)+2^-1075` dla tego
backendu. Sztuczne drzewo z L=2^32 i poprawnymi leaf widths daje trzecie
centrum 12884901888. **Żaden z tych testów nie dowodzi emitted-key ani
whole-Sign reachability**; `required_domain_counterexample=false`.

Pozostały cel: `Reach_call_C(...) -> CenterClass(mu)`, obejmujący zero/domain,
wewnętrzne subtractive-LDL pivots/L, machine errors i pełne source binding.
`H3_range_proved=false`, `global_source_semantics_kernelized=false`,
`security_reduction_proved=false`. Odbiór nie nadaje owner acceptance.

Źródła aktywnego kandydata nadal mają manifest `2553358f…`; pakiet nie
wprowadza poprawki C ani opakowania M0. Historyczne raporty pozostają bajtowo
niezmienione, włącznie z ich statusami i logami kompilacji.

`git diff --cached --check` zgłasza historyczny whitespace przypiętych kopii
źródeł/raportów oraz końcowe puste wiersze strumieni toolchainu. Zachowano
te bajty ze względu na piny; kontrola nowej dokumentacji przechodzi osobno.
Pełna integralność wszystkich dziesięciu checkpointów przeszła `archive.py verify`.
