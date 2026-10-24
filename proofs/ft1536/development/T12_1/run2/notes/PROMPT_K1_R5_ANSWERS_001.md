# ZADANIE: R1 → T-THRESHOLD — odpowiedzi K1 + minimalny zestaw R5

Małe okno boczne (NIE przerywa głównej trasy R1; osobne zadanie).
Cel: przygotować dla toru T-THRESHOLD komplet odpowiedzi z R1
i zapisać je DO PLIKU w W spike'a:

`proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/K1_R1_ANSWERS.md`
(+ ewentualne załączniki pinów w tym samym katalogu, np. R5_MINSET.md).

## Zasada nadrzędna
Każda odpowiedź ma źródło (ścieżka + linia / pin / commit).
Czego R1 jeszcze nie ma — odpowiadasz **„OPEN w R1"** z precyzyjnym
opisem, kiedy będzie i co dokładnie jest potrzebne. Żadnego
zgadywania; to dane dla projektu MPC, fałszywa odpowiedź = zły obwód.

## Materiały źródłowe (tylko czytaj; R1 jest kanoniczne)
- `source3/notes/run/KEYGEN_PUBLIC_FORWARD_159_REPORT.md` (evaluate,
  Outcome, Packet — sygnatury i struktura),
- `source3/notes/run/R5_R1_INTERFACE_NOTES.md` (jeśli jest) oraz
  `KEYGEN_R1_TAIL_TODO.md` (stan regionów, OPEN),
- `run2/notes/` raporty checkpointów 192–194 (seed9, ENTRY_PINS,
  Accepted env input seed),
- `work/FT1536_THRESHOLD_SPIKE_001/spike/K1_R1_QUESTIONS.md`
  (lista pytań — definicje).
Źródła C: `Extra/c` (struktury keygen: pk 2881 B, sk ≤ 10370 B).

## 9 pytań K1 — odpowiedzi z dowodami
1. G(seed*) = SHAKE/XOF czy algebra? (koszt MPC; 1 perm ≈ 10³–10⁵ × G_frag)
2. Ile bajtów wyjścia / ile kroków w regionach 2–4 (NTT, root)?
3. Czy wolno liczyć mnożenia na udziałach w regionach 2–4 jako model kosztu?
4. Kanoniczny artefakt packet — pin/hash do testów?
5. Czy evaluate = some (.inr packet) jest owner-accepted czy OPEN (region 5)?
6. Czy env/input można zamrozić jako pin interfejsu (seed9)?
7. Failure (.inl) — domknięta forma fail-closed dla obwodu MPC?
8. Dół: 2^-256 atom vs certified_set_lower — które wiążące dla progu?
9. Stop-and-report przy rozjeździe pinów/hash — ownership w R1?

## Minimalny zestaw R5 §2 — co dostarczyć (statusowo)
(a) Sygnatura evaluate / Outcome / Packet (Lean) — dokładne typy.
(b) Postać packet po emit: secretBytes / publicBytes, pk 2881 B,
    sk ≤ 10370 B — rozkład bajtów.
(c) Relacja Accepted env input seed + seed9 (jawny fixture) —
    jeśli fixture istnieje: podaj; jeśli nie: „OPEN — brak fixture".
(d) Dowód package_of_witness na seed9 — UWAGA: świadek R1 jest
    w toku (G(seed*) nie domknięte) → odpowiedź statusowa:
    „OPEN — zależne od domknięcia świada; oś czasu wg KEYGEN_R1_TAIL_TODO".
(e) Zgodność pinów/hash (SHA-256 artefaktu) — format pinów R1
    (ENTRY_PINS/postseal) + uzgodnienie z VECTOR_PINS spike'a.

## Zasady
- Zapisujesz WYŁĄCZNIE plik(i) w katalogu `spike/` W thresholda
  (K1_R1_ANSWERS.md [+ R5_MINSET.md]); nie ruszasz kodu spike'a,
  akt R1 ani niczego pod work/ poza tym plikiem.
- Struktura odpowiedzi: `## Pytanie N — odpowiedź: <treść>
  źródło: <dowód>; status: POTWIERDZONE / OPEN / BRAK DANYCH`.
- Na końcu trzy zdania: co R1 dostarcza teraz / co OPEN i kiedy /
  czego odpowiedzi NIE rozstrzygają.
- Bez push, bez commitów (plik w obcym W — właściciel/koordynator
  zdecydują o commicie).
