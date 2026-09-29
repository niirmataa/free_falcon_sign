# Własne próby V02 — zachowane wersje

- `own_sage_001` exit1: w `.sage` `^` to potęgowanie, a XOR wymaga `^^`.
  Źródło i stderr zachowane. Po korekcie `own_sage_002` exit1: Sage `~n`
  jest odwrotnością w QQ, nie bitowym NOT; maskę poprawiono przez `M64 ^^ n`.
- `own_sage_003` exit1: CLI Sage nadało `__file__` plikowi site-packages,
  próba zapisu tam odrzucona przez RO. Wersja 004 liczyła 1437 wierszy,
  ale exit1 przy serializacji Sage Integer do JSON; `version()` dodatkowo
  emitowało DeprecationWarning. Wersja 005 i receipt-complete `own_final_001`
  używają `Path.cwd()`, jawnego `int` i `sage.version.version`: exit0,
  czysty stderr i identyczny wektor SHA. Nie twierdzimy, że cztery nieudane
  wersje są zielonymi obliczeniami.
- `own_lean_001` exit1: `by decide` bez rozwinięcia rint/floor/pack domain
  oraz brak bezpośredniego importu RintExec; druk w *nieudanej próbie*
  zawiera `sorryAx` z otwartego goalu. `own_lean_002` exit1: błąd nawiasów
  we własnym `change` i brak importu taktyki `norm_num`. Dopiero 003 oraz
  `own_final_001` exit0, bez ostrzeżeń i bez `sorryAx`; są to finalne źródła.
- `fresh_replay_audit` pierwsza próba exit1: własny komparator szukał
  `.py` w `argv[-1]`, podczas gdy kontrolery mają tam argument `normal`.
  Wersja 002 używa faktycznego `argv[-2]`; 43 kroki/16 produktów/45
  child commands potwierdzone bez ponawiania pełnego replayu.
- Pierwsze `check_inputs.py` miało omyłkowo skrócony literal TASK SHA;
  failed raw logs 001–004 zachowane, poprawione pełne piny i exact-set
  potwierdzone w runie 005, after oraz final. Nie było rozbieżności
  zautoryzowanych wejść: błędny był literal własnego checkera.

`evidence/failed_attempts/` zawiera dokładne źródła i logi prób Sage/Lean
(oraz wszystkie własne nieudane stdout/stderr). Wczesne wersje skryptów
organizacyjnych `check_inputs.py` i `audit_fresh_replay.py` były edytowane
w miejscu i nie mają osobnych source snapshots sprzed korekty: zachowano
ich raw błędy, lokalizację wadliwego warunku i końcowe źródła, lecz nie
przedstawiamy rekonstrukcji jako oryginalnych bajtów tych prób;
`evidence/own_final/` zawiera jedyny końcowy receipt kompletny
start/stop/argv/cwd/source-before-after/log/exit. `v02_fresh_001` wykonano
tylko raz. Historyczne sześć nadpisań P02 pozostaje odrębnym ograniczeniem
autorskiego archiwum, nie nieudaną próbą V02.
