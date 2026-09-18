# FT1536 — przekazanie wyniku odbioru Blue do GPT-ASTRA

Data: 2026-09-18. Nota po zakończeniu niezależnego odbioru.

## Karta dla autora

- **Cel:** utrwalić potwierdzenie wyniku Astry i wskazać jeden kolejny krok.
- **Po co teraz:** Blue zakończył odbiór; można kontynuować badania z Astrą.
- **Wejścia:** zamrożone RUN_001 i ODBIOR_BLUE_001, tylko do odczytu.
- **Zapis tej czynności:** wyłącznie niniejsza nowa nota w Dokumenty.
- **Wynik:** potwierdzone piny, zakres wniosku i rekomendacja matematyczna.
- **Warunek końca:** przekazanie noty. Kolejnego zadania obliczeniowego ani
  poprawki implementacji jeszcze nie rozpoczęto.

## 1. Stan po odbiorze

GPT-ASTRA uzyskał `COUNTEREXAMPLE_REQUIRED_DOMAIN`.
Codex / Daybreak Blue-latest zakończył niezależny odbiór wynikiem
**`CONFIRMED_COUNTEREXAMPLE_REQUIRED_DOMAIN`**.

Rozstrzygnięta jest fałszywość konkretnej implikacji L_V-STATIC dla
`Ext0(h,c,b)=(center_q(c-h*s(b)),s(b))` i ustalonego modelu
S17 / GCC 14.2.0 / C99 / Linux x86_64 LP64. Jest to wynik matematyczny
powiązany z konkretnym wykonaniem źródeł, nie owner acceptance projektu.

Odbiór Blue jest zakończony. Zapisy w wcześniejszych instrukcjach o odbiorze
„do wykonania” opisują etap startowy; nie są powodem jego ponownego uruchomienia.

## 2. Zamrożone kotwice

```text
R = /home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001
D = /home/footfalcon/Dokumenty/FT1536_LV_STATIC_ODBIOR_BLUE_001

R/REPORT.md
c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd

R/OUTPUTS.sha256
0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87

D/DAYBREAK_REVIEW.md
d9f9559ffe29b84504a7ff58da88b419b0070b24fc101665bc49459605ef24cc

D/OUTPUTS.sha256
281d10aa5071b13a05c6178380909f55743da33469330a6d7463dd5517424771

D/DAYBREAK_RESULT.json
fb28cfd25053a109414b620c4f89d22820e05c68b1845f215ac0852545b09aab
```

Właściwa baza nadal jest historycznym S17:

```text
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
S17 = H/build
commit = d641ab1037c2fa1dd4a22c258854d79d67b9b46b
manifest = evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256
manifest SHA-256 = 03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
```

## 3. Kontrola po otrzymaniu raportu Blue

Wykonano odczytowe sprawdzenie integralności, niezależne od skryptów Blue:

- cztery piny raportów/manifestów R i D powyżej są zgodne;
- **98/98** wpisów `D/OUTPUTS.sha256` jest zgodnych;
- zakres manifestu dokładnie odpowiada `D/OUTPUT_SCOPE.md`;
- **37/37** wpisów `D/INPUTS.sha256` jest zgodnych, także wejścia zewnętrzne;
- brak duplikatów, niedozwolonych ścieżek i symlinków w sprawdzonym zakresie;
- `COMMANDS.frozen.log` ma **18688 bajtów i 18 rekordów**; żywy dziennik
  w chwili kontroli był identyczny;
- SHA-256 zamrożonego dziennika:
  `db64c14068c7925bfb9dc34b9fe314a3769f39f00e55c3c73d3bdca919cd1244`;
- dla 17 rekordów wykonania sprawdzono hashe obu strumieni; rekord 18 jest
  jawnie opisanym własnym wpisem finalizera bez procesu potomnego;
- jedyny niezerowy kod tych wykonań to udokumentowana awaria środowiskowa
  LeakSanitizera pod ptrace. Późniejszy przebieg ASan/UBSan ma exit 0.

Pierwsza próba kontrolera dziennika zatrzymała się na `KeyError: stdout`,
ponieważ zakładała strumienie również dla własnego wpisu finalizera. Po
odczytaniu tego rekordu zastosowano osobną, jawną kontrolę jego typu;
pełna kontrola zakończyła się poprawnie. Nie był to błąd obliczeń Blue.

Przejrzano raport, checkery Python/Sage, zapisane wyniki C, powiązanie
literałów Lean i wyjście `#print axioms`. Kontrola tej noty nie była kolejnym
uruchomieniem C, Sage lub Lean. Niezależne wykonania tych narzędzi wykonał Blue.
Jego audyt **170/170** artefaktów R jest częścią przypiętego raportu odbioru.

## 4. Co zostało rozstrzygnięte

Dla istniejącego publicznego h*, jawnego kanonicznego c i payloadu STATIC:

| Wielkość | Wartość |
|---|---:|
| `V_S17(h*,c,b)` | 1 |
| zdekodowane s | `(-20000,0,...,0)` |
| słowo wejścia NTT dla pierwszego współczynnika | 63969 |
| `63969 mod 18433` | 8670 |
| `(-20000) mod 18433` | 16866 |
| norma pary rzeczywiście sprawdzanej przez C | 400000000 |
| `B` | 2093922385 |
| `Q(Ext0)` | 43058711057 |
| `Q(Ext0)-B` | 40964788672 |

