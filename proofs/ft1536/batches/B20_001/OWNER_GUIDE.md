# B20 — instrukcja właściciela:20 kolejnych zadań i20 niezależnych odbiorów

Autor projektu Niirmata.2026-09-22. To następny formalny tranche istniejącego
ROADMAP: T02→T03→T04→T05→T06,z koniecznym uzupełnieniem formalizacji starszych
fundamentów. Pakiet zawiera dokładnie20 Pxx i20 Vxx. T02.1 jest już u recenzenta;
jego przyszłych hashy nie zgadujemy. Powiązany P03 czeka na rzeczywisty handoff.

## 1. Standard i znaczenie wyniku

**SageMath + Lean4 + Mathlib,kernelowo.** Końcowy PROVED wymaga formalnego
łańcucha od przypiętego modelu/źródła do konkretnego theorem type,z rzeczywistymi
instancjami przesłanek. Sage dostarcza sprawdzalne certyfikaty,a tekst opisuje
argument. Mixed analytical/kernel wynik historyczny jest materiałem do portu,
nie automatycznie gotową formalną przesłanką nowych zadań.

Plan nie obiecuje prawdziwości każdej badanej tezy. W szczególności uniform
integer recovery/gap lub center compatibility mogą skończyć się formalnym
blockerem/counterexample. Taki wynik zachowujemy; dalszy consumer nie dostaje
brakującej tezy jako założenia. Dopuszczalne jawne primitive/platform assumptions
nie mogą ukrywać celu zadania lub niedowiedzionego source refinementu.

Ten tranche nie jest całym M7. T07–T14 (ideal norm/retry,image/R5T,public sampler,
freshness,ROM simulator,indexed extraction,pełna security composition) dostają
od P20 precyzyjny formalny interfejs i pozostają dalszymi etapami. S01/S06
zachowują osobne wymagane poprawki; publikacja nadal czeka na bramkę S01.

## 2. Twoja kolejność — zadanie i jego weryfikator

| P | Zadanie wykonawcze | Weryfikator | Główne zależności |
|---|---|---|---|
| [P01](tasks/P01/TASK.md) | Formalny fundament/source semantics/certificate checker + Mathlib bootstrap | [V01](reviews/V01/REVIEW_TASK.md) | gotowe materiały bazowe |
| [P02](tasks/P02/TASK.md) | Word/FPEMU source refinement | [V02](reviews/V02/REVIEW_TASK.md) | P01 |
| [P03](tasks/P03/TASK.md) | Formalny frng init/refill/layout/counter | [V03](reviews/V03/REVIEW_TASK.md) | P01,P02,odbiór T02.1 |
| [P04](tasks/P04/TASK.md) | Getters/reset/resource envelope | [V04](reviews/V04/REVIEW_TASK.md) | P01,P03 |
| [P05](tasks/P05/TASK.md) | Computational real-RNG→IID game bridge | [V05](reviews/V05/REVIEW_TASK.md) | P01,P03,P04 |
| [P06](tasks/P06/TASK.md) | Integer reference/mapping/congruence w kernelu | [V06](reviews/V06/REVIEW_TASK.md) | P01,P02 |
| [P07](tasks/P07/TASK.md) | Ciasne stored FFT basis residuals | [V07](reviews/V07/REVIEW_TASK.md) | P01,P02,P06 |
| [P08](tasks/P08/TASK.md) | Tree reconstruction δ/eroot i domains | [V08](reviews/V08/REVIEW_TASK.md) | P01,P02,P07 |
| [P09](tasks/P09/TASK.md) | Target/terminal error transport ηt | [V09](reviews/V09/REVIEW_TASK.md) | P06–P08,primitive foundation |
| [P10](tasks/P10/TASK.md) | Gap<1/2 i actual wide-rint recovery | [V10](reviews/V10/REVIEW_TASK.md) | P06–P09,primitive foundation |
| [P11](tasks/P11/TASK.md) | Prefix API/nonce/H2P/ReadyRetryEntry | [V11](reviews/V11/REVIEW_TASK.md) | P01–P03 |
| [P12](tasks/P12/TASK.md) | Formalny scalar IID stopped kernel | [V12](reviews/V12/REVIEW_TASK.md) | P01–P03,P09 domains |
| [P13](tasks/P13/TASK.md) | Scalar Gaussian TV/chi2 i support | [V13](reviews/V13/REVIEW_TASK.md) | P01,P12 |
| [P14](tasks/P14/TASK.md) | Ordered adaptive3072-call joint kernel | [V14](reviews/V14/REVIEW_TASK.md) | P08,P09,P12,P13 |
| [P15](tasks/P15/TASK.md) | H6 tails + stopped cap16/resources | [V15](reviews/V15/REVIEW_TASK.md) | P04,P11,P14,primitive foundation |
| [P16](tasks/P16/TASK.md) | Global reference/coset-Gaussian geometry | [V16](reviews/V16/REVIEW_TASK.md) | P06–P09,P13,P14 |
| [P17](tasks/P17/TASK.md) | Precast/stored norm/codec/bytes refinement | [V17](reviews/V17/REVIEW_TASK.md) | P11,P15,primitive foundation |
| [P18](tasks/P18/TASK.md) | Verify center/norm compatibility | [V18](reviews/V18/REVIEW_TASK.md) | P06,P10,P15–P17 |
| [P19](tasks/P19/TASK.md) | Complete observed source/IID/reference kernels | [V19](reviews/V19/REVIEW_TASK.md) | P05,P10,P11,P15–P18 |
| [P20](tasks/P20/TASK.md) | Formalna kompozycja i interfejs dalszego M7 | [V20](reviews/V20/REVIEW_TASK.md) | P04,P05,P10,P11,P15–P19 |

