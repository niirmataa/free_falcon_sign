# FT1536 — GPT-ASTRA: kontrakt M0

Przeczytaj i wykonaj:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_M0_CONTRACT_2026-09-19.md`.
Wersjonowana kopia znajduje się w
`/home/footfalcon/free_falcon_sign/proofs/ft1536/documents/`.

Oczekiwany SHA-256 zadania:
`a1556c02ab1bb89ce2f1b61d309e946bc15057a7c3c6bb4c173b0d560fe94956`.

Jedyny katalog zapisu:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_M0_CONTRACT_RUN_001`.
Kontynuuj w tej samej rozmowie Astry. Przeczytaj również AGENTS.md repo.
Ustaw rzeczywisty sandbox/cwd na W; source, archiwa, Extra/c i dawne katalogi
wykonawców są read-only. HOME/TMPDIR/DOT_SAGE/LEAN_PATH i cache kieruj pod W.

## Decyzje właściciela

- Uczciwy Sign: pojemność payloadu **4096 bajtów**, z nagłówkiem.
- Nonce ma osobne **40 bajtów**; payload zachowuje zmienną długość.
- Główny cel redukcji jest **parametryczny** w Q_s,Q_H,t,w,L.
- Podstawa: kandydat L_RHO z ukończonym L_V, verifier SHA-256
  `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.

## Zakres

Zdefiniuj dokładne prawo klucza, grę, orakle, framing, obserwacje, zasoby
i ledger metryk/otwartych obowiązków. Sprawdź źródłowo bound długości STATIC
3160 bajtów i syntetyczny przypadek wymagający 3156 bajtów.
Nie nakładaj pojemności uczciwego Sign na payloady przeciwnika.
Zachowaj parametry N/q/Phi/sigma/B i pełny język Verify NONE/STATIC.

Wynik M0 to spójny kontrakt i ograniczone dowody pomocnicze, nie ukończona
redukcja EUF-CMA ani integracja opakowania. Stary CLI nie staje się
implementacją nowych parametrów przez zmianę jego opisu. H3 jest późniejszym
zadaniem; nie rozpoczynaj go podczas wykonywania M0.

Bez KeyGen, nowych kluczy, odczytu sekretów/seedów, instalacji, sieci
badawczej i innych agentów. Nowe Lean mają czyste logi i jawne axioms;
bez sorry/admit/native_decide. Stosuj skończone limity i pełne receipts.
Po freeze wykonaj standardowy replay z finalnym zewnętrznym pinem.
Git, import i commit wykona prowadzący sesję po odbiorze pakietu.
