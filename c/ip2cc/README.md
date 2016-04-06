ip2cc
=====

Introduction
------------

This isn't a complete package or a usable program. If you're not a
reasonably competent _C_ programmer working on _Linux_, you probably
won't want to bother with this.



History — Complete BST from Sorted List
----------------------------------------

A few years ago, for a completely different application, I thought of
the idea of populating a complete binary search tree (CBST) from a
sorted array. If you represent the BST as an array, doing index
calculations for “left” (`2*i+1`) and “right” (`2*i+2`) and the BST is
_complete_, it has the same number of elements as the input array.

The advantages are clear: no space wasted on `left` and `right`
pointers in each node, one `malloc()` for the whole CBST instead of
one per node at build time, and simple integer arithmetic on indices,
instead of pointer chasing when it's time to search. Nice.

But we need a way of mapping the index of the sorted input array to
the index in the CBST array, which is clearly feasible if you know the
total size of the input array (there's a uniqueness theorem for
CBSTs). In other words, given an ordered list of objects
_X=(x<sub>0</sub>, x<sub>1</sub>, ..., x<sub>i</sub>, ...,
x<sub>n-1</sub>)_, the CBST of_X_ is a particular and unique
permutation of _X_, _C=(c<sub>0</sub>, c<sub>1</sub>, ...,
c<sub>j</sub>, ..., c<sub>n-1</sub>)_, so we need a function that maps
every _x<sub>i</sub>_ to the corresponding _c<sub>j</sub>_:
_c<sub>j</sub>=f(x<sub>i</sub>)_

This turns out to be “surprisingly straightforward”, by which I mean
that I spent weeks trying to derive a general formula, but ultimately
settled on a simple “stateful simulating iterator” type solution.


The Current Problem
-------------------

If you run a webserver, or any other service accessible to the open
Internet, you'll notice the logs full of (what is euphemistically
called) “Internet background noise” — essentially, people trying to
find a way in to your machine.

These are rumored to originate mostly from China and Russia, so I
wanted an easy way of seeing where these were coming from (at
country-level granularity) with a view to just blocking tranches of IP
space. I wanted a little command-line utility that I could use in my
own shell scripts and whatnot, not something where I had to copy-paste
individual IP addresses into a browser or pay for some kind of
subscription service. In terms of analysis, it doesn't make a whole
lot of difference to me whether the results are 90% or 98% accurate.

A couple of different sites provide IP-to-ccTLD mapping data as CSV
files where each row represents an IP range (sometimes as min and max
IP addresses, sometimes as CIDR networks) and the corresponding
country. These typically have between, say, 125,000 and 250,000
records and they are always sorted in ascending order.


The Solution
------------

So, the old CBST idea and the current problem came together: hundreds
of thousands of immutable records, supplied in order, that I want to
search.

With little or no error-checking, the solution is hacky and fragile,
but adequate. It suffices to prove the “CBST from a sorted array”
concept, and to enable command-line lookups of ccTLDs from IPv4
addresses with commonly available databases.

Currently, the “stateful simulating iterator” index mapping function
is not, in fact, stateful (it would require a teensy bit more work)
and consequently much less efficient than it could be. But because the
CBST can be, and is, written to disk in binary form, the mapping
function runs so infrequently that there is very little incentive to
improve it.

The whole thing is pretty rudimentary. There are no options. Give it
one or more IP addresses and it should be fine, but anything else and
it will segfault. Do a `make ludost` (or `make maxmind`) to get a
database. Read the `Makefile` for URLs, etc.


Files
-----

  * `ip2cc.c` — the main executable, compiles to `ip2cc`
  * `ip-cbst.c`, `ip-cbst.h` — a complete binary search tree specialized for IPv4
  * `cbst.c`, `cbst.h` — complete binary search tree “library”
  * `Makefile` — builds the software and fetches the database files

