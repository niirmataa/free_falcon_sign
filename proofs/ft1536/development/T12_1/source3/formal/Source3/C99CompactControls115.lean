import Source3.C99CompactBinding115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompactControls115
open C99CompactCells115
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

/-- Closed controls for the representation/compiler boundary, not a
    substitute for the still-open full KeyGen witness. -/
def locals : Locals := [("x".toList,.i32 (some 42)),("y".toList,.u64 none)]
def caller : State := ⟨⟨.empty⟩,locals,[],[],[]⟩
def arrayPointer : C99MemoryReference.ArrayPointer := ⟨7,0,8,1,0⟩

theorem uninitialized_read_rejected :
    C99CompactScalar115.assign noCalls locals "x".toList (.var "y".toList) = none := by decide +kernel

theorem cast_to_declared_width :
    (C99CompactScalar115.assign noCalls locals "x".toList (.literal .u64 (2^32+5))).bind
      (fun out => C99NameMap115.lookup out "x".toList) = some (.i32 (some 5)) := by decide +kernel

theorem scope_restores_type_and_value :
    C99NameMap115.lookup
      (C99NameMap115.restore locals [("x".toList,.u64 (some 100))] ["x".toList]) "x".toList =
      some (.i32 (some 42)) := by decide +kernel

theorem pointer_one_past :
    C99CompactPointer115.advance arrayPointer (.u64 8) = some {arrayPointer with index := 8} := by decide +kernel

theorem pointer_past_end_rejected :
    C99CompactPointer115.advance arrayPointer (.u64 9) = none := by decide +kernel

theorem negative_index_rejected :
    C99CompactPointer115.advance arrayPointer (.i32 (-1)) = none := by decide +kernel

theorem evaluated_before_binding :
    (C99CompactBinding115.bind noCalls caller [.scalar .uint64 "x".toList] [.scalar (.var "x".toList)]).bind
      (fun out => C99NameMap115.lookup out.locals "x".toList) = some (.u64 (some 42)) := by decide +kernel

theorem external_arguments :
    (C99CompactBinding115.external caller [.scalar .uint64 "len".toList,.pointer "seed".toList]
      [.scalar (.uint64 32),.pointer arrayPointer]).map
      (fun out => (C99NameMap115.lookup out.locals "len".toList,C99NameMap115.lookup out.arrays "seed".toList,
        C99NameMap115.lookup out.locals "x".toList)) =
      some (some (.u64 (some 32)),some arrayPointer,none) := by decide +kernel

def code : List CLogic.Stmt := [.declare .i32 ["x".toList],.assign "x".toList (.literal .u64 (2^32+5))]
def output : Locals := [("x".toList,.i32 (some 5))]

theorem code_computed : C99CompactScalar115.run noCalls [] code = some output := by decide +kernel

theorem code_source :
    C99ScalarReference.Exec FprPrefixCalls.calls (environment []) (C99Frontend.scalars code)
      (.normal (environment output)) :=
  C99CompactScalar115.run_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
    [] output code code_computed

end FT1536.Source3.C99CompactControls115
