# Astra — osobny matematyczny tor EUF-CMA → MT-ISIS

TASK_ID=FT1536_MATH_EUFCMA_MTISIS_RUN_001. ROADMAP_ID=T12.1.
Status2026-09-23: **PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW**.
Właściciel przekazał zakończony run Astry Fast. Wstępnie potwierdzono4461/4461
członków manifestu; niezależny odbiór zostanie przygotowany po kampanii dudect.
REPORT `fa6bbac7b379d80c256ceb2875a67106a1d7322d84e7ee0cc6b8bddecec7de9a`,
OUTPUTS `a9e3af2ebccc221035024fabc7631fa47a93b841c1611e3e79f28ccf5ee5c98f`.
Pakiet: W/output; pełny handoff: W/HANDOFF.md. Zakończonego runu nie wznawiaj.
Claim:101 twierdzeń w15 modułach,finite-box G16,chi2/Phi/adaptive i operacje
reduktora. Pełny interpreter gry,powiązanie praw warunkowych i bit-cost OPEN.
Przed importem trzeba rozliczyć filtr nazw archive.py dla publicznego
`REPLAY_SEED.sha256`; to zgodny bajtowo manifest replayu,nie pin prywatnego seedu.
Nie zmieniono frozen pakietu ani narzędzia archiwizacji.

- [Pełny TASK](documents/FT1536_ZADANIE_ASTRA_MATH_EUFCMA_MTISIS_2026-09-23.md),
  SHA `0fe2ad810e476e44e6cc3a1bca0bcc409004810cfe4b5424523ba914ac9e0cc3`.
- W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_001`.
- BASE: `c5faaeb6395c8238724494e8000eb6df55e65baf`,main.
- [Bootstrap25 plików](background/MATH_EUFCMA_MTISIS_2026-09-23/README.md),
  MANIFEST SHA `a1fe3416478599c3f19200cdfeedc80e98a1291678dd1c871b3f6e6511d28b15`.
  Identyczna kopia w W/inputs/bootstrap; BASE_PINS i ORIGINS określają źródła.

Najpierw pełne matematyczne prawo Sign i publiczny joint law/symulator,
potem formalny lemat warunkowy: adaptive chi2,konflikty programowania ROM,
indexed extraction do≤Q_H+1 celów,końcowa nierówność Phi i zasoby.
Cel: ordinary EUF-CMA; MT-ISIS jest założeniem trudności,właściwie rozkładowym
i zasobowym. Wszystko w Lean4+Mathlib; rachunek `sage <nazwa>.sage`.

Równolegle do B20/P02,we własnym W. Formalny lemat warunkowy ma własny scope;
istnienie efektywnego samplera,małe e_img/e_sign i most do implementacji są
osobnymi obowiązkami. M0,muH,centrowanie,normę,aborty i kierunek miary zachowaj
dokładnie. Nie utożsamiaj conditional-history z ignorującym obserwacje typem P01.

Workflow: work → niezależny review → zaakceptowane stages → commit main przez
koordynatora jako niirmataa. Wykonawca bez Git/push i bez uruchamiania innych
modeli. Dołączono bibliografię; oficjalne PDF-y zwróciły HTTP403 i nie są
udawane jako pobrane. TASK zawiera samodzielny kontrakt do formalizacji.
