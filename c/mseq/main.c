#include <stdio.h>
#include <inttypes.h>

#include <mseq.h>

const int nbits=5;

int main(void)
{
    mseq_o m;

    m=mseq_new(nbits);

    printf("%16" PRIx64 ": %u %3lu ---\n", m.u64, m.nbits
	   , (unsigned long)m.state);
    
    for(int i=0; i<(1<<nbits); i++) {
	unsigned long n=mseq_next(&m);
	printf("%16" PRIx64 ": %u %3lu %3lu\n", m.u64, m.nbits
	       , (unsigned long)m.state, n);
    }

    return 0;
}
