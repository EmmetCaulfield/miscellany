#pragma once

// For size_t:
#include <stddef.h>

size_t cbst_root(size_t nmemb);
size_t cbst_index(size_t nmemb, size_t value);
void*  cbst_new(size_t nmemb, size_t size);
size_t cbst_add(void* cbst, size_t nmemb, size_t size, size_t pos, const void* value);
void*  cbst_from_sorted_array(const void *base, size_t nmemb, size_t size);
const void* cbst_find(const void *cbst, size_t nmemb, size_t size,
                      int (*compar)(const void *, const void *), const void *value, size_t root);
