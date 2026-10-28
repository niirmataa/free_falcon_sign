import Source3.ExactLengthSource217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source call frames and the two exact-length calls in bezout part2. -/
namespace FT1536.Source3.ExactLengthCalls217
open C99ArrayReference (State Name bindPointer bindValue)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)

def fresh (s : State) := CrtAddMulCall205.fresh s
def withLen (s : State) := bindValue (fresh s) "xlen".toList .uint64 (.uint64 335)
def entry (s : State) (root : ArrayPointer) := bindPointer (withLen s) "x".toList root
def args (src : String) : List C99ArrayReference.Arg := [.pointer src.toList C99ProcedureParser.zero,.scalar (.var "len".toList)]
def call (src dst : String) : KeygenZintCall.Stmt := .call .exactLen (args src) (.into dst.toList)
noncomputable def withX (s : State) (X : Nat → BitVec 32) := bindValue s "xlen".toList .uint64 (.uint64 (word (highest X 335)))
noncomputable def after (s : State) (X Y : Nat → BitVec 32) := bindValue (withX s X) "ylen".toList .uint64 (.uint64 (word (highest Y 335)))
def code : KeygenZintCall.Stmt := .seq (call "x" "xlen") (.seq (call "y" "ylen") ZintNormWord194.wskip)

theorem shape : KeygenZintCall.bezoutPart 2=code := by decide

theorem binding (s : State) (src : String) (root : ArrayPointer)
    (rootBinding : s.arrays src.toList=some root) (len : Cell s "len".toList 335) (cap : root.index+335 ≤ root.count) :
    C99ArrayReference.Bind s (KeygenZintCall.params .exactLen) (args src) (entry s root) :=
  .pointer "x".toList src.toList C99ProcedureParser.zero root _ _ _
    (RootBinding175.zero s src root rootBinding (by omega))
    (.scalar .uint64 "xlen".toList (.var "len".toList) [] [] (fresh s) (.uint64 335) (.variable _ _ _ len) .nil)

theorem call_source (s : State) (src dst : String) (root : ArrayPointer) (W : Nat → BitVec 32)
    (rootBinding : s.arrays src.toList=some root) (len : Cell s "len".toList 335)
    (cap : root.index+335 ≤ root.count) (data : Data s root 335 W)
    (declared : s.locals dst.toList=some (.uint64,none)) :
    Exec (call src dst) s ⟨bindValue s dst.toList .uint64 (.uint64 (word (highest W 335))),.normal⟩ := by
  have inputCell : Cell (entry s root) "xlen".toList 335 := by rfl
  have inputRoot : (entry s root).arrays "x".toList=some root := by rfl
  have image : Data (entry s root) root 335 W := data
  obtain ⟨out,run,heap⟩:=ExactLengthSource217.source (entry s root) root W 335 (by decide) inputCell inputRoot cap image
  have source := KeygenZintCall.Exec.call s .exactLen (args src) (.into dst.toList) (entry s root)
    ⟨out,.returned (some (.uint64 (word (highest W 335))))⟩
    (some (C99IntegerReference.convert .uint64 (C99IntegerReference.Value.uint64 (word (highest W 335))).integer)) _
    (binding s src root rootBinding len cap) run (.value .uint64 _) (.into _ _ .uint64 none _ declared)
  have same : {s with heap:=out.heap}=s := by rw [heap]; cases s; rfl
  have conv := C99CountedWords.convert_self (C99IntegerReference.Value.uint64 (word (highest W 335)))
  change C99IntegerReference.convert .uint64 (C99IntegerReference.Value.uint64 (word (highest W 335))).integer =
    .uint64 (word (highest W 335)) at conv
  simpa only [same,conv,call] using source

theorem source (s : State) (x y : ArrayPointer) (X Y : Nat → BitVec 32)
    (xb : s.arrays "x".toList=some x) (yb : s.arrays "y".toList=some y)
    (len : Cell s "len".toList 335) (xc : x.index+335 ≤ x.count) (yc : y.index+335 ≤ y.count)
    (xdata : Data s x 335 X) (ydata : Data s y 335 Y)
    (xdecl : s.locals "xlen".toList=some (.uint64,none)) (ydecl : s.locals "ylen".toList=some (.uint64,none)) :
    Exec (KeygenZintCall.bezoutPart 2) s ⟨after s X Y,.normal⟩ := by
  rw [shape]
  have first := call_source s "x" "xlen" x X xb len xc xdata xdecl
  have yb' : (withX s X).arrays "y".toList=some y := yb
  have len' : Cell (withX s X) "len".toList 335 :=
    (SelectedStepAddPrime195.locals_keep _ "xlen".toList .uint64 _ "len".toList (by decide)).trans len
  have yd' : Data (withX s X) y 335 Y := ydata
  have ydecl' : (withX s X).locals "ylen".toList=some (.uint64,none) :=
    (SelectedStepAddPrime195.locals_keep _ "xlen".toList .uint64 _ "ylen".toList (by decide)).trans ydecl
  have second := call_source (withX s X) "y" "ylen" y Y yb' len' yc yd' ydecl'
  exact .seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second (ZintNormWord194.word_skip _))

end FT1536.Source3.ExactLengthCalls217
