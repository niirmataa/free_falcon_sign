# Niezależny odbiór ORDERED_JOINT_KERNEL — 2026-09-22

Odebrano **H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**,
na kanonicznym `main` z parentem
`683b71be3e5f988d494431e46ac643169d93764a`.
To mieszany dowód kernelowy/analityczny/źródłowy dla **jednego required
emitted/canonical root invocation, warunkowo na legalnej entry PAST w IID_BUFFER**.
Odbiór nie jest owner acceptance ani nową integracją źródeł.

## Piny i odtwarzalność

| Artefakt | SHA-256 |
|---|---|
| REPORT.md | `b150ca1284600dbda3a40ae3656a2058d8a6c0f3b7cfb1e38d15a9ccc5e78c59` |
| OUTPUTS.sha256 | `da8cfccceea6837fc21edd04e46157351d91ad2d317a37286c05f41f3126e263` |
| ORDERED_JOINT_CERTIFICATE.json | `2461bfa9d86f246117634bd453716fd076c669aedbe5300894993a0c78921768` |
| 17-file candidate manifest | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| VALIDATION.sha256 | `d8071abebcd6c30a571e5023d32de3ef9c3233a3b0e58106084b68b85dee236f` |

Import zachowuje2596 outputs i759 publicznych inputs,109017387 bajtów.
Niezależny `maintainer-replay-001` wystartował2026-09-21T22:43:06.183209Z
(22 września00:43 CEST), zakończył się po **254.985s**, exit0, bez timeoutu:
**359/359 semantic files**, `FRESH_REPLAY_PASS`, `source_scope_unchanged=true`.
Odtworzenie ze świeżego project cache w bwrap/network-off/W-only; oryginalne
Dokumenty i historyczne H były ukryte. Wszystkie nowe dane są na trwałym dysku
pod `/home/footfalcon/free_falcon_sign/proofs/ft1536/`.

[VALIDATION.sha256](VALIDATION.sha256) obejmuje **721 plików,54714833 bajty**:
pełne driver/executor/kernel/build/native/toolchain receipts i strumienie,
359 plików znaczeniowych, zachowane kontrmodele i failed routes oraz
[capture.py](capture.py) i [review_checks.json](review_checks.json).
Skrypt sprawdza bajty i zakresy, a także niezależnie dokładną arytmetykę
majorant drugiego momentu, TV, support exit i resource Chernoff bound.

Kontrole:114 modułów Lean,884 twierdzenia (37 nowych),107 niezmienionych
modułów zależnych; czyste logs/types/terms/axioms. Po9 native batches w normal
i ASan/UBSan:6148 scalar calls,9376 proposals,4096 start ptrs, dwa root tapes,
oba signed-zero terminal cases i4 suffix/codec controls. Cztery małe exact QQ
adaptive trees,12 wykrytych mutacji i no-op. Synthetic roots nie mają
Emitted membership; finite controls nie zastępują uniform source argumentu.

## Co rzeczywiście jest PROVED

1. **Actual3072-call source order i domknięcie każdego dodatniego prefixu.**
   Root/binary right-before-left, cubic2→1→0, terminalmu1 przed updatedmu0.
   Każdy dodatni atom ma skończony normal-return byte witness. Następne domeny
   wynikają z entry, rzeczywistego prefixu i ORDERED/LEFT; nie założono legalności
   przyszłych centers ani przyszłego norm acceptance. Rejection stutters nie
   zmieniają caller words; projection do Y ma jawny frame.
2. **Exact adaptive law**, product conditional kernels na tej samej historii,
   także joint N/Y i revealed-byte/resources. Nie są to independent marginals.
   Z A_h>=1/8 wynika a.s. powrót całego root w IID_BUFFER i stopped fresh tail.
3. **Jawne Q_S i Q_stop.** Pierwszy lokalnie normalizuje G_h na dodatnim
   source support; drugi opuszcza referencję przed C conversion/update dla
   niedopuszczonego draw. Na live paths Q_stop(Y)=Q_S(Y)*product(1-t_h).
   Q_S na ogół nie jest Q_stop conditioned on whole-call survival.
4. **Kierunkowe porównanie całego Y** z obiema referencjami:
   `chi2(P||Q)<=(1+2^-60)^3072-1<2^-48`, `TV(P,Q)<=2^-25`.
   `TV(Q_S,Q_stop)=Q_stop(EXIT)<2^-50`.
   Reverse chi2(Q_stop||P)=infinity; osobny bound dla Q_S wynosi
   `2^811008-1` i jest bardzo luźny. Wspólny conditional resource lift jest
   konstrukcją dowodową, nie implementacją Gaussian samplera.
5. **Zasoby:** E[T]<=24576 proposals. Conditional MGF, bez niezależności
   kolejnych N_i, daje `Pr[T>49152]<2^-1024`. Literal getter schedule zachowuje
   `ptr+33T+D=4096R+q`, z discard<=9R i brakiem resetów między calls.
   Cap49152 to ghost event, nie nowy abort źródła.
6. **Deterministic POST pushforward i transfer zdarzenia H6P** dla obu
   pre-narrow vectors. Dla live BadPrecast, q=Q(B),
   `p<=min(1,q+min(2^-25,sqrt(Delta*q*(1-q))))`.
   Włączenie EXIT do zdarzenia wymaga innego q; nie wykonuje się suffixu na EXIT.

## Niewygodne wyniki i granice

- Zachowano exact kontrmodel local conditioning vs whole survival (TV1/10),
  local positive-proposal/zero-acceptance atom oraz synthetic source tapes
  z tym samym Y/POST, ale różnymi N i zasobami. To różne, jawne zakresy.
- q=reference BadPrecast probability pozostaje **OPEN**. Nazwa Gaussian nie
  daje globalnej lattice law dla actual source raw-L/stable-D/iFFT/rint map.
- Safe16 nie jest uniwersalnie dowiedzione ani obalone na required domain.
  POST zachowuje historyczne PARTIAL_PROOF. Stored norm test nie kontroluje
  automatycznie wartości sprzed narrowing.
- Real SHAKE/ChaCha→IID_BUFFER, retry/whole-call composition, integer recovery,
  Sign→Verify, whole real Sign termination/security/CT pozostają otwarte.
  `fully_kernelized=false`, `C_compiler_verified=false`, `owner_accepted=false`.

## Ocena i następny krok

Mamy już spójny rozkład całego adaptacyjnego root i sposób przenoszenia
prawdopodobieństwa zdarzenia z referencji na model kodu. To istotny postęp
względem samych lokalnych Gaussian bounds. Brakuje jednak wartości q w tym
wzorze. Następny konkretny obowiązek to **H6P_REFERENCE_BAD_EVENT**: źródłowo
uzasadniony joint tail dla obu pre-narrow vectors pod zdefiniowaną referencją,
z pełnym rachunkiem transformacji, błędów zaokrągleń i lokalnej normalizacji.
Źródła oraz odłożony nocny dudect mają własne, odrębne workflow.
