#define MKN(logn, ter)   ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)))
typedef int (*samplerZ)(void *ctx, fpr mu, fpr sigma);
