#ifndef MSEQ_H
#define MSEQ_H

#include <stdint.h>

typedef union {
    uint64_t u64;
    struct {
	unsigned nbits      :  6;
	unsigned            : 10;
__extension__
	unsigned long state : 48;
    };
} mseq_o;

mseq_o mseq_new(unsigned nbits);
unsigned long mseq_next(mseq_o* m);

#endif
