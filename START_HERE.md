# FT1536 — start dla nowego modelu

Ten plik zastępuje konieczność czytania całej historii czatu. Autor projektu:
**Niirmata** (Git: `niirmataa`). Zachowuj atrybucję Falcon Project / Thomas
Pornin i licencje. Z właścicielem rozmawiaj po polsku.

## Pierwsze pięć minut

1. Przeczytaj [AGENTS.md](AGENTS.md) — zasady obowiązujące w repo.
2. Przeczytaj [bieżący stan](docs/onboarding/STATE.md).
3. Sprawdź `git status --short --branch` w kanonicznym repo.
4. Ustal rolę i bieżące polecenie właściciela. Sam odczyt dokumentów **nie
   upoważnia do rozpoczęcia aktywnego zadania innego wykonawcy**.
5. Dla pracy badawczej odczytaj [CURRENT_TASK](proofs/ft1536/CURRENT_TASK.md),
   następnie właściwe W/AGENTS i przypięte TASK. Zanim cokolwiek uruchomisz,
   sprawdź, czy nie pracuje już jeden wykonawca tego etapu.

Kanoniczne repo/Git: **`/home/footfalcon/free_falcon_sign`**, gałąź `main`.
Wszystkie nowe etapy, skrypty, logi, cache i replaye trzymaj pod repo.
**Zakaz systemowego `/tmp`, `/tmp/opencode` i tmpfs dla prac projektu.**
Ustaw TMPDIR/HOME/cache obliczeń na ich trwały W. Istniejący alias magazynu
dudect na NVMe jest opisanym w AGENTS wyjątkiem zatwierdzonym przez właściciela.

## Co to za projekt

FT1536 jest badawczym profilem podpisu opartym na kodzie Falcona, z pełnoternarnymi
sekretami i arytmetyką FPEMU. Celem jest argument powiązany z rzeczywistym kodem,
rozkładami, bajtami i zdefiniowaną grą bezpieczeństwa. Projekt ma liczne odebrane
lokalne dowody, ale **nie ma jeszcze pełnego dowodu bezpieczeństwa schematu**.

Nie utożsamiaj: testu z dowodem; zgodności hashy z poprawnością matematyczną;
IID_BUFFER z rzeczywistym SHAKE/ChaCha; one-root z całym Sign; niskiego
prawdopodobieństwa BadPrecast z uniwersalnym Safe16 lub Sign→Verify.

## Czytaj dalej tylko według potrzeby

| Potrzeba | Dokument |
|---|---|
| Najnowsze wyniki, aktywne prace, zakaz publikacji | [STATE](docs/onboarding/STATE.md) |
| Główna ścieżka twierdzeń, jawna kolejka i kryteria zadań | [ROADMAP](docs/onboarding/ROADMAP.md) |
| Osobne bieżące zlecenie MiMo/T03 | [CURRENT_MIMO_TASK](proofs/ft1536/CURRENT_MIMO_TASK.md) |
| Korekty Family/S01, warunek publikacji | [CURRENT_FAMILY_TASK](proofs/ft1536/CURRENT_FAMILY_TASK.md) |
| Niezależny odbiór zwróconych korekt S01 | [CURRENT_FAMILY_REVIEW_TASK](proofs/ft1536/CURRENT_FAMILY_REVIEW_TASK.md) |
| Odbiór częściowej kampanii estymatora S06 | [S06 review](proofs/ft1536/validation/2026-09-22-family-estimator-independent/README.md) |
| Mały niezależny fragment T02.1 | [CURRENT_SMALL_TASK](proofs/ft1536/CURRENT_SMALL_TASK.md) |
| Obowiązkowy rachunek `.sage` / `sage lemma.sage` | [Zasada SageMath](proofs/ft1536/documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md) |
| Prompt oczekującego niezależnego odbioru | [CURRENT_REVIEW_TASK](proofs/ft1536/CURRENT_REVIEW_TASK.md) |
| Model matematyczny i najważniejsze zależności | [PROOF_MAP](docs/onboarding/PROOF_MAP.md) |
| Wznowienie/przekazanie, jeden writer, odbiór | [HANDOFF](docs/onboarding/HANDOFF.md) |
| Pełny indeks checkpointów i workflow archiwum | [proofs/ft1536/README](proofs/ft1536/README.md) |
| Build aktywnego kandydata | [FT1536_ACTIVE_BUILD](provenance/FT1536_ACTIVE_BUILD.md) |
| Magazyn i start dudect | [FT1536_DATA_STORAGE](provenance/FT1536_DATA_STORAGE.md) |

Nie wczytuj rekurencyjnie wszystkich stages/background/work. Na start wystarczą
AGENTS, ten plik i STATE; potem tylko TASK oraz certyfikaty rzeczywiście potrzebne
do zadania. Podsumowanie jest indeksem, nie zamiennikiem przesłanek dowodu.

## Gotowy komunikat startowy

> Pracujesz w /home/footfalcon/free_falcon_sign. Przeczytaj AGENTS.md,
> START_HERE.md i docs/onboarding/STATE.md. Sprawdź status repo i aktywnego
> wykonawcę. Nie uruchamiaj żadnego istniejącego etapu, modelu ani dudect
> automatycznie. Krótko podsumuj stan, otwarte obowiązki i gotowość do mojego
> konkretnego polecenia. Pozostałe dokumenty czytaj wybiórczo według PROOF_MAP.
