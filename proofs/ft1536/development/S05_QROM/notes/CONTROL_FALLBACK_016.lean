import FiniteLaw016

/- A finite mathematical negative control, not a production sampler test.
   Rejected coin b reused via1-b gives a different law from a fresh coin. -/
namespace FT1536.S05.ControlFallback016
open FT1536.Run2.FiberBinding

def shared (b : Bool) : Bool := if b then true else !b
def fresh (coins : Bool×Bool) : Bool := if coins.1 then true else !coins.2

theorem shared_one : ((Law.uniform : Law Bool).map shared).mass true=1 := by
  rw [map_mass]
  norm_num [shared,Law.uniform,Fintype.sum_bool]

theorem fresh_three_quarters : ((Law.uniform : Law (Bool×Bool)).map fresh).mass true=3/4 := by
  rw [map_mass]
  norm_num [fresh,Law.uniform,Fintype.sum_prod_type,Fintype.sum_bool]

theorem correlation_changes_law : (Law.uniform : Law Bool).map shared≠
    (Law.uniform : Law (Bool×Bool)).map fresh := by
  intro he
  have hh := congrArg (fun p : Law Bool => p.mass true) he
  rw [shared_one,fresh_three_quarters] at hh
  norm_num at hh

#print axioms shared_one
#print axioms fresh_three_quarters
#print axioms correlation_changes_law
end FT1536.S05.ControlFallback016
