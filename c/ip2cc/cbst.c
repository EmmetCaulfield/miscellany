#include <cbst.h>

#include <stdlib.h>     // for malloc()
#include <string.h>     // for memcpy()
#include <sys/param.h>  // for correct MIN()/MAX() macros

#include <stdio.h>      // for printf()
 
// Heap/tree movement:
static inline int left(int i)   { return (i<<1)+1; }
static inline int right(int i)  { return (i<<1)+2; }
static inline int parent(int i) { return (i-1)>>1; }

// Zoom left n steps:
static inline int weft(int i, int n) { return (i<<n)+(1<<n)-1; }
// Zoom right n steps:
static inline int warp(int i, int n) { return (i<<n)+(2<<n)-2; }

static inline int is_p2(int i) {
    return __builtin_popcount(i)==1;
}

// Height of binary tree given size n
static inline unsigned height(unsigned n) {
    return 8*sizeof(unsigned)-__builtin_clz(n);
}

// Conditional printing:
static int cprint_on=0;
#define cprintf(...) if(cprint_on) { printf(__VA_ARGS__); }


size_t cbst_root(size_t n) 
{
    if( n==1 ) {
        return 0;
    }
    size_t h = height(n);    // Height of BST
    size_t i = (1<<(h-1))-1; // Index of zero element
    size_t w = n-i;          // Occupied width of the bottom level
    size_t k = 1<<(h-2);     // Half-capacity of bottom level
    size_t r = i - MAX((ssize_t)(k-w),0);

    cprintf("[%2zu %6zu %6zu %6zu %6zd %6zu]", h, i, k, w, k-w, r);

    return r;
}


size_t cbst_index2(size_t nmemb, size_t value)
{
    size_t saved = value;
    size_t index = 0;
    size_t mask  = 1;
    size_t contra = 1;

    // Commute trailing ones to zeros:
//    while( mask & value ) {
//        value ^=mask;
//        mask <<= 1;
//    }

    mask = 1 << (height(nmemb)-1);
    cprintf("{%6zu (%6zu %5zx) (%6zu %5zx) (%6zu %6zu) %d}\n", saved, value, value, index, index, mask, contra, !!(mask&value));
    while( mask ) {
        if( mask & value ) {
            index  = right(index);
            value ^= mask; // Clear the bit we just tested
        } else {
            index = left(index);
        }
        mask >>= 1;
        contra <<= 1;
        cprintf("{%6zu (%6zu %5zx) (%6zu %5zx) (%6zu %6zu) %d}\n", saved, value, value, index, index, mask, contra, !!(mask&value));
        if( value == mask-1 ) {
            break;
        }
    }

    cprintf("Final: {%6zu (%6zu %5zx) (%6zu %5zx) %5zx %zx}\n", nmemb, value, value, index, index, mask, mask&value);
    return index;
}


// Compute the index in the CBST of size 'size' of a given 'value':
size_t cbst_index(size_t nmemb, size_t value)
{
    size_t index=0;
    size_t root=1;

    size_t test=cbst_index2(nmemb, value);

    if(cprint_on) {
        cprint_on=1;
    }

    printf("\ncbst_index(%zu, %zu) %zx\n", nmemb, value, nmemb^value);
    while( root ) {
        root = cbst_root(nmemb);
/*
        if( is_p2(root+1) ) {
            cprintf("  ");
        } else {
            cprint_on++;
            cprintf(" @%d", cprint_on);
        }
*/
        cprintf("\t%zu ?= %zu (%zu, %zu)", value, root, nmemb, index);
        if( value > root ) {
            // Go right
            cprintf(" -> \n");
            index  = right(index);
            nmemb -= root + 1;
            value -= root + 1;
        } else if( value < root ) {
            // Go left
            cprintf(" <- \n");
            index = left(index);
            nmemb = root;
        } else {
            cprintf(" == \n");
            // value == root
            break;
        }
    }

    if( index!=test ) {
        cprint_on = 1;
    }

    cprintf( "%s %zu (%zu)\n\n", (index==test ? "BOOM!" : "Wah!!"), index, test);
    return index;
}


void* cbst_new(size_t nmemb, size_t size)
{
    return malloc(nmemb*size);
}

// Add the 'value' of size 'size' from position 'pos' in some array of
// length 'nmemb' to 'cbst', which also has 'nmemb' elements:
size_t cbst_add(void* cbst, size_t nmemb, size_t size, size_t pos, const void* value)
{
    size_t j;

    j = cbst_index(nmemb, pos);
    memcpy((char*)cbst+j*size, value, size);
    return j;
}


// Constructs a Complete Binary Search Tree from a sorted array:
void* cbst_from_sorted_array(const void *base, size_t nmemb, size_t size)
{
    unsigned i;
    void *cbst = cbst_new(nmemb, size);

    for(i=0; i<nmemb; i++) {
        cbst_add(cbst, nmemb, size, i, (char*)base+i*size);
    }
    return cbst;
}

// Find the (value pointed at by) 'value':
const void *cbst_find(const void *cbst, size_t nmemb, size_t size,
                      int (*compar)(const void *, const void *), const void *value, size_t root)
{
    int cmp;

    if( cbst==NULL || root >= nmemb) {
        return NULL;
    }

    cmp = compar((char*)cbst+root*size, value);
    if( cmp > 0 ) {
        // root > value
        return cbst_find(cbst, nmemb, size, compar, value, right(root));
    } else if (cmp < 0 ) {
        // root < value
        return cbst_find(cbst, nmemb, size, compar, value, left(root));
    }

    // root == value, return it:
    return (char*)cbst+root*size;
}

