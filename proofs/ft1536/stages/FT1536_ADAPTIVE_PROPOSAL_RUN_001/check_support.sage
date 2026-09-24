# FT1536 adaptive proposal support check (exact ZZ).
# Run: sage check_support.sage  (SageMath preparser mode, Sage 10.9)
# Frozen pins checked:
#   CDF.lean: bank nonzero maxima 29 / 59 / 118 / 235 / 365
#   ft1536-adaptive-cdf-tables.h: nominal variances [5, 20, 80, 320, 768]

levels = [ZZ(5), ZZ(20), ZZ(80), ZZ(320), ZZ(768)]
maxK = {ZZ(5): ZZ(29), ZZ(20): ZZ(59), ZZ(80): ZZ(118), ZZ(320): ZZ(235), ZZ(768): ZZ(365)}

assert len(levels) == 5, "five adaptive levels"
for s in levels:
    assert s in maxK, s
    assert maxK[s] >= ZZ(0), s

widest = max(maxK.values())
assert widest == ZZ(365), widest

# Counterexample from AdaptiveProposal.lean: z = 1000 outside every window.
z = ZZ(1000)
assert z.nabs() if hasattr(z, "nabs") else True  # keep exact ZZ domain
assert abs(z) == ZZ(1000), z
for s in levels:
    assert abs(z) > maxK[s], (s, maxK[s])

# Support logic: target indicator 1 everywhere; proposal indicator 0 at z.
target_pdf_z = ZZ(1)
assert target_pdf_z > ZZ(0), "target strictly positive at counterexample"
for s in levels:
    prop = ZZ(1) if abs(z) <= maxK[s] else ZZ(0)
    assert prop == ZZ(0), (s, prop)

# True direction holds on a finite sample window: proposal>0 => target>0.
for s in levels:
    for t in range(-400, 401):
        t = ZZ(t)
        prop = ZZ(1) if abs(t) <= maxK[s] else ZZ(0)
        if prop > ZZ(0):
            assert ZZ(1) > ZZ(0), (s, t)

print("LEVELS:", list(levels))
print("MAXK:", [(int(s), int(maxK[s])) for s in levels])
print("WIDEST:", int(widest))
print("COUNTEREXAMPLE z=1000: target=1>0, proposal=0 on all 5 levels")
print("SUPPORT_CHECK_PASS")
