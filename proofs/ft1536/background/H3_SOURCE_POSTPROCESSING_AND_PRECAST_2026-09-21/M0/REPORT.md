# FT1536 M0 — profil, gra i parametryczny ledger

Data zadania:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_M0_CONTRACT_RUN_001`.

## 1. Wynik

**M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE.** Zdefiniowano spójny kontrakt
FT1536-M0-r40-static4096-parametric-v1: źródła/ABI, dokładne prawo klucza,
orakle i obserwacje, framing, zasoby oraz22-wierszowy ledger porównań.

Oddzielny wynik pomocniczy:
**PROVED_ANALYTIC_AND_KERNEL_COUNT_MODEL_WITH_PINNED_C_BINDING** dla boundu
STATIC payload<=3160 po rzeczywistym norm acceptance.4096 jest wystarczającą
wybraną pojemnością, a rzeczywisty syntetyczny świadek wymaga3156 bajtów.

`security_reduction_proved=false`, `source_integrated=false`,
`protocol_wrapper_integrated=false`, `owner_accepted=false`.
Właścicielskie4096/r40 i parametryczny cel pozostają decyzjami przyjętymi.
Ukończone L_V kandydata zachowuje pełny status dla swojego pinu.

## 2. Piny i podstawa

- TASK: `a1556c02ab1bb89ce2f1b61d309e946bc15057a7c3c6bb4c173b0d560fe94956`.
- PREV/REPORT: `81702fa89ee516f162a37db86e2abb03ae0bb57a49a5723ed63eab5a17a69296`.
- PREV/OUTPUTS: `13fa5a9f706a962434c8ac479212af5ef33d91e1ececd6c948d68ed42871a74e`.
- Verifier candidate: `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
- Manifest17 źródeł: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

Zweryfikowano15 zadanych pinów,97 wybranych kopii i17 source files.
61 formalnych zależności od Norm64 skonsumowano bez zmian i ponownie sprawdzono
ze źródeł. Nie powtarzano całego L_V ani native kampanii NTT/samplera.
PROFILE i SOURCE_MODEL_BINDING rozdzielają rdzeń, caller oraz historyczny CLI.

## 3. Pojemność — dokładny nowy dowód

N1536, q18433, sigma768, B2093922385 i Q offset768 A2 pozostają te same.
Z `2*A2(x,y)=x²+y²+(x+y)²` otrzymano Q0>=0 oraz
sqSum(s2)<=2Q0(s2)<=4187844768. Skończony Cauchy uzasadnia rachunek z zadania.
Kernel używa prostszego całkowitoliczbowego majorantu, bez biblioteki Real:

```
3302|x| <= x²+2725801, z (|x|−1651)²>=0
Σ|s2_i| <=2536243
Σ floor(|s2_i|/256) <=9907
STATIC bits <=10*1536+9907=25267
payload <=1+ceil(25267/8)=3160 <4096.
```

EncoderCount zachowuje source prefix9, byte drains, unary terminator,
padding i każdy guard capacity. Signed int16 promotion/negation i ne0..128
oraz post-decrement do−1/−2 są rozliczone. Nie zastąpiono Source Sign idealną
definicją. STATIC_FITS_4096 konsumuje source isShort=true i daje sukces
licznika kodera dla4095 data bytes oraz powyższą granicę. Pełne typy/axioms
są w logs/final/M0Types.stdout i M0Audit.stdout. Zakres analytic/kernel/C
binding oraz ograniczenia byte-value proof są rozdzielone w CAPACITY.md.

Rzeczywisty falcon_is_short akceptuje publiczny wektor s1=0, s2=(x,−x),
x:330×1792 i438×1536. Q=2093088768, bits25236, data3155, payload3156.

| Payload capacity | Encoder capacity | Source result |
|---:|---:|---|
|2049|2048|0, brak miejsca|
|3073|3072|0, brak miejsca|
|3155|3154|0, brak miejsca|
|3156|3155|3155 data bytes, round-trip PASS|
|4096|4095|3155 data bytes, round-trip PASS|

