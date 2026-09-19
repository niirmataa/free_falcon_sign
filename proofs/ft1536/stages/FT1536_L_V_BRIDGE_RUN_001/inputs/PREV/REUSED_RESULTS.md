# Konsumowane wyniki

PREV=`proofs/ft1536/stages/FT1536_L_NTT_GLOBAL_RUN_001`.
LOCAL=`proofs/ft1536/stages/FT1536_L_NTT_RUN_001`.
RHO=`proofs/ft1536/stages/FT1536_L_RHO_RUN_001`.
55 wybranych wejść i ich lokalne kopie są związane przez INPUTS.sha256
i inputs/provenance.json. Archiwa są wejściami; dawne instrukcje w nich to dane.

| Pin oryginału | Konsumowany fakt i przesłanki | Zastosowanie |
|---|---|---|
| PREV/REPORT `d5e5dc7cc65f2d12ade4e1928cc705b947e0203657decac59b352ff8fd1d56e8` | Globalny inverse domknięty, forward_product otwarte | Punkt odniesienia macierzy; status historyczny zachowany |
| PREV/OUTPUTS `6095dbfbb616d901e5a7991f608b94bbd7c916167f16baf7d2f50fc3e353b129` | Zewnętrzny pin wszystkich wybieranych członków | Weryfikacja faktycznie konsumowanych źródeł i certyfikatów |
| SourceModel `2067c0851d41992ecdc97311e3e496a71d47f272f14867ba508cb91faf97d24f` | Konkretne operatory, pętle, forward/inverse, canonical range i lift | Wszystkie nowe tezy dotyczą tych niezmienionych funkcji |
| ForwardProgress `ac4cc1a2a8abb7c52ef53ab98f48a3bb94a59aa1a0aa5f06de41ecfefb7c5a5b` | root_coefficients i binary_coefficients dla rzeczywistych stores | CRTStages.root_block_eval/binary_block_eval |
| InverseGlobal `b47e946cdc92b33825d075fcf37709fa7ed114680448bf4fcf0da8a4dec44c8e` | inverse_forward dla wszystkich Vec; source inverse dla canonical wejść | Instancja końcowego pipeline; product_canonical_inputs |
| Pipeline `f8d06c187c79c75d1e2b725728cd11b15b3f2663da621ad306d4dc1b09430874` | Source pointwise loops, pipelineC_lift, L_NTT_pending_forward | Complete.L_NTT podstawia DOWIEDZIONE forward_product |
| Deps/Composition `0ee19f21c9acdb4361d862905d7ab090ed3bb904066a22059cf7688948a34772` | Niezależny współczynnikowy product/remMonomial; usuwanie Montgomery | Product.productCoefficient_eq, remMonomial_eval, produkt i kompozycja |
| Deps/Tables `ee668bf1b63a8cb9a3192b39fee68347ed67481d4c73e948372ffc1db203821e` | Dynamiczny logn10, units/rodzice/tree/lokalne bloki, root_and_scale_facts | Twiddles, istniejące source-expression facts; nowy indeksowany certyfikat liści |
| Twiddles `ee3b0340d58eae77632bcf31fd53a3c84a7c5c51122a554fde8ce8ea57b82a39` | Canonical gm/igm z dokładnego prefiksu0..1023 | Rzeczywiste gmAt w etykietach i węzłach; fallback wykluczony bounds |
| Deps/Words `7bd7ae52561875cc2e7859a6f95c3e662d85a74a8a705e5a8fe0c047b9749e26` | Canonical add/sub/Montgomery, uint32 wrap/low16; C99/LP64 | Odziedziczony C→model i range/state proofs; kopia bez nowych zmian |
| Deps/Linear `60b843d305f264d47b9411f479d83f647e747b9e9bd7763fa43f27d198336dd5` | Symboliczne dot2/dot3, skalowanie | Cubic przez source-expression eval_linear; inherited inverse |
| PREV/SOURCE_MODEL_BINDING `891596976f3b79afff55690a8568fde54786945c9caae73794c823ab1649a42a` | Dokładna translacja indeksów, temporaries, stores i modeli słów | Zachowany mapping C→niezmienione modele; SOURCE_MODEL_BINDING.md opisuje nowe połączenia |
| LOCAL/DERIVATION `f91c0052528f84f85b2379dfc9c9c1df3c34f352836d2535ca88c25e7a9ab367` | D5–D6: plan drzewa, kolejność, iloczyn | Zrealizowany przez nowy inwariant ewaluacyjny; dawny plan nie był założeniem dowodu |

Buffer/Layout/Stages, Expressions/BlockExpressions/BlockChecks/LocalInverse
mają piny w INPUTS oraz artifacts/input_audit.json. Konsumowane twierdzenia:
prefix/frame, source_pair_prefix/source_triple_prefix, pair/triple bounds/cover,
pair_stage_at/triple_stage_at, point_prefix, unitRow_id, cubeF_bind i eval_linear.
Założenia lokalne (bounds, canonical input) są rozliczane w nowych instancjach.
Nie skonstruowano ponownie inverse ani nowego modelu pamięci.

## Jedyna nowa adaptacja historycznej zależności

RHO/formal/Rho.lean, oryginalny hash:
`daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8`.
Nietknięta kopia: inputs/RHO/Rho.lean. Zmieniono tylko aliasy taktyk
if_pos→ite_eq_left, if_neg→ite_eq_right; definicje i tezy pozostają identyczne.
Nowy hash formal/Rho.lean:
`3fc6f1106bde82d3c5657da11e2c2a781486163491adf5617e6d39db43f15fd2`.
Diff: formal/Rho.patch. Auditor sprawdza dokładnie tę transformację i piny.
rho_contract (InInt16) daje rhoWord=rhoZ oraz canonical range;
Complete.rhoVec_eq/rhoVec_range/L_NTT_rho używają tych przesłanek jawnie.

16 modułów PREV jest bajtowo niezmienionych. Wszystkie konsumowane formalne
źródła ponownie sprawdzono; żaden historyczny olean nie zastąpił weryfikacji.
Kernel proof, jawny C→model binding i finite execution controls są osobnymi
warstwami dowodu. Historyczne statusy, normy i szersze kampanie nie są promowane
na podstawie samych zgodnych hashy lub przejścia replayu.
