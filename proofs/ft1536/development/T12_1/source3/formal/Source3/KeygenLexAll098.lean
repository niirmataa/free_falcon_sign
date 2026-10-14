import Source3.KeygenLexChunks098A
import Source3.KeygenLexChunks098B
import Source3.KeygenLexChunks098C
import Source3.KeygenLexChunks098D
import Source3.KeygenLexChunks098E
import Source3.KeygenLexData098
import Source3.KeygenLexFinish098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexAll098

def whole : KeygenLexCompose098.Chunk := KeygenLexCompose098.append KeygenLexChunks098A.chunk00 (KeygenLexCompose098.append KeygenLexChunks098A.chunk01 (KeygenLexCompose098.append KeygenLexChunks098A.chunk02 (KeygenLexCompose098.append KeygenLexChunks098A.chunk03 (KeygenLexCompose098.append KeygenLexChunks098A.chunk04 (KeygenLexCompose098.append KeygenLexChunks098A.chunk05 (KeygenLexCompose098.append KeygenLexChunks098A.chunk06 (KeygenLexCompose098.append KeygenLexChunks098A.chunk07 (KeygenLexCompose098.append KeygenLexChunks098A.chunk08 (KeygenLexCompose098.append KeygenLexChunks098B.chunk09 (KeygenLexCompose098.append KeygenLexChunks098B.chunk10 (KeygenLexCompose098.append KeygenLexChunks098B.chunk11 (KeygenLexCompose098.append KeygenLexChunks098B.chunk12 (KeygenLexCompose098.append KeygenLexChunks098B.chunk13 (KeygenLexCompose098.append KeygenLexChunks098B.chunk14 (KeygenLexCompose098.append KeygenLexChunks098B.chunk15 (KeygenLexCompose098.append KeygenLexChunks098B.chunk16 (KeygenLexCompose098.append KeygenLexChunks098B.chunk17 (KeygenLexCompose098.append KeygenLexChunks098C.chunk18 (KeygenLexCompose098.append KeygenLexChunks098C.chunk19 (KeygenLexCompose098.append KeygenLexChunks098C.chunk20 (KeygenLexCompose098.append KeygenLexChunks098C.chunk21 (KeygenLexCompose098.append KeygenLexChunks098C.chunk22 (KeygenLexCompose098.append KeygenLexChunks098C.chunk23 (KeygenLexCompose098.append KeygenLexChunks098C.chunk24 (KeygenLexCompose098.append KeygenLexChunks098C.chunk25 (KeygenLexCompose098.append KeygenLexChunks098C.chunk26 (KeygenLexCompose098.append KeygenLexChunks098D.chunk27 (KeygenLexCompose098.append KeygenLexChunks098D.chunk28 (KeygenLexCompose098.append KeygenLexChunks098D.chunk29 (KeygenLexCompose098.append KeygenLexChunks098D.chunk30 (KeygenLexCompose098.append KeygenLexChunks098D.chunk31 (KeygenLexCompose098.append KeygenLexChunks098D.chunk32 (KeygenLexCompose098.append KeygenLexChunks098D.chunk33 (KeygenLexCompose098.append KeygenLexChunks098D.chunk34 (KeygenLexCompose098.append KeygenLexChunks098D.chunk35 (KeygenLexCompose098.append KeygenLexChunks098E.chunk36 (KeygenLexCompose098.append KeygenLexChunks098E.chunk37 (KeygenLexCompose098.append KeygenLexChunks098E.chunk38 (KeygenLexCompose098.append KeygenLexChunks098E.chunk39 (KeygenLexCompose098.append KeygenLexChunks098E.chunk40 (KeygenLexCompose098.empty)))))))))))))))))))))))))))))))))))))))))

theorem lines_source : whole.lines = KeygenBezoutText098.lines := by decide +kernel
theorem raw_value : whole.raw ++ [['}']] = KeygenLexData098.raw := by decide +kernel

theorem chars_value : KeygenBezoutText098.chars = KeygenLexFinish098.chars whole.lines :=
  congrArg KeygenLexFinish098.chars lines_source.symm

theorem tokens_source : KeygenZintCall.tokens KeygenBezoutText098.chars = some KeygenLexData098.tokens :=
  (congrArg KeygenZintCall.tokens chars_value).trans
    ((KeygenLexFinish098.normalized whole).trans
      (congrArg some ((congrArg C99ArrayParser.normalizeTypes raw_value).trans KeygenLexData098.normalized)))

end FT1536.Source3.KeygenLexAll098
