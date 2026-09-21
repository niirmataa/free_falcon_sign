# Niezależny odbiór SCALAR_KERNEL_IID — 2026-09-21

Autor projektu: Niirmata. Odbiór z kanonicznego
/home/footfalcon/free_falcon_sign, rodzic9ae1a434e9abf4723f854d9a0a19c560bc246f9b.
Status: **H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

| Artefakt | SHA-256 |
|---|---|
| REPORT.md | `28a46ed15039e7cb8fc610874ce64cc87436eeeba4ba110beb9ba3152033d903` |
| OUTPUTS.sha256 | `0923f85b0290b4b1e57b4f7af356bd58e327cac68d235805e6a8c78d4e622a8f` |
| SCALAR_KERNEL_CERTIFICATE.json | `70950f0e9d6973a29cc40039a43a9d3098ad46ec445532261b6454ed7feb9245` |
| VALIDATION.sha256 | `aa05c3466709a9bfd80549de1252a858aa932b85c9a87278d66de9494db25efb` |

## Replay i kontrole

Import1556 OUTPUTS/344 INPUTS,80813037 bajtów, PASS. Pierwszy replay zakończył
się na job0: uruchomienie sage --version przekroczyło jego45s limit; żaden
proof job nie został wykonany. Zachowano execution i pełne strumienie błędu.
Osobna bounded/network-off diagnoza tego samego narzędzia zwróciła10.9 po15.482s.
Pakietu ani limitów jego runnera nie zmieniono.

Nowy **maintainer-replay-002**: fresh build/cache/olean, bwrap/network-off,
ukryte Dokumenty/H, **364/364 pliki,146.437s,exit0**, bez timeoutu. Wszystkie
nowe pliki i TMPDIR znajdują się pod trwałym repozytorium. VALIDATION obejmuje
560 plików/49888600 bajtów:20 driverów/executorów,32 kernel receipts,32 native
batches na tryb normal/ASan+UBSan, oba buildy/toolchain, pełne znaczeniowe wyniki,
pierwszy nieudany replay i diagnozę środowiska.

Lean:32 moduły,208 twierdzeń,37 nowych,25 inherited; final logs/types/terms/axioms
czyste. Zgodność normal/sanitized outputs sprawdzona. Kontrole obejmują4096
entry pointers,21114 iteration atoms,54 exact PMFs, CDF/primitive/BerExp/trace
cases i meaningful mutations. Dodatkowy maintainer checker przeliczył exact
CDF differences/sum2^128, Horner intervals/positive atom, wszystkie pointer
transitions i rational lower bound>1/256 oraz jawne scope flags.

## Co wykazano i co to zmienia

**Wyłącznie w jawnej grze IID_BUFFER**: source getter schedule, exact CDF
masses i integer BerExp probability z cutoff/saturation dają iteration weights
w_y i A>=1/256. Source rejection z conditional fresh bytes wyprowadza:

```text
Pr[N=n,Y=y | PAST]=(1-A)^(n-1)w_y
Pr[Y=y | PAST]=w_y/A
Pr[N>m | PAST]<=(255/256)^m; E[N | PAST]<=256
```

Unread tail/future blocks po skończonym return zachowują conditional IID przy
właściwej filtracji PAST. Nie warunkuje się na ich pełnych wartościach.
Każda proposal zwraca33 bytes; source ptr4087/drop/refill i dodatkowe zasoby
są rozliczone. Dodatni atom k0/smaller delta używa maszynowego integer threshold,
a nie założenia exp(-x)>0. Counts/domains mają kernel/exact-integer/QQ wsparcie;
product measure, stopping time i geometric limits są jawną warstwą analityczną.

## Granice i następny krok

**real_prng_to_iid_bridge_proved=false.** Wynik nie dowodzi realnego ChaCha/SHAKE
IID, all-tapes termination lub pełnego source Sign law. Infinite rejection
pozostaje możliwą ścieżką; a.s. w tej idealnej grze nadaje jej mass0, nie return0.
Historyczny POST pozostaje PARTIAL_PROOF, a Safe16/joint BadPrecast/reference
recovery/Sign→Verify/security/CT pozostają osobne.

[NEXT_INTERFACE](NEXT_INTERFACE.md) rozdziela real-PRNG game/loss,
SCALAR_GAUSSIAN_COMPARISON oraz ORDERED_JOINT_KERNEL/H6P. Rekomendowany następny
etap ilościowy: exact K_C kontra niezależna reference Gaussian, z source
remainder/expm domains, CDF quantization, cutoff/finite support, normalizerem
i właściwym kierunkiem miary. Mały błąd lub Gaussian law nie wynika z nazwy
BerExp. [PRNG_GAP_INTERFACE](PRNG_GAP_INTERFACE.md) zachowuje osobny cryptographic hop.
