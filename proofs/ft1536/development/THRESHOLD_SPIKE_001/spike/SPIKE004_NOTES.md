# Spike 004 — rejection sampling w torze progowym (kawałek P0.1)

**Status: POMIAR / PROTOTYP.** Nie Klein-sampler FT1536, nie 73-bit precision,
nie ATMACA. Pytanie P0.1: bias odrzucania na udziałach a jawność liczby prób.

## Ścieżki w kodzie (`src/rejection.rs`)

| API | Co robi | Jawność |
|---|---|---|
| `sample_clear` | jawny rejection (oracle) | x i T jawne |
| `sample_mpc_naive` | kandydaci + **bit accept co rundę** | pełny ślad bitów = jawne T |
| `sample_mpc_fixed_window` | okno `t_max` prób, bez pętli | jawny indeks / `AllRejected` |

Model akceptacji: `x ~ U{-W..W}`, `w(x)=256/(1+x²/σ²)` (stand-in Gaussa, bez `exp`).

## Wynik: 28/28 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 18 unit + 10 integration: ALL PASS
```

| # | Test | Twierdzenie |
|---|---|---|
| r1 | clear w zakresie | sampler działa |
| r2, r5 | naive ślad bitów | **T jawne w całości** (długość śladu = T) |
| r3 | fixed window | brak jawnej pętli; `Accepted{idx}` / `AllRejected` |
| r4 | corr(\|x\|,T) ≈ 0 | **RETAINED FINDING** (patrz niżej) |
| r6 | E[T] rozdziela sekrety | **gdy p(accept) zależy od sekretu, T go zdradza** |

## Retained finding (r4) — hipoteza obalona

Pierwotna hipoteza: „większe |x| → dłuższe T → T zdradza |x|".
**Wynik:** przy niezależnym reject (akceptacja zależy tylko od x) próbki
i.x. ⇒ T ~ geometryczne z parametrem średniej wagi — **niezależne od |x|**
(corr ≈ 0, test r4). Samo ujawnienie T **nie** zdradza wtedy wartości x.

To **nie** zamyka P0.1 — przeciwnie:

1. **T i tak jest jawne** w transkrypcie ścieżki naive (r2/r5) — publiczny
   metadany protokołu (timing, liczba rund).
2. **T zdradza sekret**, gdy p(accept) zależy od sekretu (r6) — klasyczny
   wyciek; w samplerach opartych na pułapce / odrzucaniu względem celu
   warunek ten bywa spełniony.
3. **Fixed window** ujawnia indeks pierwszego przyjęcia (albo `AllRejected`)
   — inny, ale też jawny kanał.
4. Bias warunkowy: jeśli strony **warunkują** wynik na sukcesie w oknie
   (odrzucają całe losowanie przy `AllRejected`), powstaje bias — nierozliczony.

## Czego to NIE jest

- nie Klein-samplerem / Gaussianą Falcona / 73-bit precision
- nie protokołem na udziałach (tu lokalny harness + jawne bity)
- nie dowodem bezpieczeństwa odrzucania
- nie zamknięciem P0.1 ani P0.2

## Następne kroki P0.1 (z tego pomiaru)

- odrzucanie na udziałach **bez otwierania bitu accept** (np. stała liczba
  prób + bezpieczne „pierwszy przyjęty" w MPC)
- rozliczenie biasu przy fixed-window + abort
- odniesienia: 2026/1300 (precision), ATMACA — techniki, nie protokół
