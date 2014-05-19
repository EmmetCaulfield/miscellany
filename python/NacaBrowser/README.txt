"NacaBrowser" is a Python applet that allows you to browse NACA
4-digit airfoil shapes using spinners.

Run "NacaBrowser.py" with a Python interpreter (see "Python" below).


Description
===========

The brower has 3 spinners, the first is for the 1st digit, the 2nd for
the 2nd digit, and the 3rd for the last two digits, in line with the
semantics for the 4-digit NACA encoding:

    * Digit 1: Maximum camber as a percentage of chord length

    * Digit 2: Maximum camber location in tens of percents of chord
      length from the leading edge

    * Digit 3 & 4: Maximum thickness of the airfoil as a percentage of
      the chord length

Note that not all 9999 possible NACA 4-digit profiles are useful. For
example, a "9121" (9% camber, 10% from the leading edge, 21% thick)
looks more like a bottle-opener than an airfoil.


Python
======

I wrote this in Python because it was the path of least resistance for
me to write something portable.

It is known to work on Ubuntu 12.04 (Python 2.7 with PySide modules)
and Microsoft Windows 8.1 with Continuum Analytics's "Anaconda" Python
distribution, which is also available for Mac OS X.

See http://continuum.io/downloads

Note that if you have a slow machine (like my Windows desktop machine,
a 7 year-old Core 2 Duo running Windows 8.1), it may take several
seconds to start and not respond smoothly if you move the sliders
quickly.

It was originally written to use PyQt4, but then monkey patched to use
PySide because that is what "Anaconda" ships with. The code is not
pretty.
