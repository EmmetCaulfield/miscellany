Matrix-Oriented Pseudo Assembly Language
----------------------------------------

See subdirectory [mopal/](mopal/).


Disassembled Code Loop Annotation
----------------------------------

These two similar programs invoke disassemblers on object code files,
and then annotate the output with arcs identifying loops and jumps.

Both are shell scripts, written almost entirely in AWK.

  * [`cufndump`](cufndump) for _CUDA_ object code files, requiring `cuobjdump` (part of the CUDA Development Kit); and
  * [`fndump`](fndump) for _x86_ object code files, requiring `objdump` (part of _GNU_ binutils).

Sample output is provided in
[cufndump-CudaDeviceFunctions.txt](cufndump-CudaDeviceFunctions.txt)
and [fndump-loopmult.txt](fndump-loopmult.txt) respectively.

Search for `m_det` in [fndump-loopmult.txt](fndump-loopmult.txt), a
function that computes a determinant naively by Laplace's method with
recursion.
