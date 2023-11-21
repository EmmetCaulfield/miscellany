#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#include <phash.h>

void usage(void) {
    fprintf(stderr, "USAGE: phtest <key>\n");
    exit(EXIT_FAILURE);
}

int main(int argc, char *argv[]) {
    uint32_t k;
    int len;
    
    if( argc != 2 ) {
        usage();
    }
    len = strlen(argv[1]);
    k = phash_str(argv[1], len);
    printf("%s: %u\n", argv[1], k);
    return 0;
}
