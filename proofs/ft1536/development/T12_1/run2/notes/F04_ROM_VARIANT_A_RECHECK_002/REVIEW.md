# F04/F05 — targeted recheck SCOPE_002 po REVIEW_001

**Werdykt: PASS_SCOPED.** Punkty (a)–(e) przechodzą dla dokładnie **166
modułów, #001–#165 i #167**, z dwoma jawnie rozliczonymi wyjątkami:
#166 SelectBitPreserve jest poza odbieraną closure; #156 ThetaBox pozostaje
w niej z historycznym wyjątkiem narzędziowym lintera. Brak nowych blokujących
rozbieżności. Nie wykonano pełnego replayu ani żadnego wywołania Lean.

Przedmiotem tego werdyktu jest poprawność zakresu i evidence, a nie nowy
dowód matematyczny F04/F05. Werdykt proof-audit dla tak sformułowanej
deklaracji: **proved as written**. Ograniczenia matematyczne REVIEW_001
pozostają: lematy F04/F05 mają jawne przesłanki źródłowe i budżetowe.

## Cel, piny i proweniencja

Sprawdzony receipt: `../F04_ROM_VARIANT_A_SCOPE_002/RECEIPT.json`, SHA256
`675e96ee8a3398688f83a1a2d5f9297369d285aac2da67557fef12f48a0427e9`.
Korekta zakresu: commit `3fe2fa533d6e5ba6552d286eea88e6ecaa9f8487`.
Oryginalne źródła/review: `d053369e081d1e8b35630f736072286095876e43`.
HEAD przy kontroli: `b5aa282d` (pełny identyfikator w CHECKS.json).

To uzupełnienie obowiązków REVIEW_001 po jawnym poleceniu właściciela.
Bieżąca sesja Codex przygotowała także korektę dokumentacji, dlatego ten
recheck rozliczamy jako targeted self-review z pomocniczymi kontrolami
w dwóch świeżych, izolowanych kontekstach: `recheck_graph` i
`recheck_history`. Pomocnicy dostali surowe artefakty i obowiązki, bez
narzuconego werdyktu; nie uruchamiali checkera autora ani Lean. Nie
przepisujemy historycznej deklaracji niezależności REVIEW_001 i nie
ogłaszamy nowego niezależnego odbioru całej matematyki na podstawie tej
kontroli dokumentacji. Zgodność pomocników nie zastępuje kontroli bajtów.

Sam recheck używa osobnego `tools/recheck_f04_scope_002.py`; nie importuje
ani nie uruchamia autorskiego `check_f04_scope_002.py`. Python służy wyłącznie
hashom, parsowaniu importów/logów i odczytowym operacjom Git.

## Graf zależności i macierz kontroli

Przypięty `final_clean_002` + replay REVIEW_001 → zgodność numerów i źródeł
z commitem wejściowym → odtworzony graf importów → closure 166 → surowe
logi aksjomatów oraz focused 21. Niezależna gałąź R2: niezmieniony ThetaBox
→ kopia różniąca się wyłącznie włączeniem lintera → przypięty log błędu
rekurencji i receipt exit 1. Zachowane manifesty/prefiksy wiążą całość
z nienaruszoną historią, bez nowego replayu.

| Kontrola | Wynik | Rozstrzygające evidence |
|---|---|---|
| (a) Closure i standard-only | PASS | 166 unikalnych modułów w oryginalnej numeracji; 402 zgodne krawędzie; zero zależności projektowych poza zakresem i zero konsumentów SelectBitPreserve |
| (b) Wyjątek ThetaBox | PASS | Źródło identyczne z baseline; testowa kopia tylko false→true; zgodne hashe kopii/logu; zachowany błąd rekurencji lintera i exit 1 |
| (c) Brak zmian matematycznych | PASS | Wszystkie 167 historycznych źródeł są bajtowo zgodne z d053369e i receiptami; korekta 3fe2fa53 nie zmienia żadnego .lean/.sage; brak zmian run2/formal lub run2/sage do kontrolowanego HEAD |
| (d) Historia | PASS | 3813/3813 wcześniejszych plików zgodnych; 14/14 kopii; PREVIOUS_* równe wersjom Git i prefiksom obecnych dokumentów; REVIEW_001 nadal CHANGES_REQUIRED |
| (e) Receipty replayu | PASS | Oba cytowane hashe zgodne z oryginałami, kopiami i REVIEW_RESULT.json z REVIEW_001; oba mają 167 kroków exit 0 |

