import VerifyBind.HashTo

/-!
# Axiom audit of the rung B3 package

Informational only: each declaration below must depend on standard axioms
at most (`propext`, `Classical.choice`, `Quot.sound`).
-/

#print axioms FT1536.VerifyBind.static_decode_encode
#print axioms FT1536.VerifyBind.encodeStatic_inj
#print axioms FT1536.VerifyBind.none_decode_encode
#print axioms FT1536.VerifyBind.unpack_pack
#print axioms FT1536.VerifyBind.encodeSig_consumed_static
#print axioms FT1536.VerifyBind.encodeSig_consumed_none
#print axioms FT1536.VerifyBind.encodeSig_inj_static
#print axioms FT1536.VerifyBind.encodeSig_inj_none
#print axioms FT1536.VerifyBind.decodeSig_length
#print axioms FT1536.VerifyBind.decodeSig_mem_int16
#print axioms FT1536.VerifyBind.decodeSig_cases
#print axioms FT1536.VerifyBind.verdict_valid_iff
#print axioms FT1536.VerifyBind.verdict_valid_decodes
#print axioms FT1536.VerifyBind.verdict_total
#print axioms FT1536.VerifyBind.decoded_or_rejected
#print axioms FT1536.VerifyBind.q0_neg
#print axioms FT1536.VerifyBind.scanValue_sound
#print axioms FT1536.VerifyBind.scanValue_length
#print axioms FT1536.VerifyBind.hashToPointOf_length
#print axioms FT1536.VerifyBind.hashToPointOf_sound
#print axioms FT1536.VerifyBind.challengeOf_length
#print axioms FT1536.VerifyBind.challengeOf_sound
#print axioms FT1536.VerifyBind.challengeOf_none_or_some
#print axioms FT1536.VerifyBind.uniform_challenge_mass
#print axioms FT1536.VerifyBind.uniform_challenge_eq
#print axioms FT1536.VerifyBind.verdictOf_valid_iff
#print axioms FT1536.VerifyBind.verdictOf_valid_decodes
#print axioms FT1536.VerifyBind.verdictOf_total
#print axioms FT1536.VerifyBind.verdictOf_decoded_or_rejected
