# Lista badań — T-THRESHOLD spike 001

Otwarte pytania z priorytetami. Status: **pytania, nie zadania wykonane**.

## P0 — blokujące dalszy tor

1. **Rejection sampling w MPC.** Jak kontrolować bias odrzucania w Klein-samplerze
   prowadzonym na udziałach, bez ujawniania liczby prób? Bias = wyciek klucza.
   Bez tego żaden wariant (A/B) nie jest bezpieczny. Odniesienia: 2026/1300 (73-bit
   precision), ATMACA — techniki, nie protokół.
   **Częściowo rozliczone w spike 004** (`SPIKE004_NOTES.md`):
   (a) jawny bit accept ⇒ jawne T (pełna długość śladu);
   (b) **retained finding:** przy niezależnym reject T ⊥ x (corr≈0) —
       hipoteza „T zdradza |x|" obalona w tym modelu;
   (c) gdy p(accept) zależy od sekretu, T go zdradza (E[T] rozdziela S);
   (d) fixed-window ujawnia indeks / `AllRejected` + nierozliczony bias
       warunkowy.
   **Spike 005:** wybór pierwszego przyjętego **bez otwierania** accept-bits
   (obwód na udziałach; jawny tylko finalny x + 1 bit `found`).
   **Spike 006:** fail-closed na accept-shares (bitność `a(a+1)`, spójność)
   + pomiar biasu abort/retry (F-11: retry vs single = ten sam `x|accept`).
   **Spike 007:** bias **vs target** (TV + max_rel_err) dla `accept_weight`;
   wektory deterministyczne (`deterministic_vector`, `vector_fingerprint`).
   **Otwarte:** Klein, 73-bit Gauss (nie stand-in `accept_weight`), zgodność
   F04/F05, abort/retry vs target przy wysokim `t_max`.
2. **Zgodność F04/F05 z technikami 2026/1300.** Czy MPC Klein-sampler z CCS 2026
   da się przenieść na FT1536 (inna pułapka, własny `G(seed*)`)? Co się psuje
   przy fixed-point / całkowitym silniku? Formalna różnica vs standardowy Falcon.
3. **Obwód `G(seed*)` w MPC.** Czy formalny opis z toru R1 jest złożony
   w obwód mnożeń/addycji przyjmowalny dla progu? Ile rund, ile trójek?
   Czy „klucz nigdy w całości" przetrwa implementację (brak scalania w dealerze
   runtime)?
   **Częściowo adresowane w spike 003:** syntetyczny `G_frag` (32→64 B,
   2-z-3, materiał wyłącznie w udziałach) — kawałek P0.3. Nie jest formalnym
   `G(seed*)` (R1 nie jest lokalne); zgodność z R1 i koszt rund — otwarte.
4. **Fałszywy udział — cichy zły wynik (udowodniony w kiełku 001, test 4).**
   Bez VSS/MAC strona może przekłamać udział i nikt nie wykryje. **To jest
   dokładny powód, dla którego w torze jest Pedersen DKG / SPDZ-MAC.**
   Pytanie: jakie VSS/MAC minimalnie wystarcza dla wariantu B (udział seeda)
   i jaki narzut rund?
   **Częściowo adresowane w spike 002:** Feldman VSS (detekcja fałszerstwa
   udziału, nie pełne malicious-secure MPC). Reszta pytania (SPDZ-MAC na
   otwarciach, Pedersen vs Feldman, narzut) — nadal otwarta.

## P1 — koszt i parametry

5. **Liczba rund vs próg k-z-n.** Ile rund ma `G(seed*)` + sampler dla k=2-z-3
   i 3-z-5? Czy ATMACA <180 rund jest osiągalne dla F04?
6. **Precyzja samplera.** 73-bit wg 2026/1300 — czy tyle wystarczy dla FT1536
   (profile F04/F05)? Jaki jest koszt bitów precyzji w MPC?
7. **Porównanie A vs B na koszcie.** Ile trójek Beavera więcej „zjada"
   udział pułapki (A) vs obwód `G` (B) przy tym samym samplerze?

## P2 — model zagrożeń i formalizacja

8. **Złośliwi uczestnicy.** SPDZ-MAC na całym torze (nie surowy Beaver —
   wymóg E-21). Czy semi-honest + VSS wystarcza na etapie badawczym?
9. **DKG seeda vs DKG pułapki.** Czy Pedersen VSS 4-z-7 z san-dkg przenosi się
   na próg seeda FT1536? Jaki związek z 2-z-3 publikacji pieczęci (DKG-02)?
10. **Formalizacja w kernelu.** Czy `G(seed*)` + próg da się wyrazić w silniku
    formalnym (tor R1 / Free Falcon)? Bez tego brak dowodu „klucz nie istnieje".
11. **Reshare / refresh progu.** `reshare_threshold` w san-mpc to stub.
    Proaktywny refresh udziałów seeda — konieczny przy długim życiu klucza.

## P3 — inżynieria

12. **GhostDB/mailboxy.** Udziały i rundy przez mailboxy (E-21), nie jeden blob.
    Harness kiełka jest lokalny — protokół pocztowy wymaga osobnej roboty.
13. **Zeroizacja upstream.** Lista napraw z `INVENTORY.md` §H (H-28/H-31)
    do ewentualnego portu do san-mpc — poza zakresem tego okna.
14. **Wektory testowe.** Deterministyczne (ziarno jawne) wektory `H_fold`
    i udziałów — hash-piny tam, gdzie zmiana zmienia sens testów.
    **Częściowo (spike 007):** `deterministic_vector` + `vector_fingerprint`
    dla `sample_clear` (StdRng seed). Brak jeszcze pinów `H_fold`/`G_frag`
    w tabeli wektorów — do zrobienia przy formalnym pakiecie wektorów.

---

*Kiełek tego okna odpowiedział wyłącznie na wąski krok: arytmetyka progowa
2-z-2 na fragmencie seeda daje wierne `K[0]`, a fałszywy udział jest cichy.
Nie odpowiedział na P0–P3.*
