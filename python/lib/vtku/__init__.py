#!/usr/bin/env python

import sys
import operator
from abc import ABCMeta, abstractmethod
import math
import vtk

def vtkIdList(it):
    """Makes a vtkIdList from a Python iterable"""
    vil = vtk.vtkIdList()
    for i in it:
        vil.InsertNextId(int(i))
    return vil


def vtkIntArray(it):
    """Makes a vtkIntArray from a Python iterable"""
    via = vtk.vtkIntArray()
    via.SetNumberOfTuples(len(it))
    for idx,val in enumerate(it):
        via.SetValue(idx, int(val))
    return via


def vtkDistance(p, q):
    return math.sqrt(sum([d*d for d in [a-b for a,b in zip(p,q)]]))


def _rotate(l,n):
    return l[n:] + l[:n]


def vtkAxisLook(camera, axis):
    pos  = camera.GetPosition()
    fp   = camera.GetFocalPoint()
    dist = vtkDistance(pos,fp)

    if axis==(1,0,0):
        if camera.GetDirectionOfProjection() == (0,0,-1):
            up  = (0,0,1)
            prj = (0,1,0)
        else:
            up  = (0,1,0)
            prj = (0,0,-1)
    elif axis==(0,1,0):
        if camera.GetDirectionOfProjection() == (0,0,1):
            up  = (0,0,1)
            prj = (-1,0,0)
        else:
            up  = (1,0,0)
            prj = (0,0,1)
    elif axis==(0,0,1):
        if camera.GetDirectionOfProjection() == (0,-1,0):
            up  = (0,1,0)
            prj = (1,0,0)
        else:
            up  = (1,0,0)
            prj = (0,-1,0)

    # Compute new camera position:
    newpos = [a-b for a,b in zip(fp, [dist*p for p in prj])]

    # Reposition the camera, maintaining distance:
    camera.SetPosition(newpos);

    # Set the view up vector. Depending on whether or not you are using
    camera.SetViewUp(up);


def vtkAxisMirror(camera, axis):
    sys.stderr.write("vtku.vtkAxisMirror() doesn't do what you think!\n")
    pos = [x*y for x,y in zip(camera.GetPosition(), [-p for p in camera.GetDirectionOfProjection()])]
    camera.SetPosition(pos)


def Gray(lum=0.5):
    return (lum, lum, lum)


