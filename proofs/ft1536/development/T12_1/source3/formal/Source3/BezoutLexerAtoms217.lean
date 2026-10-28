import Source3.BezoutLexerPieces217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One-step source lexer equations at concrete token boundaries. -/
namespace FT1536.Source3.BezoutLexerAtoms217

theorem word_if (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('i'::'f'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map ("if".toList::·) := by rfl

theorem word_alen (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('a'::'l'::'e'::'n'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map ("alen".toList::·) := by rfl

theorem word_blen (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('b'::'l'::'e'::'n'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map ("blen".toList::·) := by rfl

theorem digit_space (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('3'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map ("3".toList::·) := by rfl

theorem digit_close (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('3'::')'::t)=
      (KeygenZintCall.tokenize [] n (')'::t)).map ("3".toList::·) := by rfl

theorem open_alen (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('('::'a'::t)=
      (KeygenZintCall.tokenize [] n ('a'::t)).map ("(".toList::·) := by rfl

theorem ge (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('>'::'='::t)=
      (KeygenZintCall.tokenize [] n t).map (">=".toList::·) := by rfl

theorem lor (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('|'::'|'::t)=
      (KeygenZintCall.tokenize [] n t).map ("||".toList::·) := by rfl

theorem close_space (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) (')'::' '::t)=
      (KeygenZintCall.tokenize [] n (' '::t)).map (")".toList::·) := by rfl

theorem brace_newline (n : Nat) (t : List Char) :
    KeygenZintCall.tokenize [] (n+1) ('{'::'\n'::t)=
      (KeygenZintCall.tokenize [] n ('\n'::t)).map ("{".toList::·) := by rfl

end FT1536.Source3.BezoutLexerAtoms217
