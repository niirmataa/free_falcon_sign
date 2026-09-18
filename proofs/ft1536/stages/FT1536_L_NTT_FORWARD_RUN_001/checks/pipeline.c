#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "../source/falcon-vrfy.c"

static void emit(const char *name, const uint16_t *a)
{
	printf("%s", name);
	for (size_t i = 0; i < 1536; i ++) printf(" %u", (unsigned)a[i]);
	putchar('\n');
}

int main(int argc, char **argv)
{
	if (argc != 2) return 2;
	FILE *in = fopen(argv[1], "r");
	if (in == NULL) return 3;
	int rho, x;
	uint16_t H[1536], a[1536], c[1536];
	if (fscanf(in, "%d", &rho) != 1 || (rho != 0 && rho != 1)) return 4;
	for (size_t i = 0; i < 1536; i ++) {
		if (fscanf(in, "%d", &x) != 1 || x < 0 || x >= 18433) return 5;
		H[i] = (uint16_t)x;
	}
	for (size_t i = 0; i < 1536; i ++) {
		if (fscanf(in, "%d", &x) != 1) return 6;
		if (rho) {
			if (x < -32768 || x > 32767) return 7;
			a[i] = ft1536_normalize_s2((int16_t)x);
		} else {
			if (x < 0 || x >= 18433) return 8;
			a[i] = (uint16_t)x;
		}
	}
	for (size_t i = 0; i < 1536; i ++) {
		if (fscanf(in, "%d", &x) != 1 || x < 0 || x >= 18433) return 9;
		c[i] = (uint16_t)x;
	}
	fclose(in);
	mq_NTT(H, 10, 1);
	mq_poly_tomonty(H, 10, 1);
	mq_NTT(a, 10, 1);
	mq_poly_montymul_ntt(a, H, 10, 1);
	mq_iNTT(a, 10, 1);
	emit("p", a);
	mq_poly_sub(a, c, 10, 1);
	emit("d", a);
	return 0;
}
