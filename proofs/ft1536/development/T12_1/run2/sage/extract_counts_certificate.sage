# Ekstrakcja calkowitej warstwy rachunku radialnego do certyfikatu packed-Nat
# (krok 1 pakietu (b)): dokladne calkowite counts A2 -> binning 16 -> paczka
# 4 binow/cyfre 128-bit -> dane certyfikatu fold dla cyclic convolution.
# Produkuje: CountsFoldCertificate.lean (decide-checked) + receipt.
# Wzorzec Cython-on-the-fly jak w run/sage/arb_radial.sage. Bez RNG.
from pathlib import Path
import hashlib, json, sys, time
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

start = time.monotonic()
sig = ZZ(768)
cutoff = ZZ(64)*2*sig^2            # 75497472 — parametr rzeczywistego przebiegu
bound = ceil(sqrt(QQ(4)*cutoff/3))
width = ZZ(16)
nbins = cutoff//width              # 4718592 = 4*1179648 (bin cutoff pominieciemy)
per_digit = ZZ(4)
n = nbins//per_digit               # 1179648 cyfr
assert nbins == per_digit*n

CODE = r'''
# distutils: language_level=3
from libc.stdint cimport uint32_t, uint64_t, int64_t
from libc.stdlib cimport calloc, free

def compute(long cutoff, long bound, long width):
    cdef uint32_t *counts = <uint32_t*>calloc(cutoff+1, sizeof(uint32_t))
    cdef long x, y, n, nb = cutoff//width + 1
    cdef int64_t norm
    if counts == NULL: raise MemoryError()
    try:
        for x in range(-bound, bound+1):
            for y in range(-bound, bound+1):
                norm = (<int64_t>x)*x+(<int64_t>x)*y+(<int64_t>y)*y
                if norm <= cutoff: counts[norm] += 1
        binned = [0]*nb
        for n in range(cutoff+1):
            binned[n//width] += counts[n]
        raw = (<char*>counts)[:4*(cutoff+1)]
        return bytes(raw), binned
    finally:
        free(counts)
'''
Path('counts_engine.pyx').write_text(CODE)
from Cython.Compiler.Main import compile as compile_cython, CompilationOptions, default_options
import sysconfig, subprocess
options = CompilationOptions(default_options, compiler_directives={'language_level': int(3), 'cdivision': True},
    output_file=str(Path('counts_engine.c').resolve()))
compiled = compile_cython(str(Path('counts_engine.pyx').resolve()), options)
assert compiled.num_errors == 0
so = Path('counts_engine'+sysconfig.get_config_var('EXT_SUFFIX')).resolve()
cmd = ['gcc','-O2','-fPIC','-shared', '-I'+sysconfig.get_path('include'),
       'counts_engine.c','-o',str(so)]
build = subprocess.run(cmd, stdout=open('engine_build.stdout','wb'),
    stderr=open('engine_build.stderr','wb'), timeout=int(300))
assert build.returncode == 0, Path('engine_build.stderr').read_text()
import importlib.util
spec = importlib.util.spec_from_file_location('counts_engine', so)
eng = importlib.util.module_from_spec(spec); spec.loader.exec_module(eng)

counts_raw, binned_all = eng.compute(int(cutoff), int(bound), int(width))
counts_sha = hashlib.sha256(counts_raw).hexdigest()
binned = binned_all[:int(nbins)]
assert len(binned) == int(nbins) and len(binned_all) == int(nbins)+1
assert max(binned) < 2**32, max(binned)

# Paczka: 4 binow na cyfre 128-bit (biny < 2^32), ulamkowo-lewa kolejnosc.
digits = [binned[4*k] + (binned[4*k+1] << 32) + (binned[4*k+2] << 64) + (binned[4*k+3] << 96)
          for k in range(int(n))]
hexA = ''.join(hex(d)[2:].zfill(32) for d in digits)
packedA = ZZ(hexA, 16)

product = packedA*packedA
bits = ZZ(n)*128
lo = product % (ZZ(2)**bits)
hi = product >> int(bits)
assert lo + (ZZ(2)**bits)*hi == product

hexLo = hex(int(lo))[2:]
hexHi = hex(int(hi))[2:]

template = '''import Lean
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
open Lean Elab Term

/- The elaborator below only decodes untrusted certificate DATA into Nat
   literals. It produces no proof and performs no acceptance check. The
   equalities are checked separately by ordinary kernel reduction. -/
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

namespace CountsFoldCertificate
def packedA : Nat := packed_nat% "HEX_A"
def packedB : Nat := packedA
def radixPower : Nat := packed_pow2% TOTAL_BITS
def lowerPart : Nat := packed_nat% "HEX_LO"
def upperPart : Nat := packed_nat% "HEX_HI"
def packedC : Nat := lowerPart + upperPart

/- Glowna premisa certificate_sound (PackedConvolution): rozklad iloczynu
   cyklicznego na lo + base^n*hi dla rzeczywistego wektora binow. -/
theorem exact_fold : lowerPart + radixPower*upperPart = packedA*packedB := by decide
theorem exact_cyclic_sum : lowerPart + upperPart = packedC := by rfl
theorem rejects_changed_fold : (lowerPart+1) + radixPower*upperPart ≠ packedA*packedB := by decide
theorem rejects_changed_product : lowerPart + radixPower*upperPart ≠ packedA*packedB + 1 := by decide
#print axioms exact_fold
#print axioms exact_cyclic_sum
#print axioms rejects_changed_fold
#print axioms rejects_changed_product
end CountsFoldCertificate
'''
code = template.replace('HEX_A', hexA).replace('HEX_LO', hexLo).replace('HEX_HI', hexHi).replace('TOTAL_BITS', str(int(bits)))
Path('CountsFoldCertificate.lean').write_text(code)

receipt = dict(
    schema='FT1536_COUNTS_FOLD_CERTIFICATE_V1',
    status='GENERATED',
    parameters=dict(sig=int(sig), cutoff=int(cutoff), bound=int(bound), width=int(width),
                    bins=int(nbins), per_digit=int(per_digit), digits=int(n),
                    digit_bits=int(128), total_bits=int(bits)),
    counts_sha256=counts_sha,
    max_bin_count=int(max(binned)),
    packedA_digits=int(n), packedA_hex_chars=len(hexA),
    product_bits=int(2*bits),
    files=dict(module='CountsFoldCertificate.lean',
               module_sha256=hashlib.sha256(code.encode()).hexdigest(),
               module_bytes=len(code)),
    kernel_checks=['exact_fold', 'exact_cyclic_sum', 'rejects_changed_fold', 'rejects_changed_product'],
    scope='full binned vector bins 0..%d (norms <= %d); bin %d (norm=cutoff) excluded'
          % (int(nbins)-1, int((nbins-1)*width+width-1), int(nbins)),
    arithmetic='Sage preparser + exact ZZ; Cython enumeration; kernel decide on Nat literals',
    elapsed_s=float(round(time.monotonic()-start, 3)),
)
Path('counts_certificate_receipt.json').write_text(json.dumps(receipt, indent=2, sort_keys=True)+'\n')
print('COUNTS_CERT_GENERATED', json.dumps(dict(counts_sha256=counts_sha, digits=int(n),
    module_bytes=len(code), max_bin=int(max(binned)), elapsed_s=receipt['elapsed_s']), sort_keys=True))
