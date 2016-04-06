#include <cbst.h>

#include <stdlib.h>     // for malloc()
#include <string.h>     // for memcpy()
 
// Heap/tree movement:
static inline int left(int i)   { return (i<<1)+1; }
static inline int right(int i)  { return (i<<1)+2; }
static inline int parent(int i) { return (i-1)>>1; }

// Bit position (0-31) of highest set bit:
static inline unsigned hsb(unsigned i) {
    return 8*sizeof(int)-1-__builtin_clz(i);
}

// Raise to the power of 2:
static inline unsigned p2(unsigned i) {
    return 1<<i;
}

// Greatest power-of-two less than or equal to
static inline unsigned gp2le(unsigned i) {
    return i==0 ? 0 : 1 << hsb(i);
}

// Level in CBST of index, counting from zero at the top:
static inline unsigned level(unsigned i) {
    return hsb( gp2le(i) );
}


#define MAX(x,y) (x>y ? x : y)
#define MIN(x,y) (x<y ? x : y)

// Compute the value at the root (index=0) of a CBST, populated with
// the integers from 0 to (n-1), given the size, n:
size_t cbst_root(size_t nmemb) 
{
    int lT=level(nmemb); // Top level, where the root is, based on
                         // zero on the bottom; also one less than the
                         // total number of levels (height)

    int i0=p2(lT)-1;     // Index of zero element

    int wB=nmemb-i0;     // Occupied width of the bottom level

    // k here is half the capacity of the bottom level (l0), the
    // capacity of the 2nd last level (l1), and one more than the
    // capacity of the 2nd top through 2nd last levels ("left
    // triangle").
    int k  = 1<<(lT-1);
    int vR = (k-1) + MIN(wB,k);    // Value at the root

    return MAX(vR,0);
}

// Compute the index in the CBST of size 'size' of a given 'value':
size_t cbst_index(size_t nmemb, size_t value)
{
    size_t index=0;
    size_t root=1;

    while( root ) {
        root = cbst_root(nmemb);
//        printf("\t%zu ?= %zu ", value, root);
        if( value > root ) {
            // Go right
//            printf(" <- \n");
            index  = right(index);
            nmemb -= root + 1;
            value -= root + 1;
        } else if( value < root ) {
            // Go left
//            printf(" -> \n");
            index = left(index);
            nmemb = root;
        } else {
            // value == root
            break;
        }
    }
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

