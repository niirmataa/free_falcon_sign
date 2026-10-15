import Source3.FftPinned139
import Source3.FftTableWord139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMiddleLoad139
open C99CompactState115 (State reference bindValue)
open C99ProcedureReference (Exec)
open FftMiddleShape139

def loadIndex : C99ProcedureReference.Stmt → CLogic.Expr
  | .base (.assign _ (.load _ index)) => index
  | _ => .literal .i32 0

def declarations := C99ProcedureParser.chain (groupParts.take 2)
def realCode := (groupParts[2]?).getD (.base .skip)
def imagCode := (groupParts[3]?).getD (.base .skip)
def limitCode := (groupParts[4]?).getD (.base .skip)

theorem real_shape : realCode=.base (.assign "sr".toList (.load "fpr_gm3_square".toList (loadIndex realCode))) := by rfl
theorem imag_shape : imagCode=.base (.assign "si".toList (.load "fpr_gm3_square".toList (loadIndex imagCode))) := by rfl
theorem prologue_shape : groupPrologue=C99ProcedureParser.chain (groupParts.take 2++[realCode,imagCode,limitCode]) := by rfl

theorem assign_load (before : State) (target array : C99ArrayReference.Name) (index : CLogic.Expr)
    (pointer : C99MemoryReference.ArrayPointer) (word : BitVec 64)
    (declared : C99NameMap115.lookup before.locals target=some (.u64 none))
    (address : C99CompactPointer115.pointer C99CompactPointer115.noCalls before array index=some pointer)
    (loaded : C99MemoryReference.Load64 (reference before).heap pointer word) :
    Exec KeygenSearchFft.program (.base (.assign target (.load array index))) (reference before)
      ⟨reference (bindValue before target .u64 (.u64 word)),.normal⟩ := by
  rw [C99CompactState115.reference_bindValue]
  refine .base _ _ _ (.assign _ _ _ .uint64 none (.uint64 word) ?_ ?_)
  · change (C99NameMap115.lookup before.locals target).map C99CompactCells115.Cell.reference=_
    rw [declared]
    rfl
  · exact .load array index pointer word
      (C99CompactPointer115.pointer_sound C99CompactPointer115.noCalls
        (C99CompactPointer115.noCalls_sound _) before array index pointer address) loaded

def declaredResult := C99ProcedureRun138.run FprFastCalls137.calls 32 declarations SelectedFftMiddleStart139.groupInit
theorem declared_defined : declaredResult.isSome=true := by decide +kernel
def declared : State := declaredResult.get declared_defined

theorem declaration_source : Exec KeygenSearchFft.program declarations
    (reference SelectedFftMiddleStart139.groupInit) ⟨reference declared,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 32 _ _ declared
    (SelectedInput124.option_get declaredResult declared_defined)

theorem declared_pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment (reference declared).heap :=
  FftPinned139.procedure _ _ _ _ declaration_source FftPinned139.middle_entry

def real : State := bindValue declared "sr".toList .u64 (.u64 0x3febb67ae8584cab)

theorem real_source : Exec KeygenSearchFft.program realCode (reference declared) ⟨reference real,.normal⟩ := by
  rw [real_shape]
  exact assign_load declared "sr".toList "fpr_gm3_square".toList (loadIndex realCode)
    {FftGlobalMemory.pointer .square with index := 4} 0x3febb67ae8584cab (by decide +kernel) (by decide +kernel)
    (FftTableWord139.loaded _ declared_pinned .square 4 _ FftTableWord139.square_four)

def imag : State := bindValue real "si".toList .u64 (.u64 0x3fdfffffffffffff)

theorem imag_source : Exec KeygenSearchFft.program imagCode (reference real) ⟨reference imag,.normal⟩ := by
  rw [imag_shape]
  exact assign_load real "si".toList "fpr_gm3_square".toList (loadIndex imagCode)
    {FftGlobalMemory.pointer .square with index := 5} 0x3fdfffffffffffff (by decide +kernel) (by decide +kernel)
    (FftTableWord139.loaded _ declared_pinned .square 5 _ FftTableWord139.square_five)

def limitResult := C99ProcedureRun138.run FprFastCalls137.calls 32 limitCode imag
theorem limit_defined : limitResult.isSome=true := by decide +kernel
def limit : State := limitResult.get limit_defined

theorem limit_source : Exec KeygenSearchFft.program limitCode (reference imag) ⟨reference limit,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 32 _ _ limit
    (SelectedInput124.option_get limitResult limit_defined)

theorem group_source : Exec KeygenSearchFft.program groupPrologue
    (reference SelectedFftMiddleStart139.groupInit) ⟨reference limit,.normal⟩ := by
  rw [prologue_shape]
  apply C99Chain139.append _ _ _ _ (reference declared) _ declaration_source
  exact .seqNormal _ _ _ _ _ real_source (.seqNormal _ _ _ _ _ imag_source
    (.seqNormal _ _ _ _ _ limit_source (.base _ _ _ (.skip _))))

def initialResult := C99ProcedureRun138.run FprFastCalls137.calls 32 butterflyInitial limit
theorem initial_defined : initialResult.isSome=true := by decide +kernel
def initial : State := initialResult.get initial_defined

theorem initial_source : Exec KeygenSearchFft.program butterflyInitial (reference limit) ⟨reference initial,.normal⟩ :=
  C99ProcedureRun138.sound _ _ FprFastCalls137.sound 32 _ _ initial
    (SelectedInput124.option_get initialResult initial_defined)

theorem initial_values : ["t","tmin","m","ht","hm","u1","v1","v2","v"].map
    (fun name => C99NameMap115.lookup initial.locals name.toList)=
    [768,3,2,384,1,0,0,384,0].map (fun word => some (C99CompactCells115.Cell.u64 (some word))) := by decide +kernel

theorem pointer_binding : (reference initial).arrays "a".toList=some ⟨31,0,35840,8,0⟩ := by decide +kernel

end FT1536.Source3.FftMiddleLoad139
