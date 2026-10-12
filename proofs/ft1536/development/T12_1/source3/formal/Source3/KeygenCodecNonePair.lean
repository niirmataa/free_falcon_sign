import Source3.KeygenCodecNoneCursor

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNonePair
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor
open KeygenCodecGuardedWrite (Window)
open KeygenCodecStaticWindow (window_refl window_trans)

theorem store_window (args : Args) (s t : State) (flow : Flow) (n d : Nat)
    (rhs : Expr) (dst : ArrayPointer) (bound : n<3072) (even : n%2=0) (step : d≤1)
    (capacity : 3072≤args.capacity.toNat) (cursor : Cursor n s.locals)
    (buffer : s.buf=some (some dst))
    (source : Exec args (.write (.index (.variable "buf".toList) (index d)) .set rhs) s t flow) :
    Window dst args.capacity.toNat s.heap t.heap := by
  have inside : n+d<args.capacity.toNat := by omega
  have small : n+d<2^64 := by omega
  cases source with
  | store args s index rhs middle last ptr offset word after held indexValue nonnegative rhsValue write =>
    have pointer : ptr=dst := by simpa using held.symm.trans buffer
    subst ptr
    obtain ⟨same,_⟩ := index_eval args s middle (.integer offset) n d small (by omega) cursor indexValue
    have integer : offset=.uint64 (BitVec.ofNat 64 (n+d)) := Value.integer.inj same
    subst offset
    have natValue : (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (n+d))).integer.toNat=n+d := by
      rw [unsigned_nat64 (n+d) small]
      rfl
    simpa only [natValue] using KeygenCodecGuardedWrite.store_window dst args.capacity.toNat (n+d) s.heap after (BitVec.ofInt 8 word.integer) inside (by simpa only [natValue] using write)

theorem pair_body (args : Args) (s t : State) (flow : Flow) (n : Nat)
    (dst : ArrayPointer) (bound : n<3072) (even : n%2=0)
    (capacity : 3072≤args.capacity.toNat) (cursor : Cursor n s.locals)
    (buffer : s.buf=some (some dst))
    (source : Exec args KeygenCodecNoneBinding.node031 s t flow) :
    Window dst args.capacity.toNat s.heap t.heap := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨declared,decl,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node022 KeygenCodecNoneBinding.node029 s t flow inside (by rfl)
    obtain ⟨loaded,load,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node023 KeygenCodecNoneBinding.node028 declared t flow rest (by rfl)
    obtain ⟨high,writeHigh,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node024 KeygenCodecNoneBinding.node027 loaded t flow rest (by rfl)
    obtain ⟨low,writeLow,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node025 KeygenCodecNoneBinding.node026 high t flow rest (by rfl)
    cases rest
    have declHeap := KeygenCodecStateFrame.heap_frame args _ s declared .normal decl (by decide +kernel)
    have loadHeap := KeygenCodecStateFrame.heap_frame args _ declared loaded .normal load (by decide +kernel)
    have declCursor : Cursor n declared.locals :=
      (KeygenCodecCellFrame.exec_frame "u".toList args _ s declared .normal decl (by decide +kernel)).trans cursor
    have loadCursor : Cursor n loaded.locals :=
      (KeygenCodecCellFrame.exec_frame "u".toList args _ declared loaded .normal load (by decide +kernel)).trans declCursor
    have declBuf := (KeygenCodecStateFrame.buf_frame args _ s declared .normal decl (by decide +kernel)).trans buffer
    have loadBuf := (KeygenCodecStateFrame.buf_frame args _ declared loaded .normal load (by decide +kernel)).trans declBuf
    have first := store_window args loaded high .normal n 0 _ dst bound even (by decide +kernel) capacity loadCursor loadBuf writeHigh
    have highCursor : Cursor n high.locals :=
      (KeygenCodecCellFrame.exec_frame "u".toList args _ loaded high .normal writeHigh (by decide +kernel)).trans loadCursor
    have highBuf := (KeygenCodecStateFrame.buf_frame args _ loaded high .normal writeHigh (by decide +kernel)).trans loadBuf
    have second := store_window args high t .normal n 1 _ dst bound even (by decide +kernel) capacity highCursor highBuf writeLow
    have result := window_trans dst _ _ _ _ first second
    simpa only [scopeExit,loadHeap,declHeap] using result

end FT1536.Source3.KeygenCodecNonePair