class Palette(object):
    """
    This is an abstract base class for color palettes.

    The idea is to provide a flexible interface for looking up colors
    by name, index, or integer triple, and representing the palette as
    integer or floating-point triples.

    There is currently exactly one concrete subclass for named colors
    from X11's `rgb.txt` file, but it should be relatively easy to
    create new subclasses for other palettes.

    """

    __metaclass__ = ABCMeta     # This is an abstract base class (ABC)

    def __init__(self, alpha=1.0):
        self._records = []      # A list of (R,G,B) triples and names, ordered by RGB value
        self._rgb     = {}      # Indices and names of colors, indexed by (R,G,B)
        self._name    = {}      # Indices and (R,G,B) triple
        self._vtk_lut = None    # This palette as a vtkLookupTable
        self._initialize()      # Initialize above data structures somehow (abstract method)
        self._alpha   = alpha   # Default transparency

    @abstractmethod
    def _initialize(self):
        """Subclasses override this abstract method to initialize the
        palette's data structures from a subclass-dependent source"""
        pass


    @staticmethod
    def _floatify(triple):
        """Turns an integer triple on [0,255] to a floating-point triple on [0,1]"""
        return (triple[0]/255.0, triple[1]/255.0, triple[2]/255.0)


    def dump_by_rgb(self):
        """Dumps rgb triples, names, and indices sorted by RGB triple"""
        for rgb in sorted(self._rgb):
            index = self._rgb[rgb]
            name  = self._records[index][1]
            print rgb, name, index


    def dump_by_name(self):
        """Dumps names, rgb triples, and indices sorted by name"""
        for name in sorted(self._name):
            index = self._name[name]
            rgb   = self._records[index][0]
            print name, rgb, index


    def getIndex(self, q):
        """Returns an integer index given a name or RGB triple"""
        if q in self._name:
            return self._name[q]
        if q in self._rgb:
            return self._rgb[q]
        return None


    def getName(self, q):
        """Returns a color name given an index or RGB triple"""
        index = None
        try:
            index = int(q)
        except ValueError:
            if q in self._rgb:
                index=self._rgb[q]
        if index is None:
            return None
        if 0 <= index < len(self._records):
            return self._records[index][1]
        return None


    def getIntegerTriple(self, q):
        """Returns an integer RGB triple given an index or a color name"""
        index = None
        try:
            index = int(q)
        except ValueError:
            if q in self._name:
                index=self._name[q]
        if index is None:
            return None
        if 0 <= index < len(self._records):
            return self._records[index][0]
        return None


    def getFloatTriple(self, q):
        """Returns a floating-point RGB triple given an index or color name"""
        return Palette._floatify( self.getIntegerTriple(q) )


    def get24bitConstant(self, q):
        """Returns a 24-bit integer constant given an index or color name"""
        return int("%02x%02x%02x" % self.getIntegerTriple(q), 16)


    def getHexString(self, q):
        """Returns a 24-bit integer constant as a hexadecimal string given an index or color name"""
        return hex(self.get24bitConstant(q))


    def getHtmlString(self, q):
        """Returns a hex color string in HTML/CSS form given an index or color name"""
        return '#' + self.getHexString(q)[2:]


    def asRgbNamePairs(self):
        """Returns the entire palette as ((R,G,B),name) pairs"""
        return self._records


    def asInts(self):
        """Returns the entire palette as integer (R,G,B) triples"""
        return [x[0] for x in self._records]


    def asFloats(self):
        """Returns the entire palette as floating-point (R,G,B) triples"""
        return [Palette._floatify(x) for x in self.asInts()]


    def asVtkLookupTable(self, alpha=None):
        """Returns the entire palette as a VtkLookupTable"""
        if self._vtk_lut is not None:
            return self._vtk_lut

        colors = self.asFloats()
        self._vtk_lut = vtk.vtkLookupTable()
        self._vtk_lut.SetNumberOfTableValues(len(colors))
        self._vtk_lut.Build()

        if alpha is None:
            alpha=self._alpha

        for i,rgb in enumerate(colors):
            self._vtk_lut.SetTableValue(i, rgb[0], rgb[1], rgb[2], alpha)

        return self._vtk_lut


class X11Palette(Palette):
    """
    Creates a palette based on the local X11 `rgb.txt` file.

    Upper camel case name syntax is adopted as the canonical form for
    color names. The alternative form with spaces in the name is not
    supported. Color names are case sensitive.

    Each color, identified by an integer RGB triple over [0,255], from
    `rgb.txt` will appear exactly once with the first name
    provided. The name will be converted to upper camel case if
    necessary. Subsequent appearances of the same triple are
    ignored. Thus there are no name aliases for color triples. This
    preserves the 1:1 mapping between names and colors. 

    X11's `rgb.txt` allows aliases for color triples. The
    correspondence between upper camel case names (converted from
    lowercase-with-spaces form here) and color triples may not be
    preserved if there is an error in the `rgb.txt` file.

    """
    def __init__(self):
        super(X11Palette,self).__init__()


    def _initialize(self):
        """Loads colors from the local X11 `rgb.txt` file."""
        with open('/etc/X11/rgb.txt', 'r') as f:
            f.readline()        # Discard bang line
            rgb_to_name = {}
            for line in f:
                rgb_name = line.split(None)
                rgb = (int(rgb_name[0]), int(rgb_name[1]), int(rgb_name[2]))
                name = ''.join( [s[0].upper()+s[1:] for s in rgb_name[3:]] )
                if rgb in rgb_to_name:
                    next
                else:
                    rgb_to_name[rgb]  = name 

        index=0
        for rgb,name in sorted(rgb_to_name.iteritems(), key=operator.itemgetter(0)):
            self._records.append( (rgb,name) )
            self._rgb[rgb]   = index
            self._name[name] = index
            index += 1
