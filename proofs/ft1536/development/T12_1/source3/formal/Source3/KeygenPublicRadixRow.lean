import Source3.KeygenPublicValueFrames

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One executed u1 row derives the inner-loop domains from its own table
   load and v2/v assignments, then consumes the complete v-loop fold. -/
namespace FT1536.Source3.KeygenPublicRadixRow
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R radix)
open KeygenPublicInputCells (Cells)
open KeygenPublicFirstTables (Table)
open KeygenPublicSizeOps (Declared)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot)
open KeygenPublicRadixProgram (rowBody)
open KeygenPublicTableControl (seq_inv frame)

def root (m j : Nat) : R := KeygenPublicRoots.root^KeygenMkgm3Indices.tableExponent (m+j)
def declareLimit : Stmt := .scalar (.declare .u64 ["v2".toList])
def declareTwiddle : Stmt := .scalar (.declare .u32 ["s".toList])
def loadTwiddle : Stmt := .assign "s".toList
  (.load16 "gm_square".toList (.bin .add (.var "m".toList) (.var "u1".toList)))
def setLimit : Stmt := .assign "v2".toList (.bin .add (var "v1") (var "ht"))
def initV : Stmt := .assign "v".toList (var "v1")

structure Fixed (p gm : ArrayPointer) (m j base h : Nat) (s : State) : Prop where
  pointer : s.arrays "a".toList=some p
  square : s.arrays "gm_square".toList=some gm
  count : USlot s "m" m
  row : USlot s "u1" j
  start : USlot s "v1" base
  half : USlot s "ht" h

def fixedNames : List C99ArrayReference.Name := ["m".toList,"u1".toList,"v1".toList,"ht".toList]
theorem fixed_after (code : Stmt) (s : State) (out : Result) (p gm : ArrayPointer) (m j base h : Nat)
    (ok : KeygenPublicTableControl.supported code=true)
    (keep : ∀ name∈fixedNames, name∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p gm m j base h s) (source : Exec KeygenPublicSource.program [] code s out) :
    Fixed p gm m j base h out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.square,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.count,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.row,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.start,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.half⟩

theorem source_row (a : Nat → R) (p gm : ArrayPointer) (m j base h : Nat) (s : State) (out : Result)
    (positive : 0<h) (extent : base+2*h≤1536) (twiddleBound : m+j<1024)
    (width : p.elementBytes=2) (fixed : Fixed p gm m j base h s) (vType : Declared s "v")
    (table : Table s.heap gm) (input : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] rowBody s out) :
    Cells out.state.heap p 1536 (KeygenPublicRadixFold.image a base h (root m j) h) ∧
      USlot out.state "v" (base+h) := by
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,d1,rest1⟩ := seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,d2,rest2⟩ := seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,read,rest3⟩ := seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,limit,rest4⟩ := seq_inv _ _ s3 result (by decide) rest3
      obtain ⟨s5,pass,last⟩ := seq_inv _ _ s4 result (by decide) rest4
      cases last
      obtain ⟨entry,initExec,loop⟩ := seq_inv initV KeygenPublicRadixFold.loop s4 ⟨s5,.normal⟩ (by decide) pass
      have state1 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u64 ["v2".toList] ⟨s1,.normal⟩ d1)
      have state2 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s1 .u32 ["s".toList] ⟨s2,.normal⟩ d2)
      dsimp only at state1 state2
      have f1 := fixed_after declareLimit s ⟨s1,.normal⟩ p gm m j base h (by decide) (by decide) fixed d1
      have f2 := fixed_after declareTwiddle s1 ⟨s2,.normal⟩ p gm m j base h (by decide) (by decide) f1 d2
      have f3 := fixed_after loadTwiddle s2 ⟨s3,.normal⟩ p gm m j base h (by decide) (by decide) f2 read
      have f4 := fixed_after setLimit s3 ⟨s4,.normal⟩ p gm m j base h (by decide) (by decide) f3 limit
      have fe := fixed_after initV s4 ⟨entry,.normal⟩ p gm m j base h (by decide) (by decide) f4 initExec
      have heap2 : s2.heap=s.heap := by rw [state2,state1]
      have heap3 : s3.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read).trans heap2
      have heap4 : s4.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ limit).trans heap3
      have heapE : entry.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ initExec).trans heap4
      have twiddle := KeygenPublicValueExpr.assign_value s2 ⟨s3,.normal⟩ "s" _ (radix*root m j)
        ⟨none,by rw [state2]; rfl⟩
        (KeygenPublicValueFrames.load_value s2 "gm_square" gm _ (m+j) _ f2.square
          (fun v ev => KeygenPublicSizeOps.scalar_sum s2 "m" "u1" m j (by omega) (by omega) v f2.count f2.row ev)
          (by rw [heap2]; exact table (m+j) twiddleBound)) read
      have limitType : Declared s3 "v2" := by
        refine ⟨none,?_⟩
        rw [(frame _ [] loadTwiddle _ _ (by decide) read).2.2 _ (by decide),state2]
        change s1.locals "v2".toList=_
        rw [state1]; rfl
      have bound := (KeygenPublicSizeOps.assign s3 ⟨s4,.normal⟩ "v2" _ (base+h) (by omega) limitType
        (KeygenPublicSizeOps.sum s3 _ _ base h (by omega) (by omega)
          (KeygenPublicSizeOps.variable_slot s3 "v1" base f3.start)
          (KeygenPublicSizeOps.variable_slot s3 "ht" h f3.half)) limit).2
      have entryType : Declared s4 "v" := by
        rw [Declared,(frame _ [] setLimit _ _ (by decide) limit).2.2 _ (by decide),
          (frame _ [] loadTwiddle _ _ (by decide) read).2.2 _ (by decide),state2,state1]
        exact vType
      have counter := (KeygenPublicSizeOps.assign s4 ⟨entry,.normal⟩ "v" _ base (by omega) entryType
        (KeygenPublicSizeOps.variable_slot s4 "v1" base f4.start) initExec).2
      have boundE : USlot entry "v2" (base+h) := (frame _ [] initV _ _ (by decide) initExec).2.2 _ (by decide) |>.trans bound
      have twiddle4 := KeygenPublicValueExpr.local_after setLimit s3 ⟨s4,.normal⟩ "s" _ (by decide) (by decide) twiddle limit
      have twiddleE := KeygenPublicValueExpr.local_after initV s4 ⟨entry,.normal⟩ "s" _ (by decide) (by decide) twiddle4 initExec
      have final := (KeygenPublicRadixFold.source_loop a p base h (root m j) entry ⟨s5,.normal⟩
        positive extent width fe.pointer fe.half boundE counter twiddleE (by rw [heapE]; exact input) loop).2
      exact ⟨final.cells,final.counter⟩

end FT1536.Source3.KeygenPublicRadixRow
