#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/time.h>

double nowsecs() {
    struct timeval now;
    gettimeofday(&now, NULL);
    return (double)now.tv_sec + now.tv_usec/1e6;
}


// LFSR mask constants for lengths n from 3 to 32, from m-sequence tap
// tables
//
// n= 3, [3,2]        = {0,1}       =                 011 = 0x0003
// n= 4, [4,3]        = {0,1}       =                0011 = 0x0003
// n= 5, [5,3]        = {0,2}       =              0 0101 = 0x0005
// n= 6, [6,5]        = {0,1}       =             00 0011 = 0x0003
// n= 7, [7,6]        = {0,1}       =            000 0011 = 0x0003
// n= 8, [8,6,5,4]    = {0,2,3,4}   =           0001 1101 = 0x001d
// n= 9, [9,5]        = {0,4}       =         0 0001 0001 = 0x0011
// n=10, [10,7]       = {0,3}       =        00 0000 1001 = 0x0009
// n=11, [11,9]       = {0,2}       =       000 0000 0101 = 0x0005
// n=12, [12,6,4,1]   = {0,6,8,11}  =      1001 0100 0001 = 0x0941
// n=13, [13,4,3,1]   = {0,9,10,12} =    1 0110 0000 0001 = 0x1601
// n=14, [14,5,3,1]   = {0,9,11,13} =   10 1010 0000 0001 = 0x2a01
// n=15, [15,14]      = {0,1}       =  000 0000 0000 0011 = 0x0003
// n=16, [16,15,13,4] = {0,1,3,12}  = 0001 0000 0000 1011 = 0x100b
//
// n=31, [31,28]      = {0,3}       =                1001 = 0x0009
// n=32, [32,22,2,1]  = {0,10,30,31}   = 1100 0000 0000 0000 0000 0100 0000 0001 = 0xA0000401
//       [32, 31, 30, 10] = {0,1,2,22} = 0000 0000 0100 0000 0000 0000 0000 0111 = 0x00800003


static const uint32_t masks[] = {
    0x1,       //  1 - the 1-bit m-sequence is just 1!
    0x3,       //  2
    0x3,       //  3
    0x3,       //  4
    0x5,       //  5
    0x3,       //  6
    0x3,       //  7
    0x1d,      //  8
    0x11,      //  9
    0x09,      // 10
    0x05,      // 11
    0x941,     // 12
    0x1601,    // 13
    0x2a01,    // 14
    0x3,       // 15
    0x100b,    // 16
    0x9,       // 17
    0x81,      // 18
    0x27,      // 19
    0x9,       // 20
    0x5,       // 21
    0x3,       // 22
    0x21,      // 23
    0x87,      // 24
    0x9,       // 25
    0x47,      // 26
    0x27,      // 27
    0x9,       // 28
    0x5,       // 29
    0x800007,  // 30
    0x9,       // 31
    //    0x80000057 // 32
    0xA0000401 // 32
};


static inline uint64_t next(uint64_t lfsr, uint64_t mask, uint8_t shift)
{
    uint32_t bit;

    bit = __builtin_parity( lfsr & mask );
    lfsr = (lfsr >> 1) | (bit << shift);

    return  lfsr;
}

// PowerCap buffer size
#define PCBUFSZ 64

// RAPL core directory
#define PCDIR "/sys/class/powercap/intel-rapl/intel-rapl:0/"

// RAPL quiescent power in microwatts (measured over 100 seconds)
#define BASE_PWR0 (798547)
#define BASE_PWR1 (142415)

int main(int argc, char *argv[])
{
    uint64_t start_state = 1ULL;
    uint64_t lfsr        = start_state;
    uint64_t mask        = 0ULL;
    //    uint64_t check;
    uint8_t  nbits;
    uint8_t  shift;

    long     input, count;
    size_t   msize, i;
    
    unsigned char *mem;
    unsigned char result = 123;

    double start;
    double tbw; // Temporal bandwidth
    double ebw; // Energy bandwidth
    
    // Energy
    FILE *core_fp;
    FILE *uncore_fp;

    uint64_t core_uj;   // microjoules
    uint64_t uncore_uj;
    uint64_t temp_uj;    // temp

    uint64_t core_bl; // Baseline
    uint64_t uncore_bl;

    char buf[PCBUFSZ];
    char *cp;
    
    if(argc != 2) { exit(1); }
    input = strtol(argv[1], NULL, 10);
    if( 1L <= input || input <= (long)sizeof(masks) ) {
	nbits = (uint8_t)input;
    } else {
	exit(1);
    }
    if( nbits > 32 ) {
	exit(1);
    }

    msize = 1;
    msize <<= nbits;
    
    mem = malloc(msize*sizeof(unsigned char));
    if( mem == NULL ) {
	exit(2);
    }
    
    for(i=0; i<msize; i++) {
	mem[i] = i%256;
    }


    shift  = nbits-1;
    mask  += masks[shift];
    count  = 0;

    core_fp = fopen(PCDIR "intel-rapl:0:0" "/energy_uj", "r");
    if( core_fp == NULL ) {
	exit(3);
    }
    cp=fgets(buf, PCBUFSZ, core_fp);
    rewind(core_fp);
    core_uj = strtoll(buf, NULL, 10);
    
    uncore_fp = fopen(PCDIR "intel-rapl:0:1" "/energy_uj", "r");
    if( uncore_fp == NULL ) {
	exit(3);
    }
    cp=fgets(buf, PCBUFSZ, uncore_fp);
    rewind(uncore_fp);
    uncore_uj = strtoll(buf, NULL, 10);

    //    printf("%lu %lu\n", core_uj, uncore_uj);
    

    // Start test
    start  = nowsecs();
    do {
	count++;
	do {
	    lfsr    = next(lfsr, mask, shift);
	    result ^= mem[lfsr];
	} while( lfsr != start_state );
    } while ( nowsecs()-start < 1.0 );
    
    start = nowsecs() - start;

    cp=fgets(buf, PCBUFSZ, core_fp);
    temp_uj = strtoll(buf, NULL, 10);

    core_uj = temp_uj - core_uj;
    
    cp=fgets(buf, PCBUFSZ, uncore_fp);
    temp_uj = strtoll(buf, NULL, 10);
    uncore_uj = temp_uj - uncore_uj;
    (void)cp;
    fclose(core_fp);
    fclose(uncore_fp);

    core_bl   = BASE_PWR0*start;
    uncore_bl = BASE_PWR1*start;

    core_uj   -= core_bl;
    uncore_uj -= uncore_bl;
    
    
    //    printf("%d %lu %lu %d %g %g\n", nbits, count, msize-1, result, start, count*msize/1e6/start);
    temp_uj = core_uj+uncore_uj; // total microjoules

    tbw = count*msize/1e6/start; // MB/s
    ebw = count*msize/(double)temp_uj; // MB/J
    
    printf("%d %lu %lu %d %g %g %g %g\n", nbits, count, msize-1, result, start, tbw, ebw, tbw/ebw);

    
    free(mem);

    return 0;
}