Pełne zależności i piny są w [INDEX.json](INDEX.json),[BASE_INPUTS.json](BASE_INPUTS.json)
i indywidualnych INPUT_CONTRACT.json. Tabela jest skrótem,nigdy zamiennikiem TASK.

## 3. Gdzie co znajdziesz

Dokumenty: `/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001`.
Wykonawcy: `proofs/ft1536/work/B20_001/P01` … `P20`.
Recenzenci: `proofs/ft1536/work/B20_001/V01` … `V20`.
Każdy W ma inputs/run/output/checkpoints/home/cache/tmp i własny AGENTS.
`checkout` jest docelową ścieżką worktree,tworzoną dopiero przy starcie.

- [AGENT_GIT_PROTOCOL](AGENT_GIT_PROTOCOL.md):dokładne wykonanie,odbiór i commity.
- [TOOLCHAIN_PINS](TOOLCHAIN_PINS.json):Lean4.34,Sage10.9,Mathlib4 v4.34.0
  commit5ed29652… i rewizje8 zależności. Publiczne metadane sprawdzono;
  lokalna materializacja/budowa biblioteki jest obowiązkiem bootstrapu P01.
- PACKAGE.sha256:piny niezmiennych dokumentów/kontraktów.
- STATUS.json:żywy rejestr koordynatora,statusy/HEAD/piny/model/kontekst.

## 4. Jak uruchomić Pxx

1. Wybierz najwcześniejsze gotowe zadanie w kolejności powyżej. Przy blockingu
   można wybrać późniejsze niezależne zadanie,zapisując przyczynę w STATUS.
2. Sprawdź brak aktywnego workera. Wypełnij owner/model/context i realne
   input bindings w W/inputs/BOUND_INPUTS.json. Gdy potrzeba przyszłego wyniku,
   czekaj na frozen handoff. Nie uruchamiaj z null/hash-placeholder.
3. Integrator tworzy własną branch/worktree. Przykład dla P01:

```sh
REPO=/home/footfalcon/free_falcon_sign
W="$REPO/proofs/ft1536/work/B20_001/P01"
git -C "$REPO" worktree add -b proof/b20/p01 "$W/checkout" main
```

   To przykład do ręcznego wykonania po kontroli ownership. Zastanej branch/W
   nie resetuj. Main użyty do checkoutu ma zawierać przygotowany pakiet; zapisz
   jego rzeczywisty HEAD. SOURCE_BASE i przypięte source bytes pozostają stałe.
4. Przekaż modelowi:

