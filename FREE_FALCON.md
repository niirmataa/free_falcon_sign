# FREE Falcon

FREE Falcon is a preservation and research reconstruction effort for the
historical Falcon EXTRA / ternary line.

It does not propose a new standard.
It does not replace Falcon or FN-DSA.
It makes no new security claims.

## Historical ternary line

    N = 3 · 2^(logn - 1)
    R = Z_q[X] / (X^N - X^(N/2) + 1)

Historical public point:

    logn = 9
    N = 768
    q = 18433
    phi(X) = X^768 - X^384 + 1

Experimental checkpoint:

    logn = 10
    N = 1536
    q = 18433
    phi(X) = X^1536 - X^768 + 1

Observed local result:

    logn=10 ternary=1 ok=1 sk_len=12289 pk_len=2881

No claim is made about full signing support, verification support,
constant-time completeness, production readiness, or security level.

Respect is due to Thomas Pornin and the Falcon authors for the original
implementation and comments that make the ternary algebraic path visible.
