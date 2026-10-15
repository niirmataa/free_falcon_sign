#!/usr/bin/env python3
"""Generate bounded kernel image checks and a complete finite-index assembly."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
FORMAL=ROOT/'formal/Source3'
options='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n'
for k in range(24):
    name=f'ConvertedImage136Part{k:02d}'
    text='import Source3.ConvertedWords136\n\n'+options+'\nnamespace FT1536.Source3.'+name+'\nopen ConvertedWords136\n\n'
    for tag in ['f','g']:
        text+=f'theorem {tag}_checked : ∀ i : Fin 64,\n    C99FiniteRead114.read64 imageHeap ({tag}Pointer (index ⟨{k},by decide +kernel⟩ i))=some ({tag}Word (index ⟨{k},by decide +kernel⟩ i)) := by decide +kernel\n\n'
    text+='end FT1536.Source3.'+name+'\n'
    path=FORMAL/(name+'.lean');assert not path.exists() or path.read_text()==text;path.write_text(text)
name='ConvertedImages136'
text='\n'.join('import Source3.ConvertedImage136Part'+f'{k:02d}' for k in range(24))+'\n\n'+options+'\nnamespace FT1536.Source3.'+name+'\nopen ConvertedWords136\nopen C99CompactState115 (reference)\n\n'
for tag in ['f','g']:
    text+=f'theorem {tag}_parts (part : Fin 24) : ∀ i : Fin 64,\n    C99FiniteRead114.read64 imageHeap ({tag}Pointer (index part i))=some ({tag}Word (index part i)) := by\n  fin_cases part\n'
    for k in range(24):text+=f'  · exact ConvertedImage136Part{k:02d}.{tag}_checked\n'
    text+=f'\ntheorem {tag}_checked (i : Fin 1536) :\n    C99FiniteRead114.read64 imageHeap ({tag}Pointer i)=some ({tag}Word i) := by\n  let part : Fin 24 := ⟨i.val/64,by omega⟩\n  let offset : Fin 64 := ⟨i.val%64,by omega⟩\n  have same : index part offset=i := by\n    apply Fin.ext\n    dsimp [index,part,offset]\n    omega\n  have checked := {tag}_parts part offset\n  rw [same] at checked\n  exact checked\n\n'
    text+=f'theorem {tag}_source (i : Fin 1536) : C99MemoryReference.Load64\n    (reference SelectedSmallGComplete136.after).heap ({tag}Pointer i) ({tag}Word i) :=\n  C99BlockReads136.load64_transfer SelectedSmallGComplete136.after.heap imageHeap ({tag}Pointer i) ({tag}Word i)\n    (block_same ({tag}Pointer i) rfl) (C99FiniteRead114.read64_sound _ _ _ ({tag}_checked i))\n\n'
text+='end FT1536.Source3.'+name+'\n';path=FORMAL/(name+'.lean');assert not path.exists() or path.read_text()==text;path.write_text(text)
