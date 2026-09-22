# Zachowane kontrmodele i ograniczenia

## Local conditioning ≠ whole-call survival

Wykonany exactQQ two-step tree: pierwszy supported return0/1 maQSprob1/2.
Po0 survival mass1/2,po1 mass3/4; przy survival drugi return0. Stąd
QS(00)=QS(10)=1/2, Qstoplive(00)=1/4,Qstoplive(10)=3/8,
Qstop(survival)=5/8. Po całkowitym conditioning dostajemy2/5,3/5,
aTV(QS,Qstop|survival)=**1/10**. Full evidence w artifacts/probability/conditioning_countermodel.json.

Klasa ABSTRACT_ADAPTIVE_KERNEL, nie Emitted/source witness. Obala generic
identity, której potrzebowałaby błędna kompozycja. Dla source wyprowadzono
dokładną history-dependent tilt formula,bez ogłaszania tego toy tree atakiem.

## Support window jest za szerokie

LocalD_env input mu0,sigmaRN(4/3),bank0,k29,b0 ma positive literal proposal
count,ale source e>=64 i acceptedweight0. Proposal window zawiera y−29,
positiveKsupport go nie zawiera. Mutacja window→S została wykonana z exact
source transducer. Nie wykazano Emitted membership tego lokalnego inputu.
EXIT pozaS nie jest automatycznie domain fault lubUB.

## Value law nie identyfikuje resource law

Dwa public source-root tapes mają IDENTYCZNE3072 values/centers/widths/POSTbytes,
lecz3147 vs6219 proposals,26vs51refills i różne ptr. Native original sampler
potwierdził to normal/ASan/UBSan. To kontrola projekcji i kontrprzykład do
wnioskowania równości resources z samej równości realizedvalue trace.
Nie obala conditional source jointN/Y law; rozdziela jego zakresy.

## Kierunki chi-square

Uniwersalnie dla required entries Qstop(EXIT)>0 iP(EXIT)=0: reversechi2∞.
QS ma ten sam support coP; reverse finite z brutalnymupper2^811008−1.
To luźna majoranta, NIE dolny bound ani wykazany duży loss. Brak małego
reverse exportu nie jest counterexample do forward boundu.

Wykonano12meaningfulmutations+no-op. Każda ma actualbaseline/changed values,
status i scope w artifacts/mutations. Mutacje modelu nie są integrated Cpatch.
Required-domain counterexample do nowej tezy nie stwierdzono. Historyczne
GAUSS negative expm/overrun i POST65536→0 zachowują swoje wcześniejsze zakresy;
nie awansują tu do emitted attacks lub nowych Safe16 claims.
