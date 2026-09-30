# Internal batch002 — source memory and Montgomery contracts

Package status: IN_PROGRESS / NOT_REVIEWED. The full emitted-KeyGen theorem
is not available. This batch records internal proof work, not acceptance of
the package or completion of the certificate prefix.

## Checked source contracts

- CertificateWorkspace.after_root_copy derives suffix WellFormed/Legal from
  a legal workspace, an initialized local flag, the actual root memcpy and
  subsequent primitive memory transitions. Deriving that complete transition
  sequence from the whole certificate function remains an obligation.
- C99ArrayReference.memory_steps extracts those primitive transitions from
  natural array/control executions, including executed callee bodies.
- FftLeafPrograms parses seven complete void bodies from pinned falcon-fft.c.
  FftLeafFrames.parsed_body_frame derives their write footprint from the parsed
  syntax. This scope excludes FFT3, complex macros and raw LDL recursion.
  The parser normalizes size_t to uint64_t only for the fixed M0 LP64 profile.
- KeygenModpWord.source_exact/source_exists bind modp_montymul's actual body
  to its 32/64-bit word operations. KeygenMontgomery derives its canonical
  range and Montgomery congruence, including wrapping in z*p0i, without an
  assumed machine no-overflow property.
- KeygenNinv31.source_exact/source_exists bind modp_ninv31 to the actual
  initialization and four Newton steps. For p=2147355649, the kernel derives
  the inverse relation. initialized_montgomery_contract consumes that source
  initialization and the multiplication execution together; it does not take
  the inverse relation as an additional premise.

The final composed scalar contract has these real premises:

```lean
(ha : a.toNat < KeygenNinv31.prime.toNat)
(hb : b.toNat < KeygenNinv31.prime.toNat)
(initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
(multiplication : KeygenModpWord.SourceExec a b KeygenNinv31.prime p0i z)
```

It concludes that z is a uint32 word w, w<p, and
`(w.toNat*2^31)%p = (a.toNat*b.toNat)%p`. Binding p to the final solver's
table read, propagating canonical ranges through NTT, and obtaining the
polynomial congruence from the final comparison loop still require source
proofs. This is not yet the NTRU equation for an emitted key.

## Evidence

Fresh replay: `.build/jobs/keygen_fiber_batch2_fresh_001`, all14 modules
accepted with clean logs. Twenty internal exports have type, proof-term and
transitive-axiom output; only propext/Classical.choice/Quot.sound or no axioms.
Elapsed67.551s, maxRSS2936928KiB. Existing job limits were unchanged.

Receipt `KEYGEN_SOURCE_TO_FIBER_001_BATCH_002.json`, SHA256
`adc2f490a1e683d812941da4bac54179c4b78c0460ba72549be84fce477acb18`.
The receipt records source, product, import, raw-log and diagnostic pins.

Sage `keygen_montgomery_checks_001`:72 public operand pairs per variant;
12 detected mutations across normal/UBSan builds. Source p0i=1869483007.
Mutations cover the mask width, shift count, omitted final correction,
incorrect inverse, premature product truncation and a wrong modulus argument.
These are finite scalar checks. No private KeyGen or real-key generation ran.

Earlier failed attempts remain intact. The first ninv proof used excessive
simplification; the accepted proof factors initialization and each Newton
step through opaque intermediate states and generic continuation lemmas.
No warning suppression or resource-limit increase was used.

## Next integration obligations

1. Complex macro expansion and the complete FFT3/raw-LDL source bodies.
2. Full certificate entry, local-object allocation, caller memory frame and
   teardown, with suffix-entry invariants derived from that execution.
3. Full KeyGen attempts and exact emitted encoding/decoding identity.
4. Source transform/table invariants, modular comparisons, source public-key
   and inverse equations, then the existing ActualNTRUFiber composition.

The owner controls review startup. No automatic batch review was launched.
Push is allowed only for own commits after the three-own-commit batch and
after checking that its outgoing range contains no unpublished foreign commit.
