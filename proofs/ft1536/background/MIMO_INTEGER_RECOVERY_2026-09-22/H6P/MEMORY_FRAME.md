# Source frame i predictability

Legal entry/context/buffer lifetimes i source initialized ranges są odebrane
z JOINT/POST. Key sk24576 words: basis6144 i normalized tree18432; immutable
przez root sampling i suffix. tmp10752: targets[0,3072),returned arrays
[3072,6144),scratch[6144,10752). SOURCE_NOISE_MAP wiąże każdy index leaf/L
z actual callback order. Tree L i width leaves nigdy nie są nadpisywane.

Terminal: source snapshot old t0,mu1,sigma przed paired call; r1,Half i update
mu0; stored call; final residual/sub; dopiero oba stores. xi0 używa ACTUAL
updated mu0,nie stale t0. CDF rejection stutters nie zapisują caller targets.
Q_S positive-prefix closure wyklucza fault/malformed returns i ustala domain
przed każdą dalszą source instruction. EXIT w Q_stop zatrzymuje przed update.

Exact reference operator coefficients a_e,r,i używają wyłącznie immutable
L/B words,fixed ideal root phases i fixed source layout. Sigma_i też entry-fixed.
Tylko innovations i bounded delta(history) zależą od sampled history. Nie ma
future-dependent predictable weights ani source execution na dowolnym vectorze
użytym do operator-norm proofu.

Source suffix zachowuje actual tx/ty copies,basis[g,-f,G,-F],ternary rint stores
bez binary sign transplant. Pre-narrow vectors są oddzielone od stored int16
i późniejszego norm/codec. Source iFFT/rint operands pozostają w domain POST
na wszystkich live Q_S histories; nie wyprowadzamy safety z późniejszego fault
check lub norm acceptance.

Kontrole normal/ASan/UBSan obejmują całe read/write snapshots,key/target frame,
scratch high water,canaries,2 root trees,2 terminal zero cases,oba post vectors
i signed rint boundaries. Publiczne local fixtures nie są emitted proofs.
Mathematical Gaussian shifted means i infinite sums nie są przekazywane do C.
