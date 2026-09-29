# T03-B — RUN_002 przygotowany do ręcznego startu

**PREPARED_OWNER_START,2026-09-29.** ROADMAP_ID=T03,
TASK_ID=FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002.
Wykonawca/model/kontekst: do wyboru właściciela; nieuruchomiony.

- [TASK](documents/FT1536_ZADANIE_T03_B_GAP_FIX_2026-09-29.md), SHA
  `c10d50304e8272df1f8367c5e19a432a0746e1239d1d7029c4447b20df75781a`.
- W: `proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002/`.
- Bootstrap1396 plików,32721541 B; MANIFEST SHA
  `a47dc77e48fb521b17de30115be67dca9e97221063e6b001af5cb4db4bc63f9f`.
- BASE `0f51e3278eaa484a09b9ce6a77b2d5be35210d3e`,main;
  repo `/media/footfalcon/FT1536_DATA/free_falcon_sign`.
- [Przygotowawczy rachunek i logi](background/T03_B_GAP_2026-09-29/README.md).
- [RUN_001 i odebrany historyczny scope](CURRENT_MIMO_TASK.md).

Cel: pełny source-bound błąd obu pre-rint vectors do niezależnego v_ref
**<1/2** i actual wide-rint recovery. B0:spójny ledger; B1:suffix D/target A3;
B2–B4:basis/tree/terminal; B5:kernelowa suma i rint. Rozwija P07–P10,
z jawnymi brakami P02/P06 i dalszych konkretnych source exports.

**Ważna korekta ścieżki:** trzy wskazówki ze starego SOURCE_ERROR§3 nie
wystarczają przy zachowaniu reszty ledgeru: D≈15.6675, A3≈0.432907;
po idealizowanym wyzerowaniu wskazanych rodzin pozostaje16.10836.
To wynik rachunku majorant, nie kontrprzykład źródeł. B-gap nadal OPEN.

## Prompt do ręcznego przekazania wybranemu wykonawcy

> Pracujesz w `/media/footfalcon/FT1536_DATA/free_falcon_sign` jako wykonawca
> `FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002` (T03-B). Przeczytaj AGENTS,
> START_HERE, STATE, CURRENT_B_GAP_TASK, własne W/AGENTS i przypięty TASK.
> Sprawdź ownership, piny bootstrapu/source17 i required exports. Zapisz swój
> model/kontekst w HANDOFF. Wykonaj B0–B5 z pełnym budżetem A–E; zacznij od
> ledgeru i source suffix D/A3. Stare progi §3 nie są proved premises.
> Wymagane Sage .sage + Lean4/Mathlib kernel i source binding. Wszystkie
> zapisy pod własnym W,bez Git/push/subagentów/relay. Oddaj jeden frozen
> handoff z REPORT/OUTPUTS SHA, rzeczywistym zakresem i zakończonymi jobami.

Właściciel uruchamia jeden model; po handoffie osobny niezależny odbiór.
Przygotowanie nie zmienia statusów P07–P10 ani historycznego T03 PARTIAL.
