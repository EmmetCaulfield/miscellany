#define _GNU_SOURCE 1

#include <ip-cbst.h>
#include <stdio.h>      // For printf()
#include <stdlib.h>
#include <stddef.h>     // For size_t
#include <assert.h>

int main(int argc, char *argv[])
{
    const ip_cbst_node* cbst = NULL;
    size_t nmemb = 0;
    const ip_cbst_node* node = NULL;
    char buf[32];

    assert(argc>=2);

    cbst = ip_cbst_load("country", &nmemb);

    for(int i=1; i<argc; i++) {
        node = ip_cbst_lookup_dq(cbst, nmemb, argv[i]);
        if( node != NULL ) {
            ip_cbst_address_range(node, buf);
            printf("%s %s (%s)\n", node->cc, argv[i], buf);
        } else {
            printf("%s (no match)\n", argv[i]);
        }
    }

    free((void *)cbst);

    return 0;
}
