import ProducerFetchStore020E6
import ZeroAllocate020E5

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerInitial020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5

theorem zero_image (regions codeSize : Nat) (hr : regions≤2^511) (hc : codeSize<2^511) :
    ProducerFetchStore020E6.image hr hc (ProducerFetch020E6.start (regions:=regions) (ProducerMachine020E6.initial codeSize))=
      zero 186 (0 : Word) := by
  change pack (pair (ProducerCodec020E6.state codeSize hc) (ProducerFetchStore020E6.tailCodec regions codeSize hr))
    (ProducerMachine020E6.initial codeSize,(none,false))=_
  rw [pack_pair]
  have hs : pack (ProducerCodec020E6.state codeSize hc) (ProducerMachine020E6.initial codeSize)=zero 162 (0 : Word) :=
    ProducerCodec020E6.initial_zero codeSize hc
  rw [hs,StartupImage020E5.pack_zero (ProducerFetchStore020E6.tailCodec regions codeSize hr) (none,false)
    (by intro j;fin_cases j <;> rfl),ZeroCodec020E5.join_zero]

theorem allocated_image (regions codeSize : Nat) (hr : regions≤2^511) (hc : codeSize<2^511) (heap : RegionRam020E5.Heap) :
    (ZeroAllocate020E5.allocate heap 186)[heap.size]'(by rw [ZeroAllocate020E5.size];omega)=
      ⟨(ProducerFetchStore020E6.image hr hc (ProducerFetch020E6.start (regions:=regions) (ProducerMachine020E6.initial codeSize))).cells⟩ := by
  rw [ZeroAllocate020E5.initialized,zero_image,StartupImage020E5.zero_cells]

end FT1536.S05.ProducerInitial020E6
