# FT1536 — sprawdzone środowisko SageMath i Lean

Zakres: identyfikacja zainstalowanych narzędzi i małe kontrole działania.
To informacja środowiskowa dla kolejnej sesji Codex CLI; nie jest pełnym
replayem historycznego pakietu ani nowym werdyktem o bezpieczeństwie FT1536.

## 1. Narzędzia obecnie dostępne

| Narzędzie | Zaobserwowana wersja | Ścieżka |
|---|---|---|
| SageMath | 10.9 | `/home/footfalcon/.local/bin/sage` |
| Środowisko Sage | Mamba `sage`, Python 3.14.7 | `/home/footfalcon/miniforge3/envs/sage/` |
| Lean | 4.34.0, commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b` | `/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean` |
| Lake | 5.0.0-src+293d5d0, Lean 4.34.0 | `/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lake` |
| GCC | Debian 14.2.0-19, GCC 14.2.0 | `/usr/bin/gcc` |
| Make | 4.4.1 | `/usr/bin/make` |
| Python systemowy | 3.13.5 | `/usr/bin/python3` |
| Git | 2.47.3 | `/usr/bin/git` |

Wrapper Sage wykonuje:

```sh
exec /home/footfalcon/miniforge3/bin/mamba run -n sage sage "$@"
```

W sesji sprawdzającej katalogi lokalnych narzędzi nie były jeszcze w PATH.
W nowej sesji można ustawić je tymczasowo:

```sh
export PATH="$HOME/.local/bin:$HOME/.elan/bin:$PATH"
```

Elan wybiera toolchain także według `lean-toolchain` danego projektu. Wersja
globalna nie zastępuje przypięcia konkretnego pakietu.

## 2. Faktycznie wykonane kontrole

### SageMath 10.9

Import `sage.all` oraz obliczenia ZZ, QQ i RealBallField(512) zakończyły się
kodem 0. Kod wykonano w izolacji z systemem plików tylko do odczytu i cache
wyłącznie w tymczasowym RAM.

```python
from sage.all import ZZ, QQ, RealBallField

gap = (ZZ(2)**24 - 1)**2 - ZZ(4489) * ZZ(2)**35
assert gap == 127234077622273

bound = QQ(4489) / (ZZ(2)**54 * (ZZ(2)**24 - 1)**2)
assert bound < QQ(1) / ZZ(2)**89

R = RealBallField(512)
assert R(2).log() < R(QQ(347) / 500)
```

Wynik: wszystkie trzy kontrole przeszły. Historyczne źródła i certyfikaty
nie były zmieniane ani wykonywane jako runner.

### Lean 4.34.0 / Std

Poniższy kod przekazano bezpośrednio do `lean --stdin`:

```lean
import Std
set_option maxRecDepth 4096

theorem ft1536_final_integer_gap :
    ((2 : Nat)^24 - 1)^2 - 4489 * 2^35 = 127234077622273 := by
  decide

theorem ft1536_final_integer_bound :
    4489 * (2 : Nat)^35 < (2^24 - 1)^2 := by
  decide

#print axioms ft1536_final_integer_gap
#print axioms ft1536_final_integer_bound
```

Exit code: 0. Wyjście:

```text
'ft1536_final_integer_gap' does not depend on any axioms
'ft1536_final_integer_bound' does not depend on any axioms
```

Sprawdzono wyłącznie tę arytmetykę całkowitoliczbową. Nie jest to formalizacja
całego T2C3, jego przesłanek analitycznych ani bezpieczeństwa schematu.
Ten test używa Std, nie mathlib; instalacji i zgodności mathlib jeszcze nie
zweryfikowano w nowym środowisku.

## 3. Historyczne piny wymagają osobnego traktowania

- T2C3/D11E2: dokumenty historyczne wskazują SageMath **9.5** i dokładną
  arytmetykę ZZ/QQ/RealBallField(512).
- `S20-FV-LEAN4-SAMPLER-HYBRID-001-20260827-a1`:
  `lean-toolchain` wskazuje **leanprover/lean4:v4.30.0**,
  a `lake-manifest.json` przypina mathlib do
  **c5ea00351c28e24afc9f0f84379aa41082b1188f**.
- W odczytanym katalogu lokalnych toolchainów znajdował się wyłącznie Lean
  4.34.0. Inne pakiety historyczne mogą mieć jeszcze inne wymagania.

Nowa instalacja jest działającym środowiskiem obliczeniowym. Historyczny replay
powinien użyć pinów konkretnego pakietu albo zostać jawnie zapisany jako
rewalidacja na nowym środowisku. Nie zmieniaj po cichu `lean-toolchain`, locków,
manifestów i historycznych certyfikatów, aby dopasować je do instalacji.

## 4. Zastosowanie w następnym zadaniu

Przeczytaj tę notatkę razem z:

```text
/home/footfalcon/Dokumenty/FT1536_PROMPT_CEL_DOWODU_BEZPIECZENSTWA_2026-09-17.md
```

Przed wykonaniem konkretnego lematu sprawdź jego własny toolchain i zależności.
Zapisz rzeczywiste wersje oraz rozróżnij dokładne obliczenie, certyfikat,
formalny dowód i jawne założenie. Oryginalne materiały z USB i Szablon nadal
stanowią wejścia tylko do odczytu.
