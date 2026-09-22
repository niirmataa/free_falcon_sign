# MiMo — nowe zadanie głównego toru T03

**TASK_ID=FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001**.
ROADMAP_ID=T03, one-root tranche. **PREPARED_OWNER_START**,2026-09-22.
Start ręczny w jednym oknie MiMo2.6PRO. Nie jest to korekta Family/S01.

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

[CURRENT_TASK](CURRENT_TASK.md) dotyczy aktywnej Astry/T01. Nie przejmuj jej W,
nie czytaj roboczych wyników jako dowodów i nie uruchamiaj drugiego workera.
Wszystkie zapisy MiMo pod jego nowym W w repo,bez systemowego tmp/tmpfs.
Bez Git/publikacji/dudect/relay. Właściciel przekazuje końcowy handoff.
Family/S01 pozostaje osobnym obowiązkiem i bramką publikacji.

Aktualny podział ról właściciela: ten prowadzący przygotowuje prompt odbioru,
a inny wybrany model niezależnie weryfikuje zwrot i wykonuje replay. Status
wykonawcy nie zostaje automatycznie uznany za odebrany wynik.
