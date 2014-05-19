"BladeTwist" is a Python applet that illustrates the twist of a wind
turbine blade. 

Run "bladetwist.py" with a Python interpreter (see "Python" below).

This is not a simulator: it is intended to let you "play" with the
functional relationships between different parameters by allowing you
to vary them without realism. Accordingly, you can have tip-speeds of
MACH-2 or a TSR of 20 for a 100m blade.


Description
===========

The incoming "true" wind, shown by a green line, is blowing "up" the
page.

The frame of reference is attached to the blade, looking toward the
hub, with the nacelle above the blade on the display.

The induced/rotational wind, shown by a blue line, comes from the
right of the display (i.e., the rotor turns clockwise).

The apparent wind, shown by a black line, is the vector sum of the
true and induced winds.

The pink shape represents a cross-section through the blade. There is
no attempt at representing this to scale.

Varying the rightmost, "d(m)" (distance of cross-section from rotor
axis), slider demonstrates how the induced/rotational wind increases
as we move out along the blade, and how the speed and direction of the
apparent wind changes accordingly.

The airfoil rotates to maintain a constant angle-of-attack (which you
can vary with the 3rd slider, labeled "alpha (degrees)") to the
apparent wind.

The wind speed can be changed with the 4th slider, labeled "v (m/s)"

The blade length can be changed with the 1st slider, labeled “l (m)”.

You can change the tip-speed ratio with the 2nd slider, labeled
"TSR".

Hovering the mouse over the sliders will show a tool-tip to remind you
of the meanings.


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
