# FT1536 — weryfikacja istniejącego uzasadnienia kanonicznego D11E2

Data: 2026-09-17. Zakres: jedna instancja fixed-key, publiczne materiały i obliczenia w pamięci. Repozytoria i historyczne artefakty tylko do odczytu.

## 1. Rozstrzygnięcie

**Znaleziono istniejący argument graph-theta completion i all-frequency/all-alias Route C. Jego ogólna część poprawnie stosuje się do kanonicznej instancji K0 po użyciu jej endpointów D7, a nie liczb poprzedniego klucza.** Zasadniczy most, którego dotyczyło G1, nie wymaga nowego odkrycia matematycznego.

Najtrafniejsza z kategorii podanych w zleceniu brzmi:

> **Argument istnieje, ale wymaga jawnego powiązania/redakcji dokumentacji.**

Ogólny wywód znajduje się przede wszystkim w §2–§3 oraz §5–§8 starszego publicznego dokumentu `HIST` zdefiniowanego poniżej. Jego uzasadnienie można powiązać z przypiętymi A, B, C3, D3, D7, D9, D10, D11D1, foundation i D5. Kanoniczne `E` zawiera właściwe nowe endpointy, rachunki i wynik. Nie wolno jednak przepisać całego starego twierdzenia wraz ze starym kluczem, stałymi `63.5`, `9860` i dawnymi targetami.

W szczególności:

- **7/7 pinów z promptu** oraz **28/28 bezpośrednich wiązań checkera E** zgadza się z plikami.
- Tożsamość PK/h, endpointu D7 i zapisanych commitmentów redukcji jest zgodna z K0.
- **147 kontroli dokładnych** w niezależnym kodzie Python/Fraction przeszło; **33/33 obwiednie tekstowe binów** zawierają dokładnie odtworzone wartości wymierne.
- Argument z dopełnieniem kwadratu nie utożsamia pointwise LDL z coefficient-basis Gram–Schmidt. Sumuje po oryginalnej kracie współczynników i używa maksimum przesuniętej theta.
- Końcowa droga daje, przy jawnych przypiętych przesłankach D7/D9/D11D1, `mean_E<2^-79`, `K_D3<2^-20`, `T_h<2^-99` dla tej jednej instancji.
- Nie znaleziono kontrprzykładu ani określonego błędnego kroku, który unieważniałby ten kanoniczny bound. Dwa krótkie rozwinięcia redakcyjne — krok centralny i własność końców binów — zapisano jawnie i odróżniono od tekstu historycznego.
- Późniejsze doprecyzowanie potwierdziło osobny **D11E1 V2**, nie „D11E2 V2”. Naprawa normalizacji D11E1 nie zmienia matematycznych wejść badanego D11E2; jej graf wiąże dokładnie ten sam verifier. Szczegóły i ograniczenia statusu V2 podano w §2.2 oraz kontroli A3.

**Korekta interpretacji wcześniejszego G1:** brak osobnego pliku z pełnym mostem w katalogu kanonicznego E nie oznacza braku ogólnego argumentu w zachowanych materiałach. Starszy dokument nie jest wykluczony matematycznie przez etykietę `comparison-only`. Etykieta ta opisuje deklarowaną proweniencję/historyczną konsumpcję. Nie zamienia poprawnego ogólnego wywodu w nieużywalną matematykę. Niniejszy raport wskazuje jego zastosowanie do K0 bez importu dawnych danych instancji.

Nie przypisuję własnych rozwinięć historycznym recenzentom i nie zmieniam zapisanych werdyktów ani statusów.

## 2. Korzenie, wersja i granice odczytu

```text
H = /media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon
F = H/evidence/candidates/framework_d641
E = F/T2C3-REVALIDATE-D11E2-001-20260822-a1-CANONICAL
D7 = F/T2C3-REVALIDATE-D7-001-20260820-a5-CANONICAL-ENDPOINT
FC = F/T2C3-CANONICAL-FINAL-COMPOSITION-001-20260822-a1
K = F/T2C3-CANONICAL-KEYGEN-001-20260819-a1
RD = F/T2C3-CANONICAL-NTRU-COMPANION-REDUCTION-DEFINITION-001-20260819-a1
D5 = F/T2C3-REVALIDATE-D5-001-20260820-a2-CANONICAL
AP = F/T2C3-CANONICAL-REDUCED-COMPANION-APPLICATION-001-20260820-a2
V2 = H/evidence/candidates/d11e1_v2/D11E1_V2
DOC = /home/footfalcon/Dokumenty
G = obiekty Git repozytorium H, commit d641ab1037c2fa1dd4a22c258854d79d67b9b46b
```

`G:<path>` oznacza odczyt obiektu z tego commita przez `git show`, po sprawdzeniu trybu obiektu `100644`/`100755`. Odczyty plików sprawdzały wszystkie komponenty ścieżki i odrzucały symlinki, `.private` oraz `private_extraction` przed odczytem.

**FD**:

```text
G:evidence/_work/T2C3-CANONICAL-FIXED-KEY-FOUNDATION-001-20260819-a2/THEOREM.md
SHA-256: c2ec9a1110c2837e8f9789197063bcf8748e5f84c0f8ad1ef0abdedf2fc35142
```

**HIST** — jedna ścieżka, poniżej złamana tylko dla czytelności:

```text
G:source_of_truth/v2.3/Results/T2C3-DISCRETE-TAIL-IMAGE-ENERGY-001/
Stages/T2C3D11E2_FINAL_GLOBAL_L2_CLOSURE_20260813/
T2C3-D11E2-FINAL-GLOBAL-L2-CLOSURE-001.md
SHA-256: 13091d1425684fcaa30684ee1d18d434ab607080564fc48b7ce1a0504c3e0ab8
```

Lista 65 odczytanych lub zahashowanych węzłów wejściowych jest w aneksie B: 61 ścieżek plikowych i 4 odczyty obiektów Git. Pierwotny zakres A1 obejmował 53 węzły; doprecyzowanie D11E1 V2 dodało 12. Część pomocniczych certyfikatów A/B/C3/D3/D11D1/D11E1 została tylko zahashowana jako przypięte wejście, bez powtórzenia ich producentów. Nie wykonano pełnej weryfikacji całego drzewa wszystkich historycznych pakietów.

Nie czytano katalogów `private_extraction`, prywatnych kluczy, seedów ani surowych prywatnych współczynników. Nie uruchamiano historycznego kodu wykonawczego. Publiczny `E/PRIVATE_ENDPOINT_REPLAY.json` jest metadanymi zachowanego wykonania, nie prywatnym replayem tej sesji. Jedynym nowym trwałym plikiem jest niniejszy raport.

### 2.1. Właściwa wersja i późniejsze dopuszczenie

`E/output_hashes.sha256` ma hash:

```text
45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76
```

Jego bajty są takie same lokalnie, w integracji `b478ba359cfea7b18243c95a9705351491bb167b` i w `G`. Kanoniczny checker ma hash `36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059`, a wynik publiczny `7cfc366d65415711c67486d82de21cb6b2d8e76a577935e11128324d5a2c1538`.

`FC/D11E2_REVIEW_ASSERTIONS.json`, SHA-256 `79c6d77048bfc11565ced298d203054b39b8c90fc8f535170f9df93021e59c15`, wiąże ten sam manifest z:

- `T2C3-D11E2-IMPL-A1-20260821T232439Z-45429B457E21` — `ACCEPT`;
- `T2C3-D11E2-MATH-A1-20260821T234300Z-45429B457E21` — `ACCEPT`.

Oba mają `artifact_persisted=false`, `artifact_path=null`, `artifact_sha256=null`. Zachowano zarówno fakt historycznych assertions, jak i brak pierwotnych raportów. `PENDING_REVIEW` w niezmienionym `E/report.md` jest stanem wykonawcy; nie anuluje późniejszego rekordu dopuszczenia. Bieżąca ocena matematyczna nie została wyprowadzona z etykiety ACCEPT. W tej sesji nie powtarzano kryptograficznej weryfikacji podpisów commitów; porównano wskazane obiekty i plik assertions.

### 2.2. Uzupełnienie właściciela: D11E1 V2 nie jest nową wersją D11E2

W trakcie zadania odczytano doprecyzowanie `DOC/FT1536_DOPRECYZOWANIE_D11E1_V2_D11E2_2026-09-17.md`, SHA-256 `841dc66be889e729087bbdc185492a990973cf4f93d80b361ce7a26099af01e3`. Zachowano ten sam wynikowy plik i odczytowy zakres zadania.

| Właściwość | Osobna naprawa D11E1 V2 | Badany kanoniczny D11E2 |
|---|---|---|
| Korzeń | `V2 = H/evidence/candidates/d11e1_v2/D11E1_V2` | `E` z §2 |
| Tożsamość w treści | `D11E1 V2 normalized public-profile composition theorem`; task `T2C3-REVALIDATE-D11E1-002`, run `20260822-a2-NORMALIZATION-REPAIR` | `D11E2 canonical global L2/tail candidate`; task `T2C3-REVALIDATE-D11E2-001` |
| Manifest | `V2/SHA256SUMS` — `15d1e81b2705e24be7143a5d3859dabf0b0dd5aeaf43fcca559c0679b5bdadaa`, 20 wpisów | `E/output_hashes.sha256` — `45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76` |
| Dokładny zakres | Raw counts → znormalizowany profil; poprawny q-local upper; częściowa kompozycja near/far | Pełne all-frequency/all-alias L2, kontur i bound T_h dla K0 |
| Stan V2 / wykonawcy | `PROVED_CANDIDATE_PENDING_DUAL_REVIEW` w README, THEOREM i STATUS | `PENDING_REVIEW` wykonawcy; późniejsze oba ACCEPT zapisane w FC, jak w §2.1 |
| Skutek dla drugiego pakietu | Deklaruje brak zmiany bajtów D11E2 i brak powtórzenia jego replayu | Nadal ten sam verifier `36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059` |

Sprawdzono 3/3 piny przekazane w uzupełnieniu oraz 10/10 wybranych członków manifestu V2. Nie deklaruję wykonania jego historycznej walidacji ani sprawdzenia wszystkich 20 wpisów. Pierwotne akceptacje D11E1 V1 **nie są przeniesione na V2**: `LEGACY_DISPOSITION.json` mówi `legacy_accepts_carried_to_v2=false`, a V2 oczekuje świeżych recenzji. Jego deklaracje `REJECTED_AS_WRITTEN` / `SUPERSEDED_BY_D11E1_REPAIRED` odnoszą się do D11E1 V1; nie zmieniałem żadnego historycznego statusu.

#### Co naprawia V2

`V2/DERIVATION_NORMALIZATION.md`, SHA-256 `6b93f5c8e00ade3bf166c7092555bbbf6e641e5481db8500dbd8dc67b97fe83d`, rozdziela surowy błąd e_c od błędu profilu po normalizacji. Przy rzeczywistych licznościach `N_c=A_raw(1+e_c)`, `|e_c|<=delta<1`, `mu=mean(e_c)`:

\[
P_c=M^{-1}\left(1+\frac{e_c-\mu}{1+\mu}\right),\qquad
E=M\sum_cP_c^2-1=\frac{\operatorname{Var}(e)}{(1+\mu)^2}
\le\frac{\delta^2}{1-\delta^2}.
\]

Ogólny lemat dla już znormalizowanego, zero-mean błędu nie jest tym samym co przejście od surowych liczności. Właśnie identyfikację tych obiektów naprawia V2. Dla dokładnego `delta_q=18432/18433^768` oznaczam **górną obwiednię**, nie rzeczywistą energię, przez

\[
U_q=\frac{\delta_q^2}{1-\delta_q^2}.
\]

Kontrola A3 w pamięci potwierdziła `2^-21737<Uq<2^-21736` oraz `Uq+2^-133+2^-66<2^-65`. Nierówność dolna dotyczy Uq; nie dowodzi dolnego boundu dla rzeczywistego E_q. Przesłanki near-minor i far pozostają jawnie importowanymi interfejsami. V2 wyłącza ze swojego wyniku selected-major, D11E2, końcową kompozycję T2C3, T5, R5 i bezpieczeństwo schematu.

#### Rzeczywista relacja do D11E2

`V2/DEPENDENCY_GRAPH_CORRECTION.json`, SHA-256 `02f761d77528c201a5de3df5051ca6cb3fd3c808aaffdf8811e51bfe45ac233a`, przypina ten sam verifier E i klasyfikuje krawędź jako `PROVENANCE_ONLY_NON_GOVERNING`, `mathematical_consumption=false`.

Sprawdzono to w kodzie: dokładnie trzy historyczne pliki `inputs/d11e1/{THEOREM.md,d11e1_certificate.json,output_hashes.sha256}` przechodzą hash gate; nie są parsowane jako dane liczbowe. Nie ma konsumpcji pól `q_energy`, `E_q`, `closed_upper`, `q_local_energy_lt`, `combined_energy_lt`. Jawni konsumenci JSON pozostają D7, D9 i D10; D11D1 jest interfejsem matematycznym near-minor.

