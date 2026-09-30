# STABLE_TOP_001 — mały krok fpr_of(3)

Wynik: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Pełny stable-top w toku.

Źródła przypięte przez `_004`: header86–90 fpr_of, C M0 fpr_scaled150–204,
macro norm21–54 i headerFPR39–55. `FprScaledBinding` sprawdza kernelowo
równość parsera z niezaufanym pretty-printem `FprScaledAST`.
Generator transportu: `EmitScaledAST.lean`, `tools/capture_scaled_ast.py`;
próba `.build/jobs/stable_top_emit_scaled_001` zachowuje pełny stdout.

Eksporty:
- `FprScaledBridge.complete/sound`: dokładna zgodność FunctionExec
  skalara z norm block i istniejącym modelem; nie założenie o wyniku.
- `FprOfThree.scaled_three`, `of_three_model`: kernelowe wykonanie
  rzeczywistego argumentu3; kod słowa `0x4008000000000000`.
- `FprOfThree.source_exists : SourceExec (.uint64 three)`.
- `FprOfThree.source_exact (z) : SourceExec z → z=.uint64 three`.

`SourceExec` jest niezależnym `C99ScalarReference.FunctionExec` fpr_of,
z CallRelation instancjowanym source fpr_scaled. Parametr int64 dostaje
rzeczywistą konwersję literalnego C int3. Norma m0 potwierdzona pinami
preprocessor branches; norm locals kończą lifetime przed suffixem.

Accepted/clean: `stable_top_scaled_binding_001`, `stable_top_scaled_bridge_001`,
`stable_top_of_three_003`, `stable_top_of_three_audit_001`. Dwie wcześniejsze
próby of3 miały błędy elaboracji/simp i są zachowane w raw logs.
Audyt drukuje dokładne typy/termy/transitive axioms, tylko standardowe
propext/Classical.choice/Quot.sound. Limity unchanged, warningAsError.

Sage standard preparser: `stable_top_inputs_sage_001`,
`sage check_stable_top_inputs.sage`. ZZ operacje kodu3+norm+FPR oraz QQ
odczyt słowa dają dokładnie3. Skończone checki pętli i mutantów indeksów
są diagnostyką; nie zastępują przyszłego dowodu u=3*v.

Krok nie twierdzi niczego o real-error FPEMU dla pozostałych operacji,
Grama, końcowych leaves ani bezpieczeństwie całego KeyGen.
