import Source3.C99IntegerReference
import B20.C.Integer

namespace FT1536.Source3.C99ValueBridge
def type : B20.C.Ty → C99IntegerReference.Ty
  | .u64 => .uint64
  | .i64 => .int64
  | .u32 => .uint32
  | .i32 => .int32

def value : B20.C.Val → C99IntegerReference.Value
  | .u64 w => .uint64 w
  | .i64 w => .int64 w
  | .u32 w => .uint32 w
  | .i32 w => .int32 w

def encode : C99IntegerReference.Value → B20.C.Val
  | .uint64 w => .u64 w
  | .int64 w => .i64 w
  | .uint32 w => .u32 w
  | .int32 w => .i32 w

theorem encode_value (v : B20.C.Val) : encode (value v)=v := by cases v <;> rfl
theorem value_encode (v : C99IntegerReference.Value) : value (encode v)=v := by cases v <;> rfl
theorem integer_matches (v : B20.C.Val) : (value v).integer=v.integer := by cases v <;> rfl
theorem type_matches (v : B20.C.Val) : (value v).type=type v.ty := by cases v <;> rfl

theorem usual_matches (a b : B20.C.Ty) :
    C99IntegerReference.usual (C99IntegerReference.promote (type a))
      (C99IntegerReference.promote (type b))=type (B20.C.commonTy a b) := by
  cases a <;> cases b <;> decide

theorem cast_matches (t : B20.C.Ty) (v : B20.C.Val) :
    value (B20.C.cast t v)=C99IntegerReference.convert (type t) (value v).integer := by
  cases t <;> cases v <;>
    simp [value,type,B20.C.cast,C99IntegerReference.convert,C99IntegerReference.Value.integer]
  all_goals first | rfl | exact (BitVec.signExtend_eq_setWidth_of_le _ (by decide)).symm

end FT1536.Source3.C99ValueBridge

#print axioms FT1536.Source3.C99ValueBridge.usual_matches
#print axioms FT1536.Source3.C99ValueBridge.cast_matches
