# FAILED_ROUTES — drogi odrzucone (z liczbami i przyczyną)

Matematyczne (SOURCE_ERROR §2):
- A_coarse via pinned ideal_reference_error 1/4: 887.03 — luźniejsze od refined.
- C1 niezależne boxy: 1165.41 — gorsze od skorelowanej trasy (1078.69).
- C convolution box przez ||G||_1 dla δ: 160471.46 — bezużyteczne.
- H6P niezależny |Lroot|≤2^25 box (cytat): 3.681e9 — przyjęto skorelowaną
  trasę trójkątną.
- Traktowanie H6P E<1095 jako bound recovery: odrzucone (to bound mapy
  innovations z d=0, nie luki integerowej).
- Traktowanie POST iFFT 1/128 jako pełnego budżetu: odrzucone (sam E=0.0078).

Narzędziowe (udokumentowane próby):
- Lean core 4.34: `split_ifs` niedostępny; `if_pos` zdeprecjonowany (wymaga
  suppression — zakazane); omega nie wspiera fdiv/fdiv-mod i tdiv/ediv
  (probe tmp/probe.lean) — rozwiązanie: Int.div/Int.mod + by_cases/simp.
- Pierwszy skład luki z SQRT(4/3) zawyżonym do 4/3 (moja funkcja ceil-sqrt):
  TOTAL 6858.2 zamiast 6086.4 — poprawione na ciasne outward (1e-12),
  crosscheck z pinned graph_basis do 4 cyfr.
- Kontrolny xgcd: błędy po stronie proberów (zip-truncation, zero-tailing,
  zła lista Phi o N zamiast N+1 współczynników) — naprawione; relacja Béout
  i odwracalność zweryfikowane (checks/exact_ring_checks C5).
Przeniesienie py→sage (techniczne, zasada 2026-09-22):
- `QQ(a,b)` (konstruktor ułamka à la Fraction) w Sage: Z_to_Q._call_with_args
  NotImplementedError → użyto `a / b` w ZZ/QQ.
- Sage Integer nie jest JSON-serializable → jawne int()/str() w certyfikatach.
- RealIntervalFieldElement nie ma `.right()` → endpointy przez .upper()/.lower()
  (.exact_rational()) z exact asercją outwardness w QQ.
- Crosscheck isqrt vs RIF: pierwotnie założono kierunek RIF ≥ isqrt (fałsz —
  RIF jest ciasniejszy); zamieniono na obustronny certyfikat outwardness.
- `split_ifs` brak w rdzeniu Lean; omega bez fdiv/tdiv/ediv (patrz wyżej).

- Mutacje algebraiczne wrażliwe tylko na relacje (h/det/target), nie na
  (a,b,c) — uniwersalność jest cechą; przeprojektowane mutacje M_*.
