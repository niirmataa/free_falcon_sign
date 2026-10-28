import Source3.DeepestCrtSource217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Bind the actual deepest bezout call, preserving the selected CRT inputs. -/
namespace FT1536.Source3.DeepestBezoutEntry217
open C99ArrayReference (State bindPointer bindValue)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open DeepestSelectedCrt217 (tmp pair)
open DeepestUnsignedCrtBody217 (words335)
open ZintNormWalkFlat208 (Data)

def Fp := SelectedDeepestWorkspace175.pointer 0
def Gp := SelectedDeepestWorkspace175.pointer 1
def empty (s : State) : State := CrtAddMulCall205.fresh s
def withTmp (s : State) := bindPointer (empty s) "tmp".toList tmp
def withLen (s : State) := bindValue (withTmp s) "len".toList .uint64 (.uint64 335)
def withY (s : State) := bindPointer (withLen s) "y".toList gd
def withX (s : State) := bindPointer (withY s) "x".toList fd
def withV (s : State) := bindPointer (withX s) "v".toList Fp
def entry (s : State) := bindPointer (withV s) "u".toList Gp

def args : List C99ArrayReference.Arg := [.pointer "Gp".toList C99ProcedureParser.zero,
  .pointer "Fp".toList C99ProcedureParser.zero,.pointer "fp".toList C99ProcedureParser.zero,
  .pointer "gp".toList C99ProcedureParser.zero,.scalar (.var "len".toList),
  .pointer "t1".toList C99ProcedureParser.zero]

theorem binding (s : State) (u : s.arrays "Gp".toList=some Gp) (v : s.arrays "Fp".toList=some Fp)
    (x : s.arrays "fp".toList=some fd) (y : s.arrays "gp".toList=some gd)
    (scratch : s.arrays "t1".toList=some tmp) (len : Cell s "len".toList 335) :
    C99ArrayReference.Bind s (KeygenZintCall.params .bezout) args (entry s) :=
  .pointer "u".toList "Gp".toList C99ProcedureParser.zero Gp _ _ _ (RootBinding175.zero s "Gp" Gp u (by decide))
    (.pointer "v".toList "Fp".toList C99ProcedureParser.zero Fp _ _ _ (RootBinding175.zero s "Fp" Fp v (by decide))
      (.pointer "x".toList "fp".toList C99ProcedureParser.zero fd _ _ _ (RootBinding175.zero s "fp" fd x (by decide))
        (.pointer "y".toList "gp".toList C99ProcedureParser.zero gd _ _ _ (RootBinding175.zero s "gp" gd y (by decide))
          (.scalar .uint64 "len".toList (.var "len".toList) _ _ _ (.uint64 335) (.variable _ _ _ len)
            (.pointer "tmp".toList "t1".toList C99ProcedureParser.zero tmp [] [] (empty s)
              (RootBinding175.zero s "t1" tmp scratch (by decide)) .nil)))))

theorem x_image (s : State) (W : Nat → BitVec 32) (h : Data s fd 335 W) : Data (entry s) fd 335 W := h
theorem y_image (s : State) (W : Nat → BitVec 32) (h : Data s gd 335 W) : Data (entry s) gd 335 W := h

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    Data made fd 335 F ∧ Data made gd 335 G ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    C99ArrayReference.Bind rebuilt (KeygenZintCall.params .bezout) args (entry rebuilt) ∧
    Data (entry rebuilt) fd 335 (words335 (pair F G)) ∧
    Data (entry rebuilt) gd 335 (fun i => words335 (pair F G) (335+i)) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,rebuilt,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,_,_,part2,fdata,gdata,crt,locals,arrays,_,image⟩ := DeepestCrtSource217.source
  let made := SelectedMakeFgReturn217.callerAfter callee second third fourth fifth sixth seventh eighth out
  have u : rebuilt.arrays "Gp".toList=some Gp := by rw [arrays]; rfl
  have v : rebuilt.arrays "Fp".toList=some Fp := by rw [arrays]; rfl
  have x : rebuilt.arrays "fp".toList=some fd := by rw [arrays]; rfl
  have y : rebuilt.arrays "gp".toList=some gd := by rw [arrays]; rfl
  have scratch : rebuilt.arrays "t1".toList=some tmp := by rw [arrays]; rfl
  have len : Cell rebuilt "len".toList 335 := by rw [Cell,locals]; rfl
  obtain ⟨xf,yf⟩:=DeepestCrtSource217.split_data rebuilt _ image
  exact ⟨made,rebuilt,_,_,part2,fdata,gdata,crt,binding rebuilt u v x y scratch len,xf,yf⟩

end FT1536.Source3.DeepestBezoutEntry217
