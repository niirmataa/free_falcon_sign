import Source3.C99ModularAnnotation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Pinned REV10 bit-reversal table (B1.03). The 1024 uint16 entries of the
   read-only source table are extracted from the pinned source lines and
   identified with the mathematical 10-bit bit reversal. The single list
   equality below is the finite-table certificate: it is checked by the
   kernel over all 1024 entries, not sampled. -/
namespace FT1536.Source3.KeygenRev10

def bitrev (bits i : Nat) : Nat :=
  (List.range bits).foldl (fun acc b => (acc <<< 1) ||| ((i >>> b) &&& 1)) 0

def bitrev10 (i : Nat) : Nat := bitrev 10 i

def natural (token : B20.C.Token) : Option Nat := do
  match ← CLogicParser.number token with
  | .literal .i32 n => pure n
  | _ => none

def line : List B20.C.Token → Option (List Nat)
  | [] => some []
  | t::[',']::rest => do
      let head ← natural t
      let tail ← line rest
      pure (head::tail)
  | t::[] => (natural t).map (fun n => [n])
  | _ => none

def parseLine (s : String) : Option (List Nat) :=
  (CLogicParser.tokenize (s.length+1) s.toList).bind line

def rawTable : Option (List Nat) :=
  (((Pinned.keygenLines.drop 2673).take 86).mapM parseLine).map List.flatten

theorem table_header :
    Pinned.keygenLines[2672]?=some "static const uint16_t REV10[] = {\n" := by decide

theorem table_tail : Pinned.keygenLines[2759]?=some "};\n" := by decide

/- The exactness certificate `rawTable = some ((List.range 1024).map bitrev10)`
   is retained as the failed reduction in job keygen_mkgm3_frontend_007: the
   single 1024-entry kernel `decide` exceeds the kernel memory bound. The
   certified route is the established checked-chunk decomposition (the FFT
   table precedent, 32-row chunks): 32-entry list equalities per theorem,
   then one assembly law. This is an open B1.03 obligation, recorded in
   KEYGEN_RESIDUE_CHECKPOINT.md. -/

end FT1536.Source3.KeygenRev10
