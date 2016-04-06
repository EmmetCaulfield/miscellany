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


static inline uint32_t xorbits0(uint32_t b, int n) {
    (void)n;
    return __builtin_popcount(b) & 1;
}


static inline uint32_t xorbits1(uint32_t v, int n) {
    (void)n;
    v ^= v >> 1;
    v ^= v >> 2;
    v = (v & 0x11111111U) * 0x11111111U;
    return (v >> 28) & 1;
}


static inline uint32_t xorbits2(uint32_t b, int n) {
    __asm__(
	"cmp	$0x08,	%1	\n\t"
	"mov 	%0,	%1	\n\t"
	"jle	1f		\n\t"
	"bswap	%1		\n\t"
	"xor	%1,	%0	\n\t"
	"mov 	%0,	%1	\n\t"
	"1:			\n\t"
	"xchg	%h0,	%b0	\n\t"
	"xor	%0,	%1	\n\t"
	"setpo	%b0		\n\t"
	"and	$0x1,	%0	\n\t"
	: "+r" (b), "+r" (n)
	: 
	: "cc"
    );

    return b;
}


static inline uint32_t xorbits3(uint32_t b, int n) {
    (void)n;
    b ^= b>>16;
    b ^= b>> 8;
    b ^= b>> 4;
    b ^= b>> 2;
    b ^= b>> 1;
    b &= 1;
    return b;
}


static inline uint32_t xorbits4(uint32_t b, int n) {
    if(n>4) {
	b ^= b>> 4;
	if(n>8) {
	    b ^= b>> 8;
	    if(n>16) {
		b ^= b>> 16;
	    }
	}
    }
    b ^= b>>2;
    b ^= b>>1;
    b &= 1;
    return b;
}

static inline uint32_t xorbits5(uint32_t b, int n) {    
    int i=1;
    do {
	b  ^= b>>i;
	i <<= 1;
    } while(i<n);
    b &= 1;
    return b;
}

static inline uint32_t xorbits6(uint32_t b, int n) {    
    if(n>16) b ^= b>>16;
    if(n> 8) b ^= b>> 8;
    if(n> 4) b ^= b>> 4;
    b ^= b>>2;
    b ^= b>>1;
    b &= 1;
    return b;
}


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
// n=32, [32,22,2,1]  = {0,10,30,31}= 1100 0000 0000 0000 0000 0100 0000 0001 = 0xA0000401

const uint32_t masks[] = {
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
    0xA0000401 // 32
};

#define FRST 0
#define NFNS 7

int main(int argc, char *argv[])
{
    uint32_t start_state = 0x00000001u;
    uint32_t lfsr        = start_state;
    uint32_t mask;
    uint8_t  shift;
    unsigned bit;
    long     input;

    uint32_t (*xorbits[])(uint32_t, int) = {xorbits0, xorbits1, xorbits2, xorbits3, xorbits4, xorbits5, xorbits6};
    double   dt[NFNS];
    unsigned count[NFNS]={0};
    int      winner;

    if(argc != 2) { exit(1); }
    input = strtol(argv[1], NULL, 10);
    if( 1L <= input || input <= (long)sizeof(masks) ) {
	shift = (uint8_t)input-1;
    } else {
	exit(1);
    }
    mask = masks[shift];


    for(int i=FRST; i<NFNS; i++) {
	uint32_t nruns=0;
	dt[i] = nowsecs();
	do {
	    count[i]=0;
	    do
	    {
		bit  = xorbits[i]( lfsr & mask, shift+1 );
		lfsr = (lfsr >> 1) | (bit << shift);
		count[i]++;
	    } while (lfsr != start_state);
	    nruns++;
	} while( nowsecs()-dt[i] < 1.0 );
	dt[i] = (nowsecs()-dt[i])/nruns;
    }

    // We use input because it's long
    input = (1<<(shift+1))-1;
    
    winner=FRST;
    for(int i=FRST+1; i<NFNS; i++) {
	if(count[i]==input && dt[i]<dt[winner]) {
	    winner=i;
	}
    }

    printf("%2d ", shift+1);
    for(int i=FRST; i<NFNS; i++) {
	double pc = 100*(dt[i]-dt[winner])/dt[winner];
	printf("%d%c%4.1f%% %s,  ", i, (count[i]==input?'-':'*'), pc, i==winner ? "winner" : "behind");
    }
    printf(" %5.1f Mps.\n", input/dt[winner]/1e6);

//    printf("%2u %10u values, winner: %d by %g %%\n", shift+1, input, dt2>dt1 ? 2 : 1, 100.0*(dt2>dt1 ? (dt2-dt1)/dt2 : (dt1-dt2)/dt1));

    return 0;
}
