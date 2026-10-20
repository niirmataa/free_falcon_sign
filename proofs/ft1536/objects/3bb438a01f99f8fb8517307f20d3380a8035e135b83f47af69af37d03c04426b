import Source3.KeygenFirstPrime
import Source3.ParsedChunks
import Source3.KeygenLevelCalls
import Source3.KeygenZintExtract

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Exact static initializer parser, including sentinel records. Struct
   members occupy offsets 0/4/8 in a 12-byte small_prime; size_t words are
   eight-byte values in the pinned LP64 profile. Primality of later rows is
   unnecessary for the operational search frame. -/
namespace FT1536.Source3.KeygenStaticTables
open C99MemoryReference
open C99ArrayReference (Name State)
open B20.C (Token)

inductive PrimeTable where | binary | ternary
  deriving DecidableEq, Repr
def primeName : PrimeTable → Name
  | .binary => "PRIMES2".toList
  | .ternary => "PRIMES3".toList
def start : PrimeTable → Nat | .binary => 840 | .ternary => 1370
def rowCount : PrimeTable → Nat | .binary => 522 | .ternary => 1101
def rows (table : PrimeTable) : List String := (Pinned.keygenLines.drop (start table-1)).take (rowCount table)
def natural (token : Token) : Option Nat := do
  let n ← KeygenFirstPrime.natural token
  if n<2^32 then pure n else none
def rowTokens : List Token → Option (Nat×Nat×Nat)
  | [['{'],p,[','],g,[','],s,['}']] | [['{'],p,[','],g,[','],s,['}'],[',']] =>
    do pure (← natural p,← natural g,← natural s)
  | _ => none
def row (text : String) : Option (Nat×Nat×Nat) :=
  (CLogicParser.tokenize (text.length+1) text.toList).bind rowTokens
def chunk (table : PrimeTable) (index : Nat) : List String := ((rows table).drop (16*index)).take 16
def chunks : PrimeTable → Nat | .binary => 33 | .ternary => 69
def parsedChunk (table : PrimeTable) (index : Nat) := (chunk table index).mapM row
def Checked (table : PrimeTable) (index : Nat) : Prop :=
  (parsedChunk table index).map List.length=some (min 16 (rowCount table-16*index))
instance (table : PrimeTable) (index : Nat) : Decidable (Checked table index) :=
  inferInstanceAs (Decidable ((parsedChunk table index).map List.length=some (min 16 (rowCount table-16*index))))
def parsed (table : PrimeTable) : Option (List (Nat×Nat×Nat)) := (rows table).mapM row
def values (table : PrimeTable) : List (Nat×Nat×Nat) := (parsed table).getD []
theorem binary_header : Pinned.keygenLines[838]?=some "static const small_prime PRIMES2[] = {\n" := by decide
theorem ternary_header : Pinned.keygenLines[1368]?=some "static const small_prime PRIMES3[] = {\n" := by decide
theorem binary_tail : Pinned.keygenLines[1361]?=some "};\n" := by decide
theorem ternary_tail : Pinned.keygenLines[2470]?=some "};\n" := by decide
theorem struct_source : (Pinned.keygenLines.drop 832).take 5=["typedef struct {\n","\tuint32_t p;\n",
    "\tuint32_t g;\n","\tuint32_t s;\n","} small_prime;\n"] := by decide
theorem rows_length (table : PrimeTable) : (rows table).length=rowCount table := by cases table <;> decide
theorem rows_partition (table : PrimeTable) : rows table=(List.range (chunks table)).flatMap (chunk table) := by
  have h := ParsedChunks.take_chunks (rows table) 16 (chunks table)
  have enough : (rows table).length≤chunks table*16 := by rw [rows_length]; cases table <;> decide
  rw [List.take_of_length_le enough] at h
  have he : (fun i => ((rows table).drop (i*16)).take 16)=chunk table := by
    funext i
    unfold chunk
    rw [Nat.mul_comm]
  rw [he] at h
  exact h
theorem row_defined (checked : ∀ table index, index<chunks table → Checked table index)
    (table : PrimeTable) (text : String) (member : text∈rows table) : ∃ value, row text=some value := by
  rw [rows_partition] at member
  obtain ⟨i,hi,member⟩ := List.mem_flatMap.mp member
  obtain ⟨data,hp,_⟩ := Option.map_eq_some_iff.mp (checked table i (List.mem_range.mp hi))
  exact (ParsedChunks.mapM_defined row (chunk table i)).mp ⟨data,hp⟩ text member
