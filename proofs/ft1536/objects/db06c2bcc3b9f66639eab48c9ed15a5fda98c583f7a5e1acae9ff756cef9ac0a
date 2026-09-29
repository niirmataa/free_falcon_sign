# P02 — cel i kolejność formalizacji (robocze)

Obowiązuje cały TASK przypięty w inputs/task/TASK.md. Cztery wymagane rodziny:

1. `B20.Word.load_store_le_refines`: legalna pamięć i zakres adresów LP64;
   wykonywanie pinned dec64le/enc64le daje little-endian BitVec64, round-trip
   i zachowanie pamięci poza ośmioma bajtami.
2. `B20.Fpr.add_sub_mul_div_sqrt_refines`: osobne jawne domeny operacji,
   definedness i oszacowanie błędu rzeczywistego wyniku przypiętej implementacji.
3. `B20.Fpr.floor_rint_refines`: semantyka literalna wordów; w odpowiedniej
   domenie floor z wyjątkiem raw −0 oraz nearest-ties-even rint. Sama finite
   nie upoważnia do matematycznego kontraktu dla arbitralnie dużych liczb.
4. `B20.Fpr.reachable_domain_interfaces`: konkretne typy caller→Domain;
   ich instancje nie mogą wynikać wyłącznie z historycznego mixed proof.

Pierwszy komponent P02: domknąć konwersję CExec→eval dla odebranego fragmentu,
następnie słowa/pamięć oraz unsigned/signed split-shift helpers z legalnością
wszystkich countów. To prerequisites pozostałych rodzin, nie zmiana celu.

Source binding musi wiązać bajty wejścia, wybór fragmentu, translację operatorów
i wykonanie. Equality do ręcznie przepisanej funkcji lub tabela fixture nie
zamykają source-refinement. Importowane P01 zostaje niezmienne; dodatki mają
własne pliki i nazwy. Żaden brakujący eksport nie zostanie zastąpiony aksjomatem.

Status po WORD_HELPERS_001: są robocze kernel-checked eksporty trzech literalnych
shift helpers,konwersu/determinizmu CExec P01 i abstrakcyjnego memory round-trip.
Dokładne typy26 eksportów i audyt transitive axioms pochodzą z fresh_word_001.
Pełne cztery rodziny wymagane TASK pozostają otwarte. Snapshot
`checkpoints/WORD_HELPERS_001` oraz HANDOFF rozdzielają osiągnięty zakres od celu.

Status 2026-09-24 (SCALAR_AND_LE_001 w budowie): LE64 refines, 7/7 parse'ów
skalarnych, wykonania neg/double/half/sub-warunkowo/pack-z-domeną, zakresy
rint i mostki signed. Zielony `fresh_scalar_le_002` (38 kroków, 31 modułów).

## Plan kamieni milowych do freeze (2026-09-24, z właścicielem)

Każdy MS = zamrożony checkpoint + zielony replay + wpis w FAILED_ROUTES.
Żaden MS nie zamyka TASK; freeze całości to MS5.

- **MS1 — SCALAR_EXEC_001**: `rint_execution` + `floor_execution` z domenami
  (spec = literalny wynik BitVec; definedness z zakresów; call-site
  `fpr_ulsh/ursh/irsh` przez proved interfejsy Fin-64). Bez matematyki
  nearest-even o liczbach rzeczywistych — to jawny missing type.
  Rozbicie na pod-kroki dla kolejnych sukcesów (2026-09-24 wieczór):
  - **CP-A STABILIZE**: `Spec.lean` wraca do zielonego (do `rint_m2_big`);
    `rint_execution` wydzielony do `B20/Fpr/RintExec.lean`. BUILD_PLAN 31→32.
    ✅ DONE (`run/fpr_spec_098` exit 0).
  - **CP-B RINT_STEPS_001**: lematy krokowe S1–S4 (m/e/maska/e2), każdy mały
    `simp only`, bez rozwijania całości do Nat.
  - **CP-C RINT_CALLS_001**: S5/S8 (`ulsh`/`ursh`) + S6/S7 (dd/f) z poprawionym
    `hmask_exp` (wewnętrzny `.setWidth 32` zgodnie z `rint_mask`).
  - **CP-D RINT_EXEC_001**: złożenie `rint_execution` przez łańcuch `evalBody`,
    2 przypadki `e<64` / `e>=64`, z `rint_m2_small/big` + `cond_neg_add64`.
    ✅ DONE 2026-09-24 (`run/fpr_spec_110` exit 0, czysty log; aksjomaty
    propext/choice/Quot.sound). Wzorzec: dwufazowa normalizacja
    (`simp only` BitVec z jawnym `hmask_exp` → pełny `simp` z manglowanym
    `hmask`), `hm1`, `hcast_s`, `lit_allOnes64`; szczegóły w FAILED_ROUTES.
  - **CP-E FLOOR_EXEC_001**: analogicznie `floorProgram` (`irsh`, maska, xor).
    ✅ DONE 2026-09-24 (`run/floor_exec_014` exit 0, czysty log;
    `run/full_scalar_floor_001` 33/33 exit 0 — cały BUILD_PLAN zielony).
    `B20.Fpr.floor_execution` PROVED, aksjomaty propext/choice/Quot.sound.
    Domena `floorDomain` = `rintDomain` + jawne wykluczenie raw −0
    (implementacja zwraca tam −1; kontrakt na później w MS2/CLAIM).
    Wzorzec: `cond_neg_add64_le` (wariant `≤`, ten sam dowód),
    `irsh_call_of_toNat`, `floor_mask_zero/all`, `floor_t` w formie zwiniętej,
    destrukturyzacja `obtain` dla `hcond7`, finał przez `rfl` (defeq)
    zamiast dopasowywania masek — szczegóły w FAILED_ROUTES.
  - **CP-E FLOOR_EXEC_001**: analogicznie `floorProgram` (`irsh`, maska, xor).
