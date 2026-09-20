# Eksport raw certificate i następny odrębny typ

RAW_PREFIX_CERTIFICATE.json eksportuje dla niezmienionego P_key i legalnych
buffers, z emitted corollary:
- actual defined terminating cut po load_skey1253;
-6144 exact SourceFFT_B words w sk[0,6144);
-18432 source-snapshot-matched raw tree words w sk[6144,24576);
-16896 finite internal L i1536 positive finite RAW subtractive leaves;
- LEAF_MAP positions, literal base word expressions i physical order;
- root Gram/basis/coeff frame, scratch high-water8192/10752 i read moments;
- pin56974571… i ROOT/NODE3/NODE2/TOWER/FLOOR proof dependencies.

Każdy leaf word jest exact base g00[0] albo computed d11[0] w jego source
momencie. Uniwersalna sekwencja zależy od p; LEAF_MAP jest jej explicit
index/expression map. Konkretne literalne raw sequences dla synthetic
controls są w checks/data/*.leaves.json, bez P_key/emitted membership claim.

## Najbliższy jeszcze OPEN typ — actual stable rebuild/normalization

```
forall p,memory,
 P_key(p) -> RawPrefixCertificate_CANDIDATE(p,memory) ->
 DefinedTerminating(
   ft_build_stable_certified_leaves(tmp,&stable_leaves,f_src,g_src,10);
   sigma=fpr_of(768);
   ffLDL_ternary_normalize(tree,sigma,10,stable_leaves,&leaf_count)) and
 stable_ok and leaf_count=1536 and tree_words=18432 and
 InternalLWordsPreserved and BasisWordsPreserved and
 StoredTerminalWidths=SourceNormalizedStableWidthSequence(p,sigma=768) and
 AllActualSqrtInverseScalingDomainsAndRequiredGates.
```

Legal buffers/lifetimes dalszego wycinka trzeba wyprowadzić z rzeczywistego
source reuse. Normalizacja jest w kodzie wykonywana po stable helperze,
nie pod nowym `if(stable_ok)` guardem; zachować actual order i końcowy return.
Trzeba dowieść real stored sequence, source sqrt/div/scaling i pozytywnych
gates; raw positive pivots nie są automatycznie normalized widths.
Nie wolno wymagać zachowania root D/Gram storage przez późniejszy reuse tmp.
Internal L preservation dotyczy finalnego tree po nowym osobnym proofie.

INITIAL_TARGETS (FFT3(c), basis products, inverse q) oraz ORDERED_REACH→
NumericCenter przed ZERO consumers są jeszcze osobnymi typami, także dla
odrzuconych attempts. Sampler-law/H1R/FFO/R5T/M7, security i CT całego Sign
nie wynikają z raw assembly. Nie dodano abortu, conditioning lub epsilon.
To handoff interfejsu; normalization nie została rozpoczęta w tym etapie.
