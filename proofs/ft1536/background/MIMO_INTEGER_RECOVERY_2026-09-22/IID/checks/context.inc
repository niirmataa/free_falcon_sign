enum {
	FT_SAMPLER_FAULT_NONE = 0,
	FT_SAMPLER_FAULT_INVALID_SIGMA = 1,
	FT_SAMPLER_FAULT_PROPOSAL_RANGE = 2,
	FT_SAMPLER_FAULT_NEGATIVE_X = 3
};

typedef struct {
	prng p;
	unsigned fault;
} ternary_sampler_context;
