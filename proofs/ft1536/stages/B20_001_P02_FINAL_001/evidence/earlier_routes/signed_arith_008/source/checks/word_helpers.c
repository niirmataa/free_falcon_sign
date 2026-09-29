#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fpr-emulated.h"

int
main(int argc, char **argv)
{
	FILE *input;
	uint64_t x, right, left, signed_right;
	unsigned long valid = 0, rejected = 0;
	int count, fields;

	if (argc != 2 || (input = fopen(argv[1], "r")) == NULL) {
		return 2;
	}
	while ((fields = fscanf(input, "%" SCNx64 " %d %" SCNx64
		" %" SCNx64 " %" SCNx64, &x, &count, &right, &left,
		&signed_right)) == 5) {
		int64_t sx;
		uint64_t got_right, got_left, got_signed;

		if (count < 0 || count >= 64) {
			rejected ++;
			continue;
		}
		memcpy(&sx, &x, sizeof sx);
		got_right = fpr_ursh(x, count);
		got_left = fpr_ulsh(x, count);
		got_signed = (uint64_t)fpr_irsh(sx, count);
		if (got_right != right || got_left != left || got_signed != signed_right) {
			fprintf(stderr, "MISMATCH x=%016" PRIx64 " n=%d"
				" got=%016" PRIx64 ",%016" PRIx64 ",%016" PRIx64
				" expected=%016" PRIx64 ",%016" PRIx64 ",%016" PRIx64 "\n",
				x, count, got_right, got_left, got_signed, right, left, signed_right);
			fclose(input);
			return 1;
		}
		valid ++;
	}
	if (fields != EOF || ferror(input) || valid == 0 || rejected != 2) {
		fclose(input);
		return 3;
	}
	fclose(input);
	printf("{\"valid\":%lu,\"preflight_rejected\":%lu,\"pass\":true}\n", valid, rejected);
	return 0;
}