Nie jest to tylko argument z kolejności nazw: odtworzona w §5–§9 globalna droga E używa dokładnej partycji częstotliwości/cosetów i zachowuje własny normalizator theta. Nie używa surowych q-local liczności D11E1 jako już znormalizowanych prawdopodobieństw. Błąd V1 nie przechodzi więc na E przez samo przypięcie hasha lub sąsiedztwo w kolejce.

W sprawdzonych, jawnie dozwolonych materiałach potwierdzono te dwa różne pakiety. **Nie zidentyfikowano tu osobnego pakietu deklarującego się jako D11E2 V2**; nie jest to twierdzenie o braku innych kopii poza zakresem zadania. Pole `integration_action` w correction JSON potraktowano jako treść artefaktu, nie polecenie zmiany rejestru.

## 3. Instancja i jednoznaczna notacja

### 3.1. K0

| Obiekt | Tożsamość |
|---|---|
| Base wygenerowania klucza | `8ffa1e011577cd877074888b8650ed521f8bb289` — identyfikator z publicznej linii KeyGen, nie commit nowego wykonania |
| Publiczny PK | `57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f` — sprawdzono publiczne bajty |
| Publiczne h | `ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2` — sprawdzono publiczne bajty |
| Commitment T | `9135c32e42dcff7d70c9e0f8f72eec8769e4f52d61d74c0cc38eb04dbf0de2c2` — porównano wyłącznie publiczne metadane |
| Commitment (F',G') | `80c6cb150959a80b89f50f9303af89e255f2354900e10cbf7cd1e6aa4a5580f2` — porównano wyłącznie publiczne metadane |
| Endpoint D7 | `d44d47fb0d12d4df5a5373af72fffecf93b9d78f249232c96be76bd857fa3b1d` — odtworzono hash kanonicznego obiektu JSON |

`E/PUBLIC_BINDINGS.json` i `D7/inputs/a3/canonical_endpoint_certificate.json` mają zgodne PK/h oraz zapisany commitment prywatnego klucza. Ta zgodność nie jest ponowną walidacją prywatnych współczynników.

### 3.2. Symbole

```text
N = 1536; d = 2N = 3072; m = N/2 = 768; q = 18433
R = Z[x]/(x^1536-x^768+1)
sigma = 768; B = 2093922385
beta = N/B; a0 = 1/(2*sigma^2); theta = a0-beta
E_comp = Q(F',G') = 448642
A_ratio = a0/beta = 2093922385/1811939328
epsilon = 7/100
A_min = (1-epsilon)*A_ratio = 12982318787/12079595520
ell = 113; u = 9923
```

`E_comp` odpowiada `A0` w dokumentach redukcji. `A_ratio` odpowiada `A0` w `verify_d11e2.sage`. `E_comp` **nie jest** używane jako `A_ratio` ani jako endpoint spektrum. W części konturowej używam `v` dla drugiej współrzędnej NTRU, żeby nie mylić jej z kątem konturu `t`.

Metryka współczynnikowa:

\[
P_0=\begin{pmatrix}I_m&I_m/2\\I_m/2&I_m\end{pmatrix},\quad
Q_0(a)=a^TP_0a,\quad M=\operatorname{diag}(P_0,P_0),\quad Q(z)=z^TMz.
\]

Kolejność to naturalne współczynniki każdego wielomianu, a pary A2 to `(i,i+768)`. Pełne `Q` ma **1536 bloków A2**; pojedyncze `Q0` ma **768 bloków A2**. Macierz pojedynczego bloku to `P2=[[1,1/2],[1/2,1]]`.

Mapa publiczna z C3 to `A_h=[I_N|H_h]` i częstotliwość `xi_u=-(u_tilde,H_h^T u_tilde)/q`. Krata `Lambda_h=ker(A_h mod q)` ma indeks `q^N` w `Z^d`; jej `Lambda_h*` poniżej jest dualną kratą względem standardowego iloczynu współrzędnych. Osobno stosowana metryka dualna to `Q*(w)=w^T M^-1 w`.

Żeby uniknąć dwuznaczności parametrów theta, definiuję:

\[
\vartheta(x)=\sum_{a,b\in\mathbb Z}e^{-x(a^2+ab+b^2)},\qquad
\mathcal R_L(s)=\sum_{w\in L}e^{-\pi s^2Q^*(w)}.
\]

`R_L(s)` odpowiada efektywnej konwencji rho w cytowanych dualnych formułach; nie należy odwracać parametru `s`. `Theta_A2(e^-x)` w HIST to `vartheta(x)` tutaj.

## 4. Znaleziony argument graf → Schur → theta

### 4.1. Co istnieje w źródłach

- **HIST §2** już zapisuje completion of squares przy ustalonej drugiej współrzędnej, uogólnione wartości własne `lambda_j`, Schur `q²/lambda_j` i shifted-theta maximum.
- **FD §2–§3** wiąże właściwy dodatni graf, mapę Frobeniusa, metrykę i surową bazę z K0.
- **D5/THEOREM.md, §Integral graph coordinates** podaje dokładną bijekcję dla `(F',G')` i całkowitą zmianę `r -> r+vT`.
- **D7/CANONICAL_ENDPOINT_INTERFACE_THEOREM.md** wiąże spektrum `|f(zeta)|²+|g(zeta)|²` z kanoniczną metryką bez dodatkowej skali.
- **E/DERIVATION_PRE_HISTORY.md §2** wybiera właściwe endpointy i jawnie zakazuje utożsamienia pointwise LDL z coefficient-basis GS.

Poniższe równania są **moją jawną notacją i rozwinięciem istniejącego argumentu**, nie nowym wynikiem przypisywanym historycznemu autorowi.

### 4.2. Operator, metryka i transport spektralny

Niech `L_p` oznacza rzeczywistą macierz mnożenia przez `p` w naturalnej bazie potęgowej. Dodatnia uporządkowana baza grafu to

\[
\mathcal B=\begin{pmatrix}L_f&L_{F'}\\L_g&L_{G'}\end{pmatrix},\qquad
\mathcal B^TM\mathcal B=\begin{pmatrix}K&C\\C^T&D\end{pmatrix}.
\]

W szczególności `K=L_f^T P0 L_f+L_g^T P0 L_g`, a `S=D-C^T K^-1 C` jest rzeczywistym dodatnim dopełnieniem Schura. Dla ustalonego całkowitego `v`:

