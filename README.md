miscellany
==========

A semi-organized collection of miscellaneous software.


Overview
--------

A random collection of *Python*, *Java*, *C*, *Matlab*, (mostly)
*awk*, *Bash*, and *GNU Make* software. Hightlights include:

  * [WindShearProfile](java/WindShearProfile) — a Java 8 applet demonstrating
    log-law wind shear in the Earth's boundary layer.
  * [BladeTwist](python/BladeTwist) — a Python “applet” demonstrating
    twist of wind turbine blades.
  * [NacaBrowser](python/NacaBrowser) — a Python “applet” that
    displays arbitrary 4-digit NACA airfoil sections.
  * [Miscellaneous simple Python libraries](python/lib/) including
    [vtku](python/lib/vtku/), a python utility module that eases some
    Python/VTK annoyances.
  * [mseq](c/mseq/), a rudimentary m-sequence generator in *C* (a work
    in-progress).
  * [occuCalc](matlab/cudaUtils/), a CUDA occupancy calculator in *Matlab*.
  * [make](make/), *GNU Make* development templates for C, C++, and
    CUDA.
  * [fndump](awk/fndump), invokes `objdump` and annotates the left
    side of the x86 ASM output with arcs showing jumps.
  * [cufndump](awk/cufndump), invokes the CUDA `cuobjdump` and annotates
    the left side of the PTX output with arcs depicting jumps.
  * [perf2csv](shell/perf2csv), attempts to convert a
    [perf](https://perf.wiki.kernel.org/index.php/Main_Page) data file
    to CSV as completely as possible.

[Bitbucket](https://bitbucket.org/) handles links badly; for these
links to work, start [here](src/master/).
