#define _POSIX_C_SOURCE 200809L

#include <ip-cbst.h>
#include <assert.h>

#include <stdio.h>      // For fopen(), etc.
#include <string.h>     // For strncat()
#include <stdlib.h>     // For exit()

// For stat()
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>


ip_cbst_node* ip_cbst_new(size_t nmemb) {
    return cbst_new(nmemb, sizeof(ip_cbst_node));
}

size_t ip_cbst_add_node(ip_cbst_node *root, size_t nmemb, size_t pos, const ip_cbst_node *node) {
    assert( node != NULL );
    assert( root != NULL );
    assert( pos < nmemb  );

    return cbst_add(root, nmemb, sizeof(ip_cbst_node), pos, node);
}

size_t ip_cbst_add_dq(ip_cbst_node *root, size_t nmemb, size_t pos, 
                      const char *dq_lo, const char *dq_hi, const char *cc)
{
    ip_cbst_node node;

    node.addr_lo = ntohl(inet_addr(dq_lo));
    node.addr_hi = ntohl(inet_addr(dq_hi));
    node.cc[0] = cc[0];
    node.cc[1] = cc[1];
    node.cc[2] = '\0';
    node.flag  = 0;
        
    return ip_cbst_add_node(root, nmemb, pos, &node);
}


static inline int ip_cbst_cmp(const ip_cbst_node* node, const in_addr_t* ipp) {
    assert(node!=NULL);
    assert(ipp!=NULL);
    
    if( node->addr_lo > *ipp ) { return -1; }
    if( node->addr_hi < *ipp ) { return  1; }
    return 0;
}

int ip_cbst_compar(const void* node, const void* ipp) {
    return ip_cbst_cmp(node, ipp);
}


const ip_cbst_node* ip_cbst_lookup_ip(const ip_cbst_node *root, size_t nmemb, in_addr_t ip) {
    if( root==NULL ) {
        return NULL;
    }

    return cbst_find(root, nmemb, sizeof(ip_cbst_node), ip_cbst_compar, &ip, 0);
}


const ip_cbst_node* ip_cbst_lookup_dq(const ip_cbst_node *root, size_t nmemb, const char* dq) {
    in_addr_t ip =  ntohl(inet_addr(dq));
    return ip_cbst_lookup_ip(root, nmemb, ip);
}


static size_t count_lines(FILE *fp) {
    rewind(fp);
    int c;
    size_t n=0;

    while( EOF!=(c=getc(fp)) ) {
        if(c=='\n') {
            n++;
        }
    }
    rewind(fp);
    return n;
}


static char *next_word(char *str) {
    while( *str!=' ' && *str!='\0' ) {
        str++;
    }
    if( *str=='\0' ) {
        return NULL;
    }
    str++;
    if( *str!='\0' ) {
        return str;
    }
    return NULL;
}

char *ip_cbst_address_range(const ip_cbst_node *node, char *buf) 
{
    struct in_addr ip;

    assert(node!=NULL);
    assert(buf!=NULL);

    *buf='\0';
    ip.s_addr=htonl(node->addr_lo);
    strncat(buf, inet_ntoa(ip), 15);
    strncat(buf, "-", 1);
    ip.s_addr=htonl(node->addr_hi);
    strncat(buf, inet_ntoa(ip), 15);

    return buf;
}


const ip_cbst_node* ip_cbst_load_text(const char *filename, size_t* nmemb)
{
    FILE    *fp      = NULL;    // Text database file
    char    *line    = NULL;    // Current line in file
    size_t   len     = 0;       // Length of current line
    ssize_t  n_read  = 0;       // Number of bytes read
    size_t   n_lines = 0;       // Number of lines in file

    char    *dq_lo = NULL;      // Low IP address as dotted quad
    char    *dq_hi = NULL;      // High IP address as dotted quad
    char    *cc = NULL;         // Two-character country code

    ip_cbst_node *cbst = NULL;  // CBST we will return
    size_t line_nr = 0;         // Current line number in file (starting at zero)
    size_t index   = 0;         // Index at which record was placed in CBST
    (void) index;
    
    fp = fopen(filename, "r");
    assert(fp!=NULL);
    n_lines = count_lines(fp);
//    printf("#lines: %zu\n", n_lines);
    cbst = ip_cbst_new(n_lines);

    line_nr = 0;
    while( -1 != (n_read=getline(&line, &len, fp)) ) {
//        printf("line_nr: %zu", line_nr);
        dq_lo = line;
        dq_hi = next_word(line);
        cc    = next_word(dq_hi); 
        index = ip_cbst_add_dq(cbst, n_lines, line_nr, dq_lo, dq_hi, cc);
        line_nr++;
//        printf(", index: %zu\n", index);
    }
    fclose(fp);
    free(line);

    *nmemb = n_lines;
    return cbst;
}


void ip_cbst_save_bin(const ip_cbst_node *cbst, size_t nmemb, const char *filename)
{
    FILE *fp = NULL;
    
    fp = fopen(filename, "wb");
    assert(fp!=NULL);
    
    fwrite(&nmemb, sizeof(size_t), 1, fp);
    fwrite(cbst, sizeof(ip_cbst_node), nmemb, fp);

    fclose(fp);
}


const ip_cbst_node* ip_cbst_load_bin(const char *filename, size_t *nmemb)
{
    FILE         *fp   = NULL;
    ip_cbst_node *cbst = NULL;

    assert(filename!=NULL);
    assert(nmemb!=NULL);

    fp = fopen(filename, "rb");
    assert(fp!=NULL);
    
    fread(nmemb, sizeof(size_t), 1, fp);
    cbst = ip_cbst_new(*nmemb);
    fread(cbst, sizeof(ip_cbst_node), *nmemb, fp);

    fclose(fp);

    return cbst;
}


const ip_cbst_node* ip_cbst_load(const char *stub, size_t *nmemb)
{
    char *bin_path = NULL;
    char *txt_path = NULL;
    int   len;
    struct stat bin_stat;
    struct stat txt_stat;

    const ip_cbst_node* cbst = NULL;

    assert(stub != NULL);
    assert(nmemb != NULL);

    len = strlen(stub);

    bin_path = malloc(len);
    assert(bin_path!=NULL);
    strncpy(bin_path, stub, len);
    strncat(bin_path, ".bin", 4);

    txt_path = malloc(len);
    assert(txt_path!=NULL);
    strncpy(txt_path, stub, len);
    strncat(txt_path, ".txt", 4);

    if( stat(bin_path, &bin_stat) ) {
        // Presume that file does not exist
        cbst = ip_cbst_load_text(txt_path, nmemb);
        ip_cbst_save_bin(cbst, *nmemb, bin_path);
    } else if( stat(txt_path, &txt_stat) ) {
        // Neither the .db (text) or .bin (binary) versions are stat()-able
        perror("failed to stat() any data files");
        exit(EXIT_FAILURE);
    } else {
        if( txt_stat.st_mtime > bin_stat.st_mtime ) {
            cbst = ip_cbst_load_text(txt_path, nmemb);
            ip_cbst_save_bin(cbst, *nmemb, bin_path);
        } else {
            cbst = ip_cbst_load_bin(bin_path, nmemb);
        }
    }

    free(bin_path);
    free(txt_path);

    return cbst;
}