theorem values_bound (checked : ∀ table index, index<chunks table → Checked table index)
    (table : PrimeTable) : parsed table=some (values table) := by
  obtain ⟨data,hp⟩ := (ParsedChunks.mapM_defined row (rows table)).mpr (row_defined checked table)
  change parsed table=some data at hp
  simp only [values,hp,Option.getD_some]
theorem values_length (checked : ∀ table index, index<chunks table → Checked table index)
    (table : PrimeTable) : (values table).length=rowCount table :=
  (ParsedChunks.mapM_length row (rows table) (values table) (values_bound checked table)).trans (rows_length table)
def primeField (p : ArrayPointer) (row : Nat) (field : KeygenLevelCalls.Field) : ArrayPointer :=
  ⟨p.block,p.offset+12*row+KeygenLevelCalls.Field.offset field,1,4,0⟩
def fieldValue (v : Nat×Nat×Nat) : KeygenLevelCalls.Field → Nat
  | .p => v.1
  | .g => v.2.1
  | .s => v.2.2
def PrimeObject (heap : Memory) (p : ArrayPointer) (table : PrimeTable) : Prop :=
  p.elementBytes=12 ∧ p.index=0 ∧ p.count=rowCount table ∧ heap.writable p.block=false ∧
  p.base+12*p.count≤heap.size p.block ∧ heap.size p.block<2^64 ∧
  ∀ i v, (values table)[i]?=some v → ∀ field,
    Load32 heap (primeField p i field) (BitVec.ofNat 32 (fieldValue v field))

inductive SizeTable where | small2 | large2 | small3 | large3
  deriving DecidableEq, Repr
def sizeName : SizeTable → Name
  | .small2 => "MAX_BL_SMALL2".toList
  | .large2 => "MAX_BL_LARGE2".toList
  | .small3 => "MAX_BL_SMALL3".toList
  | .large3 => "MAX_BL_LARGE3".toList
def sizeStart : SizeTable → Nat | .small2 => 4940 | .large2 => 4944 | .small3 => 4948 | .large3 => 4952
def sizes : SizeTable → List (BitVec 64)
  | .small2 => [1,1,2,2,4,7,14,27,53,106,212]
  | .large2 => [2,2,5,7,12,22,42,80,157,310]
  | .small3 => [1,1,2,3,6,12,22,42,82,166,335,700]
  | .large3 => [2,3,5,9,16,32,62,123,245,490,1000]
def parsedSizes (table : SizeTable) : Option (List (BitVec 64)) := do
  let line ← Pinned.keygenLines[sizeStart table]?
  let data ← KeygenRev10.parseLine line
  pure (data.map (BitVec.ofNat 64))
theorem size_values (table : SizeTable) : parsedSizes table=some (sizes table) := by cases table <;> decide
theorem size_header (table : SizeTable) : Pinned.keygenLines[sizeStart table-1]?=
    some ("static const size_t "++String.ofList (sizeName table)++"[] = {\n") := by cases table <;> decide
theorem size_tail (table : SizeTable) : Pinned.keygenLines[sizeStart table+1]?=some "};\n" := by cases table <;> decide
def SizeObject (heap : Memory) (p : ArrayPointer) (table : SizeTable) : Prop :=
  p.elementBytes=8 ∧ p.index=0 ∧ p.count=(sizes table).length ∧ heap.writable p.block=false ∧
  p.base+8*p.count≤heap.size p.block ∧ heap.size p.block<2^64 ∧
  ∀ i v, (sizes table)[i]?=some v → Load64 heap (KeygenSmallOutput.element p i) v
def Environment (s : State) : Prop :=
  (∀ table, ∃ p, s.tables (primeName table)=some p ∧ PrimeObject s.heap p table) ∧
  (∀ table, ∃ p, s.tables (sizeName table)=some p ∧ SizeObject s.heap p table) ∧
  ∃ p, s.tables KeygenZintCall.vvObject=some p ∧ KeygenZintCall.Static32 s.heap p KeygenZintExtract.vv

end FT1536.Source3.KeygenStaticTables
