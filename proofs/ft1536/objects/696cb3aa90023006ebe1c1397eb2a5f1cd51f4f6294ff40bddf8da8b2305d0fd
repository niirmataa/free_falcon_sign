import Source3.FftProcedureFrames
import Source3.C99ProcedureSequence
import Source3.CertificateWorkspace

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source lines7721--7745, after the four smallint conversions. Every FFT/LDL
   call uses the closed source table. The copy witness and its subsequent
   initialization trace are extracted from execution, not input hypotheses.
   The preceding conversions/layout and following Gate00 still need the
   enclosing full-function composition. -/
namespace FT1536.Source3.CertificateAfterConversion
open C99ArrayReference (Name Arg State)
open C99ProcedureReference (Stmt Exec Result)
open C99MemoryReference C99InitializationTrace
open C99ProcedureSequence

def context : List Name :=
  ["tmp","tf","tg","tF","tG","g00","g10","g11","gxx","tree","t3","leaves","scratch"].map String.toList
def parseRegion (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let ts ← C99ProcedureParser.tokens text
  let (code,_,rest) ← C99ProcedureParser.body FftProcedurePrograms.signatures context 256 ts
  if rest.isEmpty then pure code else none

def zero : CLogic.Expr := .literal .u64 0
def dimensionArgs : List Arg := [.scalar (.var "logn".toList),.scalar (.literal .i32 1)]
def unaryCall (name array : String) : Name×List Arg :=
  (name.toList,.pointer array.toList zero::dimensionArgs)
def firstCalls : List (Name×List Arg) := [
  unaryCall "falcon_FFT3" "tf",unaryCall "falcon_FFT3" "tg",
  unaryCall "falcon_FFT3" "tF",unaryCall "falcon_FFT3" "tG",
  unaryCall "falcon_poly_neg_fft3" "tf",unaryCall "falcon_poly_neg_fft3" "tF"]
def countExpr : CLogic.Expr := .bin .mul (.var "n".toList) (.literal .u64 8)
def rootCopy : C99ArrayReference.Stmt := .copy "g00".toList "tg".toList zero zero countExpr
def tail : Stmt := (parseRegion 7728 18).getD C99ProcedureParser.skip
def code : Stmt := callsThen firstCalls (.seq (.base rootCopy) tail)

theorem source_bound : parseRegion 7721 25=some code := by decide
theorem tail_bound : parseRegion 7728 18=some tail := by decide

def workspacePointer (base slot : Nat) : ArrayPointer := ⟨0,base,35840,8,1536*slot⟩

theorem zero_pointer (s : State) (name : Name) (p root : ArrayPointer)
    (h : C99ArrayReference.Pointer s name zero p) (binding : s.arrays name=some root) : p=root := by
  cases h with
  | add original _ value bound evaluated nonnegative within =>
      have he : original=root := Option.some.inj (bound.symm.trans binding)
      subst original
      change C99ScalarReference.Eval _ _ (.literal .uint64 0) value at evaluated
      cases evaluated
      cases within
      cases root
      rfl

theorem copy_length (s : State) (n : BitVec 64)
    (bound : s.locals "n".toList=some (.uint64,some (.uint64 1536)))
    (h : C99ArrayReference.scalar s countExpr (.uint64 n)) : n=12288 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .times (.variable "n".toList) (.literal .uint64 8)) (.uint64 n) at h
  cases h with
  | arithmetic op a b x y z hx hy operation =>
      cases hx with
      | «variable» _ _ _ binding =>
          have hv : x=.uint64 1536 := Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans bound)))
          subst x
          cases hy
          have he := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp operation).2
          change C99IntegerReference.Value.uint64 n=.uint64 12288 at he
          exact C99IntegerReference.Value.uint64.inj he

theorem root_copy_from_execution (before after : State)
    (base : Nat) (hn : before.locals "n".toList=some (.uint64,some (.uint64 1536)))
    (hg : before.arrays "g00".toList=some (workspacePointer base 4))
    (ht : before.arrays "tg".toList=some (workspacePointer base 1))
    (source : C99ArrayReference.Exec FftLeafPrograms.program rootCopy before after) :
    Memcpy before.heap (CertificateWorkspace.view base 4) (CertificateWorkspace.view base 1) 12288 after.heap := by
  cases source with
  | copy before after dst src di si count p q n destination source length destinationObject sourceObject copy =>
      have hp := zero_pointer before "g00".toList p (workspacePointer base 4) destination hg
      have hq := zero_pointer before "tg".toList q (workspacePointer base 1) source ht
      have hl := copy_length before n hn length
      subst p
      subst q
      subst n
      simpa [Memcpy,workspacePointer,CertificateWorkspace.view,CertificateWorkspace.slot,
        ArrayPointer.offset] using copy

theorem root_copy_witness (base : Nat) (before : State) (result : Result)
    (hn : before.locals "n".toList=some (.uint64,some (.uint64 1536)))
    (hg : before.arrays "g00".toList=some (workspacePointer base 4))
    (ht : before.arrays "tg".toList=some (workspacePointer base 1))
    (source : Exec FftProcedurePrograms.program code before result) :
    ∃ entry copied : Memory, Steps before.heap entry ∧
      Memcpy entry (CertificateWorkspace.view base 4) (CertificateWorkspace.view base 1) 12288 copied ∧
      Steps copied result.state.heap := by
  obtain ⟨entry,he,ha,hs,hbody⟩ := calls_before_tail _ firstCalls (.seq (.base rootCopy) tail) before result source
  obtain ⟨copied,hcopy,hrest⟩ := base_before_tail _ rootCopy tail entry result hbody
  refine ⟨entry.heap,copied.heap,hs,?_,C99ProcedureReference.memory_steps _ _ _ _ hrest⟩
  · exact root_copy_from_execution entry copied base (by simpa only [he] using hn)
      (by simpa only [ha] using hg) (by simpa only [ha] using ht) hcopy

theorem suffix_entry_from_source (base bad : Nat) (before : State) (result : Result)
    (legal : CertificateWorkspace.Legal base bad before.heap)
    (flag : Initialized before.heap 0 bad 4)
    (hn : before.locals "n".toList=some (.uint64,some (.uint64 1536)))
    (hg : before.arrays "g00".toList=some (workspacePointer base 4))
    (ht : before.arrays "tg".toList=some (workspacePointer base 1))
    (source : Exec FftProcedurePrograms.program code before result) :
    CertificateMemory.WellFormed (CertificateWorkspace.layout base bad) ∧
      CertificateMemory.Legal (CertificateWorkspace.layout base bad) (C99MemoryBridge.encode result.state.heap) := by
  obtain ⟨entry,copied,hs,hcopy,hrest⟩ := root_copy_witness base before result hn hg ht source
  have hp := steps_preserve before.heap entry hs
  exact CertificateWorkspace.after_root_copy base bad entry copied result.state.heap
    (CertificateWorkspace.legal_preserved base bad before.heap entry legal hp)
    (region_preserved before.heap entry hp 0 bad 4 flag) hcopy hrest

end FT1536.Source3.CertificateAfterConversion
