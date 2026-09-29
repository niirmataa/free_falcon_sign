# Zachowane niepowodzenia i ograniczenia

1. Initial numeric draft zaokrąglał real abs cap w górę do integer, następnie
   ponownie ceil po dodaniu1/2, dostając luźne4572097. Zachowano artifact
   i źródło w artifacts/attempts/initial_numeric_loose_rint_cap. Poprawny
   integral consumer zachowuje rational4572095+1/128, daje4572095. Nie błąd C.
   Snapshot script już zawierał tę poprawkę; pierwotny run/output są w pełnym
   COMMANDS/logs. command.json w folderze snapshotu to ostatni command w chwili
   archiwizacji, nie twierdzenie, że każdy zapisany artifact wytworzył ten command.
2. RintRefinement initial: nieudane omega dla symbolic quotient/remainder,
   dependent rewrite przez Decidable i składnia let. Poprawiono explicit
   Nat.mod_add_div, simp i let delimiter. Potem usunięto rzeczywiście unused
   simp arg Int.mul_zero. Obie wersje/receipts zachowane w attempts; final logs
   czyste, bez warning suppression. Nie zmieniono celu theorem.
3. Independent inverse oracle: pierwsza próba Sage bez jawnego scripts import
   path zakończyła się ModuleNotFoundError. Potem repeated complex-ball powers
   powodowały wrapping radius ~sqrt2^k, tak że enclosure przyk~476 było zbyt
   szerokie dla1/128. Zachowano wszystkie failing enclosure records w
   artifacts/oracle_failure_ifft_dense.json, failed
   source/logs i attempts. To utrata ostrości interval, nie displacement source
   point poza proof bound. Poprawa: każda phase przez exact modular exponent
   modulo4608 i fresh RBF256 sin/cos, wszystkie coefficients przechodzą.
4. Right-only energy nie jest whole-root output bound. Nowy proof sumuje budgets
   obu source-L subtrees i root orthogonal residual row Bperp. x/y raw-error
   niezależnie traciłby Lδ; użyto triangular error decomposition.
5. Luźny raw product X*bs+Y*bL<2^49 wystarcza do primitive domain, lecz nie do
   sensownego rint/precast bound. Weighted source-basis image daje mniejsze
   frequency89531345 i coefficient4572095. Nadal nie daje Safe16.
6. Future norm acceptance⇒Safe16 jest niedozwoloną implikacją. Wykonany
   EXTENDED_LOCAL_SUFFIX wrap witness65536→0,Q0 obala ją na nadzbiorze. Nie ma
   emitted/P_key/source sampler membership, nie jest required-domain witness.
7. Mathematical inverse-evaluation LEFT nie certyfikował source iFFT;
   floor ZERO nie dowodzi rint; M0 length nie dowodzi bytes; L_V Verify→Ext0
   nie daje Sign→Verify. Nowe operational refinements zamykają pierwsze trzy
   gaps, reference integer/sign correctness pozostają osobne.
8.13 meaningful model mutations+noop rzeczywiście wykonano, pełne changed/
   baseline evidence w artifacts/mutations: binary sign,stale copy,wrong suffix
   scale,iFFT order/conjugation/scale,ties-away,omit narrowing,future norm,
   j7,omit terminator,nonzero padding,early header. Są kontrolą falsyfikowalności
   modeli względem pinned native observations, nie production source changes.

Cała historia command/stdout/stderr pozostaje w scope, także failures.
Brak final required-domain counterexample lub twierdzenia probability0.
