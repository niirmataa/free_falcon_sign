# Granica „żaden proces nie zna pełnego materiału"

**Status: granica eksperymentu — nie zamknięta.** Zgłoszone przez właściciela.

## Co było źle

1. **`verify_consistency` interpolowało jawny wielomian** (`interpolate_poly`,
   Vandermonde) — współczynniki zawierają `a0 = f(0) = sekret`. Kontrola
   „spójności" **odtwarzała sekret** w pamięci wywołującego.
2. **Harness lokalny** (jeden proces testowy) trzyma wszystkie kolumny udziałów
   (`Vec<Vec<Share>>`), więc jakakolwiek własność „żaden proces nie zna
   materiału" **nie wynika** z tego kodu.
3. **Dealer zna wejście** (model testowy) — przy `shamir_share` / `split_seed`
   sekret istnieje w całości w dealerze w momencie podziału.

## Co naprawione (algebra / API)

| Zmiana | Skutek |
|---|---|
| `interpolate_poly` **usunięte** | brak ścieżki kontroli tworzącej `a0` |
| `eval_lagrange(shares, x)` | eval **tylko w x≠0**; `x=0` → `XZero` |
| `verify_consistency` | porównanie `f(x_k…)` vs udziały — **bez f(0)** |
| `PartyView` | typ trzyma **jedną kolumnę** (x + udziały bajtów); Drop zeroizuje |

Testy: `b1_consistency_never_evaluates_at_zero`, `b2_party_view_single_column`.

## Czego NIE naprawiony (i co trzeba, żeby twierdzenie było prawdziwe)

1. **Rozdzielenie procesów / hostów** — strony jako osobne procesy; `PartyView`
   to kontrakt API, nie izolacja pamięci w tym samym binarium.
2. **Dealer bez wejścia** — DKG (Pedersen VSS, san-dkg) lub distributed input;
   do tego momentu dealer zna seed.
3. **Rekonstrukcja tylko w kontrakcie** — `reconstruct` / `open_*` to jawny
   „moment"; w torze produkcyjnym otwarcie musi być regułą, nie helperem
   testowym dostępnym z jednego procesu.
4. **SPDZ-MAC / złośliwi** — nadal poza zakresem.

## Formułowanie twierdzeń (obowiązuje)

| Twierdzenie | Czy prawdziwe? |
|---|---|
| „K[0]/G_frag powstaje z udziałów bez odtwarzania seeda w obwodzie" | **TAK** po usunięciu `interpolate_poly` |
| „Kontrola spójności nie tworzy f(0)" | **TAK** (`eval_lagrange` x≠0) |
| „Żaden proces nie poznaje pełnego materiału" | **NIE** — patrz niżej po spike 008 |
| „Threshold signing / bezpieczny próg" | **NIE** |

### Po spike 008 (izolacja procesów)

| Twierdzenie | Czy prawdziwe? |
|---|---|
| „Po wyjściu dealera party×3 i mailbox nie mają seeda ani cudzych kolumn" | **TAK** (demo `iso`, test `s8_process_isolation_demo`) |
| „Dealer nie zna seeda" | **NIE** — model testowy; DKG osobno |
| „Pełny G_frag/Beaver między procesami bez agregacji" | **NIE** — cząstkowo w demo |
| „Żaden proces w produkcji nie zna materiału" | **NIE** do czasu 1–3 ze `SPIKE008_NOTES.md` |

### Po spike 009 (G_frag między procesami)

| Twierdzenie | Czy prawdziwe? |
|---|---|
| „64 muls G_frag między 3 procesami; party nie mają cudzych kolumn" | **TAK** (`iso full`, `s9_g_frag_across_processes`) |
| „Mailbox widzi tylko jawne maski (d,e)" | **TAK** |
| „Dealer nie zna seeda" | **NIE** — nadal model testowy |
| „Żaden proces w produkcji nie zna materiału" | **NIE** — DKG + audyt syscalli otwarte |

### Po spike 010 (DKG seeda)

| Twierdzenie | Czy prawdziwe? |
|---|---|
| „Seed = ⊕ s_i nie istnieje w żadnym procesie jako całość (przed oracle)" | **TAK** (brak `seed.bin`; DKG deals) |
| „G_frag z DKG-seeda == `g_frag_local(seed)`" | **TAK** (`iso dkg`, `s10`) |
| „Preprocessing trójek bez dealera" | **NIE** — `triple-dealer` (jak SPDZ preprocess) |
| „Żaden proces w produkcji nie zna materiału" | **NIE** — s_i w oracle, semi-honest, brak audytu syscalli |

*Właściciel: jeśli wymagacie testu izolacji procesów — to osobny spike
(osobne procesy + IPC), nie komentarz.* → **zrobione: SPIKE 008**, reszta
punktów otwarta (DKG, pełny protokół między procesami, audyt syscalli).
