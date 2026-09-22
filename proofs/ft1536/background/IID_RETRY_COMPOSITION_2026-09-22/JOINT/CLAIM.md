# ORDERED_JOINT_KERNEL — teza i zakres

Autor projektu: **Niirmata**. Kod źródłowy zachowuje atrybucję Falcon Project /
Thomas Pornin i jego licencję. Zadanie z 2026-09-21; zakończenie 2026-09-22.

Status: **H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

Kwantyfikacja: każde wymagane emitted/same-STATIC/canonical normalized root entry
z ORDERED/LEFT/POST i każda legalna entry PAST z conditional IID unread tail.
Nie zmieniamy P_key, Emitted, K_seed[E], M0, źródeł ani success event.

1. Oryginalny scheduler ma M=3072 scalar positions, wyprowadzonych z rekurencji.
   Każdy dodatni support prefix daje legalny next scalar entry PRZED instrukcjami,
   z actual bank i correlated terminal A2 budgets. Fault nie pojawia się w tym
   zakresie; rejection stutters nie wykonują caller stores.
2. W **IID_BUFFER**, jeden root invocation wraca prawie na pewno. Joint VALUE law
   to iloczyn adaptacyjnych K_h, nie niezależnych marginals. Wyprowadzono również
   dokładne N/Y, revealed33-byte proposal atoms, pointer/refill/drop law oraz
   stopped fresh-tail. E[T]≤24576. Ghost T≤49152 ma complement <2^-1024,
   bez nowego source abortu.
3. Q_S używa G_h lokalnie conditioned on dokładnym positive source support S_h.
   Q_stop używa G_h na Z i zwraca tag EXIT przed source conversion/update poza S_h.
   Wszystkie parametry w ilorazach pochodzą z TEGO SAMEGO prefiksu.
4. Dla obu Q∈{Q_S,Q_stop}, w przestrzeni ordered VALUE trace:

```
chi2(P||Q) ≤ (1+2^-60)^3072-1
           ≤ 3/(2^50-3) < 2^-48,
TV(P,Q) ≤ 2^-25.
TV(Q_S,Q_stop)=Q_stop(EXIT) ≤ 3072*tau < 2^-50.
```

Tau to dokładny przypięty rational z GAUSS/ERROR_LEDGER, podany w SUPPORT_EXIT.
Bez podwójnego dodania tego samego tail cost. Reverse chi2(Q_stop||P)=∞.
Q_S i P mają ten sam finite support; reverse chi2(Q_S||P) jest finite, z
wyprowadzoną, bardzo luźną majorantą2^811008−1 (nie kryptograficznie użyteczną).
Q_S nie jest na ogół Q_stop conditioned on whole-call survival.

5. Literalny POST suffix jest deterministycznym pushforward dla obu live
   referencji i P; EXIT zachowuje tag. Daje typed event transfer dla JOINT
   BadPrecast obu pre-narrow vectors, bez założenia jego reference probability.
6. Zdefiniowany osobno wspólny source-conditional resource/byte lift zachowuje
   TV i forward chi2 dokładnie. Nie jest implementacją Gaussa lub mostem real PRNG.

Dowód mieszany: kernel Lean / uniwersalna source simulation i analiza
product-measure / exact rational instancje. fully_kernelized=false,
C_compiler_verified=false. Kontrole skończone nie zastępują source induction.

Realny PRNG→IID, joint BadPrecast bound, Safe16, reference integer recovery,
global lattice Gaussian/H6P, retry composition, Sign→Verify, whole real Sign
termination/security/CT pozostają OPEN. Historyczny POST pozostaje PARTIAL_PROOF.
source_changed=false, production_source_changed=false,
new_source_patch_integrated=false, owner_accepted=false.
