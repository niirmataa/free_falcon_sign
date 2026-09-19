# FREE Falcon

FREE Falcon preserves and studies the historical Falcon EXTRA / ternary implementation path.

This repository contains an experimental functional extension of the historical ternary path to:

```text
logn = 10
N = 1536
q = 18433
phi(X) = X^1536 - X^768 + 1
```

This is not a standardization proposal.  
This is not a replacement for Falcon or FN-DSA.  
No security, production-readiness, or constant-time completeness claims are made.

## Acknowledgements

FREE Falcon exists because the historical Falcon authors left a clear and carefully engineered algebraic path in the EXTRA / ternary implementation.

This project does not speak for the original authors. It is a preservation and research continuation of the historical ternary path.

Special respect is due to Thomas Pornin and the Falcon authors for the code, comments, and structure that made this path visible.

The purpose of FREE Falcon is simple:

```text
preserve the path,
test the path,
keep attribution visible.
```

The Falcon-1536 ternary checkpoint is presented as a respectful technical continuation of the historical EXTRA line, not as a new scheme and not as a standardization claim.

## Current checkpoint

The normal `Extra/c/test_falcon` path now includes Falcon-1536 ternary coverage.

Observed result:

```text
Test key encode/decode (none): <q=12289,logn=4->len=129><q=12289,logn=9->len=4097><q=18433,logn=9->len=6145><q=18433,logn=10->len=12289>done.
Test key encode/decode (Huffman): <q=12289,logn=4->len=73><q=12289,logn=9->len=2305><q=18433,logn=9->len=3841><q=18433,logn=10->len=7681>done.

Test Falcon verify: [16].......... [512].......... [1024].......... [768].......... [1536].......... done.

Test FFT3 (full): [2]...[3]...[4]...[5]...[6]...[7]...[8]...[9]..[10]. done.
Test FFT3 (partial): [1]...[2]...[3]...[4]...[5]...[6]...[7]...[8]....[9].. done.

Test Falcon sign: ... done.
Test Falcon keygen (bin): [1]...[2]...[3]...[4]...[5]...[6]...[7]...[8]...[9]...[10]... done.
Test Falcon keygen (ter): [3]...[4]...[5]...[6]...[7]...[8]...[9]...[10]... done.

Keygen (N=1536): 23.327 keygen/s  (avg = 42.87 ms)

N=1536: 1985.295 sig/s  (len = 1986.44 [max: 2000])  8436.524 vrf/s
```

This means Falcon-1536 ternary is covered by the normal `test_falcon` path:

- key encode/decode,
- deterministic verifier test vectors,
- FFT3 full / partial tests,
- signing tests,
- ternary keygen/sign/verify loop,
- keygen benchmark,
- sign/verify benchmark.

The ternary verifier vectors for `[768]` and `[1536]` are FREE Falcon deterministic test vectors. They are not NIST KAT files.

## How to reproduce

From the repository root:

```sh
cd Extra/c
make clean
make
./test_falcon
```

Expected result: all tests complete successfully, including:

```text
Test Falcon verify: [16] [512] [1024] [768] [1536]
Test Falcon keygen (ter): [3]...[10]
Keygen (N=1536)
N=1536 sign/verify benchmark
```

## Scope

What is currently shown:

- Falcon-1536 ternary key encode/decode works.
- Falcon-1536 ternary deterministic verifier vectors work.
- Falcon-1536 ternary signing tests pass.
- Falcon-1536 ternary dynamic keygen/sign/verify loop works.
- Falcon-1536 ternary FFT3 full/partial tests pass.
- Falcon-1536 ternary benchmark path runs.

Additional internal probes reached logn=11 / N=3072 functionally, but the current public test checkpoint is Falcon-1536 / logn=10.

## Repository status

Main functional checkpoint:

```text
Falcon-1536 ternary:
  keygen: OK
  key encode/decode: OK
  deterministic verifier vectors: OK
  sign: OK
  verify: OK
  test_falcon: OK
```

Relevant tag:

```text
v0.4-free-falcon-1536-full-test-falcon-ok
```

## License

This Falcon implementation is provided under the MIT license, whose text is included at the start of all source files.