- **MS2 — DOMAIN_IFACE_001**: `reachable_domain_interfaces` — nazwane typy
  obligation dla każdego call-site konsumentów + instancje dla udowodnionych
  callerów; `add/mul/div/sqrt` jako jawne unresolved types z dokładnymi
  sygnaturami (nie PROVED na siłę).
  ✅ DONE 2026-09-25 (`run/domain_iface_002` exit 0, czysty log;
  `run/full_domain_001` 34/34 exit 0 — cały BUILD_PLAN zielony).
  Nowy `src/B20/Fpr/Domain.lean` (BUILD_PLAN 33→34): `PrimObligation`
  (jednolity interfejs wołania), `ShiftCountDomain` + aliasy
  `Ulsh/Ursh/IrshDomain`, instancje `rint_ulsh_domain` (z `he2int` callera),
  `rint_ursh_domain`/`floor_irsh_domain` (bezwarunkowe, z `rint_e2_range`),
  `Add/Mul/Div/SqrtObligation` (dokładne kształty `u64→u64` z `typedef`,
  bez instancji — jawnie unresolved), `sub_refines_via_add_obligation`
  (historyczne warunkowe `sub_execution` przez interfejs, PROVED),
  rejestr `parsedCallSites` (4 parsed call-sites).
  Aksjomaty: shift-domeny propext/Quot.sound, reszta standardowa trójka.
- **MS3 — SCALAR_CONTROLS_001**: oryginalne C (normal/UBSan/ASan) dla
  wycinków skalarnych + Sage oracle + mutacje shift/sign/rounding,
  z preflight domen. LE i word kontrole już zielone.
  ✅ DONE 2026-09-25 (`run/scalar_controls_006` normal: Sage oracle,
  gcc normal+UBSan, 5 mutantów odrzuconych, exit 0;
  `run/scalar_asan_001` ASan exit 0).
  Nowe: `src/checks/scalar.sage` (oracle ZZ, certyfikat
  P02_SCALAR_ORACLE_V1, 19721 in + 21352 obs + 2 rejecty),
  `src/checks/scalar_controls.c` (harness z preflight `e+1076`
  i diagnostyką każdej ścieżki błędu), `src/tools/scalar_controls.py`,
  mutacje shift/rounding_rint/sign_neg/floor_mask/rounding_pack.
  Wpięte w replay (`job.py`). Zakres: neg/double/half/pack/rint/floor
  (in: kontrakt; obs: zgodność diagnostyczna, w tym raw −0 → −1),
  sub jako wiring-check `fpr_sub==fpr_add(x,y^sign)` (arytmetyka add
  unresolved, zgodnie z MS2).
- **MS4 — FREEZE_001**: komplet artefaktów autora wg TASK §9 do `output/`,
  OUTPUTS.sha256, pełny replay+ASan, handoff COMPLETE_FOR_REVIEW do V02.
  Uczciwy werdykt: PARTIAL_PROOF z dokładnymi missing types albo PROVED
  w zadeklarowanym zawężonym scope — rozstrzyga przegląd MS1–MS3.
  ✅ DONE 2026-09-25: 21/21 artefaktów §9 + formal/ (31 modułów) + checks/
  + tools/; OUTPUTS.sha256 = 68 członków (weryfikacja `sha256sum -c` OK;
  hash manifestu w zewnętrznym HANDOFF/podsumowaniu — poza manifestem,
  żeby nie było pętli zależności); skan 489 nazw (FORMAL_EXPORTS.json + AXIOMS.json,
  0 forbidden shortcuts); `replay_001` 42/42 exit 0; ASan word/le/scalar
  zielone. Werdykt: **PARTIAL_PROOF (cały TASK) / PROVED w zadeklarowanych
  zawężonych zakresach** (dokładny podział w GOAL_SPEC.json/CLAIM.md).
