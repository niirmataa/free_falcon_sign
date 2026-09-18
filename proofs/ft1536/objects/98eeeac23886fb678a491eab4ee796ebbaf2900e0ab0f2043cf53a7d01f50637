# T2C3-CANONICAL-KEYGEN-001 — final handoff

Status: `KEYGEN_GENERATED_AND_VALIDATED`. Run: `20260819-a1`. Branch:
`codex/ft1536-canonical-keygen-001-20260819-a1`; result is `UNCOMMITTED`
on base commit `8ffa1e011577cd877074888b8650ed521f8bb289` and tree
`854a8e85176226ea82d36dde1005ef50b70b4d20`.

Exactly one local CLI KeyGen invocation completed with exit code 0. No external
retry, selection, or cherry-picking occurred. Randomness came only through the
frozen implementation's 32-byte `/dev/urandom` path; the seed was neither
stored nor emitted. Internal candidate rejection remained inside that single
KeyGen process.

The frozen private-key binding is
`d073480ca8971c41719e855fef2d38a5271e4a5249a7764f236bef538bd4519c`
(7681 encoded bytes). Private bytes, decoded coordinates, seed, and literal
storage path do not occur in evidence. The private file is referenced only by
logical alias `PRIVATE_KEY_READ_ONLY` and remains outside all repositories in
operator LocalAppData. Final readback confirmed the current operator as owner,
disabled ACL inheritance, and exactly two allowed principals: current operator
and local SYSTEM.

Future bounded tasks resolve `PRIVATE_KEY_READ_ONLY` only from a transient
`FT1536_SECURE_DIR` environment value plus the fixed relative basename. The
environment value is never written to evidence; every use must reject symlinks
and Git-worktree locations and recheck the frozen private hash and ACL first.

The frozen encoded public key is
`57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f`
(2881 bytes). The canonical text representation of public `h` hashes to
`ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2`.

Validation used the frozen 17-file source manifest
`03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589`,
generator binary `565cfe45...37db1bf`, run-local decoder binary
`0ab605a8...56b7d8`, and native SageMath 9.5. It checked exact headers and
consumption, `N=1536`, `q=18433`, full ternary membership of `f,g`, unit status
of `f`, `hf=g`, `hF=G`, `fG-gF=q`, equality of encoded and recomputed public
keys, and the implementation's resultant, raw-norm, GS-norm, and leaf
acceptance gates. Private coordinates traveled only over an anonymous decoder
to Sage pipe. Hashes and sizes were rechecked after validation.

This changes only the provenance of the official fixed-key instance: the new
locally generated and validated key is eligible to replace external `key_1`
in a later reviewed integration. It does not establish a KeyGen-distribution
theorem, a population quantifier, canonical-key coherence delta, T2C3, or any
security claim. The old external key and A8 remain diagnostic/untrusted
provenance.

Files read included `SOURCE_OF_TRUTH.md`, Protocol v2.0, the frozen baseline
manifest, all 17 active build sources, and the active KeyGen/encoding/RNG/tool
paths. Files created or changed are confined to this run evidence directory
plus four protected files in the external private vault. A preparation-only
local branch/worktree was created before execution; no staging, commit, push,
Merkle, GPG, or network action occurred. D5, D6, D2, coherence work, and any
campaign were not attempted.

Open storage qualifications: encryption at rest is not attested. Cloud-provider
configuration and system-backup exclusion were not inspected; the selected
LocalAppData path is outside known cloud-sync path names and every Git worktree.
