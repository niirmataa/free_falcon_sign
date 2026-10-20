import Source3.FftTableSources
import Source3.CertificateFunctionReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftGlobalMemory
open C99MemoryReference
open FftTableParser (Table rowCount)

def block : Table → Nat | .square => 1 | .cubic => 2
def pointer (table : Table) : ArrayPointer := ⟨block table,0,2*rowCount table,8,0⟩
def tables (name : C99ArrayReference.Name) : Option ArrayPointer :=
  if name="fpr_gm3_square".toList then some (pointer .square)
  else if name="fpr_gm3_cubic".toList then some (pointer .cubic) else none

def tableByte (table : Table) (offset : Nat) : Option Byte := do
  let word ← (FftTableSources.words table)[offset/8]?
  pure (byte64 word ⟨offset%8,Nat.mod_lt _ (by decide)⟩)

def install (before : Memory) : Memory where
  bytes := fun b offset => if b=1 then tableByte .square offset
    else if b=2 then tableByte .cubic offset else before.bytes b offset
  size := fun b => if b=1 then 16384 else if b=2 then 32768 else before.size b
  writable := fun b => if b=1 ∨ b=2 then false else before.writable b

def environment : CertificateFunctionReference.Environment := ⟨FftGlobalScalars.environment,tables⟩

theorem caller_bytes (before : Memory) (b offset : Nat) (h1 : b≠1) (h2 : b≠2) :
    (install before).bytes b offset=before.bytes b offset := by simp [install,h1,h2]
theorem caller_size (before : Memory) (b : Nat) (h1 : b≠1) (h2 : b≠2) :
    (install before).size b=before.size b := by simp [install,h1,h2]
theorem read_only (before : Memory) (table : Table) : (install before).writable (block table)=false := by
  cases table <;> simp [install,block]

theorem byte_at (table : Table) (i : Nat) (hi : i<(FftTableSources.words table).length) (byte : Fin 8) :
    tableByte table (8*i+byte.val)=some (byte64 (FftTableSources.words table)[i] byte) := by
  have hb := byte.isLt
  have hd : (8*i+byte.val)/8=i := by omega
  have hm : (8*i+byte.val)%8=byte.val := by omega
  unfold tableByte
  rw [hd,List.getElem?_eq_getElem hi]
  have hf : (⟨(8*i+byte.val)%8,Nat.mod_lt _ (by decide)⟩ : Fin 8)=byte := Fin.ext hm
  simp only [hf]
  rfl

theorem loaded_source_word (before : Memory) (table : Table) (i : Nat)
    (hi : i<(FftTableSources.words table).length) :
    Load64 (install before) {pointer table with index := i} (FftTableSources.words table)[i] := by
  have bound : i<2*rowCount table := by simpa only [FftTableSources.words_length] using hi
  have allocated : Allocated (install before) {pointer table with index := i} := by
    cases table <;> simp [Allocated,install,pointer,block,rowCount] at bound ⊢ <;> omega
  have joined := B20.Word.LE.join_byteOf ((FftTableSources.words table)[i])
  change le64 (byte64 ((FftTableSources.words table)[i]))=(FftTableSources.words table)[i] at joined
  rw [← joined]
  apply Load64.load _ _ (byte64 ((FftTableSources.words table)[i])) allocated rfl
  intro byte
  have hb := byte_at table i hi byte
  cases table <;> simpa [install,pointer,block,ArrayPointer.offset] using hb

end FT1536.Source3.FftGlobalMemory
