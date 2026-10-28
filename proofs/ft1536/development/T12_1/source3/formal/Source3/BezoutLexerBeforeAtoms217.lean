import Source3.BezoutLexerAfter217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Additional exact lexer steps for the for-loop header and r declaration. -/
namespace FT1536.Source3.BezoutLexerBeforeAtoms217

theorem word_for (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('f'::'o'::'r'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map ("for".toList::·) := by rfl

theorem word_int (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('i'::'n'::'t'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map ("int".toList::·) := by rfl

theorem word_r (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('r'::';'::t)=
      (KeygenZintCall.tokenize [] n (';'::t)).map ("r".toList::·) := by rfl

theorem open_semi (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('('::';'::t)=
      (KeygenZintCall.tokenize [] n (';'::t)).map ("(".toList::·) := by rfl

theorem semi_semi (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) (';'::';'::t)=
      (KeygenZintCall.tokenize [] n (';'::t)).map (";".toList::·) := by rfl

theorem semi_close (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) (';'::')'::t)=
      (KeygenZintCall.tokenize [] n (')'::t)).map (";".toList::·) := by rfl

theorem semi_newline (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) (';'::'\n'::t)=
      (KeygenZintCall.tokenize [] n ('\n'::t)).map (";".toList::·) := by rfl

end FT1536.Source3.BezoutLexerBeforeAtoms217
