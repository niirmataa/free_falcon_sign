"""Exact integer reference: declarative bit grammar and polynomial reduction.

No S17 NTT is used for correct multiplication, centering or norms.
"""
from math import isqrt

N, Q, B = 1536, 18433, 2093922385


def wrap16(x):
    return (x + 32768) % 65536 - 32768


def center(x):
    return (x + Q//2) % Q - Q//2


def norm(a):
    assert len(a) == N
    return sum(x*x + x*y + y*y for x, y in zip(a[:N//2], a[N//2:]))


def product(a, b, phi_sign=1):
    """Integer convolution, then long division by X^N-X^(N/2)+1."""
    assert len(a) == len(b) == N
    conv = [0]*(2*N-1)
    nz = [(j,x) for j,x in enumerate(b) if x]
    for i,x in enumerate(a):
        if x:
            for j,y in nz:
                conv[i+j] += x*y
    for k in range(2*N-2, N-1, -1):
        v = conv[k]
        conv[k] = 0
        conv[k-N+N//2] += phi_sign*v
        conv[k-N] -= v
    return [v % Q for v in conv[:N]]


def encode_raw(pairs):
    assert len(pairs) == N
    bits = "".join(str(s) + format(m % 256, "08b") + "0"*(m//256) + "1"
                   for s,m in pairs)
    bits += "0"*((-len(bits)) % 8)
    return bytes([0xAA]) + bytes(int(bits[i:i+8], 2) for i in range(0,len(bits),8))


def encode(s, mode=1):
    if mode == 0:
        return bytes([0x8A]) + b"".join((v % 65536).to_bytes(2,"big") for v in s)
    return encode_raw([(int(v<0), abs(v)) for v in s])


def decode(payload):
    if len(payload) <= 2 or payload[0] not in (0x8A, 0xAA):
        raise ValueError("HEADER")
    data = payload[1:]
    if payload[0] == 0x8A:
        if len(data) != 2*N:
            raise ValueError("NONE_LENGTH")
        result = [int.from_bytes(data[i:i+2], "big", signed=True) for i in range(0,len(data),2)]
        if any(abs(x)>9216 for x in result):
            raise ValueError("NONE_RANGE")
        return result
    bits = "".join(format(b,"08b") for b in data)
    pos = 0
    result = []
    for _ in range(N):
        if pos+9 > len(bits):
            raise ValueError("TRUNCATED_SIGN_LOW")
        sign = int(bits[pos]); low = int(bits[pos+1:pos+9],2); pos += 9
        stop = bits.find("1", pos)
        if stop < 0:
            raise ValueError("TRUNCATED_UNARY")
        # uint32_t/unsigned ne counts zeros modulo 2^32, even for long codes.
        count = (stop-pos) % (2**32)
        if count > 255:
            raise ValueError("STATIC_NE")
        magnitude = low + 256*count
        result.append(wrap16(-magnitude if sign else magnitude))
        pos = stop+1
    consumed = (pos+7)//8
    if consumed != len(data):
        raise ValueError("TRAILING_BYTES")
    if any(b != "0" for b in bits[pos:]):
        raise ValueError("PADDING")
    return result


def four_squares(n):
    """Small exact helper for the three norm boundary vectors, not randomness."""
    for a in range(isqrt(n), max(-1,isqrt(n)-32), -1):
        r = n-a*a
        for b in range(isqrt(r)+1):
            r2 = r-b*b
            for c in range(isqrt(r2)+1):
                d = isqrt(r2-c*c)
                if d*d == r2-c*c:
                    return [a,b,c,d]
    raise ArithmeticError("four-square helper did not finish")
