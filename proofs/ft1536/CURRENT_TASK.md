# Bieżące zadanie Astry — ręczny start

**TASK_ID: `FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001`**

Stan przygotowania: **PREPARED_OWNER_START** (2026-09-22). To wskaźnik
zlecenia, nie potwierdzenie uruchomienia lub wynik badania. Rzeczywisty postęp
i finalny handoff znajdują się w poniższym W.

```text
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001
TASK=/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H6P_REFERENCE_BAD_EVENT_2026-09-22.md
BASE=22e6dd41507a0e990b584dad8d1f4c8834d4c289
```

- [Pełne zlecenie](documents/FT1536_ZADANIE_ASTRA_H6P_REFERENCE_BAD_EVENT_2026-09-22.md),
  SHA-256 `cdaa0ed0ce877774e5ba914329d6ceb71b7df756152ab47c8c2006d47683c9c7`.
- [Bootstrap](background/H6P_REFERENCE_BAD_EVENT_2026-09-22/README.md),1144 członków;
  MANIFEST SHA-256 `4e66e844d425ab9cd8cc6441f4852101f48acfcc178de0d6988f0ec785e42369`.
- Poprzedni ORDERED_JOINT_KERNEL zakończony i odebrany w `22e6dd4`:
  [niezależny odbiór359/359](validation/2026-09-22-ordered-joint/README.md).

Cel: źródłowo uzasadniona majoranta reference joint BadPrecast probability
dla obu pre-narrow vectors, a następnie one-root IID transfer. Pełny zakres,
statusy i kryteria domknięcia określa TASK.

Przy starcie/wznowieniu porównaj TASK_ID, W i piny z W/AGENTS.md. Historyczne
TASK/AGENTS/prompty/runners w stages, background i starych W nie wybierają
bieżącego zadania. Nie uruchamiaj ponownie ORDERED_JOINT. Jeżeli nowy W ma
już sealed OUTPUTS i finalny handoff, zwróć istniejący wynik zamiast powtarzać
obliczenia lub modyfikować freeze. Nocny dudect ma odrębny start właściciela.
