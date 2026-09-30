#!/usr/bin/env python3
"""gen_fftpin.py — generator formal/FftBind/FftPin.lean.

Wpisuje przypięty tekst M0 (falcon-fft.c + falcon-enc.c) jako `List String`
w stylu Source3 (KeygenSource/FprCSource) + stałe SHA256 pinów M0 +
twierdzenia-kotwice (`by decide`) na kluczowych liniach.
Aserje: wejścia istnieją, niepuste, liczba linii > próg, kotwice znalezione
w tekście wejściowym (stare wzorce assert w skryptach patchujących).
"""
import hashlib, pathlib, sys

T = pathlib.Path("/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_1_BINBIND")
SRC = T / "inputs/m0_source"
OUT = T / "formal/FftBind/FftPin.lean"

M0_PINS = {
    "fftSha256": ("falcon-fft.c", "06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063"),
    "encSha256": ("falcon-enc.c", "0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05"),
    "keygenSha256": ("falcon-keygen.c", "0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf"),
    "fprHeaderSha256": ("fpr-emulated.h", "242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa"),
}

def lean_str(s: str) -> str:
    out = []
    for ch in s:
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\t":
            out.append("\\t")
        elif ch == "\r":
            out.append("\\r")
        else:
            assert ord(ch) >= 0x20, f"non-printable char {ord(ch)}"
            out.append(ch)
    return '"' + "".join(out) + '"'

def lines_of(name: str):
    data = (SRC / name).read_bytes()
    text = data.decode("utf-8")
    assert len(text) > 1000, name
    lines = text.splitlines(keepends=True)
    assert len(lines) > 50, name
    return text, lines

def anchors(name: str, lines, wanted):
    out = []
    for i, needle in wanted:
        assert 1 <= i <= len(lines), f"{name}:{i} poza zakresem"
        assert needle in lines[i - 1], f"{name}:{i} nie pasuje: {lines[i-1]!r}"
        out.append((i, lines[i - 1]))
    return out

FFT_ANCHORS = [
    (38, '#include FPR_IMPL'),
    (55, '#define FPC_ADD'),
    (66, '#define FPC_SUB'),
    (77, '#define FPC_MUL'),
    (98, '#define FPC_SQR'),
    (112, '#define FPC_INV'),
    (128, '#define FPC_DIV'),
    (176, 'falcon_FFT(fpr *f, unsigned logn)'),
    (256, 'falcon_iFFT(fpr *f, unsigned logn)'),
    (755, '#define MKN(logn, full)'),
    (759, 'falcon_FFT3(fpr *a, unsigned logn, unsigned full)'),
    (854, 'falcon_iFFT3(fpr *a, unsigned logn, unsigned full)'),
    (1041, 'falcon_poly_mul_fft3(fpr *restrict a, const fpr *restrict b,'),
]
ENC_ANCHORS = [
    (173, 'falcon_encode_18433'),
    (216, 'falcon_decode_18433'),
    (384, 'falcon_encode_small'),
    (549, 'falcon_decode_small'),
    (564, 'falcon_hash_to_point'),
    (597, 'falcon_is_short'),
]

def main() -> int:
    fft_text, fft_lines = lines_of("falcon-fft.c")
    enc_text, enc_lines = lines_of("falcon-enc.c")
    for key, (fname, want) in M0_PINS.items():
        got = hashlib.sha256((SRC / fname).read_bytes()).hexdigest()
        assert got == want, f"{fname}: {got} != {want}"
    a_fft = anchors("falcon-fft.c", fft_lines, FFT_ANCHORS)
    a_enc = anchors("falcon-enc.c", enc_lines, ENC_ANCHORS)

    chunks = []
    chunks.append("""/- Project Niirmata — C_TASK_1_BINBIND / warstwa FFT-NTT.
Przypięty tekst M0 (FT1536_M0_CONTRACT_RUN_001/source) dla falcon-fft.c
i falcon-enc.c; styl Source3 (pinned text -> parser -> typed execution).
Plik generowany przez scripts/gen_fftpin.py — NIE edytować ręcznie.
Piny: CONTRACTS.md i inputs/SHA256SUMS_M0; tekst <-> hash wiąże maszynowo
scripts/check_embed.py. Komentarze C NIE są źródłem założeń numerycznych. -/
set_option maxRecDepth 32768
namespace FT1536.FftBind.FftPin

/-- Pinned M0 text of `falcon-fft.c`, one String per source line. -/
def fftLines : List String := [""")
    chunks.append(",\n".join(lean_str(l) for l in fft_lines))
    chunks.append("""]

/-- Pinned M0 text of `falcon-enc.c`, one String per source line. -/
def encLines : List String := [""")
    chunks.append(",\n".join(lean_str(l) for l in enc_lines))
    chunks.append("]\n\n")
    for key, (fname, want) in M0_PINS.items():
        chunks.append(f'/-- SHA256 pin M0: {fname}. -/\ndef {key} : String := "{want}"\n')
    chunks.append(f"""
theorem fft_line_count : fftLines.length = {len(fft_lines)} := by decide
theorem enc_line_count : encLines.length = {len(enc_lines)} := by decide

/-- Slice helper (1-based source line numbers), konwencja jak FprPrimitives.hslice. -/
def fftSlice (line count : Nat) : List Char :=
  ((fftLines.drop (line-1)).take count).flatMap String.toList
def encSlice (line count : Nat) : List Char :=
  ((encLines.drop (line-1)).take count).flatMap String.toList
""")
    for i, line in a_fft:
        nm = f"fft_line_{i}"
        chunks.append(f"theorem {nm} : fftLines[{i-1}]? = some {lean_str(line)} := by decide\n")
    for i, line in a_enc:
        nm = f"enc_line_{i}"
        chunks.append(f"theorem {nm} : encLines[{i-1}]? = some {lean_str(line)} := by decide\n")
    chunks.append("""
end FT1536.FftBind.FftPin

#print axioms FT1536.FftBind.FftPin.fft_line_count
#print axioms FT1536.FftBind.FftPin.enc_line_count
""")
    for i, _ in a_fft:
        chunks.append(f"#print axioms FT1536.FftBind.FftPin.fft_line_{i}\n")
    for i, _ in a_enc:
        chunks.append(f"#print axioms FT1536.FftBind.FftPin.enc_line_{i}\n")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    s = "".join(chunks)
    assert len(s) > 10000 and "fftLines" in s and "encLines" in s
    OUT.write_text(s)
    print(f"GEN_OK {OUT} lines_in=({len(fft_lines)},{len(enc_lines)}) bytes={len(s)}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
