# T01 — zapis niezależnego odbioru IID_RETRY_COMPOSITION

2026-09-22. Autor projektu: **Niirmata**; atrybucja Falcon Project / Thomas
Pornin zachowana. ROADMAP_ID=T01. Status w rejestrze: **REVIEWED**, werdykt
recenzenta: **PASS_SCOPED_REVIEW**. Status matematyczny pakietu pozostaje
**IID_RETRY_COMPOSITION_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

## Role i podstawa zapisu

Właściciel przekazał zakończony odbiór innego, niezależnego modelu wraz z
zewnętrznymi pinami. [Oryginalny REVIEW](review/REVIEW.md),
[REVIEW_RESULT](review/REVIEW_RESULT.json) i wszystkie12 członków
[REVIEW_OUTPUTS.sha256](review/REVIEW_OUTPUTS.sha256) zachowano bajtowo.
Dokładny identyfikator modelu recenzenta nie występuje w przekazanym raporcie;
nie został dopisany przez prowadzącego.

Prowadzący wykonał administracyjne związanie pinów/receiptów z bajtami,
import immutable stage i lokalny checkpoint. **Nie wykonywał nowego replayu
ani własnego odbioru matematycznego.** Pola `owner_accepted=false` w raportach
pozostają zachowane. PASS nie oznacza publikacji lub produkcyjnej akceptacji C.

## Piny

| Artefakt | SHA-256 |
|---|---|
| Author REPORT.md | `b7164dbbee02db248ea43adce1d63ae0a38ed4493a566c5acd3a2f507db14590` |
| Author OUTPUTS.sha256 | `3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074` |
| IID_RETRY_CERTIFICATE.json | `2a91dd43cc3c21486aa8968ebb0e4ae211a603a786e647a257d05174ef39ce2b` |
| Independent REVIEW.md | `8523b1ea63faabdf2d78c602ccf1a5f7aaceba9c71ecc3ee6032c1add02344ec` |
| Independent REVIEW_OUTPUTS.sha256 | `5072eacae41c4eedf6184484385076a5447b538a2f646166e3dc5d872a7ca318` |
| Independent REPLAY_RESULT.json | `e1d441f686e1e61ec1775241a75bb299e90d5fdf5bad197dab97d597051ffd91` |
| VALIDATION.sha256 | `cbc273258e29f1571b97e65e8eba30bd44849e523a3de0dea88e543b11ad2bf8` |

Import:2414 OUTPUTS/1275 INPUTS,52687818 bajtów,integralność PASS.
Archiwum odbioru:939 manifest-listed plików/21222715 bajtów, w tym492
semantic results oraz pełne dostępne logs/receipts świeżego runu recenzenta.
[ARCHIVE_RECEIPT](ARCHIVE_RECEIPT.json) podaje zakres czynności prowadzącego,
proweniencję i ścieżki. Dodatkowy niezapieczętowany inventory `replay_seed.json`
pozostał w REVIEW_W zgodnie z polityką nazw archiwum; nie jest semantic result.

## Świeży replay i ocena recenzenta

Recenzent wykonał **492/492,exit0,662.514s** we własnym
`FT1536_IID_RETRY_INDEPENDENT_REVIEW_001/seed/tmp/independent_001`, ze świeżym
cache, ukrytymi oryginalnymi drzewami i network-off. To nie receipt autora.
[Receipt](replay/REPLAY_RESULT.json) jest identyczny z kopią przypiętą przez
REVIEW_OUTPUTS;492 par path/hash związano z sealed source i zachowanymi bajtami.

Recenzent potwierdził A–F: entry/scheduler/re-entry, filtrację IID,
WholeRegionBad/hazard, checked-precast coupling, wspólne budżety/reset accounting
i exact STATIC bytes. Zachowano jego [niezależny rachunek](review/NUMERIC_CHECKS.json)
i [checklistę](review/CHECKLIST.md). Formalizacja:120 modułów,922 twierdzenia,
26 nowych; granica **mixed source/analytical/kernel**, `fully_kernelized=false`.
To nie pełna kernelizacja programu C ani kompilatora.

## Co wykazano i dlaczego to ważne

One-root H6P zostało skomponowane z rzeczywistą pętlą **do16 osiąganych prób**,
od jednego legalnego post-H2P ReadyRetryEntry, w **G_retry_IID**:

```text
Pr(WholeRegionBad | entry PAST) <= 2^-80
```

Zdarzenie obejmuje obie pre-narrow vectors również w próbach odrzuconych
przez normę. Re-entry/fresh-tail wynikają z source flow; nie założono
niezależności prób ani legalności wszystkich przyszłych wejść.
Coupling zgadza obserwacje source/checked-precast poza tym zdarzeniem.

Na wspólnym zdarzeniu H, w którym każda reached próba ma T_j<=49152,
jednocześnie obowiązują6352 bloki/26017792 wygenerowane bajty oraz pozostałe
budżety. Recenzent potwierdził `Pr(H^c)<2^-1020` ze strict per-root bounds.
Sam bound na total-T nie wystarcza do tego rachunku; failed route zachowano.
Po stored norm acceptance payload STATIC wraz z headerem ma długość<=3160;
nonce40 i prefix H2P leżą poza tym cut.

## Niewygodne wyniki i otwarte obowiązki

- Dwa INPUTS wskazują zmienione później żywe AGENTS/CURRENT_TASK. Dokładne
  oryginały istnieją w sealed `inputs/context/repo_agents.md` oraz
  `inputs/context/CURRENT_TASK.md`; import użył tych bajtów i zachował ich hashes
  w content-addressed objects. Rozbieżność proweniencji pozostaje jawna.
- Floor timeout, odmowy locka, incydent overlap i resource clarification są
  zachowane w author `artifacts/attempts` i `FAILED_ROUTES`, oraz opisane w review.
- `Bad AND success` nie jest `Bad GIVEN success`: nie ma darmowego boundu
  warunkowego na sukces bez dolnej granicy jego prawdopodobieństwa.
- Real SHAKE/ChaCha→IID, H2P prefix, whole real Sign, universal Safe16,
  reference integer recovery, Sign→Verify,security/CT pozostają OPEN.
  Brak nowego eta_pre w M0 i brak zmiany źródeł.

Wynik domyka T01 w przyjętym zakresie. Następny wpis roadmapy to
**T02 PRNG_REAL_TO_IID_BUFFER**, korzystający z tego konkretnego interfejsu
zasobów; osobny T03/MiMo dotyczy integer recovery. T02 nadal wymaga przypiętego
zlecenia i ręcznego startu. GitHub pozostaje wstrzymany do poprawionego Family
i jego pozytywnego niezależnego odbioru oraz późniejszego polecenia właściciela.
