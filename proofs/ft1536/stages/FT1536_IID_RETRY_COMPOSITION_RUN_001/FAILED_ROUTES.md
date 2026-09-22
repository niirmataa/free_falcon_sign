# Nieudane i ograniczone drogi

1. Pierwszy inherited Floor build miał180s timeout/exit−9 bez stdout/stderr.
   Snapshot: artifacts/attempts/floor_start_timeout. Ten sam source SHA
   cf4e4442f0b188eb32b123a954db9ce8f27f9bca1f0373c13cbfad6f3a7dd9f1
   przeszedł ponownie w34.514s bez edycji lub zwiększania limitów, a pełny
   rebuild/audit120 modules później przeszedł. Przyczyny timeoutu nie
   ustalono. To failure wykonania, nie matematyczny counterexample.
2. Kilka prób startu podczas istniejącego bounded job zostało odrzuconych
   przez nonblocking executor.lock (BlockingIOError/EAGAIN). Diagnostyka
   wskazała python3 PID598874. Nie wymuszano locka ani drugiego workera.
   Te odmowy następują przed logowaniem joba w run.py; niniejszy opis jest
   zapisem obserwacji narzędzia, nie dorobionym COMMANDS receipt. Przy
   kontynuacji lock był wolny, a batches0–2 już miały completed receipts.
3. Początkowy resource JSON podawał block budget i total-T tail, ale nie
   nazywał jawnie wspólnego sufficient eventu. Doprecyzowano H=każdy reached
   T_j<=49152. Archiwum resource_budget_clarification zachowuje poprzednie
   źródło/cert. Nie używamy samego total-T boundu do6352 blocks.
4. Przenoszenie jednej pointer equation przez re-init gubi porzucony tail;
   pomijanie initial refill gubi4096 bytes każdej reached próby. Exact
   countermodels/mutations zachowano. To błędy modeli, nie ustalone błędy C.
5. Independence of retry outcomes, accepted-only Bad i conditioning on
   positive return bez mianownika są błędnymi drogami. Patrz COUNTERMODELS.
6. Generic stopped-union lemma nie dowodzi source applicability. Ten brak
   zamknięto osobnym current-entry/frame/init/fresh-tail induction, bez
   assumed all-future legal entries. Formalizacja pozostaje jawnie mixed.

Aktualny source unchanged, brak nowego required-domain counterexample.
Real PRNG, full Sign, H2P prefix, universal Safe16 i correctness/security
nie są domknięte przez ten wynik. To wyraźny scope, nie przemilczane PASS.
