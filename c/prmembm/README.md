Pseudo-Random Memory Bandwidth Measurement
==========================================

This experimental code uses a LFSR-based (linear feedback shift
register) m-sequence (maximum length binary sequence) generator to
read every memory location in a memory block of size specified by a
small integer and report the time and energy used.

    make
    ./simple n

This will cause a block of size 2^n to be allocated, every byte read
in pseudo-random order. The difference between the start and end times
and energies in microjoules (using Intel RAPL counters) is used to
calculate and report the temporal bandwidth, in MB/s, the energy
bandwidth, in MB/J, and the ratio between the two.
