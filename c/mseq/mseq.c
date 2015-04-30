#include <stdio.h>
#include <assert.h>
#include <inttypes.h>

#include <mseq.h>

static const unsigned max_nbits = 48;

mseq_o mseq_new(unsigned nbits) {
    mseq_o   m;
    
    assert(nbits < max_nbits);

    m.nbits = nbits;
    m.state = 1UL;

    return m;
}


unsigned long mseq_next(mseq_o* m) {
    unsigned newbit = (m->state & 0x1)^((m->state & 0x2)>>1);
    m->state >>= 1;
    m->state |= newbit << (m->nbits-1);
    return (unsigned long)m->state;
}
