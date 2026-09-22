# MiMo — T03 zarchiwizowany, ponowny odbiór przez nowy model

**TASK_ID=FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001**.
ROADMAP_ID=T03, one-root tranche. **FROZEN_AWAITING_REVIEW**,2026-09-22.
Autor MiMo2.6PRO: **PARTIAL_PROOF**. Po przekazanym odbiorze Muse i rozbieżności
hashy właściciel wybrał ponowną weryfikację przez inny model.
[REVIEW_002](CURRENT_REVIEW_TASK.md) jest przygotowany do ręcznego startu.

- REPORT SHA `e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c`.
- OUTPUTS SHA `0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de`.
- [Pakiet autora](stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001/REPORT.md):
 85 OUTPUTS/29 INPUTS,import przez identyczny seed z jawnym aliasem TASK.
- [Archiwum review](validation/2026-09-22-integer-recovery-independent/README.md):
 32 pliki recenzenta,11/11 zapisanych wyników replayu,pełna closure inputów.
 Recenzent potwierdza A/reference+mapping,C/gap lemma i conditional D;
 B-gap≈6086.4 pozostaje OPEN. T03 jeszcze nie otrzymał REVIEWED.
- Różne hashe3 dodatkowych `.sage` w poprzedniej recenzji pozostają zapisane
 w historii. Własny pełny odbiór REVIEW_002 ma samodzielnie ocenić A–D,replay
 i binding. Przygotowany wcześniej mały suplement został zastąpiony decyzją
 właściciela; frozen W autora i pierwszego recenzenta pozostają RO.

**Obowiązkowe uzupełnienie właściciela2026-09-22:**
[rachunek w `.sage` uruchamiany `sage lemma.sage`](documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md),
SHA `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241`.
Dotyczy nowych/zmienianych rachunków i checkerów; istniejący wykonawca
przyjmuje je na granicy kroku i dopina do INPUTS. Frozen W wymaga osobnego
suplementu, bez edycji starego freeze. Pierwotne TASK/bootstrap piny zachowane.

```text
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001
TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/FT1536_ZADANIE_MIMO_REFERENCE_INTEGER_RECOVERY_2026-09-22.md
BASE=1aed8adebb68105e1517ab441046a0bbc6c424e7
```

- [Pełne zlecenie](documents/FT1536_ZADANIE_MIMO_REFERENCE_INTEGER_RECOVERY_2026-09-22.md),
  SHA `bbd1f59e795beb3bb7e46e62d0ae86f4f1aa7464c9cc70f9f074d86b83af6169`.
- [Bootstrap](background/MIMO_INTEGER_RECOVERY_2026-09-22/README.md):1275 członków,
  MANIFEST SHA `c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b`.
- [ROADMAP T03](../../docs/onboarding/ROADMAP.md).

Cel: niezależny exact integer reference z canonical c/klucza/ordered samples,
integrality/congruence,uniform actual-source error do tej referencji i rint
recovery obu vectors. Małe BadPrecast i H6P E<1095 nie zamykają tego obowiązku.
Kryteria PROVED/PARTIAL/counterexample, kontrole, replay i dokładny format
odpowiedzi określa TASK. Częściowy wynik z dokładnym missing type jest akceptowany.

[CURRENT_TASK](CURRENT_TASK.md) dotyczy zakończonego i odebranego T01.
T03 nie jest korektą Family/S01. Nie wznawiaj frozen W autora; recenzent ma
własny REVIEW_W i jeden ręczny start. Nie uruchamiaj drugiego workera.
Wszystkie zapisy MiMo pod jego nowym W w repo,bez systemowego tmp/tmpfs.
Bez Git/publikacji/dudect/relay. Właściciel przekazuje końcowy handoff.
Family/S01 pozostaje osobnym obowiązkiem i bramką publikacji.

Aktualny podział ról właściciela: ten prowadzący przygotowuje prompt odbioru,
a inny wybrany model niezależnie weryfikuje zwrot i wykonuje replay. Status
wykonawcy nie zostaje automatycznie uznany za odebrany wynik.
