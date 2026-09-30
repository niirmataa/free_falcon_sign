# Authoritative exact integer fixture generator for kernel feasibility only.
from pathlib import Path
import hashlib, json, sys, time
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
assert len(sys.argv) >= 2
out = Path('generated')
out.mkdir(exist_ok=False)
rows = []
for arg in sys.argv[1:]:
    fields = arg.split(':')
    exponent = ZZ(fields[0])
    kind = fields[1] if len(fields)>1 else 'product'
    fmt = fields[2] if len(fields)>2 else 'hex'
    assert kind in ['product','data','split','multiply','badmultiply','fold']
    assert fmt in ['hex','ffi']
    assert 2 <= exponent <= 22
    n = ZZ(2)^exponent
    digit_bits = ZZ(128)
    base = ZZ(2)^digit_bits
    bits = n*digit_bits
    start = time.monotonic()
    # Distinct data chunks avoid an unrealistically cheap repeated-literal fixture.
    ab,bb = bytearray(),bytearray()
    for j in range(int(n)):
        av = (ZZ(j)*65537+17) % 1000003
        bv = (ZZ(j)*131071+31) % 1000033
        ab.extend(int(av).to_bytes(int(digit_bits//8),'little'))
        bb.extend(int(bv).to_bytes(int(digit_bits//8),'little'))
    a,b = ZZ(int.from_bytes(ab,'little')),ZZ(int.from_bytes(bb,'little'))
    product = a*b
    mask = (ZZ(1)<<bits)-1
    c = (product & mask)+(product>>bits)
    assert n*1000003*1000033 < base
    assert c < (ZZ(1)<<bits)
    module = 'PackedConvolution'+str(exponent)+('_'+kind if kind!='product' else '')+('_ffi' if fmt=='ffi' else '')
    code = '''import Lean
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
open Lean Elab Term

/- The elaborator below only decodes untrusted certificate DATA into Nat
   literals. It produces no proof and performs no acceptance check. The
   equality is checked separately by ordinary kernel reduction. -/
private def hexDigit (c : UInt8) : Nat :=
  let n := c.toNat
  if n <= 57 then n-48 else n-87

private def hexSmall (data : ByteArray) (start count : Nat) : Nat :=
  (List.range count).foldl (fun n j => n*16+hexDigit data[start+j]!) 0

private def hexBalanced (data : ByteArray) (start count : Nat) : Nat :=
  if count <= 1024 then hexSmall data start count
  else
    let lo := count/2
    let hi := count-lo
    (hexBalanced data start lo <<< (4*hi))+hexBalanced data (start+lo) hi
termination_by count
decreasing_by all_goals omega

syntax "packed_nat% " str : term
elab_rules : term
  | `(packed_nat% $s:str) => do
    let data := s.getString.toUTF8
    for c in data.data do
      unless (48 <= c.toNat && c.toNat <= 57) || (97 <= c.toNat && c.toNat <= 102) do
        throwError "invalid hexadecimal certificate data"
    return mkNatLit (hexBalanced data 0 data.size)

syntax "packed_pow2% " num : term
elab_rules : term
  | `(packed_pow2% $n:num) => return mkNatLit (1 <<< n.getNat)

namespace RadialKernelFeasibility
def packedA : Nat := packed_nat% "A_VALUE"
def packedB : Nat := packed_nat% "B_VALUE"
def packedC : Nat := packed_nat% "C_VALUE"
def radixPower : Nat := packed_pow2% TOTAL_BITS
theorem exact_cyclic_product :
  (packedA*packedB)%radixPower+(packedA*packedB)/radixPower=packedC := by
  decide
#print axioms exact_cyclic_product
end RadialKernelFeasibility
'''.replace('A_VALUE',hex(a)[2:]).replace('B_VALUE',hex(b)[2:]).replace('C_VALUE',hex(c)[2:]).replace('TOTAL_BITS',str(bits))
    if kind == 'data':
        code = code[:code.index('theorem exact_cyclic_product')] + '#check packedA\nend RadialKernelFeasibility\n'
    elif kind == 'split':
        half = bits//2
        suffix = '''def high : Nat := packed_nat% "HIGH_VALUE"
def low : Nat := packed_nat% "LOW_VALUE"
def halfPower : Nat := packed_pow2% HALF_BITS
theorem exact_split : high*halfPower+low=packedA := by decide
#print axioms exact_split
end RadialKernelFeasibility
'''.replace('HIGH_VALUE',hex(a>>half)[2:]).replace('LOW_VALUE',hex(a%2^half)[2:]).replace('HALF_BITS',str(half))
        code = code[:code.index('theorem exact_cyclic_product')]+suffix
    elif kind in ['multiply','badmultiply','fold']:
        claimed_product = product+1 if kind=='badmultiply' else product
        suffix = 'def fullProduct : Nat := packed_nat% "'+hex(claimed_product)[2:]+'"\n'
        if kind == 'badmultiply':
            suffix += 'theorem rejects_changed_product : packedA*packedB ≠ fullProduct := by decide\n#print axioms rejects_changed_product\n'
        elif kind == 'multiply':
            suffix += 'theorem exact_multiply : packedA*packedB=fullProduct := by decide\n#print axioms exact_multiply\n'
        else:
            suffix += 'def lowerPart : Nat := packed_nat% "'+hex(product & mask)[2:]+'"\n'
            suffix += 'def upperPart : Nat := packed_nat% "'+hex(product>>bits)[2:]+'"\n'
            suffix += 'theorem exact_fold : lowerPart+radixPower*upperPart=fullProduct ∧ lowerPart+upperPart=packedC := by decide\n#print axioms exact_fold\n'
        suffix += 'end RadialKernelFeasibility\n'
        code = code[:code.index('theorem exact_cyclic_product')]+suffix
    if fmt == 'ffi':
        # Inputs are parsed natively, like numeral tokens; no proof checking is
        # performed by the loader. The resulting Expr contains only Nat literals.
        loader = '''import Lean
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
open Lean Elab Term
namespace RadialCertificate.Loader
@[extern "ft1536_radial_nat_data"]
opaque decimalNat (_s : @& String) : Nat := 0
end RadialCertificate.Loader
syntax "packed_file% " str : term
elab_rules : term
  | `(packed_file% $s:str) => do
    let root <- IO.getEnv "RADIAL_CERT_DATA"
    let some root := root | throwError "RADIAL_CERT_DATA not set"
    let data <- IO.FS.readFile (System.FilePath.mk root / s.getString)
    return mkNatLit (RadialCertificate.Loader.decimalNat data)
syntax "packed_pow2% " num : term
elab_rules : term
  | `(packed_pow2% $n:num) => return mkNatLit (1 <<< n.getNat)
namespace RadialKernelFeasibility
'''
        code = loader+code.split('namespace RadialKernelFeasibility\n',1)[1]
        data_dir = out/'data'
        data_dir.mkdir(exist_ok=True)
        literal_index = [0]
        def store_literal(match):
            v = ZZ(match.group(1),16)
            name = module+'_'+str(literal_index[0])+'.decimal'
            literal_index[0] += 1
            (data_dir/name).write_text(str(v))
            return 'packed_file% "'+name+'"'
        import re
        code = re.sub(r'packed_nat% "([0-9a-f]+)"',store_literal,code)
    path = out/(module+'.lean')
    path.write_text(code)
    rows.append(dict(module=module, kind=kind, format=fmt, exponent=int(exponent), coefficients=int(n),
        expected_kernel_success=True, expected_certificate_acceptance=bool(kind!='badmultiply'),
        digit_bits=int(digit_bits), operand_bits=int(bits), source_bytes=path.stat().st_size,
        source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
        producer_elapsed_s=float(round(time.monotonic()-start,3))))
result = dict(schema='RADIAL_PACKED_KERNEL_FEASIBILITY_V1',fixtures=rows,
    all_public_synthetic=True,actual_radial_certificate=False,
    arithmetic='Sage preparser + exact ZZ; generated theorem uses ordinary kernel decide',
    purpose='Measure kernel parsing/reduction and memory before choosing a certificate format')
Path('benchmark_inputs.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print(json.dumps(result,sort_keys=True))
