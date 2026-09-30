# C_TASK_3_REFINE — kontrola algebraiczna node'ow LDL (dokladne QQ, preparser).
# Srodek algebraiczny GramLDL.lean: tozsamosci pivots/LDL dla blokow kanonicznych
# weryfikowane PRZED formalizacja Lean (asserty, dziedzina QQ — bez floatow).
# Uruchomienie: sage check_gram_ldl.sage   (wymagany tryb sage, nie --python).

R.<a,b,c,x,y,lam,q> = PolynomialRing(QQ, order='lex')
F = R.fraction_field()
a,b,c,x,y,lam,q = F(a),F(b),F(c),F(x),F(y),F(lam),F(q)

def pivots2(G):
    p0 = G[0,0]
    p1 = G[1,1] - G[0,1]^2/p0
    return (p0, p1)

def pivots3(G):
    p0 = G[0,0]
    p1 = G[1,1] - G[0,1]^2/p0
    l21 = (G[1,2] - G[0,1]*G[0,2]/p0)/p1
    p2 = G[2,2] - G[0,2]^2/p0 - l21^2*p1
    return (p0, p1, p2)

# --- StableLeafAlgebra: average / harmonic / ternary0/1/2 -------------------
def t0(u,v,w): return (u+v+w)/3
def t1(u,v,w): return (u*v+u*w+v*w)/(u+v+w)
def t2(u,v,w): return 3*u*v*w/(u*v+u*w+v*w)
average = (a+b)/2
harmonic = 2*a*b/(a+b)

# --- pairGram (blok spektralny 2x2, dane spektralne (a,b)) -----------------
s = (a+b)/2
d = (a-b)/2
G2 = matrix(F, [[s, d], [d, s]])
assert pivots2(G2) == (average, harmonic), "pairGram: pivots != (average, harmonic)"
assert G2.det() == a*b, "pairGram: det != a*b"

# --- tripleGram (reprezentant kumulatywny, t-ladder) ------------------------
T0, T1, T2 = t0(a,b,c), t1(a,b,c), t2(a,b,c)
G3 = matrix(F, [[T0, T0, T0],
                [T0, T0+T1, T0+T1],
                [T0, T0+T1, T0+T1+T2]])
assert pivots3(G3) == (T0, T1, T2), "tripleGram: pivots != ternary0/1/2"
assert G3.det() == a*b*c, "tripleGram: det != a*b*c (dane spektralne)"

# wpisy G3 przez niezmienniki e1,e2,e3 (rownania do tezy/premis Lean):
e1 = a+b+c
e2 = a*b+a*c+b*c
e3 = a*b*c
assert G3[0,0] == e1/3
assert G3[1,1] == (e1^2 + 3*e2)/(3*e1)
assert G3[2,2] == (e1^2*e2 + 3*e2^2 + 9*e1*e3)/(3*e1*e2)
assert G3[1,2] == G3[1,1] and G3[0,1] == G3[0,2] == G3[0,0]

# --- A2-split: skala (lam, 3lam/4) + affine shift y/2 ----------------------
lhs = lam*(x^2 + x*y + y^2)
rhs = lam*(x + y/2)^2 + (3*lam/4)*y^2
assert lhs == rhs, "A2-split: skala (lam, 3lam/4) + shift y/2"

GA2 = matrix(F, [[lam, lam/2], [lam/2, lam]])
assert pivots2(GA2) == (lam, 3*lam/4), "a2Gram: pivots != (lam, 3lam/4)"
assert GA2.det() == lam^2*(3/4), "a2Gram: det"

# --- dualnosc reziproczna (streszczenie StableLeafSchedule) -----------------
Gs = matrix(F, [[(q/a+q/b)/2, (q/a-q/b)/2], [(q/a-q/b)/2, (q/a+q/b)/2]])
assert pivots2(Gs) == (q/harmonic, q/average), "pairGram dual: reverse reciprocal"
assert (t0(q/a,q/b,q/c) == q/t2(a,b,c)
        and t1(q/a,q/b,q/c) == q/t1(a,b,c)
        and t2(q/a,q/b,q/c) == q/t0(a,b,c)), "ternary dual: reverse reciprocal"

# --- skala wiezy: a = pivot/(2*pi*768^2) <= maxCoefficient <=> pivot <= q^2/991
# (pi znika przy rownowaznosci; tu tozsamosc przeskalowania w QQ):
assert (18433^2/(991*2*768^2)) * (2*768^2) == 18433^2/991, "maxCoefficient: przeskalowanie"

print("GRAM_LDL_ALGEBRA_PASS")