\[
Q(S'(r,v))=(r+K^{-1}Cv)^TK(r+K^{-1}Cv)+v^TSv. \tag{1}
\]

Normalizacja śladowa to

\[
Q_0(p)=\frac1N\sum_{\zeta\text{ primitive }4608}|p(\zeta)|^2.
\]

Można ją sprawdzić bez prywatnych współczynników: znormalizowane sumy pierwotnych potęg w zakresie różnic współczynników `-(N-1)..N-1` są 1 przy różnicy 0, 1/2 przy ±768 i 0 poza nimi. Daje to dokładnie `P0`, z dodatnim wyrazem mieszanym A2.

W tej izometrii operator `P0^-1 K` ma wartości własne `lambda_j=|f(zeta_j)|²+|g(zeta_j)|²`. W każdym osadzeniu dokładna tożsamość Lagrange'a daje

\[
(|f|^2+|g|^2)(|F'|^2+|G'|^2)-|\overline fF'+\overline gG'|^2
=|fG'-gF'|^2=q^2.
\]

Stąd wartości własne `P0^-1 S` to `q²/lambda_j`. Nie są to długości GS dowolnie uporządkowanej bazy współczynnikowej. Są to uogólnione wartości własne dwóch dokładnie wskazanych form względem `P0`.

Z endpointów K0:

\[
\ell P_0\prec K\prec uP_0,\qquad
\frac{q^2}{u}P_0\prec S\prec\frac{q^2}{\ell}P_0,
\quad \ell=113,\ u=9923. \tag{2}
\]

### 4.3. Całkowita zmiana bazy i rzeczywiste przesunięcie mają różne role

Redukcja daje `F'=F-Tf`, `G'=G-Tg`, `T in R`, więc

\[
S_{F,G}(r,v)=S_{F',G'}(r+vT,v).
\]

Mnożenie przez T ma całkowitą macierz, ponieważ Phi jest moniczny. Jest to unipotentna bijekcja `Z^(2N)`, zachowująca wszystkie wektory i ich krotności.

Natomiast `eta_v=K^-1 Cv` z (1) jest na ogół **rzeczywiste, niecałkowite**. Nie zmieniam zmiennej sumowania na nową kratę całkowitą. Dla dowolnej dodatniej formy K Poisson daje theta z przesunięciem jako szereg cosinusowy o nieujemnych współczynnikach, zatem

\[
\sum_{r\in\mathbb Z^N}e^{-\alpha(r+\eta)^TK(r+\eta)}
\le\sum_{r\in\mathbb Z^N}e^{-\alpha r^TKr}.
\]

Po zastosowaniu przy każdym v i następnie (2):

\[
\sum_{(a,b)\in\Gamma_h}e^{-\alpha Q(a,b)}
\le\Theta_K(\alpha)\Theta_S(\alpha)
\le\vartheta(\ell\alpha)^{N/2}
   \vartheta((q^2/u)\alpha)^{N/2}. \tag{3}
\]

To jest dokładnie ogólny krok HIST §2, z kanonicznymi `113,9923`. Nie wymaga, żeby reduced companion był globalnym minimum ani żeby `eta_v` było całkowite. Surowa wierszowa baza signera `[[g,-f],[G,-F]]` nie jest tu utożsamiana literalnie z dodatnią bazą grafu.

## 5. Wszystkie częstotliwości i aliasy — właściwy lemat dla checkera

### 5.1. Istniejące źródła i zakres denominatorów

**HIST §3** podaje dokładną mapę aliasów i wynik globalnej agregacji. **A/THEOREM.md** dowodzi dla każdego `c>=1`, także złożonego i podzielnego przez 3:

\[
|G_{a,c}(m)|\le\sqrt{d_c}/c,\qquad d_c=\gcd(c,3).
\]

**B/THEOREM.md §2** zawiera dowód przez rozkład na klasy `r+cZ²` i Poissona:

\[
\vartheta_\xi(\beta-it)=\frac{2\pi}{\sqrt3(\beta-i\tau)}
\sum_{m\in\mathbb Z^2}G_{a,c}(m)
\exp\!\left[-\frac{\pi^2}{\beta-i\tau}Q_2^*(m/c-\xi)\right]. \tag{4}
\]

Choć otaczająca specyfikacja lokalnych otoczeń B wymienia `2<=c<=64`, **sam dowód tożsamości (4) nie używa ograniczenia 64**. Rozkład na klasy i Poisson działają dla każdego dodatniego c, `Re(beta-i tau)>0`. W E potrzebne są tożsamość (4) dla `c<=1000` oraz all-modulus bound A, a nie numeryczny remainder B ograniczony do 64. To jawne zastosowanie istniejącego algebraicznego dowodu, nie ekstrapolacja dawnych testów numerycznych. Dla `c=1` wybiera się centrum 0 modulo `2pi`, a lokalny Gauss factor wynosi 1.

**C3/THEOREM.md §1–§4** ustala naturalny porządek, znaki xi i dokładne 1536-blokowe mnożenie przy jednym wspólnym t. Nie potrzeba probabilistycznej niezależności.

### 5.2. Partycja cosetów i normalizator

Niech

\[
t=2\pi a/c+\tau,\quad A=1+(\tau/\beta)^2,\quad X=K^2=c^2A,
\qquad t_0^2=\pi/\beta.
\]

Ponieważ `[I|H_h]` jest surjekcją, `Lambda_h*/Z^d` ma dokładnie `q^N` klas reprezentowanych przez `xi_u`. Ponieważ `c<=1000<q=18433` i q jest pierwsze, mnożenie przez c permutuje te klasy. Dlatego

\[
(u,m)\longmapsto w=m-c\xi_u
\]

jest bijekcją całego `((Z/qZ)^N) × Z^d` na `Lambda_h*`. Dla dwóch aliasów przy tym samym u ich różnica `z=m-m'` jest całkowita. Para `(w,z)` odtwarza `(u,m,m')` jednoznacznie. Żaden punkt nie jest policzony `q^N` razy.

Poisson dla normalizatora pełnej metryki daje dokładnie

\[
\Theta_0(\beta)=\left(\frac{2\pi}{\sqrt3\beta}\right)^N
\mathcal R_{\mathbb Z^d}(t_0).
\]

Po wzięciu modułów lokalnych Gauss factors i rzeczywistej części wykładnika (4), a następnie rozwinięciu dodatniego kwadratu, pojawia się

\[
Q^*(w)+Q^*(w-z)=2Q^*(w-z/2)+\tfrac12Q^*(z).
\]

Shifted-theta maximum na **całej** `Lambda_h*` obsługuje przesunięcie `z/2`, nawet jeśli nie należy ono do kraty. Otrzymujemy lemat HIST §3 w pełnej normalizacji:

\[
\boxed{
\sum_u|F_u(t)|^2\le
\left(\frac{d_c}{X}\right)^N
\frac{\mathcal R_{\mathbb Z^d}(t_0/\sqrt{2X})
      \mathcal R_{\Lambda_h^*}(\sqrt{2/X}\,t_0)}
     {\mathcal R_{\mathbb Z^d}(t_0)^2}.
} \tag{5}
\]

Mianownik jest co najmniej 1 i można go bezpiecznie opuścić w górnej granicy. To rozlicza również normalizację kompleksowego prefaktora, `c^-2` w każdym lokalnym Gauss sum i wszystkie krotności. W alternatywnej drodze przez ortogonalność znaków pojawia się `q^N` i znika przy Poissonie na jądrze o indeksie `q^N`; nie wolno dopisać go po prawej stronie (5).

Suma w (5) **zawiera u=0**. Dla moderate, large i near-minor używamy bezpiecznie `E(t)=sum_(u!=0)|F_u|² <= sum_u|F_u|²`. Nie odejmujemy arbitralnie jedynki. Osobna kontrola centralna w §8 zachowuje wykluczenie klasy zerowej.

### 5.3. Frobenius i przejście do graph theta

FD podaje `w=mathcal J(a,b)/q` oraz

\[
Q^*(w)=\frac4{3q^2}Q(a,b),\qquad (a,b)\in\Gamma_h.
\]

Wobec tego drugi czynnik (5) ma wykładnik

\[
\alpha(X)=\frac{8\pi^2}{3q^2\beta X}=\frac{\gamma_0}{X}.
\]

Ambient factor rozkłada się na N bloków:

\[
\mathcal R_{\mathbb Z^d}(t_0/\sqrt{2X})
=\vartheta\!\left(\frac{2\pi^2}{3\beta X}\right)^N.
\]

Tu użyto `Q2*(a,b)=(4/3)(a²-ab+b²)` i bijekcji `b -> -b`. Nie podmieniono dodatniej metryki A2 na metrykę współrzędnych euklidesowych ani nie zmieniono skali q.

## 6. Dlaczego dokładnie `b2=(dc*AMB/lo)^2*theta1*theta2`

Niech `X in [lo,hi)` będzie jednym z 33 binów. Wartości `theta1`, `theta2` są poprawnymi górnymi granicami odpowiednio

\[
\vartheta(\gamma_0\ell/X),\qquad
\vartheta(\gamma_0(q^2/u)/X).
\]

Z (3), (5) oraz ambient boundu `AMB=33/32`:

\[
\sum_u|F_u|^2
\le\left(\frac{d_c AMB}{X}\right)^N
        (theta1\,theta2)^{N/2}
\le\left[\left(\frac{dc\,AMB}{lo}\right)^2theta1\,theta2\right]^{768}. \tag{6}
\]

`dc` jest bezpieczną górną granicą `gcd(c,3)`, a `N/2=768`. Nie jest to zmniejszenie liczby bloków pełnej metryki z 1536 do 768; potęga wynika z dwóch form r/v o randze N każda.

### 6.1. Direct/Poisson i kierunki

Istniejące HIST §5–§6 używa dodatniego shell boundu i Poissona. Dla `x>0`:

\[
\vartheta(x)\le1+\frac{6e^{-x}}{(1-e^{-x})^2},\qquad
\vartheta(x)=\frac{2\pi}{\sqrt3x}\vartheta\!\left(\frac{4\pi^2}{3x}\right). \tag{7}
\]

Pierwszą nierówność daje `r_A2(n)<=6n`. Krótkie elementarne sprawdzenie: dla `a²+ab+b²=n>=1`, `3a²<=4n`, zatem całkowite a spełnia `|a|<=n`; dla każdego a są co najwyżej dwa b. Stąd `r(n)<=4n+2<=6n`. Druga równość wynika z dwuwymiarowego Poissona, `det(P2)=3/4` oraz wspomnianej zmiany znaku b.

W checkerze:

- Direct używa **hi** w mianowniku argumentu: mniejszy argument theta daje większy upper.
- Poisson używa **lo** w rosnącym argumencie theta po transformacji oraz **hi** w rosnącym prefaktorze.
- Dla formy K argument po transformacji to `q² beta lo/(2 ell)`; dla S jest to `u beta lo/2`.
- `m=floor(exponent_lower/LN2_UP)` i `LN2_UP=347/500>ln(2)` dają `exp(-exponent)<2^-m` dla przyjętych `m>=1`.
- Minimum dwóch już poprawnych upper bounds nadal jest upper boundem. Nie jest to wybór pomiaru korzystnego dla klucza.

Przekład na kod to `direct_theta`, `poisson_theta_1/2`, `best_theta` i linie 216–235 checkera. Wszystkie 33 biny mają `b2<17/20`, a dokładna arytmetyka daje `(17/20)^768<2^-180`.

### 6.2. Punkt X=9

Przy `X<9` nie może być `3|c`, bo `X=c²A>=c²`. Przy `X>=9` płaci się `dc=3`. Dlatego należy czytać bin kończący się na 9 jako **[6,9)**, a punkt `c=3,tau=0,X=9` należy do **[9,10)** z `dc=3`. Jest to literalna granica HIST §5 i poprawna partycja danych checkera. W kodzie nie ma jawnego pola otwartości końca, więc jest to doprecyzowanie dokumentacji.

Nie twierdzę, że `dc=1` byłoby poprawne dla c=3 na zamkniętym [6,9]. Kontrola A2 wyznacza właściwego właściciela punktu: bin o indeksie 9, `dc=3`. W ten sposób nie ma luki pokrycia ani potrzeby zmiany certyfikatu liczbowego.

## 7. Large range i wyznaczniki

**HIST §6** stosuje Poissona do rzeczywistych form K i S, nie do fikcyjnej bazy GS. Z dokładnej NTRU bijekcji:

\[
|\det\mathcal B|=q^N,\quad
\det K\det S=q^{2N}(\det P_0)^2,\quad
\det P_0=(3/4)^{768}. \tag{8}
\]

Dwukrotny Poisson daje dla produktu theta prefaktor

\[
\frac{(\pi/\alpha)^N}{\sqrt{\det K\det S}}
=\left(\frac{\sqrt3q\beta X}{4\pi}\right)^N.
\]

Czynnik `X^N` znika z zewnętrznym `X^-N` w (5). To jest pochodzenie `Cg=sqrt(3)*q*beta/(4*pi)` w checkerze. **Nie** zastępuje się prawdziwego iloczynu wyznaczników iloczynem dwóch konserwatywnych scalar floors `ell` i `q²/u`.

Z (2) wynika

\[
K^{-1}\succeq u^{-1}P_0^{-1},\qquad
S^{-1}\succeq (\ell/q^2)P_0^{-1}.
\]

Stąd argumenty odwrotnych theta to co najmniej

```text
yK = q² beta X/(2u)
yS = ell beta X/2.
```

Przy `X>=250000` każdy daje lokalny correction `<33/32`. Każda forma ma 768 bloków, więc ich łączny correction to `(33/32)^1536`, nie `(33/32)^3072`.

- Dla `250000<=X<9000000`, ambient theta `<13`; uzyskany exact upper bazy to `5867555694/77475128245 < 2/25`.
- Dla `X>=9000000`, Poisson ambient daje argument `2 beta X` i upper `vartheta(x_A)<X/2400000`; z globalnym Xmax baza wynosi `67412432304667969287100552297/373440662493458123980800000000 < 1/5`.

Obie potęgi do N są `<2^-180`. Są to istniejące kroki HIST §6, odtworzone z kanonicznymi endpointami i stałymi checkera, linie 237–260.

## 8. Pełne pokrycie, central i near-minor

### 8.1. Cover

HIST §4 i E używają `Q_D=1000`. Twierdzenie Dirichleta zapewnia dla każdego kąta modulo `2pi` jakiś zredukowany `a/c` taki, że

\[
1\le c\le1000,\qquad |\tau|\le\frac{2\pi}{1000c}.
\]

Nie trzeba zakładać jednoznaczności przybliżenia ani rozłączności wszystkich takich otoczeń. Ponieważ `c<q`, zachowana jest bijekcja częstotliwości. Ponadto

\[
X\le1000^2+\left(\frac{2\pi}{1000\beta}\right)^2
<\frac{896143129095640349689}{12050340249600}
<75000000.
\]

Dla `c>=2`: `X>=4>A_ratio`, więc obowiązuje outer. Dla `c=1`: centrum jest 0 modulo pełnego okręgu, a `X=A=1+(t/beta)²`; rozdzielają się central, near-minor i outer. Biny przyjmujemy lewostronnie domknięte i prawostronnie otwarte; punkt 250000 obsługuje large, a 9000000 large-high. Dowody upper bounds pozostają ważne także na potrzebnych wspólnych końcach.

### 8.2. Krok centralny — jawne krótkie rozwinięcie tej sesji

HIST §7 powołuje central good arc, a kod kanoniczny w liniach 262–271 zachowuje dodatkowy `R_epsilon` zamiast po prostu pisać `E(t)<tau2`. Poniższe rozwinięcie Cauchy'ego jest **nową analizą roboczą w tym raporcie**, nie cytatem ani odtworzoną treścią dawnej recenzji. Uzupełnia krótki zapis, korzystając z już istniejącego Poissona, shifted-theta maximum i D9.

Dla c=1, po normalizacji (4), niech `kappa=pi*t0²/A`. W klasie `L_u=Z^d-xi_u` zastosujmy ważoną nierówność Cauchy'ego:

\[
\left(\sum_{w\in L_u}e^{-\kappa Q^*(w)}\right)^2
\le
\left(\sum_{w\in L_u}e^{-2(1-\epsilon)\kappa Q^*(w)}\right)
\left(\sum_{w\in L_u}e^{-2\epsilon\kappa Q^*(w)}\right). \tag{9}
\]

Drugi czynnik jest co najwyżej theta `Z^d` bez przesunięcia. Sumowanie pierwszego tylko po `u!=0` obejmuje `Lambda_h*\Z^d`, nie klasę zerową; można je zwiększyć do `Lambda_h*\{0}`. Ponieważ

\[
A\le A_{\min}=(1-\epsilon)A_{ratio},\qquad
s_0^2=\pi/a_0,
\]

pierwszy czynnik po sumowaniu jest ograniczony przez `R_(Lambda_h*)(sqrt(2)*s0)-1 = tau2 < 2^-80` z D9. Prefaktor `A^-N` i odwrotność kwadratu normalizatora są co najwyżej 1.

Ponieważ `Q*(w)>=(2/3)||w||²`, pozostały ambient factor jest co najwyżej `theta3(exp(-4 epsilon pi²/(3 beta A)))^d`. Checker stosuje jeszcze luźniejszy exponent lower

```text
x_central = 2 epsilon PI_LO²/(3 beta A_min)
```

oraz większą potęgę `4N` zamiast wystarczającej `d=2N`. Obie zamiany powiększają upper i są bezpieczne. Z `x_central>100 ln2` i `theta3(e^-x)<=1+2e^-x/(1-e^-x)`:

\[
E(t)\le (1+2^{-98})^{4N}\tau_2
<\frac32\,2^{-80}<2^{-79}. \tag{10}
\]

Nie odjęto jedynki od boundu obejmującego wszystkie częstotliwości, nie przyjęto `F0(t)=1` i nie użyto skrótu `T_h<=tau2`.

### 8.3. Near-minor

`E/inputs/d11d1/THEOREM.md` zawiera istniejący pełny argument: przy `A<=A_ratio` dodatnie theta w (5), dla c=1, dominowane są przez skalę D9; przy `A>=A_min` mamy dokładnie

\[
A_{\min}=\frac{12982318787}{12079595520}>\frac{17}{16}.
\]

Stąd używając `2^134*16^1536<17^1536` otrzymuje się `sum_u|F_u|²<2^-133`. D11D1 korzysta z mocniejszego endpointu D9 `<2^-90`; jego luźniejsza konsekwencja `<2^-80` także wystarcza do pomocniczego oszacowania dodatniego produktu przez 2. Bieżąca sesja nie powtarza wcześniejszego producenta D9.

Tabela kompletnego pokrycia:

| Przypadek | Zakres | Bound |
|---|---|---|
| c=1, central | `1<=A<=A_min` | `<(3/2)2^-80<2^-79` |
| c=1, near-minor | `A_min<=A<=A_ratio` | `<2^-133` |
| dowolne c, moderate outer | `A_ratio<=X<250000` | `<2^-180` |
| dowolne c, large-mid | `250000<=X<9000000` | `<2^-180` |
| dowolne c, large-high | `9000000<=X<=Xmax<75000000` | `<2^-180` |

Jest to pointwise cover. Nie mnoży się boundu przez liczbę binów ani liczbę przybliżeń racjonalnych. Wspólny, ścisły upper jest mniejszy od `2^-79`, więc także znormalizowana średnia po okręgu jest `<2^-79`.

## 9. Prefaktor i T_h

Istniejące **D3 §D3-B** i **HIST §8** podają

\[
T_h\le K_{D3}\,mean_E,\qquad K_{D3}=\frac{C_*^2}{1-e^{-2\theta}}.
\]

Nie ma dodatkowego czynnika `q^N` po sumie częstotliwości. Dla `x=A_ratio-1>0`, `theta B=Nx`. Nierówność

\[
\log(1+x)\le x-\frac{x^2}{2(1+x)}
\]

oraz dokładnie sprawdzone `Nx²/(2A_ratio)>23 ln2` dają główny prefaktor `<2^-23`. Dodatnia poprawka Poissona spełnia `N delta<1/2`, więc `(1+delta)^N<=1/(1-N delta)<2`; stąd `C*<2^-22`.

Dalej, `theta>2^-24` oraz `0<2theta<1` implikują `1-e^-2theta>theta`. Zatem

\[
K_{D3}<2^{-44}\,2^{24}=2^{-20},\qquad
T_h<2^{-20}\,2^{-79}=2^{-99}.
\]

Wszystkie liczby rozstrzygające te nierówności w E sprawdzono dokładnie w A2. Twierdzenia transcendentalne są uzasadnione szeregami/nierównościami opisanymi tutaj i w źródłach; nie zastąpiono ich floatem o wysokiej precyzji. Dla stałych pi dodatkowo zastosowano w pamięci racjonalne obwiednie Machina; dla ln2 dodatnią sumę Taylora z oryginalnego argumentu checkera.

`D11E1` jest przypięty w `EXPECTED_SHA256`, ale parser AST pokazuje, że checker otwiera numerycznie tylko certyfikaty D7, D9 i D10. Jego globalny wynik nie jest dodaniem `E_closed` D11E1 do nowej liczby. Gałąź z Q_D=1000 daje samodzielne pełne pokrycie przy wskazanych ogólnych interfejsach.

## 10. Mapa przesłanka → źródło → konsument → zakres kontroli

Pełne hashe każdego wymienionego pliku są w aneksie B; poniższe hashe identyfikują główne artefakty, nie skróty.

| Krok / przesłanka | Dokładne źródło i SHA-256 | Lemat i konsument w E/scripts/verify_d11e2.sage | Zakres sprawdzenia / pozostały obowiązek |
|---|---|---|---|
| Uporządkowany graf, jego bijekcja i redukcja | `D5:THEOREM.md` — `b3a22eccbbd293bce97c03dcad285726009026899d12d1579fb893caf5983095`; `FD` — `c2ec9a1110c2837e8f9789197063bcf8748e5f84c0f8ad1ef0abdedf2fc35142` | S' i całkowite r+vT; podstawa linii 153–157 i 237–260 | Argument istnieje. Rozwinięto rozróżnienie realnego eta i całkowitego T. Nie odtwarzano prywatnej redukcji. |
| Endpoint/spektrum w tej metryce | `D7:CANONICAL_ENDPOINT_INTERFACE_THEOREM.md` — `93c9f610612dfbd2c243cc9d59f5cb48b8f559501490efcb9692b012dde01e2d`; `D7:inputs/a3/canonical_endpoint_certificate.json` — `fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d` | Linie 82–100, 153–177; kanoniczne ell/u i Schur | Racjonalne endpointy i tożsamość sprawdzone; ich prywatny producent pozostaje jawnym wejściem, nie nowym obliczeniem. |
| Shifted theta i graph-theta completion | `HIST` §2, §6 — `13091d1425684fcaa30684ee1d18d434ab607080564fc48b7ce1a0504c3e0ab8` | (1)–(3), (8); theta1/2 i Cg | Zidentyfikowano istniejący wywód, poprawnie podstawiono kanoniczne endpointy. W E brakuje zwięzłego jawnego odsyłacza do ogólnego argumentu; redakcja, nie brak GS-lematu. |
| Gauss i plus-phase coset Poisson | `E:inputs/a/THEOREM.md` — `27c4cdeb092eb01a649654c606ef93b54031c21d0dd3e7d2cc51ef52a4bb4cc8`; `E:inputs/b/THEOREM.md` — `4ed6753f563c03be562e0b8edf16df0eb49814b1e91dbc401d1ce99fa3270366` | (4), (5); linie 134, 217, 220 | All-modulus A istnieje; algebraiczny dowód B działa poza lokalnym zakresem 64. Nie importowano ograniczonych do 64 bounds reszty B. |
| Znaki, kolejność, 1536 czynników i normalizacja | `E:inputs/c3/THEOREM.md` — `3d36cbf12734902886472b45f81b9182de08b0f2af2015b38e1b879d045112b6` | xi, coset partition, Q*, (5); linie 153–235 | Rozliczono u=0, krotności i brak dodatkowego q^N. Jest to argument matematyczny, nie efekt boolowskich flags certyfikatu. |
| b2 i moderate | `HIST` §5 — hash wyżej; `E:scripts/verify_d11e2.sage` — `36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059` | Linie 137–235, wzór (6) | 33 exact bounds odtworzone; 33 tekstowe enclosures zgodne. X=9 przypisano do [9,10), dc=3. |
| Large determinant cancellation | `HIST` §6 — hash wyżej; FD i D5 | Linie 237–260 | Dokładny determinant actual K/S, nie iloczyn scalar floors. Sprawdzone racjonalne base_mid, base_high i potęgi. |
| Central, near-minor, complete cover | `E:inputs/d9/THEOREM.md` — `dae44634ccccc7d970fabf98edbbd459426aedafe0a106808bc904134459ef8e`; `E:inputs/d11d1/THEOREM.md` — `c451ca664417fceb9eddcbe1baa743301b9980a62996fc8e0e99559260481cea`; HIST §4/§7 | Linie 255–277 | Cover istnieje; wariant central epsilon=7/100 rozwinięto w (9)–(10) jako nową krótką analizę. D9 jest przyjętym upstream boundem. |
| mean → sharp tail | `E:inputs/d3/THEOREM.md` — `ca155d021a91c42d78f272160d51b1cc1605ce55e94c8c05af9c2ca6dd20a7aa`; HIST §8 | Linie 279–291 | Prefaktor rozliczony symbolicznie; wszystkie rational gates ponownie sprawdzone. Wynik warunkowy na jawnych upstream przesłankach. |
| Końcowy frontier | `E:inputs/d10/d10_certificate.json` — `46eff64586aef6a2845e8abbb04ad31307a4363a92cd87aa35a51f332bd9f4ad`; `E:certificates/public/d11e2_certificate.json` — `7cfc366d65415711c67486d82de21cb6b2d8e76a577935e11128324d5a2c1538` | Linie 100, 290–291, eksport global | `2^-99<T_work` sprawdzone dokładnie. Nie rozszerzono na T5 lub bezpieczeństwo schematu. |

## 11. Rozdzielenie dowodu, nowych rozwinięć, deklaracji i kontroli

### Znaleziony historyczny argument

- HIST §2: completion of squares, Schur i shifted theta dla pełnej kraty współczynników.
- HIST §3: pełna mapa aliasów, sumowanie kwadratu, normalizator i globalna nierówność.
- HIST §4–§6: Dirichlet, moderate i large; prawdziwy determinant NTRU.
- HIST §8: dokładny-discrete prefaktor i kompozycja z D3.
- A/B/C3/D3/D11D1/FD/D5: ogólne tożsamości, znaki, metryka, zakresy i właściwe interfejsy.

### Nowa analiza robocza tej sesji

- Zapis macierzy K/C/S w naturalnych współrzędnych, kontrola normalizacji śladowej i jawna instancjacja ogólnego argumentu endpointami 113/9923.
- Rozwinięcie krotności mapy `(u,m)` i pełnego mianownika w (5).
- Krótkie rozwinięcie Cauchy'ego (9) dla kanonicznego epsilon=7/100, z wyłączeniem u=0 i z bezpiecznymi, luźniejszymi stałymi checkera.
- Przyjęcie jawnej konwencji half-open na granicy X=9; nie przypisano tej konwencji do nieistniejącego pola certyfikatu.
- Niezależny kod kontrolny w aneksie A, nie kopia wykonania historycznego generatora.

Są to rozwinięcia/uzgodnienia przy użyciu już dostępnych lematów. Nie przedstawiam ich jako znalezionych dosłownych fragmentów raportów dawnych recenzentów.

### Deklaracje zachowanych artefaktów

- D7 deklaruje outward spectrum dla dokładnego K0; E deklaruje prywatny replay endpointu i zachowane commitmenty.
- E eksportuje globalny bound i `PENDING_REVIEW` wykonawcy; FC zapisuje późniejsze dwa ACCEPT.
- `history_used_as_premise=false` zachowano jako deklarację proweniencji E. Nie wnioskowano z niej o matematycznej nieprzydatności ogólnych lematów w HIST ani o rzeczywistej kolejności myślenia dawnego autora.

### Kontrole faktycznie wykonane

Wykonano A1 i A2: hashe, porównania obiektów, parsowanie AST i 147 sprawdzeń dokładnych. Żadna decydująca nierówność nie opiera się na binarnym float. Osiemnastocyfrowe i trzydziestocyfrowe przedziały wyświetlane przez A2 to dokładne wymierne zaokrąglenia na zewnątrz.

Po doprecyzowaniu wykonano osobno A3: identyfikację D11E1 V2, sprawdzenie trzech pinów, wybranych wpisów manifestu, zgodności correction graph z kodem E oraz dokładnych nierówności dla Uq. Zachowano pierwotne wyniki A2, ponieważ kod i wejścia numeryczne D11E2 nie zostały zmienione.

Nie wykonywano pełnego oryginalnego runnera Sage, wcześniejszych producentów D7/D9 ani prywatnego widma. `sage`, `flint`, `mpmath`, `sympy` i binarium Sage nie były dostępne. Nie instalowano narzędzi. Dostępny Python 3.13.5 wystarczył do wskazanych kontroli dokładnych, w tym porównania racjonalnych wartości z zapisanymi przedziałami RBF. To odtworzenie ich zawartości liczbowej, nie uruchomienie Sage/Arb.

### Kontrole negatywne

Nie uruchamiano historycznych mutation runners. Zachowane tryby `drop-alias` i `tail-shortcut` zawierają bezwarunkowe `require(False,...)`; nadal nie uznaję ich za dowód semantycznego wykrycia błędnej zmiany modelu. Ta słabość kontroli nie jest kontrprzykładem do (5).

W A2 rzeczywistą kontrolą historycznego progu jest **dolny** endpoint lambda_max >9860, nie samo przekroczenie 9860 przez upper. Kontrola granicy c=3,X=9 rozlicza rzeczywisty warunek gcd; nie skonstruowano sztucznego FAIL dla oczekiwanego werdyktu.

### Przesłanki nadal przyjmowane

Poprawność wcześniejszej ekstrakcji NTRU/spektrum i boundu D9 pozostaje jawną przesłanką wejściową tej weryfikacji. Nie odtwarzano ich prywatnych źródeł. Podstawowe tożsamości Poissona, shifted-theta maximum i Dirichleta sprawdzono na poziomie podanego argumentu matematycznego, nie w formalnym kernelu. Brak formalnego replayu nie jest tu stwierdzeniem fałszywości tych lematów.

## 12. Najmniejsze dalsze działanie i granica wyniku

Nie wskazuję nowego zadania badawczego polegającego na wynalezieniu mostu D7→D11E2. Został znaleziony i jego zastosowanie sprawdzono.

Jeśli ma nastąpić dalsza praca, wystarczy **jedno zadanie redakcyjne**: w nowym, osobno dopuszczonym opracowaniu wskazać ogólne §2–§8 HIST oraz konkretne A/B/C3/FD/D5, zapisać podmianę wyłącznie endpointów na K0, włączyć krótkie centralne rozwinięcie (9), oznaczyć half-open bins i kolizję symbolu A0 oraz rozróżnić D11E1 V2 od kanonicznego D11E2 i krawędź provenance-only. Historycznych bajtów, manifestów i werdyktów nie trzeba do tego przepisywać. Niniejszy raport już zawiera taką mapę do przeglądu właściciela.

**Końcowa ocena:** dostępny ogólny argument jest poprawnie stosowalny do tej konkretnej instancji przy zadanych publicznych przesłankach. Kanoniczna numeryka zgadza się z certyfikatem. G1 należy traktować jako problem jawnego powiązania dokumentacji i rozwinięcia skrótów, nie jako wykazane brakujące zasadnicze twierdzenie lub obalenie T2C3. Wynik pozostaje fixed-key i nie jest twierdzeniem o produkcyjnym samplerze, T5 ani EUF-CMA.

## Aneks A. Odtwarzalne kontrole publicznych wejść i rachunków

Poniższy kod został przygotowany dla tego audytu. Nie wykonuje historycznych runnerów, nie importuje Sage ani skryptów projektu i nie zapisuje plików. Blok A2 korzysta z jawnych funkcji odczytu i przypiętych wejść przygotowanych przez A1. Odwołania do plików `PRIVATE_ENDPOINT_REPLAY.json` i pól commitmentów są odczytami publicznych metadanych, nie prywatnych kluczy. Katalogi `.private` i `private_extraction` są odrzucane przed odczytem.

### A1. Piny, inwentarz, historia dopuszczenia i tożsamość

<!-- CONTROL_A1 -->
```python
import ast
import hashlib
import importlib.util
import json
import os
import pathlib
import re
import shutil
import stat
import subprocess
import sys
from fractions import Fraction as Q

os.environ["GIT_OPTIONAL_LOCKS"] = "0"
H = pathlib.Path("/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon")
F = H / "evidence/candidates/framework_d641"
E = F / "T2C3-REVALIDATE-D11E2-001-20260822-a1-CANONICAL"
D7 = F / "T2C3-REVALIDATE-D7-001-20260820-a5-CANONICAL-ENDPOINT"
FC = F / "T2C3-CANONICAL-FINAL-COMPOSITION-001-20260822-a1"
K = F / "T2C3-CANONICAL-KEYGEN-001-20260819-a1"
RD = F / "T2C3-CANONICAL-NTRU-COMPANION-REDUCTION-DEFINITION-001-20260819-a1"
D5 = F / "T2C3-REVALIDATE-D5-001-20260820-a2-CANONICAL"
AP = F / "T2C3-CANONICAL-REDUCED-COMPANION-APPLICATION-001-20260820-a2"
DOC = pathlib.Path("/home/footfalcon/Dokumenty")
GREF = "d641ab1037c2fa1dd4a22c258854d79d67b9b46b"
BASES = {"E": E, "D7": D7, "FC": FC, "K": K, "RD": RD, "D5": D5, "AP": AP, "DOC": DOC}
inventory = {}
cache = {}

def digest(data):
    return hashlib.sha256(data).hexdigest()

def safe_bytes(path):
    assert not any(x in (".private", "private_extraction") for x in path.parts)
    for part in [*reversed(path.parents), path]:
        assert not stat.S_ISLNK(part.lstat().st_mode), str(part)
    assert stat.S_ISREG(path.lstat().st_mode), str(path)
    return path.read_bytes()

def read(label):
    if label not in cache:
        base, rel = label.split(":", 1)
        parts = pathlib.PurePosixPath(rel)
        assert not parts.is_absolute() and ".." not in parts.parts
        cache[label] = safe_bytes(BASES[base] / rel)
        inventory[label] = digest(cache[label])
    return cache[label]

def object_json(label):
    return json.loads(read(label))

def git_bytes(path, ref=GREF):
    parts = pathlib.PurePosixPath(path)
    assert not parts.is_absolute() and ".." not in parts.parts
    assert not any(x in (".private", "private_extraction") for x in parts.parts)
    cmd = ["git", "ls-tree", "-z", ref, "--", path]
    tree = subprocess.run(cmd, cwd=H, capture_output=True, check=True).stdout
    records = [row for row in tree.split(b"\0") if row]
    assert len(records) == 1 and records[0].split(b" ", 1)[0] in (b"100644", b"100755")
    data = subprocess.run(["git", "show", ref + ":" + path], cwd=H,
                          capture_output=True, check=True).stdout
    inventory["G@" + ref + ":" + path] = digest(data)
    return data

def manifest(data):
    result = {}
    for line in data.decode("utf-8").splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  (.+)", line)
        assert match is not None
        expected, rel = match.groups()
        path = pathlib.PurePosixPath(rel)
        assert not path.is_absolute() and ".." not in path.parts and rel not in result
        result[rel] = expected
    return result

pins = {
    "D7:output_hashes.sha256": "f986c7f563816ff1f60aaaa5391e8d144d29798ebc9dc6bc2f15f5d687de96be",
    "D7:CANONICAL_ENDPOINT_INTERFACE_THEOREM.md": "93c9f610612dfbd2c243cc9d59f5cb48b8f559501490efcb9692b012dde01e2d",
    "D7:inputs/a3/canonical_endpoint_certificate.json": "fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d",
    "E:output_hashes.sha256": "45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76",
    "E:DERIVATION_PRE_HISTORY.md": "6b08d19150b3e0feae486d42b7e77410dc688ee0e1676604f45f6900d37693c0",
    "E:scripts/verify_d11e2.sage": "36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059",
    "E:certificates/public/d11e2_certificate.json": "7cfc366d65415711c67486d82de21cb6b2d8e76a577935e11128324d5a2c1538",
}
for label, expected in pins.items():
    assert digest(read(label)) == expected, label
prior = "DOC:FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md"
assert digest(read(prior)) == "def738641b8072e723fc4f457a3eb4f60ad6c102fd7a7b371e27faa9a0ba081c"
read("DOC:FT1536_PROMPT_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md")

extra = [
    "E:THEOREM.md", "E:report.md", "E:HISTORICAL_COMPARISON.md",
    "E:HISTORICAL_COMPARISON_BINDINGS.json", "E:PUBLIC_BINDINGS.json",
    "E:PRIVATE_ENDPOINT_REPLAY.json", "FC:D11E2_REVIEW_ASSERTIONS.json",
    "RD:DEFINITION.md", "D5:THEOREM.md", "AP:public_normal/public_verification.json",
    "K:canonical_public_key.bin", "K:canonical_public_h.txt",
]
for label in extra:
    read(label)

# Parse only the literal dependency dictionary; never execute historical code.
source = read("E:scripts/verify_d11e2.sage").decode("utf-8")
tree = ast.parse(source)
assignment = next(n for n in tree.body if isinstance(n, ast.Assign)
                  and any(isinstance(t, ast.Name) and t.id == "EXPECTED_SHA256" for t in n.targets))
dependencies = ast.literal_eval(assignment.value)
assert len(dependencies) == 28
for rel, expected in dependencies.items():
    assert digest(read("E:" + rel)) == expected, rel
cert = object_json("E:certificates/public/d11e2_certificate.json")
assert cert["bindings"] == dependencies
em = manifest(read("E:output_hashes.sha256"))
dm = manifest(read("D7:output_hashes.sha256"))
for label, actual in list(inventory.items()):
    base, rel = label.split(":", 1)
    if base == "E" and rel != "output_hashes.sha256":
        assert em[rel] == actual, label
    if base == "D7" and rel != "output_hashes.sha256":
        assert dm[rel] == actual, label

fd_path = "evidence/_work/T2C3-CANONICAL-FIXED-KEY-FOUNDATION-001-20260819-a2/THEOREM.md"
old_path = ("source_of_truth/v2.3/Results/T2C3-DISCRETE-TAIL-IMAGE-ENERGY-001/"
            "Stages/T2C3D11E2_FINAL_GLOBAL_L2_CLOSURE_20260813/"
            "T2C3-D11E2-FINAL-GLOBAL-L2-CLOSURE-001.md")
assert digest(git_bytes(fd_path)) == "c2ec9a1110c2837e8f9789197063bcf8748e5f84c0f8ad1ef0abdedf2fc35142"
assert digest(git_bytes(old_path)) == "13091d1425684fcaa30684ee1d18d434ab607080564fc48b7ce1a0504c3e0ab8"
epath = "evidence/_work/" + E.name + "/output_hashes.sha256"
for ref in (GREF, "b478ba359cfea7b18243c95a9705351491bb167b"):
    assert git_bytes(epath, ref) == read("E:output_hashes.sha256")

d7 = object_json("D7:inputs/a3/canonical_endpoint_certificate.json")
assert read("E:inputs/d7/canonical_endpoint_certificate.json") == read("D7:inputs/a3/canonical_endpoint_certificate.json")
endpoint = json.dumps(d7["endpoint"], sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode()
endpoint_hash = digest(endpoint)
assert endpoint_hash == d7["endpoint_sha256"] == "d44d47fb0d12d4df5a5373af72fffecf93b9d78f249232c96be76bd857fa3b1d"
pk_hash = digest(read("K:canonical_public_key.bin"))
h_hash = digest(read("K:canonical_public_h.txt"))
assert pk_hash == "57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f"
assert h_hash == "ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2"
binding = object_json("E:PUBLIC_BINDINGS.json")
assert binding["canonical_key"]["public_encoded_sha256"] == pk_hash == d7["bindings"]["canonical_public_sha256"]
assert binding["canonical_key"]["public_h_sha256"] == h_hash == d7["bindings"]["canonical_h_sha256"]
assert binding["canonical_key"]["private_encoded_sha256"] == d7["bindings"]["canonical_private_sha256"]
reduction = object_json("AP:public_normal/public_verification.json")["reduction"]
assert reduction["T_coefficient_sha256"] == "9135c32e42dcff7d70c9e0f8f72eec8769e4f52d61d74c0cc38eb04dbf0de2c2"
assert reduction["reduced_pair_coefficient_sha256"] == "80c6cb150959a80b89f50f9303af89e255f2354900e10cbf7cd1e6aa4a5580f2"
assert reduction["output_A0"] == 448642
reviews = object_json("FC:D11E2_REVIEW_ASSERTIONS.json")
assert reviews["candidate_manifest_sha256"] == pins["E:output_hashes.sha256"]
for role in ("implementation_review", "math_review"):
    assert reviews[role]["verdict"] == "ACCEPT"
    assert reviews[role]["artifact_persisted"] is False

consumers = []
for node in ast.walk(tree):
    if isinstance(node, ast.With):
        for item in node.items:
            call = item.context_expr
            if isinstance(call, ast.Call) and isinstance(call.func, ast.Attribute) and call.func.attr == "open":
                value = call.func.value
                if isinstance(value, ast.BinOp) and isinstance(value.right, ast.Constant):
                    consumers.append(value.right.value)
assert consumers == ["inputs/d7/canonical_endpoint_certificate.json",
                     "inputs/d9/d9_certificate.json", "inputs/d10/d10_certificate.json"]

print("A1_PINS=7/7; CHECKER_DEPENDENCIES=28/28; INSTANCE_BINDINGS=PASS")
print("A1_REVIEW_RECORDS=ACCEPT/ACCEPT; ORIGINAL_REVIEW_ARTIFACTS_PERSISTED=false")
print("A1_NUMERIC_JSON_CONSUMERS=" + json.dumps(consumers))
print("A1_ENDPOINT_SHA256=" + endpoint_hash)
print("PYTHON=" + sys.version.split()[0])
print("SAGE_BINARY=" + str(shutil.which("sage")))
print("OPTIONAL_MODULES=" + json.dumps({name: importlib.util.find_spec(name) is not None
                                      for name in ("sage", "flint", "mpmath", "sympy")}))
print("INVENTORY_COUNT=" + str(len(inventory)))
for label, value in sorted(inventory.items()):
    print(value + "  " + label)
```
<!-- END_CONTROL_A1 -->

### A2. Dokładne kontrole wymierne i całkowitoliczbowe

<!-- CONTROL_A2 -->
```python
from math import gcd, isqrt

checks = []
def check(label, condition):
    if not condition:
        raise AssertionError(label)
    checks.append(label)

def floor_q(x):
    return x.numerator // x.denominator

def outward_decimal(x, digits=18):
    # Exact decimal enclosure, not a floating-point proof or rounded verdict.
    scale = 10 ** digits
    lo = floor_q(x * scale)
    def show(n):
        assert n >= 0
        return str(n // scale) + "." + str(n % scale).zfill(digits)
    return "[" + show(lo) + "," + show(lo + 1) + "]"

def stored_ball_contains(text, value):
    match = re.fullmatch(r"\[([^ ]+) \+/- ([^]]+)\]", text)
    assert match is not None, text
    centre, radius = map(Q, match.groups())
    return radius >= 0 and centre - radius <= value <= centre + radius

def atan_interval(z, terms=16):
    partial = sum(((-1) ** k * z ** (2*k+1) / (2*k+1)
                   for k in range(terms)), Q(0))
    following = (-1) ** terms * z ** (2*terms+1) / (2*terms+1)
    return min(partial, partial + following), max(partial, partial + following)

pi_lo, pi_hi = Q(333, 106), Q(355, 113)
sqrt3_lo, sqrt3_hi, ln2_hi = Q(265, 153), Q(7, 4), Q(347, 500)
a5, b5 = atan_interval(Q(1, 5))
a239, b239 = atan_interval(Q(1, 239))
machin_lo, machin_hi = 16*a5 - 4*b239, 16*b5 - 4*a239
tan2 = 2*Q(1, 5)/(1-Q(1, 5)**2)
tan4 = 2*tan2/(1-tan2**2)
check("MACHIN_TANGENT_IDENTITY", (tan4-Q(1, 239))/(1+tan4*Q(1, 239)) == 1)
check("PI_ENCLOSURE", pi_lo < machin_lo < machin_hi < pi_hi)
check("SQRT3_ENCLOSURE", sqrt3_lo**2 < 3 < sqrt3_hi**2)
term = exp_lower = Q(1)
for k in range(1, 10):
    term *= ln2_hi/k
    exp_lower += term
check("LN2_UPPER_BY_POSITIVE_TAYLOR", exp_lower > 2)

N, d, q, B, sigma, QD = 1536, 3072, 18433, 2093922385, 768, 1000
beta, a0 = Q(N, B), Q(1, 2*sigma*sigma)
theta, A_ratio = a0-beta, a0/beta
epsilon = Q(7, 100)
A_min = (1-epsilon)*A_ratio
lam_lo, lam_hi = Q(113), Q(9923)
d9 = object_json("E:inputs/d9/d9_certificate.json")
d10 = object_json("E:inputs/d10/d10_certificate.json")
check("D7_LOWER", Q(d7["endpoint"]["lambda_min"]["lower"]) > lam_lo)
check("D7_UPPER", Q(d7["endpoint"]["lambda_max"]["upper"]) < lam_hi)
check("OLD_9860_REFUTED_BY_LOWER_ENDPOINT", Q(d7["endpoint"]["lambda_max"]["lower"]) > 9860)
check("SPECTRUM_CERTIFICATE_BINDING",
      cert["canonical_spectrum"]["lambda_min_exact_lower"] == d7["endpoint"]["lambda_min"]["lower"]
      and cert["canonical_spectrum"]["lambda_max_exact_upper"] == d7["endpoint"]["lambda_max"]["upper"])
check("D9_INTERFACE", d9["full_doubled_theta"]["lt_target"] is True
      and d9["full_doubled_theta"]["target"] == "2^-80")
check("Q_PRIME", all(q % k for k in range(2, isqrt(q)+1)))
check("COVER_COPRIMALITY", QD < q and all(gcd(c, q) == 1 for c in range(1, QD+1)))

gamma_lo = 8*pi_lo*pi_lo/(3*q*q*beta)
C = (None, gamma_lo*lam_lo, gamma_lo*q*q/lam_hi)
D = (None, 2*pi_hi/(sqrt3_lo*C[1]), 2*pi_hi/(sqrt3_lo*C[2]))

def correction(exponent_lower):
    m = floor_q(exponent_lower/ln2_hi)
    if m < 1:
        return None
    r = Q(1, 2**m)
    return 1 + 6*r/(1-r)**2, m

def theta_bound(which, lo, hi):
    options = []
    direct = correction(C[which]/hi)
    if direct is not None:
        options.append(("direct", direct[0], direct[1]))
    y = q*q*beta*lo/(2*lam_lo) if which == 1 else lam_hi*beta*lo/2
    reciprocal = correction(y)
    if reciprocal is not None:
        options.append(("poisson", D[which]*hi*reciprocal[0], reciprocal[1]))
    assert options
    return min(options, key=lambda row: row[1])

r8 = Q(1, 2**8)
AMB = Q(33, 32)
check("AMBIENT_MODERATE_EXPONENT", 2*pi_lo*pi_lo/(3*beta*250000) > 8*ln2_hi)
check("AMBIENT_MODERATE_THETA", 1 + 6*r8/(1-r8)**2 < AMB)
edges = [A_ratio, Q(5,4), Q(3,2), Q(7,4), Q(2), Q(9,4),
         Q(3), Q(4), Q(6), Q(9), Q(10), Q(12), Q(14), Q(16),
         Q(20), Q(25), Q(30), Q(36), Q(64), Q(100), Q(144),
         Q(225), Q(400), Q(625), Q(900), Q(1600), Q(2500),
         Q(5000), Q(10000), Q(20000), Q(40000), Q(80000),
         Q(160000), Q(250000)]
check("MODERATE_PARTITION", len(edges) == 34 and all(a < b for a,b in zip(edges, edges[1:])))
check("MODERATE_CERTIFICATE_COUNT", cert["cover"]["moderate_bin_count"] == 33
      and len(cert["cover"]["moderate_rows"]) == 33)
values = []
for index, (lo, hi) in enumerate(zip(edges, edges[1:])):
    dc = 3 if lo >= 9 else 1
    first, second = theta_bound(1, lo, hi), theta_bound(2, lo, hi)
    b2 = (dc*AMB/lo)**2 * first[1]*second[1]
    check("MODERATE_BIN_" + str(index), b2 < Q(17,20))
    row = cert["cover"]["moderate_rows"][index]
    check("ROW_METADATA_" + str(index),
          Q(row["K2_lo"]) == lo and Q(row["K2_hi"]) == hi and row["d_c"] == dc
          and row["theta1_method"] == first[0] and row["theta2_method"] == second[0]
          and row["theta1_dyadic_m"] == first[2] and row["theta2_dyadic_m"] == second[2])
    check("ROW_OUTWARD_TEXT_" + str(index), stored_ball_contains(row["b2_RBF512"], b2))
    values.append(b2)
    print("BIN", index, str(lo), str(hi), dc,
          first[0]+":"+str(first[2]), second[0]+":"+str(second[2]), outward_decimal(b2))
maximum = max(values)
imax = values.index(maximum)
check("MAXIMUM_INDEX", imax == cert["cover"]["moderate_max_b2_index"])
check("MAXIMUM_OUTWARD_TEXT", stored_ball_contains(cert["cover"]["moderate_max_b2_RBF512"], maximum))
check("MODERATE_ENERGY", Q(17,20)**768 < Q(1, 2**180))

# Half-open bin ownership: the exact c=3,tau=0 point X=9 belongs to [9,10).
index9 = next(i for i, (lo,hi) in enumerate(zip(edges, edges[1:])) if lo <= 9 < hi)
check("X9_BOUNDARY_OWNER", edges[index9] == 9 and cert["cover"]["moderate_rows"][index9]["d_c"] == 3)
check("NO_DC3_BELOW_X9", all(c*c >= 9 for c in range(1,QD+1) if gcd(c,3) == 3))

check("LARGE_RECIPROCAL_K", q*q*beta*250000/(2*lam_hi) > 8*ln2_hi)
check("LARGE_RECIPROCAL_S", lam_lo*beta*250000/2 > 8*ln2_hi)
Cg = sqrt3_hi*q*beta/(4*pi_lo)
check("LARGE_MID_AMBIENT", 2*pi_lo*pi_lo/(3*beta*9000000) > ln2_hi)
mid = 3*Cg*13*AMB
check("LARGE_MID_BASE", mid < Q(2,25))
r18 = Q(1,2**18)
corr18 = 1 + 6*r18/(1-r18)**2
check("LARGE_HIGH_EXPONENT", 2*beta*9000000 > 18*ln2_hi)
check("LARGE_HIGH_CORRECTION", corr18 < Q(257,256))
check("LARGE_HIGH_AMBIENT_POISSON", sqrt3_hi*beta/pi_lo*Q(257,256) < Q(1,2400000))
Xmax = QD*QD + (2*pi_hi/(QD*beta))**2
check("DIRICHLET_MAXIMUM", Xmax < 75000000)
high = 3*Cg*(Xmax/2400000)*AMB
check("LARGE_HIGH_BASE", high < Q(1,5))
check("LARGE_ENERGIES", Q(2,25)**N < Q(1,2**180) and Q(1,5)**N < Q(1,2**180))
check("LARGE_EXACT_CERTIFICATE_BINDINGS", Q(cert["cover"]["large_mid_base_exact"]) == mid
      and Q(cert["cover"]["large_high_base_exact"]) == high
      and Q(cert["cover"]["K2_global_upper"]) == Xmax)
check("DIRICHLET_OUTWARD_TEXT", stored_ball_contains(cert["cover"]["K2_global_upper_RBF512"], Xmax))

xcentral = 2*epsilon*pi_lo*pi_lo/(3*beta*A_min)
check("CENTRAL_EXPONENT", xcentral > 100*ln2_hi)
r100 = Q(1,2**100)
theta3_bound = 1 + 2*r100/(1-r100)
check("CENTRAL_THETA3", theta3_bound < 1+Q(1,2**98))
central_factor = (1+Q(1,2**98))**(4*N)
check("CENTRAL_CORRECTION", central_factor < Q(3,2))
check("CENTRAL_OUTWARD_TEXT", stored_ball_contains(cert["central_arc"]["correction_factor_RBF512"], central_factor))
check("CENTRAL_ENERGY", Q(3,2)/2**80 < Q(1,2**79))
check("CENTRAL_MINOR_BOUNDARY", A_min == Q(12982318787,12079595520))
check("CENTRAL_MINOR_CERTIFICATE", Q(cert["cover"]["A_min"]) == A_min
      and Q(cert["cover"]["A0"]) == A_ratio)
check("NEAR_MINOR_LOWER", A_min > Q(17,16) and A_min < A_ratio < 4)
check("NEAR_MINOR_POWER", 2**134 * 16**N < 17**N)

x = A_ratio-1
check("CONTOUR_IDENTITY", theta*B == N*x)
check("CONTOUR_EXPONENT", N*x*x/(2*A_ratio) > 23*ln2_hi)
check("CONTOUR_POISSON", 4*pi_lo*pi_lo/(3*beta) > 100*ln2_hi)
delta = 6*r100/(1-r100)**2
check("CONTOUR_CORRECTION", N*delta < Q(1,2))
check("CONTOUR_DENOMINATOR", theta > Q(1,2**24) and 0 < 2*theta < 1)
check("TAIL_EXPONENT_COMPOSITION", Q(1,2**20)*Q(1,2**79) == Q(1,2**99))
Twork = Q(d10["frontiers"]["working"]["tail_safe"])
check("D10_WORKING_BUDGET", Q(1,2**99) < Twork
      and Twork == Q(12774260389107117,50000000000000000000000000000000000))

print("A2_EXACT_CHECKS=" + str(len(checks)) + "; ALL_PASS")
print("A_ratio=" + str(A_ratio) + "; A_min=" + str(A_min))
print("B2_MAX_INDEX=" + str(imax) + "; B2_MAX=" + outward_decimal(maximum))
print("X9_OWNER_INDEX=" + str(index9) + "; DC=3")
print("K2_MAX=" + str(Xmax) + "; DISPLAY=" + outward_decimal(Xmax))
print("LARGE_MID=" + str(mid) + "; DISPLAY=" + outward_decimal(mid))
print("LARGE_HIGH=" + str(high) + "; DISPLAY=" + outward_decimal(high))
print("CENTRAL_FACTOR=" + outward_decimal(central_factor, 30))
print("CERTIFICATE_BIN_TEXT_ENCLOSURES=33/33; NATIVE_SAGE_NOT_EXECUTED")
```
<!-- END_CONTROL_A2 -->

### Polecenie wykonania kontroli A1 i A2

```bash
GIT_OPTIONAL_LOCKS=0 python3 -B -c 'import pathlib,re; p=pathlib.Path("/home/footfalcon/Dokumenty/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md"); text=p.read_text(); blocks=re.findall(r"<!-- CONTROL_(A[12]) -->\n```python\n(.*?)\n```",text,re.S); assert [name for name,code in blocks]==["A1","A2"]; scope={}; [(exec(compile(code,"<report-"+name+">","exec"),scope)) for name,code in blocks]'
```

### Wynik wykonanego polecenia

Polecenie A1+A2 wykonano z katalogu `/home/footfalcon/free_falcon_sign`; kod wyjścia **0**. Nie było uruchomienia historycznego runnera ani zapisu wyników pośrednich do plików. Najważniejszy stdout:

```text
A1_PINS=7/7; CHECKER_DEPENDENCIES=28/28; INSTANCE_BINDINGS=PASS
A1_REVIEW_RECORDS=ACCEPT/ACCEPT; ORIGINAL_REVIEW_ARTIFACTS_PERSISTED=false
A1_NUMERIC_JSON_CONSUMERS=["inputs/d7/canonical_endpoint_certificate.json", "inputs/d9/d9_certificate.json", "inputs/d10/d10_certificate.json"]
A1_ENDPOINT_SHA256=d44d47fb0d12d4df5a5373af72fffecf93b9d78f249232c96be76bd857fa3b1d
PYTHON=3.13.5
SAGE_BINARY=None
OPTIONAL_MODULES={"sage": false, "flint": false, "mpmath": false, "sympy": false}
INVENTORY_COUNT=53
A2_EXACT_CHECKS=147; ALL_PASS
A_ratio=2093922385/1811939328; A_min=12982318787/12079595520
B2_MAX_INDEX=0; B2_MAX=[0.796915207366232405,0.796915207366232406]
X9_OWNER_INDEX=9; DC=3
K2_MAX=896143129095640349689/12050340249600; DISPLAY=[74366624.554471563532057829,74366624.554471563532057830]
LARGE_MID=5867555694/77475128245; DISPLAY=[0.075734701276582572,0.075734701276582573]
LARGE_HIGH=67412432304667969287100552297/373440662493458123980800000000; DISPLAY=[0.180517118448098537,0.180517118448098538]
CENTRAL_FACTOR=[1.000000000000000000000000019387,1.000000000000000000000000019388]
CERTIFICATE_BIN_TEXT_ENCLOSURES=33/33; NATIVE_SAGE_NOT_EXECUTED
```

Pełne wiersze rachunku binów — `indeks lo hi dc metoda1:m metoda2:m przedział_b2`:

```text
BIN 0 2093922385/1811939328 5/4 1 direct:13 direct:4167 [0.796915207366232405,0.796915207366232406]
BIN 1 5/4 3/2 1 direct:11 direct:3473 [0.682620967265594627,0.682620967265594628]
BIN 2 3/2 7/4 1 direct:9 direct:2976 [0.478216890469360947,0.478216890469360948]
BIN 3 7/4 2 1 direct:8 direct:2604 [0.355460463597203587,0.355460463597203588]
BIN 4 2 9/4 1 direct:7 direct:2315 [0.278528790944300638,0.278528790944300639]
BIN 5 9/4 3 1 direct:5 direct:1736 [0.252039614406289744,0.252039614406289745]
BIN 6 3 4 1 direct:4 direct:1302 [0.168580729166666666,0.168580729166666667]
BIN 7 4 6 1 poisson:6 direct:868 [0.132981427652276603,0.132981427652276604]
BIN 8 6 9 1 poisson:9 direct:578 [0.081784625622112215,0.081784625622112216]
BIN 9 9 10 3 poisson:14 direct:520 [0.359392226585327935,0.359392226585327936]
BIN 10 10 12 3 poisson:15 direct:434 [0.349265291855419440,0.349265291855419441]
BIN 11 12 14 3 poisson:19 direct:372 [0.282920995959055883,0.282920995959055884]
BIN 12 14 16 3 poisson:22 direct:325 [0.237552276743539381,0.237552276743539382]
BIN 13 16 20 3 poisson:25 direct:260 [0.227344667785352191,0.227344667785352192]
BIN 14 20 25 3 poisson:31 direct:208 [0.181875702214524874,0.181875702214524875]
BIN 15 25 30 3 poisson:39 direct:173 [0.139680538912016650,0.139680538912016651]
BIN 16 30 36 3 poisson:47 direct:144 [0.116400449092081784,0.116400449092081785]
BIN 17 36 64 3 poisson:57 direct:81 [0.143704258138366452,0.143704258138366453]
BIN 18 64 100 3 poisson:101 direct:52 [0.071045195979050889,0.071045195979050890]
BIN 19 100 144 3 poisson:158 direct:36 [0.041904161676806370,0.041904161676806371]
BIN 20 144 225 3 poisson:228 direct:23 [0.031575665242020863,0.031575665242020864]
BIN 21 225 400 3 poisson:357 direct:13 [0.023009525757053970,0.023009525757053971]
BIN 22 400 625 3 poisson:635 direct:8 [0.011635744503342652,0.011635744503342653]
BIN 23 625 900 3 poisson:993 direct:5 [0.008044203689346804,0.008044203689346805]
BIN 24 900 1600 3 poisson:1430 direct:3 [0.011379031052589016,0.011379031052589017]
BIN 25 1600 2500 3 poisson:2542 poisson:8 [0.007296722239395516,0.007296722239395517]
BIN 26 2500 5000 3 poisson:3972 poisson:13 [0.011687626502247315,0.011687626502247316]
BIN 27 5000 10000 3 poisson:7945 poisson:26 [0.011679071451028992,0.011679071451028993]
BIN 28 10000 20000 3 poisson:15891 poisson:52 [0.011679070406838712,0.011679070406838713]
BIN 29 20000 40000 3 poisson:31782 poisson:104 [0.011679070406838697,0.011679070406838698]
BIN 30 40000 80000 3 poisson:63564 poisson:209 [0.011679070406838697,0.011679070406838698]
BIN 31 80000 160000 3 poisson:127129 poisson:419 [0.011679070406838697,0.011679070406838698]
BIN 32 160000 250000 3 poisson:254258 poisson:839 [0.007128338871361509,0.007128338871361510]
```

Kontrola parametrów i metadanych jest oddzielona od rekonstrukcji 33 nierówności; liczba 147 obejmuje oba rodzaje kontroli, a nie 147 nowych twierdzeń matematycznych. Nie powstały nowe upstream certyfikaty ani nowe wyniki prywatnej ekstrakcji.

### A3. Doprecyzowanie D11E1 V2 — osobny pakiet, ten sam D11E2

Kontrola dodana po otrzymaniu pliku `FT1536_DOPRECYZOWANIE_D11E1_V2_D11E2_2026-09-17.md`. Używa A1 oraz nowych publicznych wejść V2; nie powtarza rachunków A2 i nie wykonuje runnera V2. Nierówność dolna dotyczy wartości **górnej obwiedni Uq**, nie dolnej granicy rzeczywistej energii profilu.

<!-- CONTROL_A3 -->
```python
before_v2 = set(inventory)
V2 = H / "evidence/candidates/d11e1_v2/D11E1_V2"
BASES["V2"] = V2
amendment = "DOC:FT1536_DOPRECYZOWANIE_D11E1_V2_D11E2_2026-09-17.md"
assert digest(read(amendment)) == "841dc66be889e729087bbdc185492a990973cf4f93d80b361ce7a26099af01e3"
v2_pins = {
    "README.md": "0e9263488e81d91e79260060d2bf6715f3a3e6f9b40d091d3244dbfe1f2fd15b",
    "THEOREM.md": "0c2c33efd0f1f655baf5d81b27ca73086d47fdd9aaa244d75eba87626188edb7",
    "DEPENDENCY_GRAPH_CORRECTION.json": "02f761d77528c201a5de3df5051ca6cb3fd3c808aaffdf8811e51bfe45ac233a",
}
for rel, expected in v2_pins.items():
    assert digest(read("V2:" + rel)) == expected, rel
for rel in ["STATUS", "SHA256SUMS", "report.md", "report.json", "SOURCE_BINDINGS.json",
            "LEGACY_DISPOSITION.json", "DERIVATION_NORMALIZATION.md",
            "certificates/normal/d11e1_v2_certificate.json"]:
    read("V2:" + rel)
v2_manifest = manifest(read("V2:SHA256SUMS"))
assert len(v2_manifest) == 20
v2_member_count = 0
for label, actual in inventory.items():
    if label.startswith("V2:") and label != "V2:SHA256SUMS":
        assert v2_manifest[label.split(":", 1)[1]] == actual, label
        v2_member_count += 1
assert v2_member_count == 10
assert read("V2:STATUS").decode().strip() == "PROVED_CANDIDATE_PENDING_DUAL_REVIEW"
graph = object_json("V2:DEPENDENCY_GRAPH_CORRECTION.json")
assert graph["d11e2_verifier_sha256"] == digest(read("E:scripts/verify_d11e2.sage"))
assert graph["mathematical_consumption"] is False
assert graph["new_classification"] == "PROVENANCE_ONLY_NON_GOVERNING"
assert graph["d11e1_numeric_fields_read_by_d11e2"] == []
bound_e1 = sorted(rel for rel in dependencies if rel.startswith("inputs/d11e1/"))
assert bound_e1 == sorted(graph["d11e1_files_hash_bound_by_d11e2"])
assert all("d11e1" not in rel for rel in consumers)
literal_fields = {node.value for node in ast.walk(tree)
                  if isinstance(node, ast.Constant) and isinstance(node.value, str)}
assert not set(graph["d11e1_values_not_consumed"]) & literal_fields
legacy = object_json("V2:LEGACY_DISPOSITION.json")
assert legacy["legacy_manifest_sha256"] == dependencies["inputs/d11e1/output_hashes.sha256"]
assert legacy["legacy_theorem_sha256"] == dependencies["inputs/d11e1/THEOREM.md"]
assert legacy["legacy_certificate_sha256"] == dependencies["inputs/d11e1/d11e1_certificate.json"]
assert legacy["legacy_bytes_modified"] is False and legacy["legacy_accepts_carried_to_v2"] is False
assert object_json("V2:SOURCE_BINDINGS.json")["base_commit"] == GREF
v2_cert = object_json("V2:certificates/normal/d11e1_v2_certificate.json")
assert v2_cert["task_id"] == "T2C3-REVALIDATE-D11E1-002"
assert v2_cert["claim_boundary"]["D11E2_rerun"] is False
assert v2_cert["normalization"]["q_local_normalization_formula"] == "delta^2/(1-delta^2)"

# Independent, public exact arithmetic only; no V2 runner or private input.
delta_q = Q(18432, 18433**768)
Uq = delta_q**2/(1-delta_q**2)
assert Q(1, 2**21737) < Uq < Q(1, 2**21736)
assert Uq + Q(1,2**133) + Q(1,2**66) < Q(1,2**65)
# Real normalization witness of the type described in V2, not FT1536 key data.
counts = [11]*9 + [9]*11
probabilities = [Q(n, sum(counts)) for n in counts]
energy = 20*sum((p*p for p in probabilities), Q(0))-1
assert energy == Q(1,99) > Q(1,100)

print("A3_V2_PINS=3/3; SELECTED_MANIFEST_MEMBERS=10/10; MANIFEST_RECORDS=20")
print("A3_PACKAGE=D11E1_V2; STATUS=PROVED_CANDIDATE_PENDING_DUAL_REVIEW")
print("A3_D11E2_VERIFIER_SHA256=" + graph["d11e2_verifier_sha256"])
print("A3_EDGE=PROVENANCE_ONLY_NON_GOVERNING; D11E1_NUMERIC_CONSUMPTION=false")
print("A3_NORMALIZATION_UPPER=delta_q^2/(1-delta_q^2); 2^-21737<Uq<2^-21736")
print("A3_CLOSED_COMPONENT_UPPER<2^-65; NORMALIZATION_WITNESS=1/99>1/100")
print("A3_ADDITIONAL_INPUTS=" + str(len(set(inventory)-before_v2)) + "; TOTAL_INPUTS=" + str(len(inventory)))
for label in sorted(set(inventory)-before_v2):
    print(inventory[label] + "  " + label)
```
<!-- END_CONTROL_A3 -->

Dokładne polecenie A1+A3:

```bash
GIT_OPTIONAL_LOCKS=0 python3 -B -c 'import pathlib,re; p=pathlib.Path("/home/footfalcon/Dokumenty/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md"); text=p.read_text(); blocks=dict(re.findall(r"<!-- CONTROL_(A[123]) -->\n```python\n(.*?)\n```",text,re.S)); scope={}; [(exec(compile(blocks[name],"<report-"+name+">","exec"),scope)) for name in ("A1","A3")]'
```

Wykonanie A1+A3 zakończyło się kodem **0**. Dodatkowy stdout, poza powtórzoną kontrolą A1:

```text
A3_V2_PINS=3/3; SELECTED_MANIFEST_MEMBERS=10/10; MANIFEST_RECORDS=20
A3_PACKAGE=D11E1_V2; STATUS=PROVED_CANDIDATE_PENDING_DUAL_REVIEW
A3_D11E2_VERIFIER_SHA256=36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059
A3_EDGE=PROVENANCE_ONLY_NON_GOVERNING; D11E1_NUMERIC_CONSUMPTION=false
A3_NORMALIZATION_UPPER=delta_q^2/(1-delta_q^2); 2^-21737<Uq<2^-21736
A3_CLOSED_COMPONENT_UPPER<2^-65; NORMALIZATION_WITNESS=1/99>1/100
A3_ADDITIONAL_INPUTS=12; TOTAL_INPUTS=65
```

### Kontrola kompletności zapisanego inwentarza

Po zapisaniu treści raportu wykonano poniższą kontrolę jego inwentarza i składni zapisanych bloków kodu. Powtarza ona A1 i uzupełnienie A3, bez ponownego wykonania rachunków A2. Ich stdout przechowywany jest wyłącznie w pamięci.

```bash
GIT_OPTIONAL_LOCKS=0 python3 -B -c 'import pathlib,re,ast,io,contextlib; p=pathlib.Path("/home/footfalcon/Dokumenty/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md"); text=p.read_text(); blocks=dict(re.findall(r"<!-- CONTROL_(A[123]) -->\n```python\n(.*?)\n```",text,re.S)); assert set(blocks)=={"A1","A2","A3"}; [ast.parse(code) for code in blocks.values()]; scope={}; capture=io.StringIO(); manager=contextlib.redirect_stdout(capture); manager.__enter__(); [exec(compile(blocks[name],"<report-"+name+">","exec"),scope) for name in ("A1","A3")]; manager.__exit__(None,None,None); annex=text.split("\n## Aneks B. Pełny inwentarz wejść z SHA-256\n",1)[1]; rows=re.findall(r"^([0-9a-f]{64})  (.+)$",annex,re.M); recorded={label:digest for digest,label in rows}; assert len(rows)==len(recorded)==65; assert recorded==scope["inventory"]; assert re.search(r"^<!-- (?:MAIN_REPORT|V2_CONTROL_RESULTS) -->$",text,re.M) is None; print("REPORT_INVENTORY=65/65; CODE_SYNTAX=3/3; NUMERIC_A2_NOT_REPEATED")'
```

Wynik kontroli zapisanego raportu: kod wyjścia **0**, stdout:

```text
REPORT_INVENTORY=65/65; CODE_SYNTAX=3/3; NUMERIC_A2_NOT_REPEATED
```

### Dodatkowe jawne polecenia odczytowe Git

Poniższe polecenia wykonano z `cwd=H`, z kodem wyjścia 0. A1 dodatkowo wykonuje programowo odczyty `git ls-tree -z` i `git show` widoczne w funkcji `git_bytes`.

```bash
GIT_OPTIONAL_LOCKS=0 git rev-parse refs/archive/framework/candidate
GIT_OPTIONAL_LOCKS=0 git ls-tree d641ab1037c2fa1dd4a22c258854d79d67b9b46b -- "evidence/_work/T2C3-CANONICAL-FIXED-KEY-FOUNDATION-001-20260819-a2/THEOREM.md" "source_of_truth/v2.3/Results/T2C3-DISCRETE-TAIL-IMAGE-ENERGY-001/Stages/T2C3D11E2_FINAL_GLOBAL_L2_CLOSURE_20260813/T2C3-D11E2-FINAL-GLOBAL-L2-CLOSURE-001.md"
GIT_OPTIONAL_LOCKS=0 git show d641ab1037c2fa1dd4a22c258854d79d67b9b46b:evidence/_work/T2C3-CANONICAL-FIXED-KEY-FOUNDATION-001-20260819-a2/THEOREM.md
GIT_OPTIONAL_LOCKS=0 git show d641ab1037c2fa1dd4a22c258854d79d67b9b46b:source_of_truth/v2.3/Results/T2C3-DISCRETE-TAIL-IMAGE-ENERGY-001/Stages/T2C3D11E2_FINAL_GLOBAL_L2_CLOSURE_20260813/T2C3-D11E2-FINAL-GLOBAL-L2-CLOSURE-001.md
```

Ref zwrócił `d641ab1037c2fa1dd4a22c258854d79d67b9b46b`; dwa jawnie wylistowane dokumenty miały tryb `100644`. Pierwszy preflight plików i dostępności narzędzi był podzbiorem powtórzonym i objętym końcowym A1. Odczyty treści narzędziem Read dotyczyły plików z poniższego inwentarza. Katalog `DOC` obejrzano tylko w celu wybrania wolnej nazwy wyniku; docelowy plik nie istniał.

## Aneks B. Pełny inwentarz wejść z SHA-256

Format: `SHA-256  baza:ścieżka`. Bazy plikowe są zdefiniowane w §2 i literalnie w A1. `G@<commit>` wskazuje dokładny obiekt w H. Jest to inwentarz tego audytu, nie zastępczy manifest historycznego pakietu. Sam zgodny hash nie oznacza poprawności dowodu.

```text
d7a8d4efa36a810fe61662ac60e7531d9561e5c40d78e94352062f6aa0b087ca  AP:public_normal/public_verification.json
b3a22eccbbd293bce97c03dcad285726009026899d12d1579fb893caf5983095  D5:THEOREM.md
93c9f610612dfbd2c243cc9d59f5cb48b8f559501490efcb9692b012dde01e2d  D7:CANONICAL_ENDPOINT_INTERFACE_THEOREM.md
fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d  D7:inputs/a3/canonical_endpoint_certificate.json
f986c7f563816ff1f60aaaa5391e8d144d29798ebc9dc6bc2f15f5d687de96be  D7:output_hashes.sha256
def738641b8072e723fc4f457a3eb4f60ad6c102fd7a7b371e27faa9a0ba081c  DOC:FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md
2f68fbc751ec2db9bac8e3ecff2d0d84c33cc0828357e9c7f180d4be2c214c05  DOC:FT1536_PROMPT_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md
6b08d19150b3e0feae486d42b7e77410dc688ee0e1676604f45f6900d37693c0  E:DERIVATION_PRE_HISTORY.md
547be7f167f906726212b4380348d14ea4634b230f92359f0be46933d8c740f8  E:HISTORICAL_COMPARISON.md
18c5b79c2d8c5884af42e0310e7c5ad53080019cf223fafe888b30951c9f5935  E:HISTORICAL_COMPARISON_BINDINGS.json
b7e5ed84d979328de257a2b3f548a86c3f925403048cdab6d009302cdac68ac9  E:PRE_HISTORY_BINDING.sha256
2f3cda9556747dc741f10033c8aae64148f9704dd3dd5f5f97be009a79a88f5b  E:PRIVATE_ENDPOINT_REPLAY.json
719e577a75c06ce75a3cac2652c0c0139c450ec07698fc574cf76237199b12fe  E:PUBLIC_BINDINGS.json
71c65bfcda7f9480f4d8c56e10baa5bc02eb8206748f51c22c0bbd0f641df86b  E:THEOREM.md
7cfc366d65415711c67486d82de21cb6b2d8e76a577935e11128324d5a2c1538  E:certificates/public/d11e2_certificate.json
27c4cdeb092eb01a649654c606ef93b54031c21d0dd3e7d2cc51ef52a4bb4cc8  E:inputs/a/THEOREM.md
25196c824d1419be031c6ec9c3a4c2fe45c93eca7e034fe00ea5f68422ddc0d2  E:inputs/a/certificate.json
449fb56a7e96e6c6979c86c78596b303797830c21a65b1241130fb5325ca0b0f  E:inputs/a/output_hashes.sha256
4ed6753f563c03be562e0b8edf16df0eb49814b1e91dbc401d1ce99fa3270366  E:inputs/b/THEOREM.md
50c19aca9d499a5233aa55953703184f60e742e2d21f48d0308412967ff2380c  E:inputs/b/certificate.json
6b99e14010ef6c4b23e6df93f5f520bf437f564bc66e01beebfda8add8e0d170  E:inputs/b/output_hashes.sha256
3d36cbf12734902886472b45f81b9182de08b0f2af2015b38e1b879d045112b6  E:inputs/c3/THEOREM.md
7df4011328ba83fc7c360f443cbab7652f0fb46acd778c5f86913c9e11955314  E:inputs/c3/certificate.json
5cd9b72feae4d1b93a326f7bd3651b21773ce1d02fb40f37f3efd53f6e6e8a90  E:inputs/c3/integration_output_hashes.sha256
af73c6b394fe516a86861399079ac6dfa6392a8009634dc89913687f3a2abfec  E:inputs/d10/THEOREM.md
46eff64586aef6a2845e8abbb04ad31307a4363a92cd87aa35a51f332bd9f4ad  E:inputs/d10/d10_certificate.json
ed325b116352a93fe97bd77a64654937bfc88a16a8564e899fb084cd3e93684c  E:inputs/d10/output_hashes.sha256
c451ca664417fceb9eddcbe1baa743301b9980a62996fc8e0e99559260481cea  E:inputs/d11d1/THEOREM.md
a5bf2c1e210a3af3c9c5c824838c4090b148f5a62ca314617a852595b74f55a8  E:inputs/d11d1/d11d1_certificate.json
f41e6264c5e3e67a497387aaca9c7deac3aee2eba22733f28bc50f7ccdd0d7fd  E:inputs/d11d1/output_hashes.sha256
8e87b7710e2dc0c4a2411c0142d1b73852737870ebaed52436fe8780819b1b13  E:inputs/d11e1/THEOREM.md
342ae631b0d924db1d56576b10f7ddf1406e606f19989f0cfaada62fdc358de8  E:inputs/d11e1/d11e1_certificate.json
7e05526efc7485af3f37cd14d0f277aff870a3f19b2bc7fb4b60cbf6f5a4c462  E:inputs/d11e1/output_hashes.sha256
ca155d021a91c42d78f272160d51b1cc1605ce55e94c8c05af9c2ca6dd20a7aa  E:inputs/d3/THEOREM.md
b20602f10d6cf0e038260d5b93f211ddb9bf4b6714f5fbf0853b72cc18305708  E:inputs/d3/certificate.json
6a78150afb6f5975b0922155fb46d0458c2bfbb210a57d2a98743148b12eef3f  E:inputs/d3/output_hashes.sha256
93c9f610612dfbd2c243cc9d59f5cb48b8f559501490efcb9692b012dde01e2d  E:inputs/d7/THEOREM.md
fa5989576606d2a7a32edd8178ddfcb5066840feade57f630c385c6037b2832d  E:inputs/d7/canonical_endpoint_certificate.json
f986c7f563816ff1f60aaaa5391e8d144d29798ebc9dc6bc2f15f5d687de96be  E:inputs/d7/output_hashes.sha256
dae44634ccccc7d970fabf98edbbd459426aedafe0a106808bc904134459ef8e  E:inputs/d9/THEOREM.md
7fcb29213f2a39cf942e011bd1c4ec3a0d843e5347ed82370b9ba9c06270c1fb  E:inputs/d9/d9_certificate.json
c16e4c2fb3415c835ff835444262eb0a7a7b1adb30d5e8f63e7bcf6b3fdb591e  E:inputs/d9/output_hashes.sha256
45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76  E:output_hashes.sha256
bd1dd588757f55c31a980a6e1d2208a5162663dbea674931b57db7a85d54849e  E:report.md
36f28793cffa915733b854270cde7b6acc98c32cb50aadcc91e5433e3e292059  E:scripts/verify_d11e2.sage
79c6d77048bfc11565ced298d203054b39b8c90fc8f535170f9df93021e59c15  FC:D11E2_REVIEW_ASSERTIONS.json
45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76  G@b478ba359cfea7b18243c95a9705351491bb167b:evidence/_work/T2C3-REVALIDATE-D11E2-001-20260822-a1-CANONICAL/output_hashes.sha256
c2ec9a1110c2837e8f9789197063bcf8748e5f84c0f8ad1ef0abdedf2fc35142  G@d641ab1037c2fa1dd4a22c258854d79d67b9b46b:evidence/_work/T2C3-CANONICAL-FIXED-KEY-FOUNDATION-001-20260819-a2/THEOREM.md
45429b457e216286cecab310c63169b63d116dbfe17f07653219ea389da4df76  G@d641ab1037c2fa1dd4a22c258854d79d67b9b46b:evidence/_work/T2C3-REVALIDATE-D11E2-001-20260822-a1-CANONICAL/output_hashes.sha256
13091d1425684fcaa30684ee1d18d434ab607080564fc48b7ce1a0504c3e0ab8  G@d641ab1037c2fa1dd4a22c258854d79d67b9b46b:source_of_truth/v2.3/Results/T2C3-DISCRETE-TAIL-IMAGE-ENERGY-001/Stages/T2C3D11E2_FINAL_GLOBAL_L2_CLOSURE_20260813/T2C3-D11E2-FINAL-GLOBAL-L2-CLOSURE-001.md
ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2  K:canonical_public_h.txt
57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f  K:canonical_public_key.bin
79b210a6a51f77afa5914cdee4153d0fb1be42c57a7cea460a8fdc86acf35a39  RD:DEFINITION.md
```

Poza tym zakresem pozostały prywatne dane, katalogi zakazane, dawne logi surowej ekstrakcji, binaria dekoderów, producerzy widma/klucza, pełne ponowne wykonania poprzedników i materiał niepowiązany z siedmioma pytaniami. Wcześniejszy raport był nawigacją; żadne stwierdzenie o brakującym dowodzie nie zostało przyjęte wyłącznie z niego.

### Uzupełnienie inwentarza po doprecyzowaniu D11E1 V2

Powyżej zapisano pierwotne 53 wejścia; poniżej jest 12 dodatkowych. Baza `V2` oznacza dokładnie `H/evidence/candidates/d11e1_v2/D11E1_V2`. Nie odczytywano archiwum audytu wskazanego przez V2 ani nie uruchamiano jego verifiera; takie hashe w metadanych V2 nie są tu deklarowane jako zweryfikowane wejścia pośrednie.

```text
841dc66be889e729087bbdc185492a990973cf4f93d80b361ce7a26099af01e3  DOC:FT1536_DOPRECYZOWANIE_D11E1_V2_D11E2_2026-09-17.md
02f761d77528c201a5de3df5051ca6cb3fd3c808aaffdf8811e51bfe45ac233a  V2:DEPENDENCY_GRAPH_CORRECTION.json
6b93f5c8e00ade3bf166c7092555bbbf6e641e5481db8500dbd8dc67b97fe83d  V2:DERIVATION_NORMALIZATION.md
565f1061515d400b7df0c1cae3c70f76db223148ad74bbb7d1c7c4dc62fe4450  V2:LEGACY_DISPOSITION.json
0e9263488e81d91e79260060d2bf6715f3a3e6f9b40d091d3244dbfe1f2fd15b  V2:README.md
15d1e81b2705e24be7143a5d3859dabf0b0dd5aeaf43fcca559c0679b5bdadaa  V2:SHA256SUMS
9fcf15c7c6f21de8f05f7d7eab225aa83bce9d86062da5eee1ba86823d82a007  V2:SOURCE_BINDINGS.json
edee821dc43627bd145fb15c16da898f2fd4162bc8af9b4bcbf3494900f85bbd  V2:STATUS
0c2c33efd0f1f655baf5d81b27ca73086d47fdd9aaa244d75eba87626188edb7  V2:THEOREM.md
de7eecb17dfb274ee2ea984b6b4672e9665df8602c07cf3404f8f3e2b14c9009  V2:certificates/normal/d11e1_v2_certificate.json
75c437003365329aa6bcc3700ef791f5fc164a4ff65248ed8abcc9e9451a928a  V2:report.json
4dec713ff464c1cdaf620dac9a31bdc7f7f0bd1b92e0f89db747c73a95aa83b8  V2:report.md
```
