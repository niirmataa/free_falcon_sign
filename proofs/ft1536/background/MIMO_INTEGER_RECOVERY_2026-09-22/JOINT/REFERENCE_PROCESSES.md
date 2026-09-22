# Q_S i Q_stop — totalne referencje ordered value trace

Fix e,PAST. Hi i source words mu_h,sigma_h są tymi z PREFIX_CLOSURE.
G_h jest niezależnym discrete Gaussian na CAŁYM Z o m=val(mu_h),v=val(sigma_h)^2,
nie o machine-parameter Ghat ani globalnym sigma768. S_h={y:K_h(y)>0} to
actual selected-bank positive table counts AND e_C<64 (GAUSS dajeZ>0).

Wspólna przestrzeń Ω: Live(y1,...,yM),y∈HM, oraz Exit(i,h,y),h∈H_(i−1),y∉S_h.
Exit zawiera unbounded mathematical integer y, nigdy jego C-cast. Illegal live
tuples mają probability0 i nie uruchamiają transducera po pierwszym wyjściu.

- P_VALUE: w każdym legal prefix drawK_h i exact deterministic caller step.
- Q_S: drawG_h(y)/(1−t_h) naS_h,t_h=G_h(S_h^c), potem ten sam source caller step.
- Q_stop: drawG_h naZ; dla y∉S_h natychmiast Exit(i,h,y) PRZED of_C/cast,
  residual/center update lub dalszym samplerem; dla y∈S_h normal continuation.

S_h jest niepusty,skończony; G dodatni wszędzie. Dlatego0<t_h<1 i lokalny
normalizer1−t_h>0. Prefix witness domyka source operations na live nodes obu
referencji. Both reference trees mają≤M draws (nie rejection implementation);
unbounded EXIT integers nie są wykonywane w C. Są mathematical laws z positive
normalizers i countable sums, nie algorytmem idealnego globalnego lattice Gaussa.

W ilorazach P/Q wykorzystujemy wartości mu_h,sigma_h z TEGO SAMEGO historyh.
Nie podstawiamy center z niezależnego execution drugiej gry. Procesy mogą
ewoluować do różnych histories, ale każda local transition jest funkcją
wspólnego argumentu h w likelihood/chain proof.

## Local versus whole-call conditioning

D(y)=Π_i(1−t_(h_i)),0<D(y)≤1. Dokładnie:
Q_stop(Live y)=Q_S(y)D(y),
Q_stop(live)=E_QS[D],
Q_stop(y|live)=Q_S(y)D(y)/E_QS[D].

Ogólnie D zależy od history, więc to tilted law, nie Q_S. Równość zachodzi
iffD jest stałe Q_S-a.s.; nie zakładamy tego dla source adaptive centers.
COUNTERMODELS zawiera wykonany QQ countermodel do generic identity (TV1/10),
bez twierdzenia, że jest emitted-source counterexample.

## Osobny, jawny source-conditional lift

Main Gaussian comparison dotyczy Ω VALUE, bez przydzielenia reference random
bytes. Aby eksportować resource/revealed trace comparison, definiujemy wspólny
Markov kernel H_y jako P_SOURCE(Z∈· | Y=y), gdzieZ zawiera wszystkieNi,getter
words/positions,pointer/refill/drop trace i associated deterministic state.
Y ma finite positive supportHM, więc to zwykłe dyskretne conditional ratio,
bez mierniczego problemu conditioning na continuous singleton.

Jawna konstrukcja H_y: conditional Ni są independent geom(A_h) po ustaleniu
CAŁEGO y (JOINT_LAW). Dla każdej scalar call, conditional onNi=n,y_i:
wybierz n−1 rejected raw atoms uniform z Reject_h, ostatni uniform z Accept_h(y_i),
następnie umieść je przez literal getters od ptr, dropped/unread cells marginalized.
Dla A_h=1 tylkon1 i brak rejected draws. To dokładnie unnormalizedD^-T
podzielone przez P(Y=y); nie uniform niezależne source bytes po narzuceniu y.
Na Exit kernel jest singletonem NoSourceResource(Exit), bez unsafe source run.

Definiujemy P*=P_VALUE H, Q_S*=Q_S H, Q_stop*=Q_stop H. P* jest actual IID
revealed/resource law z JOINT_LAW. Ponieważ Y/Exit pozostaje w lifted tuple,
sum_z H_y(z)=1 daje DOKŁADNIE
TV(P*,Q*)=TV(P_VALUE,Q) i chi2(P*||Q*)=chi2(P_VALUE||Q).
To theorem o konkretnym ghost lift, nie wniosek o dowolnym reference byte
generatorze. Projektując tylkoZ otrzymujemy inequalities data processing.
Lift nie jest implementacją G, nie jest realnym seeded transcriptem i nie
przenosi automatycznie boundu na nieopisane revealed outputs innych gier.
