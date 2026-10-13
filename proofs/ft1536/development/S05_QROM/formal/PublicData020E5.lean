import BoundaryFill020E5
import PublicImage020E4

set_option exponentiation.threshold 512
namespace FT1536.S05.PublicData020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5

def fieldCodec : Codec (ZMod 18433) 1 :=
  contramap (finCodec 18433 (by norm_num)) (fun z => (⟨z.val,ZMod.val_lt z⟩ : Fin 18433))
    (by intro a b h;apply ZMod.val_injective;exact congrArg Fin.val h)

def cellCodec : Codec SyntaxCells020E.Cell 2 := pair (finCodec 16 (by norm_num)) wordCodec

/-- The public image is resident data. The tables are prepared literals,
    not runtime calls computing a CDF or a free unbounded key function. -/
structure Data where
  key : CostInput020E4.Key
  cdf : Bank Word 30721
  threshold : Bank Word 61441
  code : Bank SyntaxCells020E.Cell 877

def codeBank : Bank SyntaxCells020E.Cell 877 :=
  load (fun j => PublicImage020E4.cells[j.val]'(by rw [PublicImage020E4.length];exact j.isLt))

def prepared (k : CostInput020E4.Key) : Data :=
  ⟨k,load (fun j => word (StandaloneRuntime019.tables.cdf j)),
    load (fun j => word (StandaloneRuntime019.tables.threshold j)),codeBank⟩

def shape (d : Data) := (d.key,(d.cdf,(d.threshold,d.code)))

theorem shape_injective : Function.Injective shape := by
  intro a b h
  exact congrArg (fun p : CostInput020E4.Key × (Bank Word 30721 × (Bank Word 61441 × Bank SyntaxCells020E.Cell 877)) =>
    (⟨p.1,p.2.1,p.2.2.1,p.2.2.2⟩ : Data)) h

def codec : Codec Data (768*2+(30721*1+(61441*1+877*2))) :=
  contramap (pair (bank (pair fieldCodec fieldCodec) 768) (pair (bank wordCodec 30721)
    (pair (bank wordCodec 61441) (bank cellCodec 877)))) shape shape_injective

def image (d : Data) := pack codec d

theorem image_injective : Function.Injective image := by
  intro a b h
  apply codec.injective
  have hh := congrArg read h
  simpa only [image,pack_read] using hh

def romCell (d : Data) (a : Fin romSize) : Word :=
  if hc : a.val<30721 then read d.cdf ⟨a.val,hc⟩ else
  if ht : a.val<92162 then read d.threshold ⟨a.val-30721,by omega⟩ else
  if hk : a.val-92162<768 then word (read d.key ⟨a.val-92162,hk⟩).1.val else
    word (read d.key ⟨a.val-92930,by have := a.isLt;simp only [romSize] at this;omega⟩).2.val

theorem romCell_eq (k : CostInput020E4.Key) (a : Fin romSize) :
    romCell (prepared k) a=InputLayout020.image (CostInput020E4.key k) a := by
  unfold romCell InputLayout020.image
  simp only [prepared,read_load,CostInput020E4.key]

theorem code_eq : List.ofFn (read codeBank)=PublicImage020E4.cells := by
  apply List.ext_getElem
  · simp only [List.length_ofFn,PublicImage020E4.length]
  · intro j hj hj'
    simp only [List.getElem_ofFn,codeBank,read_load]

theorem image_size (d : Data) : (image d).cells.size=95452 := (image d).size_eq

/-- Use this reader in the fill loop; the old chunked-reader implementation
    is only a value-refinement target, never an additional resident input. -/
def filledROM (d : Data) : Bank Word romSize := BoundaryFill020E5.fill (romCell d) 0

theorem filledROM_eq (k : CostInput020E4.Key) : filledROM (prepared k)=BoundaryFill020E5.rom k := by
  rw [filledROM,BoundaryFill020E5.fill_eq,BoundaryFill020E5.rom_eq]
  exact congrArg load (funext (romCell_eq k))

end FT1536.S05.PublicData020E5