### (a) Dokładny zakres i znaczenie standard-only

Odtworzona mapa źródeł ma 177 pozycji: 29 archive i 148 local. Graf odbieranego
zakresu zawiera 332 krawędzie projektowe i 70 wystąpień importów zewnętrznych
(39 różnych modułów Mathlib). Każda krawędź projektowa prowadzi do jednego
z zaakceptowanych 166 modułów, w kolejności topologicznej zachowanego receiptu.
`MODULES.md` jest zgodny z numerami, nazwami i SHA256 w JSON-ie. Zakres jest
świadomie szeroki, nie jest deklarowany jako minimalna closure eksportów.

Zero modułów w pełnej 177-elementowej mapie importuje SelectBitPreserve.
Źródło diagnostyki ma SHA256
`b7f57ec65c98b3477a7177e4107d92eefc78ff58ff5c8f57c6d5fb7cb47a9523`.
Zachowany log SHA256
`81fb8910687d4604cd23a35722862bd82c413b4daa40b953c5c7e746b89f0d09`
cytuje dodatkowy aksjomat:

```text
select_bits_equiv._native.bv_decide.ax_1_5
```

Jest zależnością trzech eksportów diagnostycznych: `select_bits_equiv`,
`select_old_eq_new`, `select_code_variants_equiv`. Wyłączenie #166 usuwa
również czwarty rekord `mask_extend_eq`, który sam miał standardowe
aksjomaty. Nie zmienia to żadnego konsumenta F04/F05.

**Doprecyzowanie konwencji licznika, bez zmiany przypiętego receiptu:**

| Zachowane wyniki #print axioms | Historyczne 167 | Odbierane 166 |
|---|---:|---:|
| Rekordy `depends on axioms: [...]` | 573 | 569 |
| Wyniki `does not depend on any axioms` | 12 | 12 |
| Łącznie wszystkie wyniki | 585 | 581 |

Licznik 569 w SCOPE_002 oznacza rekordy z listą zależności aksjomatycznych,
a nie wszystkie wyniki polecenia #print axioms. Dodatkowe 12 wyników jest
axiom-free; ich deklaracje są wypisane w CHECKS.json. Jest to nieblokujące
doprecyzowanie skrótu „569 wydruków” w NOTES/CHECKPOINT, nie trzeci wyjątek
od granicy zaufania. Wszystkie 581 zachowanych wyników w odbieranym zakresie
mają zbiory aksjomatów zawarte w `{propext, Classical.choice, Quot.sound}`.
Osobne 21 deklaracji audytu REVIEW_001 jest zgodne z surowym logiem audytu;
20 używa standardowej trójki, a Sampler ma pusty zbiór aksjomatów.

PASS_SCOPED nie oznacza enumeracji wszystkich deklaracji środowiska Lean
lub Mathlib. Standard-only odnosi się do udokumentowanych audytów
w dokładnie 166-modułowym zakresie, zgodnie z jawnym polem boundary receiptu.

### (b) ThetaBox — jawny wyjątek narzędziowy

#156 ThetaBox: SHA256
`07db75cf4adfc8e3349c92919bf4789ef9453e08685ead8a5026eee203365ebe`.
Linia 166 lokalnie wyłącza `linter.constructorNameAsVariable` przy
`blockSum_eq_boxSum`. Źródło jest zgodne również z baseline `832a9953^`.
To wyjątek lintera nazw, nie wyciszenie dowodu ani kernela.

Kopia testowa ma SHA256
`a3061f1d964cc7877de08f211a884a04d90d2dc9224f8896c3992fd6bfa99def`;
jej jedyna różnica względem źródła to `false → true` w tej opcji. Log
SHA256 `1fa8918be6d90f09de4c96e65753de6e3ab73c552fb211d0026b9955ff8c53e8`
zawiera `linter Lean.Linter.constructorNameAsVariable failed: maximum
recursion depth has been reached`. Oryginalny EXTRA_CHECKS_RECEIPT zapisuje
exit 1 po 10,63 s, przed timeoutem 30 s. Sprawdzono zachowane evidence; testu nie
uruchamiano ponownie. Nie przywracamy blanket claim „zero wyciszeń”.

