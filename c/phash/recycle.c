/*
--------------------------------------------------------------------
By Bob Jenkins, September 1996.  recycle.c
You may use this code in any way you wish, and it is free.  No warranty.

This manages memory for commonly-allocated structures.
It allocates RESTART to REMAX items at a time.
Timings have shown that, if malloc is used for every new structure,
  malloc will consume about 90% of the time in a program.  This
  module cuts down the number of mallocs by an order of magnitude.
This also decreases memory fragmentation, and freeing structures
  only requires freeing the root.
--------------------------------------------------------------------
*/

#include <recycle.h>

#include <stdint.h>     /* for uint32_t */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>      /* for fprintf() */

#define align(a) (((uint32_t)a+(sizeof(void *)-1))&(~(sizeof(void *)-1)))

reroot *remkroot(size_t size)
{
    reroot *r = (reroot *)remalloc(sizeof(reroot), __FILE__ ", root");
    r->list = (recycle *)0;
    r->trash = (recycle *)0;
    r->size = align(size);
    r->logsize = RESTART;
    r->numleft = 0;
    return r;
}

void refree(reroot *r)
{
    recycle *temp;

    while (r->list) {
        temp = r->list->next;
        free((char *)r->list);
        r->list = temp;
    }

    free(r);
    return;
}

/* to be called from the macro renew only */
char *renewx(reroot *r)
{
    recycle *temp;
    if (r->trash) {
        /* pull a node off the trash heap */  
        temp = r->trash;
        r->trash = temp->next;
        (void)memset((void *)temp, 0, r->size);
    } else {  
        /* allocate a new block of nodes */
        r->numleft = r->size*((uint32_t)1<<r->logsize);
        if (r->numleft < REMAX) ++r->logsize;
        temp = (recycle *)remalloc(sizeof(recycle) + r->numleft, __FILE__ ", data");
        temp->next = r->list;
        r->list = temp;
        r->numleft-=r->size;
        temp = (recycle *)((char *)(r->list+1)+r->numleft);
    }
    return (char *)temp;
}

void *remalloc(size_t len, const char *purpose)
{
    void *x = malloc(len);
    if (x==NULL)
    {
        fprintf(stderr, "malloc(%zu) failed for %s\n", len, purpose);
        exit(EXIT_FAILURE);
    }
    return x;
}
