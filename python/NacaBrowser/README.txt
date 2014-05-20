"NacaBrowser" is a Python applet that allows you to browse NACA
4-digit airfoil shapes using spinners.

The UI suggests that NACA 5-digit airfoils[2] are supported, but this
is a work in progress and does not currently work.

From the zip file, simply run "NacaBrowser.py" with a Python
interpreter (see "Python" below).

If using the source from GitHub, you will need to append the 'lib'
directory (sibling of NacaBrowser directory) to PYTHONPATH.


Description
===========

The browser has 3 spinners, the first is for the 1st digit, the 2nd
for the 2nd digit, and the 3rd for the last two digits, in line with
the semantics for the 4-digit NACA encoding:

    * Digit 1: Maximum camber as a percentage of chord length

    * Digit 2: Maximum camber location in tens of percents of chord
      length from the leading edge

    * Digit 3 & 4: Maximum thickness of the airfoil as a percentage of
      the chord length

The camber location and amount are indicated by measure lines that
move as their corresponding spinners are changed.

There are 87 "canonical" NACA 4-digit airfoils [1]. When one of these
is selected, it is drawn in green and the profile from the original
1933 publication appears at top-right for comparison.

It is reasonable to suppose that other 4-digit descriptors within the
range covered by the canonical profiles will be reasonably
well-behaved. For example, if there are 9% and 12% thick NACA foils,
and there's no reason to believe that a 10% thick foil would be "bad",
all other things being equal. Accordingly, when a 4-digit descriptor
is within the "envelope" of the canonical profiles, it is drawn in
yellow.

All other profiles -- outside the envelope of the 87 canonical NACA
4-digit airfoils -- appear in red, including any thickness more than
25%, any camber location more than 70%, or any camber amount more than
6%. For example. a "9199" (9% camber, 10% from the leading edge, 99%
thick) looks more like a mitten than an airfoil.



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


References
==========

[1] Jacobs, Eastman N., Ward, Kenneth E., and Pinkerton, Robert
    M.: "The Characteristics of 78 Related Airfoil Sections From Tests
    in the Variable-Density Wind Tunnel"; NACA Report 537; National
    Advisory Committee for Aeronautics, Washington D.C.; November,
    1933.

[2] Jacobs, Eastman N., and Pinkerton, Robert M.: "Tests in the
    Variable-Density Wind Tunnel of Related Airfoils Having the
    Maximum Camber Unusually Far Forward"; NACA Report 537; National
    Advisory Committee for Aeronautics, Washington D.C.; November,
    1935.

[3] Ladson, Charles L., and Brooks, Cuyler W, Jr.: "Development of a
    Computer Program to Obtain Ordinates for NACA 4-Digit, 4-Digit
    Modified, 5-Digit, and 16-Series Airfoils"; NASA Technical
    Memorandum X-3284; NASA, Washington, DC; 1975.