Kongruencja Ext0 zachodzi. Fałszywy jest wniosek o jego krótkości.
Jeden taki świadek wystarcza do obalenia uniwersalnej implikacji z tym Ext0.
Nie można kontynuować jej dowodzenia dla niezmienionego S17 tak, jakby nadal
była otwartą tezą oczekującą dodatniego dowodu.

Lean certyfikuje arytmetykę konkretnego świadka: 768 par A2 i 26 deklaracji,
ze standardowym `propext` w zależnych twierdzeniach. Nie formalizuje całego C
ani przynależności h do support KeyGen. Ta ostatnia korzysta z przypiętego
historycznego publicznego zapisu udanego KeyGen.

Wynik nie wyklucza innego ekstraktora, nie znajduje preimage HashToPoint i nie
stanowi efektywnego fałszerstwa EUF-CMA. Nie obala T2C3 ani T5; nie zastępuje
też brakującego pełnego dowodu bezpieczeństwa schematu.

## 5. Uwaga o wersji Sage

Blue faktycznie uruchomił:

```text
/home/footfalcon/.local/bin/sage checkers/independent_sage.py inputs
```

Checker używa `sage.all.GF` i `PolynomialRing`, czyli dokładnej arytmetyki
Sage. Pozostała drobna nieścisłość metadanych: pole `sage_version` w jego
JSON pochodzi z `sys.version` i opisuje Python 3.14.7. Osobny,
przypięty `TOOLCHAIN.txt` oraz `collect_toolchain.py` dokumentują Sage 10.9
na podstawie `sage --version`.

W nowych wynikach należy zapisywać `sage.version.version` jako wersję Sage
i `sys.version` jako wersję Pythona. Ta uwaga nie zmienia wartości obliczeń;
zamrożonego pakietu nie poprawia się w miejscu.

## 6. Jedna rekomendacja dla Astry

Rekomendacja powtarza merytoryczny następny krok z **§9 raportu Astry**:
osobny, związany z kodem kontrakt normalizacji zdekodowanego int16 przed NTT,
dla przyszłej, jawnie przypiętej wersji Verify.

Proponowane oznaczenie nowego obowiązku: **L_RHO**. Dla `q=18433`:

```text
forall x in [-32768,32767]:
    0 <= rho(x) < q
    rho(x) == x (mod q)
```

Zakres przyszłej pracy:

1. Podać dokładny kontrakt matematyczny i realizację słowową; dowieść zakresów
   wszystkich działań i zgodności C z rho, bez założenia centered s.
2. Zachować rzeczywisty zdekodowany s w normie. Zmiana reprezentacji jego
   reszty w mnożeniu modularnym nie uprawnia do podmiany s w Q.
3. Sprawdzać całą skończoną dziedzinę 65536 wartości jako kontrolę realizacji;
   formalny dowód ma jasno wskazywać, co sprawdza kernel i jakie przyjmuje
   przesłanki o słowach/C. Sam wykres lub losowy test nie zamyka obowiązku.
4. Zachować obecny kontrprzykład jako kontrolę regresyjną oraz sprawdzić
   zgodność na dziedzinie, w której stara mapa już zwracała canonical residue.
5. Wyliczyć pozostałe obowiązki dla pełnego L_V: zakresy i poprawność
   NTT/Montgomery, reprezentację pierwszego komponentu, znak i formę A2,
   dekodowanie pełnego języka oraz ścisły test `Q<B`.

**L_RHO samo nie dowodzi jeszcze pełnego L_V.** Każda zmiana Verify tworzy
nowego kandydata źródłowego z własnym hashem. S17 pozostaje referencją ujemnego
wyniku. Nie zmieniać N, q, Phi, B, Q, uczciwego COMP_STATIC ani kwantyfikatorów
w celu uzyskania dodatniego wyniku.

To propozycja osobnego zadania dla Astry, do decyzji użytkownika. Nie wdraża
poprawki i nie nadaje statusu dodatniego żadnemu nowemu lematowi.

## 7. Zachowanie kontekstu i następne uruchomienie

`/home/footfalcon/Dokumenty/AGENTS.md` jest obecnie przypiętym wejściem
odbioru Blue (pierwszy wpis jego INPUTS.sha256), z hashem:

```text
e5d9cc7b5120aad39da592f796eef44cc8a1c71bc6c43b311f48362d60fdd038
```

Aktualizacja stanu jest dlatego w tej oddzielnej nocie. Oryginalne instrukcje,
R i D pozostają wejściami historycznymi. Przed ewentualnym uruchomieniem
L_RHO potrzebne jest osobne zlecenie z własnym nowym katalogiem pracy
i lokalnym AGENTS.md wskazującym aktualny etap. Nie używać R ani D jako
katalogu zapisu następnej pracy i nie uruchamiać ich finalizerów ponownie.

Przekazanie do Astry powinno zaczynać się od tej noty i obu przypiętych
raportów, a nie od historycznego promptu ponawiającego L_V-STATIC lub odbiór Blue.
