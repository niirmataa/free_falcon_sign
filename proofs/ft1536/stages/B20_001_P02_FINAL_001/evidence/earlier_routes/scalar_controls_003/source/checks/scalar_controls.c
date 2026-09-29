#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fpr-emulated.h"

static int
hex64(const char *s, uint64_t *out)
{
	unsigned long long v;
	char extra;

	if (sscanf(s, "%llx%c", &v, &extra) != 1) {
		return -1;
	}
	*out = (uint64_t)v;
	return 0;
}

static void
mismatch(const char *op, const char *detail)
{
	fprintf(stderr, "MISMATCH op=%s %s\n", op, detail);
}

int
main(int argc, char **argv)
{
	FILE *input;
	char op[16], scope[16], line[512];
	unsigned long valid_in = 0, valid_obs = 0, rejected = 0;
	unsigned long lineno = 0;

	if (argc != 2 || (input = fopen(argv[1], "r")) == NULL) {
		return 2;
	}
	while (fgets(line, sizeof line, input) != NULL) {
		char a[64], b[64], c[64], d[64];
		uint64_t x, y, m, exp, got;
		long long s, ev;

		lineno ++;
		if (sscanf(line, "%15s", op) != 1) {
			continue;
		}
		if (strcmp(op, "neg") == 0 || strcmp(op, "double") == 0 ||
		    strcmp(op, "half") == 0 || strcmp(op, "rint") == 0 ||
		    strcmp(op, "floor") == 0) {
			if (sscanf(line, "%*s %63s %63s %15s", a, b, scope) != 3 ||
			    hex64(a, &x) != 0 || hex64(b, &exp) != 0) {
				return 3;
			}
			if (strcmp(op, "neg") == 0) {
				got = fpr_neg(x);
			} else if (strcmp(op, "double") == 0) {
				got = fpr_double(x);
			} else if (strcmp(op, "half") == 0) {
				got = fpr_half(x);
			} else if (strcmp(op, "rint") == 0) {
				int64_t r = fpr_rint(x);
				memcpy(&got, &r, sizeof got);
			} else {
				long r = fpr_floor(x);
				memcpy(&got, &r, sizeof got);
			}
			if (got != exp) {
				char detail[192];
				snprintf(detail, sizeof detail,
					"x=%016" PRIx64 " got=%016" PRIx64
					" expected=%016" PRIx64 " line=%lu",
					x, got, exp, lineno);
				mismatch(op, detail);
				fclose(input);
				return 1;
			}
			if (strcmp(scope, "in") == 0) {
				valid_in ++;
			} else if (strcmp(scope, "obs") == 0) {
				valid_obs ++;
			} else {
				return 3;
			}
		} else if (strcmp(op, "pack") == 0) {
			if (sscanf(line, "%*s %63s %63s %63s %63s %15s",
			    a, b, c, d, scope) != 5) {
				return 3;
			}
			s = strtoll(a, NULL, 10);
			ev = strtoll(b, NULL, 10);
			if (hex64(c, &m) != 0 || hex64(d, &exp) != 0) {
				return 3;
			}
			if (ev + 1076 > INT_MAX || ev + 1076 < INT_MIN) {
				if (strcmp(scope, "in_reject") != 0) {
					return 3;
				}
				rejected ++;
				continue;
			}
			got = FPR((int)s, (int)ev, m);
			if (got != exp) {
				char detail[256];
				snprintf(detail, sizeof detail,
					"s=%lld e=%lld m=%016" PRIx64
					" got=%016" PRIx64 " expected=%016" PRIx64
					" line=%lu",
					s, ev, m, got, exp, lineno);
				mismatch(op, detail);
				fclose(input);
				return 1;
			}
			if (strcmp(scope, "in") == 0) {
				valid_in ++;
			} else if (strcmp(scope, "obs") == 0) {
				valid_obs ++;
			} else {
				return 3;
			}
		} else if (strcmp(op, "subw") == 0) {
			uint64_t flipped, rsub, radd;

			if (sscanf(line, "%*s %63s %63s %15s", a, b, scope) != 3 ||
			    hex64(a, &x) != 0 || hex64(b, &y) != 0) {
				return 3;
			}
			flipped = y ^ ((uint64_t)1 << 63);
			rsub = fpr_sub(x, y);
			radd = fpr_add(x, flipped);
			if (rsub != radd) {
				char detail[192];
				snprintf(detail, sizeof detail,
					"x=%016" PRIx64 " y=%016" PRIx64
					" sub=%016" PRIx64 " add=%016" PRIx64
					" line=%lu",
					x, y, rsub, radd, lineno);
				mismatch(op, detail);
				fclose(input);
				return 1;
			}
			if (strcmp(scope, "in") == 0) {
				valid_in ++;
			} else {
				return 3;
			}
		} else {
			return 3;
		}
	}
	if (ferror(input) || valid_in == 0 || valid_obs == 0 || rejected != 2) {
		fclose(input);
		return 3;
	}
	fclose(input);
	printf("{\"valid_in\":%lu,\"valid_obs\":%lu,\"rejected\":%lu,\"pass\":true}\n",
		valid_in, valid_obs, rejected);
	return 0;
}
