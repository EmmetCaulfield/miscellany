LFSR-based M-sequence Generator
===============================

This experimental code compares the runtimes of different ways of
XOR-ing the bits of the LFSR (linear feedback shift register) in an
m-sequence (maximum length binary sequence) generator.

This operation is equivalent to counting the set bits and taking the
LSB or computing the parity of the register. Unsurprisingly,
`__builtin_parity()` and `__builtin_popcount() & 1` win over the other
strategies.

Run:

    make
    ./simple n

Where `n` is a number between 1 and 32, the number of bits in the
M-sequence. The code has one “mask” constant (arbitrarily chosen where
more than one choice exists), representing the taps, for each number
of bits.


