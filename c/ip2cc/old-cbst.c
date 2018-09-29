#include <cbst.h>

#include <stdlib.h>     // for malloc()
#include <string.h>     // for memcpy()
 
// Heap/tree movement:
static inline int left(int i)   { return (i<<1)+1; }
static inline int right(int i)  { return (i<<1)+2; }
static inline int parent(int i) { return (i-1)>>1; }

// Bit position (0-31) of highest set bit:
static inline unsigned height(unsigned i) {
    return 8*sizeof(unsigned)-__builtin_clz(i);
}

#define MAX(x,y) (x>y ? x : y)
#define MIN(x,y) (x<y ? x : y)

// Compute the value at the root (index=0) of a CBST, populated with
// the integers from 0 to (n-1), given the size, n:
size_t cbst_root(size_t n) 
{
    if( n==1 ) {
        return 0;
    }
    unsigned h = height(n);    // Height of BST
    unsigned i = (1<<(h-1))-1; // Index of zero element
    unsigned w = n-i;          // Occupied width of the bottom level
    unsigned k = 1<<(h-2);     // Half-capacity of bottom level

    return i - MAX((int)k-w,0);
}

// Compute the index in the CBST of size 'size' of a given 'value':
size_t cbst_index(size_t nmemb, size_t value)
{
    size_t index=0;
    size_t root=1;

    while( root ) {
        root = cbst_root(nmemb);
        printf("\t%zu ?= %zu (%zu, %zu)", value, root, nmemb, index);
        if( value > root ) {
            // Go right
            printf(" -> \n");
            index  = right(index);
            nmemb -= root + 1;
            value -= root + 1;
        } else if( value < root ) {
            // Go left
            printf(" <- \n");
            index = left(index);
            nmemb = root;
        } else {
            // value == root
            printf(" == %zu\n", index);
            break;
        }
    }
    printf("\t%zu ?= %zu ", value, root);
    printf(" == %zu\n", index);
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

