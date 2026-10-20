import Run2.BitModular
namespace FT1536.Run2.BitArithmetic
def modulusBits : List Bool := [true, false, false, false, false, false, false, false, false, false, false, true, false, false, true]
theorem modulusBits_value : value modulusBits=18433 := by norm_num [modulusBits,value,bit]
theorem modulusBits_length : modulusBits.length=15 := rfl
def negOneBits : List Bool := [false, false, false, false, false, false, false, false, false, false, false, true, false, false, true]
theorem negOneBits_value : value negOneBits=18432 := by norm_num [negOneBits,value,bit]
theorem negOneBits_length : negOneBits.length=15 := rfl
theorem field_cost_arithmetic :
  64*(16+16+1)*(16+1)+128*(48+15+1)*(48+1)+2*15+1+1 < (2 : ℕ)^20 := by norm_num
end FT1536.Run2.BitArithmetic
