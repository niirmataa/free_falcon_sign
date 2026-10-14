import Source3.KeygenZintExtractArity098
import Lean.Elab.Tactic.Cbv

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTokenizerStep098
open B20.C (Token)
open KeygenZintCall (tokenize expand)

@[cbv_eval]
theorem zero (macros : List (Token × List Token)) (chars : List Char) : tokenize macros 0 chars = none := rfl

/-- A source unfolding equation. Supplying the complete step avoids
    the evaluator's failed automatic equation generation for overlapping
    slash/shift-token patterns; no tokenization result is assumed. -/
@[cbv_eval]
theorem step (macros : List (Token × List Token)) (fuel : Nat) (chars : List Char) :
    tokenize macros (Nat.succ fuel) chars =
      match chars with
      | [] => some []
      | '/' :: '*' :: rest => do
          let tail ← B20.C.Scalar.skipBlock (rest.length + 1) rest
          tokenize macros fuel tail
      | '/' :: '/' :: rest => tokenize macros fuel (rest.dropWhile (· != '\n'))
      | '#' :: cs =>
          let line := cs.takeWhile (· != '\n')
          let beyond := cs.drop line.length
          let directive := line.takeWhile B20.C.wordChar
          let after := line.drop directive.length
          if directive = "undef".toList then
            let name := (after.dropWhile (· == ' ')).takeWhile B20.C.wordChar
            tokenize (macros.filter (fun entry => entry.1 ≠ name)) fuel beyond
          else if directive = "define".toList then
            let spacing := after.dropWhile (· == ' ')
            let name := spacing.takeWhile B20.C.wordChar
            let body := (spacing.drop name.length).dropWhile (· == ' ')
            do
              let expansion ← tokenize macros fuel body
              tokenize ((name, expansion) :: macros) fuel beyond
          else none
      | c :: cs =>
          if c == ' ' || c == '\t' || c == '\n' || c == '\r' then tokenize macros fuel cs
          else if B20.C.wordChar c then
            let tail := cs.takeWhile B20.C.wordChar
            let emitted := expand macros (c :: tail)
            (tokenize macros fuel (cs.drop tail.length)).map (emitted ++ ·)
          else match c, cs with
            | '+', '+' :: rest => (tokenize macros fuel rest).map (['+', '+'] :: ·)
            | '>', '>' :: '=' :: rest => (tokenize macros fuel rest).map (['>', '>', '='] :: ·)
            | '<', '<' :: '=' :: rest => (tokenize macros fuel rest).map (['<', '<', '='] :: ·)
            | '>', '>' :: rest => (tokenize macros fuel rest).map (['>', '>'] :: ·)
            | '<', '<' :: rest => (tokenize macros fuel rest).map (['<', '<'] :: ·)
            | '&', '&' :: rest => (tokenize macros fuel rest).map (['&', '&'] :: ·)
            | '|', '|' :: rest => (tokenize macros fuel rest).map (['|', '|'] :: ·)
            | _, '=' :: rest =>
                if ['+', '-', '*', '^', '&', '|', '=', '!', '<', '>'].contains c then
                  (tokenize macros fuel rest).map ([c, '='] :: ·)
                else none
            | _, _ =>
                if ['(', ')', '{', '}', '[', ']', ';', ',', '^', '&', '|', '-', '+', '*', '~', '=', '!', '<', '>', '.', '?', ':'].contains c
                then (tokenize macros fuel cs).map ([c] :: ·)
                else none := by
  conv_lhs => unfold tokenize
  split <;> simp_all
  all_goals repeat' (split <;> simp_all)
  all_goals split_ifs <;> simp_all


/-- Unrestricted head pattern for the proof-producing evaluator: it also
    matches a fuel expression before it is represented as a successor. -/
@[cbv_eval]
theorem unfold_all (macros : List (Token × List Token)) (fuel : Nat) (chars : List Char) :
    tokenize macros fuel chars =
      match fuel with
      | 0 => none
      | fuel + 1 =>
          match chars with
          | [] => some []
          | '/' :: '*' :: rest => do
              let tail ← B20.C.Scalar.skipBlock (rest.length + 1) rest
              tokenize macros fuel tail
          | '/' :: '/' :: rest => tokenize macros fuel (rest.dropWhile (· != '\n'))
          | '#' :: cs =>
              let line := cs.takeWhile (· != '\n')
              let beyond := cs.drop line.length
              let directive := line.takeWhile B20.C.wordChar
              let after := line.drop directive.length
              if directive = "undef".toList then
                let name := (after.dropWhile (· == ' ')).takeWhile B20.C.wordChar
                tokenize (macros.filter (fun entry => entry.1 ≠ name)) fuel beyond
              else if directive = "define".toList then
                let spacing := after.dropWhile (· == ' ')
                let name := spacing.takeWhile B20.C.wordChar
                let body := (spacing.drop name.length).dropWhile (· == ' ')
                do
                  let expansion ← tokenize macros fuel body
                  tokenize ((name, expansion) :: macros) fuel beyond
              else none
          | c :: cs =>
              if c == ' ' || c == '\t' || c == '\n' || c == '\r' then tokenize macros fuel cs
              else if B20.C.wordChar c then
                let tail := cs.takeWhile B20.C.wordChar
                let emitted := expand macros (c :: tail)
                (tokenize macros fuel (cs.drop tail.length)).map (emitted ++ ·)
              else match c, cs with
                | '+', '+' :: rest => (tokenize macros fuel rest).map (['+', '+'] :: ·)
                | '>', '>' :: '=' :: rest => (tokenize macros fuel rest).map (['>', '>', '='] :: ·)
                | '<', '<' :: '=' :: rest => (tokenize macros fuel rest).map (['<', '<', '='] :: ·)
                | '>', '>' :: rest => (tokenize macros fuel rest).map (['>', '>'] :: ·)
                | '<', '<' :: rest => (tokenize macros fuel rest).map (['<', '<'] :: ·)
                | '&', '&' :: rest => (tokenize macros fuel rest).map (['&', '&'] :: ·)
                | '|', '|' :: rest => (tokenize macros fuel rest).map (['|', '|'] :: ·)
                | _, '=' :: rest =>
                    if ['+', '-', '*', '^', '&', '|', '=', '!', '<', '>'].contains c then
                      (tokenize macros fuel rest).map ([c, '='] :: ·)
                    else none
                | _, _ =>
                    if ['(', ')', '{', '}', '[', ']', ';', ',', '^', '&', '|', '-', '+', '*', '~', '=', '!', '<', '>', '.', '?', ':'].contains c
                    then (tokenize macros fuel cs).map ([c] :: ·)
                    else none := by
  cases fuel with
  | zero => rfl
  | succ fuel => exact step macros fuel chars

end FT1536.Source3.KeygenTokenizerStep098
