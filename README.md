miscellany
==========

A semi-organized collection of miscellaneous software, both trivial
and interesting.

[Bitbucket](https://bitbucket.org/)'s link handling is broken. You
probably want to start
[here](https://bitbucket.org/emmetac/miscellany/src/master/).


Overview
--------

### By Predominant Language ###

Languages include:

  * [*AWK*](awk/), the classic _Unix_ utility, by [**A**ho](https://en.wikipedia.org/wiki/Alfred_Aho), [**W**einberger](https://en.wikipedia.org/wiki/Peter_J._Weinberger), and [**K**ernighan](https://en.wikipedia.org/wiki/Brian_Kernighan)
  * [*C*](c/)
  * [*flex*](flex/), the [lexical analyzer generator](http://flex.sourceforge.net/), not the [_Adobe_ thing](http://www.adobe.com/products/flex.html).
  * [*Java*](java/)
  * [*GNU Make*](make/)
  * [*MATLAB*](matlab/) and/or [GNU Octave](http://www.gnu.org/software/octave/)
  * [*Python*](python/)
  * [*R*](R/), the statistics language
  * [*sed*](sed/), the classic _Unix_ stream editor
  * [*Bash*](shell/), the shell

### By Topic ###

#### Wind Energy ####

  * [WindShearProfile](java/WindShearProfile) — a Java 8 applet demonstrating
    log-law wind shear in the Earth's boundary layer.
  * [BladeTwist](python/BladeTwist) — a Python “applet” demonstrating
    twist of wind turbine blades.
  * [NacaBrowser](python/NacaBrowser) — a Python “applet” that
    displays arbitrary 4-digit NACA airfoil sections.

#### Software Examples ####

  * [The Bison C++ Example with a C++ Flex Lexer](flex/bison-cxx-example/).
  * A nice little [sed script](sed/) to extract multi-line tag content.
  * An [IP to ccTLD converter](c/ip2cc/) that builds a [complete binary search tree](https://en.wikipedia.org/wiki/Binary_tree#Types_of_binary_trees) with no comparisons.
  * A [minimal perfect hashing function generator](c/phash/)
  * A [pseudo-random memory bandwidth measurement](c/prmembm) utility that uses the [M-sequence generator](c/mseq/) to measure temporal and energy bandwidth of random accesses to a power-of-two sized memory block.

#### Software Analysis ####

  * [MOPAL](awk/mopal/), a tool for producing dependency graphs by
    analyzing [GNU Octave](http://www.gnu.org/software/octave/)
    programs written like 2-register assembly language.
  * [fndump](awk/fndump), invokes `objdump` and annotates the left
    side of the x86 ASM output with arcs showing jumps.
  * [cufndump](awk/cufndump), invokes the CUDA `cuobjdump` and annotates
    the left side of the PTX/SASS output with arcs depicting jumps.
  * [perf2csv](shell/perf2csv), attempts to convert a
    [perf](https://perf.wiki.kernel.org/index.php/Main_Page) data file
    to CSV as completely as possible and largely succeeds unless the
    data was recorded with `-g` and includes callgraph information.

#### Software Libraries ####

  * [Miscellaneous simple Python libraries](python/lib/) including
    [vtku](python/lib/vtku/), a python utility module that eases some
    Python/VTK annoyances.
  * [mseq](c/mseq/), a rudimentary m-sequence generator in *C* (a work
    in-progress).
  * [make](make/), *GNU Make* development templates for C, C++, and
    CUDA.

#### Software Development Utilities ####

  * [occuCalc](matlab/cudaUtils/), a CUDA occupancy calculator in
    _MATLAB_ that is more a transliteration and explanation of
    Nvidia's spreadsheet than a program that merely “does what it says
    on the tin”.
  * [occuPlots](matlab/cudaUtils/) — a demonstration of `occuCalc.m`
    that generates (more or less) the same plots as found in Nvidia's
    *CUDA Occupancy Calculator* spreadsheet for one set of (fairly
    arbitrary input) values. **Not verified to work with Matlab; works
    with Octave**.