Query out=NULL również zwraca3155. Canaries i niewykorzystany suffix są
zachowane, normal/ASan/UBSan zgodne. Dodatkowe przypadki: zero1921,
short dokładnie3073 oraz non-short26497. Ten ostatni nie spełnia Q<B.
Mutacje terminatora/j7 zmieniają rzeczywistą długość na2964/4198; wykryto je.
No-op przechodzi. Nie twierdzi się, że3156 zostało wylosowane przez Sign,
jest atakiem EUF-CMA lub dowodzi optymalności3160.

Wniosek jest lokalny: po zdefiniowanym source norm acceptance i przy legalnym
caller4096 brak miejsca nie powoduje failure STATIC. Inne aborty i
pre-cast/source-distribution obligations pozostają. H6P nie przeniesiono
przez zamianę3073 na4096.

## 4. Zakres zdefiniowanej gry

GAME.md określa jeden świeży capped KeyGen z32 uniform seed bytes na sukcesie
jawnego środowiska E i z rzeczywistą deterministyczną ekspansją. E_K obejmuje
całe wywołanie, łącznie z kodowaniem. K_seed[E]=Law(output|E_K), p_K>0;
Adv_uncond=p_K*Adv_cond dokładnie RAZ. K_iid, raw ternary proposal i h* nie
są utożsamiane z tym prawem. Ten sam (sk,pk) jest wspólny dla wszystkich queries.

Każde Sign ma świeży kontekst i ten sam sk. m jest ustalone przed start,
nonce nie jest ujawniany w trakcie query, nie ma external seed/nonce API dla A.
Dokładny source order fault/norm/retry/encoding jest zapisany. Odpowiedzi:
PRE_ABORT, (r,POST_ABORT), (r,b); brak reason code, partial buffer i timing
observation. Abort queries wchodzą do SeenSign. Nie relabeluje się niepoprawnych
emitowanych b jako source bot. Uncapped loops i STUCK mają jawny status,
nie nowy ukryty timeout implementacji.

Pierwszy cel to klasyczny ordinary EUF-CMA w direct-output ROM. Wygrana
wymaga świeżego m*, nonce40 i source Verify=1. Przeciwnik zachowuje NONE/STATIC
i dowolne legalne payloady w swoim L, również>4096. Framing ma kernelowy
dowód injektywności pary (r,m), nie hasha. Kontrola r40→r39 zachowuje surowe
r||m, ale gate nowego kontraktu odrzuca39; mutant dopuszczający39 jest wykryty.
Stary tool.c sig2049/variable-rlen nie jest tym wrapperem.

Źródłowy parent budget świeżego Sign to40+16*56=936. Nie ogranicza inner draws.
56 bytes to key32+IV16+counter8 exact Falcon PRNG; source XOR dotyczy ostatnich
8 bytes IV mimo nieprecyzyjnego komentarza. SHAKE capacity512 to SHAKE-256,
nie „SHAKE-512”. Prymitywy nie stają się idealnymi oraklami przez definicję gry.

## 5. Parametryczny ledger i otwarte obowiązki

RESOURCE_MODEL.md definiuje Nat-parametry Q_s,Q_H,t,w,L, bit-step work,
memory bits i dokładny budżet interfejsowych bytes, wraz z odpowiedziami,
streamingiem i finalnym fałszerstwem. Koszt decoder/extractor rośnie z|b*|;
RO table obejmuje<=Q_H+Q_s+1 nazw i ich rzeczywiste bajty.
MT-ISIS_seed,rel ma jeden klucz i Q_H+1 indeksowanych uniform targets,
świadka całkowitego bez centered restriction z2. Nie dodano drugiego
target-guessing multiplier, estimator nie jest theorem hardness.

HOP_LEDGER.json/.md zawierają22 przejścia, status każdej przesłanki, źródła,
metryki, kierunek, historię, conditioning, abort ownership i koszty.
Image direction jest **chi2(S||R)**, R uniform, S reverse. Potrzebne
pełne conditional kernels po historii są otwartym M5. Phi_Delta zachowuje
właściwą orientację i kolejność kosztów; nie przeniesiono go na H1R ani
reverse/high-order Renyi. Nie policzono dwa razy tego samego abortu.

