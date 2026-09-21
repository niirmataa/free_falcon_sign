# Failed routes i zachowane ograniczenia

1. Pierwszy reuse script próbował skopiować scope.py z GAUSS projection, w której
   tego pliku nie ma. Zachowano FileNotFoundError/source draft. Poprawiono
   deklarację reuse do dostępnych pinned inputs i rejestrację częściowo
   skopiowanych plików. Nie sięgnięto do historycznego W jako ukrytego inputu.
2. Pierwszy native POST link nie dołączał source/shake.c, wymaganego przez
   niezależną funkcję falcon_hash_to_point w encoder unit. Undefined
   shake_extract zachowany z draftem/logami; dodano tę samą zależność co POST.
   Funkcja SHAKE/real PRNG nie jest wykonywana przez fixtures.
3. Pierwszy mutation runner wywołał no-op bez flagi expected_equal=True.
   Poprawna równość baseline/changed spowodowała błędny assert harnessu.
   Snapshot/stderr zachowano; naprawiono flagę i ponowiono meaningful controls.
4. M*epsilon=3/2^26 to sound sequentialTVbound, ale luźniejszy od2^-25 z
   directed second moment. Union resourcecapM*768 jest luźniejszy od conditional
   Chernoff cap49152. Oba zachowano jako osobne correct bounds.
5. Reversechi2QS≤2^811008−1 jest finite, ale zbyt luźny do small loss. Nie
   podmieniamy go na forwardkappa,nie nazywamy tego counterexample; Qstop ma
   odrębny support obstruction∞.
6. QS=Qstop|whole-survival jest generic false (exacttoyTV1/10). W dowodzie
   użyto product local factors/tilt,nie globalnego conditioning shortcutu.
7. Samo|Y−mu|≤367 nie zamyka roottransfer. Zużyto źródłowe bank/width
   i paired A2 budgets oraz LEFTcorrelated bridge. Historical ORDERED PARTIAL
   i POST PARTIAL są zachowane; nie ukryto ich pierwotnych ograniczeń.

Pełne failed command receipts i źródła w artifacts/attempts oraz logs.
Nowe Lean przeszły bez failed proof drafts/warning suppression. Analiza
dotyczy conditionalIID; brak realPRNG/higher-level proof jest obowiązkiem
osobnego etapu,nie przemilczaną przesłanką bieżących theoremów.
