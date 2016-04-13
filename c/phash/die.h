#ifndef DIE_H
#define DIE_H

#include <stdio.h>  // for fprintf() & fputs()
#include <stdlib.h> // for exit()
#include <libgen.h> // for basename()

/** @def DIE_IF(C,M)
 *
 * A crude macro which fails with message M if condition C is true.
 */
#define DIE(...) {                                                \
        (void)fprintf(stderr, "FATAL: %s:%d:%s(): ",              \
                      basename(__FILE__), __LINE__, __func__);    \
        (void)fprintf(stderr, __VA_ARGS__);                       \
        (void)fputs(".\n", stderr);                               \
        exit(EXIT_FAILURE);                                       \
    }
#define DIE_IF(C,...) if(C) DIE(__VA_ARGS__)
#define DIE_UNLESS(C,...) if(!(C)) DIE(__VA_ARGS__)


/** @def WARN_IF(C,M)
 *
 * A crude macro which warns and continues with message M if condition
 * C is true.
 */
#define WARN(...) {                                               \
        (void)fprintf(stderr, "WARNING: %s:%d:%s(): ",            \
                      basename(__FILE__), __LINE__, __func__);    \
        (void)fprintf(stderr, __VA_ARGS__);                       \
        (void)fputs(".\n", stderr);                               \
    }
#define WARN_IF(C,...) if(C) WARN(__VA_ARGS__)
#define WARN_UNLESS(C,...) if(!(C)) WARN(__VA_ARGS__)

#endif /* DIE_H */
