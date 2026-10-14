import Source3.KeygenPublicInput124
import Source3.SelectedSeedBytes119

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedInput124
open C99CompactState115 (State reference)
open KeygenCallerData123 (env base rawEnv)

theorem option_get (value : Option α) (known : value.isSome=true) : value=some (value.get known) := by
  cases value with
  | none => cases known
  | some x => rfl

def seed := SelectedSeedBytes119.seed
def result := KeygenPublicInput124.seed env base 0 seed 128 64

theorem defined : result.isSome=true := by decide +kernel

def seeded : State := result.get defined

theorem computed : KeygenPublicInput124.seed env base 0 seed 128 64=some seeded := option_get result defined

/-- The public32-byte replace call, on the SAME closed base heap as the
    whole-law input. No native execution or desired RNG state is a premise. -/
theorem source : KeygenSeedEntry089.Seeded env (reference base) 0 seed (reference seeded) :=
  KeygenPublicInput124.seed_sound env base seeded 0 seed 128 64 computed

def domain : KeygenWholeBytes088.Domain env (reference seeded) :=
  KeygenWholeStages109.domain rawEnv KeygenCallerDomain123.input seed (reference seeded) source

end FT1536.Source3.SelectedInput124