```text
Wykonujesz P01 z B20_001. Przeczytaj:
/home/footfalcon/free_falcon_sign/proofs/ft1536/batches/B20_001/tasks/P01/TASK.md
oraz AGENTS w swoim W. Pracuj we wskazanym checkout/branch,formalnie w
Lean4+Mathlib,z rachunkiem SageMath zgodnie z TASK. Sam zapisuj lokalne
milestone commity jako niirmataa. Oddaj frozen handoff z pinami i HEAD.
```

Podstaw ID rzeczywiście wybranego zadania. Nie wysyłaj przez relay lub
`opencode run --session`. Domyślne limity/izolację określa protokół.

## 5. Jak przekazać wynik do Vxx

1. Autor kończy joby i przekazuje dokładny branch/HEAD,REPORT SHA,OUTPUTS SHA,
   FORMAL_EXPORTS/ASSUMPTIONS,scope i NEXT_INTERFACE.
2. Integrator sprawdza piny i materializuje wynik + closure RO w
   `Vxx/inputs/producer`,oraz zależności w `Vxx/inputs/dependencies`.
   W BOUND_INPUTS wpisuje rzeczywiste źródła,piny,HEAD i role.
3. Uruchamiasz niezależnego recenzenta z właściwym REVIEW_TASK.md. Własny
   worktree `proof/b20/vxx`,własny context i nowe raw receipts są obowiązkowe.
4. Vxx oddaje formalną ocenę typów/termów/source applicability i własny replay.
   PASS dotyczy dokładnego scope. PARTIAL upstream może odblokować wyłącznie
   konkretne w pełni proved/odebrane exports,nie nieudowodniony cel.
5. Integrator aktualizuje STATUS i consumer bindings. Przy CHANGES_REQUIRED
   autor robi nowy checkpoint/wersję,nie edytuje starego freeze.

## 6. Bootstrap Mathlib i brak analitycznych skrótów

P01 może zlokalizować istniejący checkout lub zgłosić koordynatorowi materializację
wyłącznie publicznych przypiętych rewizji z TOOLCHAIN_PINS. Pozyskanie źródeł
jest osobnym,jawnie logowanym krokiem przygotowania pod trwałym W/bootstrap;
proof/build/replay pracują potem offline. Żadnego update do nieprzypiętego main.
Closure źródeł,build receipt i hashe używanej biblioteki są wymagane.

Fresh projekt nie używa olean/cache autora. Zweryfikowana immutable biblioteka
narzędziowa może być współdzielona RO po sprawdzeniu pochodzenia; finalne
theorem axioms audytuje się transitywnie. Nie ma dowodu przez samo „Sage PASS”,
liczbę theoremów lub tekstowy szkic. Brak formalnego kroku jest jawnym blockerem.

## 7. Git,integracja i zmiana prowadzącego

Autorzy i recenzenci sami commitują milestones do swoich gałęzi jako niirmataa.
Work/ jest ignorowany:checkpointy trafiają przez archive.py do standardowych
stages/catalog/objects we własnym checkout. Scope/checker/logi/negatywne wyniki
są częścią checkpointu. Protokół podaje dokładną zatwierdzoną tożsamość.

Jeden integrator zarządza kanonicznym main. Najpierw sprawdza evidence/review,
potem FF gdy historia pasuje,lub jawny merge bez przepisywania commitów.
Globalne indeksy aktualizuje dopiero po odbiorze. Produkcja Extra/c i push
nie wynikają z lokalnego commita dowodu. Family publication gate obowiązuje.

Przed końcem limitu/modelu:HANDOFF z ostatnim HEAD,pinami,eksportami,missing
types i stanem jobów. Kolejny prowadzący czyta ten przewodnik,STATUS,STATE
i handoff aktywnej roli. Dzięki checkpointom przejmuje konkretny krok zamiast
odtwarzać rozmowę. Matematyczny blocker pozostaje prawdziwym blockerem;
zmiana modelu nie uprawnia do osłabienia celu.

## 8. Kontrola przygotowania

```sh
python3 -B proofs/ft1536/batches/B20_001/build_package.py verify
```

Sprawdza20+20,acykliczne zależności,manifest dokumentów i40 W. To kontrola
przygotowania,nie wykonanie któregokolwiek dowodu. STATUS rozróżnia gotowość
dokumentów od gotowości wejść. Żaden worker nie wystartował przez wygenerowanie
tego pakietu.