### (c)–(e) Źródła, historia i cytowane receipty

Kontrola obejmuje wszystkie 167 pozycji historycznego builda, w tym
wyłączony #166. Każdy hash źródła odpowiada bajtom Git z d053369e, obecnemu
plikowi oraz snapshotom i receiptom. Potwierdza to
`mathematical_sources_changed=false`, a nie tylko brak pliku .lean
w statystyce commita dokumentacji.

Sprawdzono 3813 plików manifestu zachowania; ponadto stare manifesty
REVIEW_001: 733 outputs, 204 inputs i 2052 external inputs. Zero braków lub
rozbieżności. PREVIOUS_NOTES i PREVIOUS_CHECKPOINT mają odpowiednio SHA256
`0a684105645efdee2cdecf22b855d3207b9f75f37a8dae5ff17a3716b1d3cad9`
oraz `458a9e31695f895f2586f982a801fd3e4ae6e631021255c5984d34dcde86ba33`.
Są dokładnymi wersjami historycznymi i prefiksami obecnych dokumentów.

| Artefakt historyczny | SHA256 |
|---|---|
| final_clean_002/RECEIPT.json | `e37814b7b768a414f4bd6a18eca34e7441d4a2ff3986b6c3cf8cc6b63107caae` |
| REVIEW_001/REPLAY_RECEIPT.json | `efc1f03db8e768bc5e86e2eb3ce5245b6d8462783b6f01bbff5c7b8fd64af232` |
| REVIEW_001/REVIEW.md | `42e5e11fb7dc8b35c71312705733f3ab16e9055bacd099b48cf6cc3c7727f8d7` |
| REVIEW_001/REVIEW_RESULT.json | `e03a89139fe403e40768420bde53aa321ec0ea2489a929b1ec8f40828cca164a` |

Oryginalny REVIEW_001 pozostaje niezmienionym faktem **CHANGES_REQUIRED**.
Nowy PASS_SCOPED dotyczy poprawionego zakresu/evidence; nie nadpisuje
tamtego raportu, jego werdyktu ani receiptu SCOPE_002.

## Polecenie, wynik i dalsza granica

Nowy checker metadanych uruchomiono z repo, bez Lean:

```sh
python3 -B proofs/ft1536/development/T12_1/run2/tools/recheck_f04_scope_002.py \
  proofs/ft1536/development/T12_1/run2/.build/f04_scope_recheck_002/CHECKS_002.json
```

Wynik: PASS (a)–(e), Lean invocations=0. CHECKS.json jest dokładną kopią
tego wyniku; INPUTS.sha256 przypina 4010 unikalnych odczytanych plików,
ze ścieżkami względem root repo. REVIEW_OUTPUTS.sha256 jest względem
katalogu tego raportu i nie obejmuje samego siebie. Wcześniejszy przebieg
metadanych pozostał w runtime jako CHECKS.json; drugi doprecyzował licznik
axiom-free, bez przebudowy któregokolwiek modułu.

Odebrany wynik nadal obejmuje idealny fresh-ROM wariant A, 12 przepisanych
warunkowych sygnatur, noise-only encoding/cost/PRG seam oraz trzy warunkowe
implikacje MachineStage F05. ReplyShape/source-defined sampler, most
bajtowy, hzero/budżety, identyfikacja prawa klucza i computational PRG/F06
pozostają otwarte. Bez owner acceptance, importu stages, tagu lub push.
MIGRATION_HOLD i dwa odrębne zadania utwardzania o NISKIM priorytecie
pozostają w mocy.

Ocena dla właściciela: rozjazd granicy zaufania R1/R2 jest rozliczony dla
nowego, dokładnie wskazanego zakresu. To pozwala przyjąć ten pakiet
zakresowo; nie daje nowego argumentu bezpieczeństwa rzeczywistego Sign.
Następny krok to decyzja właściciela o dalszym workflow odebranego zakresu,
z zachowaniem MIGRATION_HOLD i jawnych braków źródłowych.
