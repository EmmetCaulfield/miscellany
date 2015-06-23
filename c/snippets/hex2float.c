#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef union {
    unsigned u32 ;
    float      f ;
} fourByte;

typedef union {
    unsigned long u64 ;
    double          d ;
} eightByte;

void die(const char *msg) {
    fputs("hex2float: FATAL: ", stderr);
    fputs(msg, stderr);
    fputs("\n", stderr);
    exit(1);
}

void usage(void) {
        fputs("USAGE: hex2float <hex>\n", stderr);
        exit(0);
}

int main(int argc, char* argv[]) {
    int len;
    fourByte four;
    eightByte eight;

    if( argc != 2 ) {
        usage();
    }

    len=strlen(argv[1]);
    eight.u64=strtol(argv[1], NULL, 16);
    if(len < 11) {
        four.u32 = (unsigned)eight.u64;
        printf("        0x%08x as a float is : %f\n", four.u32, four.f);
    }
    printf("0x%016lx as a double is: %f\n", eight.u64, eight.d);

    return 0;
}

