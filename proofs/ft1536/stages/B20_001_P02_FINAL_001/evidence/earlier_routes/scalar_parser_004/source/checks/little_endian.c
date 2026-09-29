#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include "shake.c"

int main(int argc, char **argv)
{
	FILE *f;
	uint64_t word;
	unsigned digit[8];
	unsigned long cases = 0;
	int fields;
	if (argc != 2 || (f = fopen(argv[1], "r")) == NULL) return 2;
	while ((fields = fscanf(f, "%" SCNx64 " %x %x %x %x %x %x %x %x",
		&word, &digit[0], &digit[1], &digit[2], &digit[3],
		&digit[4], &digit[5], &digit[6], &digit[7])) == 9) {
		unsigned offset, i;
		for (i = 0; i < 8; i ++) {
			if (digit[i] > 255) { fclose(f); return 3; }
		}
		for (offset = 0; offset < 16; offset ++) {
			unsigned char memory[32];
			memset(memory, 0xA5, sizeof memory);
			for (i = 0; i < 8; i ++) memory[offset + i] = (unsigned char)digit[i];
			if (dec64le(memory + offset) != word) {
				fprintf(stderr, "MISMATCH decode %016" PRIx64 " offset=%u\n", word, offset);
				fclose(f); return 1;
			}
			memset(memory, 0xA5, sizeof memory);
			enc64le(memory + offset, word);
			for (i = 0; i < sizeof memory; i ++) {
				unsigned expected = i >= offset && i < offset + 8 ? digit[i - offset] : 0xA5;
				if (memory[i] != expected) {
					fprintf(stderr, "MISMATCH encode/frame %016" PRIx64 " offset=%u byte=%u\n", word, offset, i);
					fclose(f); return 1;
				}
			}
			cases ++;
		}
	}
	if (fields != EOF || ferror(f) || cases == 0) { fclose(f); return 3; }
	fclose(f);
	printf("{\"pass\":true,\"cases\":%lu}\n", cases);
	return 0;
}
