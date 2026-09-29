# T03-B — RUN_002 odebrany zakresowo; integer recovery OPEN

**REVIEWED_SCOPED,2026-09-29.** ROADMAP_ID=T03,
TASK_ID=FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002.
Status matematyczny autora:**BLOCKED_UPSTREAM_EXPORTS**,częściowa algebra
B0/B1 i diagnoza;pełny recovery OPEN. Autor:GPT-6 Astra Fast,
sesja `ses_f13640949ffeJ0RtC7tFAz07UR`,świeży kontekst według HANDOFF.
Własne joby autora zakończone. Frozen W nie wznawiać.

REPORT `b2e8c9af003edee089b49156541e631e3ab8bb01c93f9cad521edf7b66a59dfc`;
OUTPUTS `12df61056ddada2f79c1b94b3b17e8f326db2b3a2cbe53d1694754d79d7958cc`.
1939 plików/75969266B;1437 inputs. Niezależny **PASS_SCOPED_REVIEW** przekazał
GPT-6 Sol Fast (`openai/gpt-6-sol-fast`),świeży kontekst,
sesja `ses_f13139bc5ffeFI41laN8mgF1PA`. Koordynator potwierdził piny/receipty
i import,bez ponownego własnego mathematical review/replayu.

- [Autor w stages](stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002/REPORT.md).
- [Odebrana recenzja](stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001/REVIEW.md),
  115 plików/1946 inputs. REVIEW SHA
  `acad9276fa7e8ed6924b8a1ada1bbf84052be330d3a0e1641a2850f2e6b5d84e`,
  REVIEW_OUTPUTS SHA
  `a4118200de729562ad1e6396c0bb252a204d9a1ee0f7d7ce085db1fb11689956`.
- [Scope,receipty i ograniczenia odbioru](CURRENT_B_GAP_REVIEW_TASK.md).
- Lokalny checkpoint pary: `5ca9abf55b7ea02461463f4253b9b082edade847`,main,
  niirmataa. Import i global verify:44 checkpointy/57 dokumentów PASS.

**Koordynator wskazany przez właściciela2026-09-29:** GPT-6 Astra Fast,
`openai/gpt-6-astra-fast`,sesja `ses_f137502d0ffe6BYk3HEHU1xxZL`.
Prowadzi handoffy,piny,zlecenie niezależnego odbioru,import i lokalny Git.

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

Zwrot RUN_002:15 kernelowych identities **algebra-only**,10-termowy ledger,
lokalny defekt add_C1643±2^-25 bez required-domain membership. Warunkowe
D≈11.07859487,A3≈0.42676412,A1+A3+D+E≈11.51331245 nadal niewystarczające;
nowy uniform source bound=null. Otwarte źródłowe P02/P06 i transport3072
old-target defects;dokładne typy w frozen EXPORT_DEPENDENCIES.json.
Recenzent wykonał własny fresh replay7/7 kroków i10/10 zgodnych produktów,
osobne UBSan/ASan3/3 każde oraz własne Sage/Lean exit0. Scoped PASS potwierdza
algebrę,ledger,diagnozę i jawne blokady;source_gap=null,full_recovery=false.
Wczesne3 stderr własnych prób Sage recenzenta nadpisano;ograniczenie zachowano
w REVIEWER_FAILED_ATTEMPTS.md. Nie odtworzono brakujących logów z opisów.

Granica konsumpcji doprecyzowana w review:A1–D to root-space,E to coefficient-
space. Potrzebny physical inverse I;root-space identity z e stosować przy
e=0,potem dodać E. B=(t−Z)DeltaB i A4+B=−Z DeltaB nie upoważniają do
przeniesienia starej majoranty B przez samą nazwę.

## Folder wykonawcy i odbiór — decyzja właściciela2026-09-29

Jedyny katalog pracy wykonawcy:

```text
/media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002/
```

Źródła dowodów,checkery,wyniki,próby,logi i cache pozostają pod tym W.
Finalny pakiet przekazania ma w korzeniu W: `REPORT.md`, `RESULT.json`,
`OUTPUTS.sha256` i `HANDOFF.md`; pozostałe artefakty i zakres manifestu
według TASK. `inputs/bootstrap` zachowuje przypięte bajty RO.

Kolejność:

1. **Wykonawca → frozen handoff w W.** Podaje koordynatorowi pełne SHA-256
   REPORT/OUTPUTS,rzeczywisty zakres,status oraz zakończenie własnych jobów.
2. **Koordynator → przygotowanie niezależnego odbioru.** Sprawdza integralność
   i przygotowuje przypiętą kopię/prompt. Recenzent wybrany i uruchomiony przez
   właściciela pracuje w osobnym W,ustalonym przy przygotowaniu odbioru.
3. **Recenzent → werdykt i fresh replay.** Poprawki wracają do pracy w W;
   pozytywny odbiór dotyczy wyłącznie wyraźnie zaakceptowanego zakresu.
4. **Koordynator → zaakceptowane stages i commit.** Używa `archive.py`
   do importu autora/recenzji oraz weryfikacji,aktualizuje żywy stan i zapisuje
   lokalny commit na `main` jako niirmataa. Docelowy stage autora:
   `proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002/`.

Wykonawca przekazuje pakiet w W; zapisy do stages/import/Git prowadzi
koordynator po odbiorze. Publikacja wymaga osobnego polecenia właściciela.
Ta instrukcja doprecyzowuje organizację pracy; TASK/bootstrap piny i cel
matematyczny zachowują swój zakres.

## Następny krok

[NEXT_INTERFACE recenzji](stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001/NEXT_INTERFACE.md):
P02 literal arithmetic dispatcher+real-error/caller domains,P06 ordered
placement/ring/physical inverse,potem INTEGER_DEFECT_TRANSPORT z update-add,
splitami i3072 defektami. P07 basis/P10 iFFT+rint mają własne otwarte typy.
Przed nowym zleceniem przypnij potrzebne eksporty i wyznacz własny W;
zakończonych frozen autora i recenzenta nie wznawiaj. P07–P10 nie odblokowano
przez ten scoped PASS. owner_accepted=false,publikacja osobnym poleceniem.
