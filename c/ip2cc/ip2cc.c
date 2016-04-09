#define _GNU_SOURCE 1

#include <defaults.h>
#include <ip-cbst.h>
#include <stdio.h>      // For printf()
#include <stdlib.h>
#include <stddef.h>     // For size_t
#include <assert.h>

void set_default_env(void)
{
    setenv(IP2CC_TXTDB_ENVAR, IP2CC_TXTDB_PATH, 0);
    setenv(IP2CC_BINDB_ENVAR, IP2CC_BINDB_PATH, 0);
}

int main(int argc, char *argv[])
{
    const ip_cbst_node* cbst = NULL;
    size_t nmemb = 0;
    const ip_cbst_node* node = NULL;
    char buf[512];

    assert(argc>=2);

    set_default_env();
    cbst = ip_cbst_load(NULL, &nmemb);

    for(int i=1; i<argc; i++) {
        node = ip_cbst_lookup_dq(cbst, nmemb, argv[i]);
        if( node != NULL ) {
            ip_cbst_address_range(node, buf);
            printf("%s %s %s\n", node->cc, argv[i], buf);
        } else {
            printf("%s (no match)\n", argv[i]);
        }
    }

    free((void *)cbst);

    return 0;
}
