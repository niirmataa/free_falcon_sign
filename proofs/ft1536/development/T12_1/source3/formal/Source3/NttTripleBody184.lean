import Source3.NttTripleStores184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleBody184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open NttTripleStates184
open KeygenNttButterflyPrograms (tripleBody declaration assign read zero scalar write)

theorem shape : KeygenNttForwardPrograms.block tripleBody=.scope names tripleBody := by decide

theorem source (s : State) (a gm : ArrayPointer) (i r : Nat) (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) (bound : i+2<1536) (rb : r<1024)
    (r1 : s.arrays "r1".toList=some (element a i)) (rc : USlot s "r" r)
    (readX : Load32 s.heap (element gm r) z.x)
    (readA : Load32 s.heap (element a i) z.a) (readB : Load32 s.heap (element a (i+1)) z.b)
    (readC : Load32 s.heap (element a (i+2)) z.c) :
    Exec (KeygenNttForwardPrograms.block tripleBody) s ⟨after s a i z,.normal⟩ := by
  rw [shape]
  exact .scope names tripleBody s ⟨third s a i z,.normal⟩
    (.seqNormal _ _ (s) (declaredA s) _ (NttTripleLoads184.dA s) (.seqNormal _ _ (declaredA s) (declared s) _ (NttTripleLoads184.dB s) (.seqNormal _ _ (declared s) (state1 s z) _ (NttTripleLoads184.h1 s a gm r z fixed rb rc readX) (.seqNormal _ _ (state1 s z) (state2 s z) _ (NttTripleLoads184.h2 s a gm z fixed) (.seqNormal _ _ (state2 s z) (state3 s z) _ (NttTripleLoads184.h3 s a gm i z fixed bound r1 readA) (.seqNormal _ _ (state3 s z) (state4 s z) _ (NttTripleLoads184.h4 s a gm i z fixed bound r1 readB) (.seqNormal _ _ (state4 s z) (state5 s z) _ (NttTripleLoads184.h5 s a gm i z fixed bound r1 readC) (.seqNormal _ _ (state5 s z) (state6 s z) _ (NttTripleScales184.h6 s a gm z fixed) (.seqNormal _ _ (state6 s z) (state7 s z) _ (NttTripleScales184.h7 s a gm z fixed) (.seqNormal _ _ (state7 s z) (state8 s z) _ (NttTripleScales184.h8 s a gm z fixed) (.seqNormal _ _ (state8 s z) (state9 s z) _ (NttTripleScales184.h9 s a gm z fixed) (.seqNormal _ _ (state9 s z) (state10 s z) _ (NttTripleScales184.h10 s a gm z fixed) (.seqNormal _ _ (state10 s z) (state11 s z) _ (NttTripleScales184.h11 s a gm z fixed) (.seqNormal _ _ (state11 s z) (first s a i z) _ (NttTripleStores184.w0 s a gm i z fixed bound r1) (.seqNormal _ _ (first s a i z) (second s a i z) _ (NttTripleStores184.w1 s a gm i z fixed bound r1) (.seqNormal _ _ (second s a i z) (third s a i z) _ (NttTripleStores184.w2 s a gm i z fixed bound r1) (.base .skip (third s a i z) (third s a i z) (.skip (third s a i z)))))))))))))))))))

end FT1536.Source3.NttTripleBody184