TARGET_TYPE.md i target w ledgerze deklarują dokładny parametryczny typ
M7 z komponentami M1–M6 i osobnymi primitive/MT assumptions. **M7 jest
wnioskiem docelowym, nigdy założeniem wejściowego rekordu.** Ordered envelope
jest interfejsem warunkowym, nie obecnie uzyskanym RHS FT1536 ani wyborem
lambda128/256. M0 nie ustawia e, gamma, epsilon lub delta na wygodne liczby.

Otwarte pozostają: H3 reachability/arithmetic; scalar-to-joint law i geometria;
pre-cast/bajty/fault/retry; nowy spójny R5T; pełne shared kernels/M5;
public sampler, budżety, klasyczne ROM programming; prymitywy, MT hardness
i końcowe M7. Publiczny bit-XOF/H2P i QROM są osobnymi dalszymi etapami.
T2C3 fixed-key, T5 pure/untruncated successful-key i niespójny stary R5T freeze
zachowują dokładne historyczne zakresy.52-bitowy przykład nie jest wynikiem schematu.

## 6. Audyt, replay i historia

Lean4.34.0/Std, GCC14.2.0/C99/LP64, Sage10.9/Python3.14.7; pełne wersje
w TOOLCHAIN.txt.67 modułów,535 twierdzeń, w tym43 nowe. Finalne logi są czyste,
tylko propext/Classical.choice/Quot.sound; bez sorry/admit/native_decide.
Audit.stdout hash `9781a29af91257c49c4b290ee71d3f31d8d80ce8971971a55248e6dedc11b3aa`;
pełne typy hash `ddb426582273e79aeb87465f1ab0e835b0c96ff2f9baf6c30f35b5db5e974bbe`.

Osiem rzeczywistych zmian kontraktu wykrywa checker (capacity, nonce,
adversary cap, K_iid substitution, extra target factor, reversed chi-square,
duplicate abort, false H3 status); no-op przechodzi. To consistency check
definicji, nie dowód przyszłych law comparisons.

Końcowy fresh rehearsal **273/273 PASS**, bez starych olean/cache, z ponownym
C normal/sanitizer i Sage. Dokumenty specyfikacji są jawnie wyróżnione jako
definicje, nie „automatycznie odkryte dowody” z samego hash match.
Po doprecyzowaniu typu przyszłego celu wykonano drugi pełny rehearsal;
oba oraz wersje ledgera zachowano. Failed Lean attempts zachowano osobno.
Standardowy replay po freeze wymaga finalnego zewnętrznego OUTPUTS pin
i zapisuje tylko nowy DEST/REPLAY_RESULT.json.

Sandbox potwierdzono dla W; source/archiwa read-only. Cache/HOME/TMPDIR/
DOT_SAGE/LEAN_PATH pozostawały pod W. Lean używał-j1-M2048/8GiB, joby miały
skończone limity; ASan miał osobny tryb virtual shadow. Nie wykonano KeyGen,
Sign, odczytu sekretów/seedów, instalacji, sieci badawczej, agentów ani Git.

## 7. Gotowe przekazanie H3

H3_INTERFACE.md podaje piny, źródłowe miejsca i dokładną domenę: emitted
(sk,pk), każda osiągalna historia/próba/scalar prefix, aktywne wejście przed
floor(mu), zakres[-2147483283,2147483281], proposal[-365,366] i zdefiniowane s+z.
Wiązać FFT/LDL/residua/FPEMU i computed dyadic dss, nie same finite(mu)/leaves
lub kampanię kluczy. Gdy potrzebny nowy guard, to osobny kandydat i ledger.
H3 nie zostało rozpoczęte w M0.

Prowadzący sesję wykonuje odbiór, import --replay standard i osobny commit.
M0 kończy się na zdefiniowanym kontrakcie i powyższych ograniczonych dowodach.
