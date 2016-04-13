phash
=====

A minimal perfect hash generator.

This is essentially a reorganization and refactoring of
[Bob Jenkins's minimal perfect hash generator](http://burtleburtle.net/bob/hash/perfect.html),
which was originally written in 1996 and has suffered from a bit of
code-rot over the years.

After a bit of TLC, it now seems to work well for my 42k+ word list
(`test/words.lst`), and produces the output files, `phash.c` and
`phash.h` instantaneously. I have no idea if it works for the other
use-cases Bob envisaged as I have not tested it extensively.

I'm sure there's still much more that could be done to improve it, but
at least now it compiles cleanly and without emitting a bazillion
error and warning messages.


Main Changes
------------

The main changes are:

  * Modernizing function prototypes, adding `const` and `restrict`
    qualifiers to pointers in obvious cases.

  * Removing Bob's `standard.h` header file entirely, which mostly
    consisted of replacing all the references `ub4`, `ub2`, and `ub1`
    `typedef`s with the standard equivalents `uint32_t`, `uint16_t`
    and `uint8_t` (respectively); also replacing the mixed `printf()`
    format specifiers (`%d`, `%ld`, `%lu`, `%x`, `%lx`)
    with `PRIu32` or `PRIx32` as appropriate.

  * Inserting ordinary `#include` guards in header files and removing
    the (rather bizarre) former system from the _C_ files.

  * Inserting missing `#include`s of standard library headers.

  * Moving the test code into a new `test` directory

  * Rewriting the main and test `Makefile`s

  * Miscellaneous cruft removal and cleanup to ensure a clean compile
    without errors or warnings under `gcc -std=c99 -Wall -Wextra`

