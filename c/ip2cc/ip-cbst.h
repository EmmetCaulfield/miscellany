#pragma once

#include <stddef.h>
#include <arpa/inet.h>
#include <cbst.h>

typedef struct ip_cbst_node ip_cbst_node;

struct ip_cbst_node {
    in_addr_t  addr_hi;
    in_addr_t  addr_lo;
    char       cc[3];
    char       flag;
};

ip_cbst_node*       ip_cbst_new(size_t nmemb);
size_t              ip_cbst_add_node(ip_cbst_node *root, size_t nmemb, size_t pos, const ip_cbst_node *node);
size_t              ip_cbst_add_dq(ip_cbst_node *root, size_t nmemb, size_t pos, const char *dq_lo, const char *dq_hi, const char *cc);
const ip_cbst_node* ip_cbst_lookup_ip(const ip_cbst_node *root, size_t nmemb, const in_addr_t ip);
const ip_cbst_node* ip_cbst_lookup_dq(const ip_cbst_node *root, size_t nmemb, const char* dq);

const ip_cbst_node* ip_cbst_load_txt(const char *filename, size_t* nmemb);
const ip_cbst_node* ip_cbst_load_bin(const char *filename, size_t *nmemb);
const ip_cbst_node* ip_cbst_load(const char *stub, size_t *nmemb);
void                ip_cbst_save_bin(const ip_cbst_node *cbst, size_t nmemb, const char *filename);

char*               ip_cbst_address_range(const ip_cbst_node *node, char *buf);
