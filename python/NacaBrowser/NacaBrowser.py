#!/usr/bin/env python

import os
import sys
import inspect

from PySide import QtUiTools
from PySide import QtGui
from PySide import QtCore

import numpy as np
import scipy.interpolate as si
import matplotlib.transforms as trx
import matplotlib.patches as patches
import matplotlib.lines as lines
import matplotlib.offsetbox as boxes

# Include library directory on Python module search path if it's
# included with this script:
lib_dir = os.path.realpath(os.path.join(os.path.split(
            inspect.getfile(inspect.currentframe()))[0], 'lib'))
if os.path.isdir(lib_dir) and lib_dir not in sys.path:
    sys.path.insert(0, lib_dir)

import NbMainWindow
import aero.naca as naca


# Monkey patch to make this work with PySide rather than PyQt4
def MainWindow():
    win = QtGui.QMainWindow()
    ui  = NbMainWindow.Ui_MainWindow()
    ui._win = win
    ui.show = win.show
    ui.setupUi(win)
    return ui


class Airfoil(object):
    N_POINTS = 100
    def __init__(self):
        super(Airfoil,self).__init__()
        self._designLift      = None
        self._maxCamberAmt    = None
        self._hasReflexCamber = None
        self._maxCamberLoc    = None
        self._maxThickness    = None
        self._artists         = []
        self._ndigits         = 0

    def setNumDigits(self, value):
        if 4 <= value <= 5:
            self._ndigits = value
        else:
            raise ValueError("Only 4 & 5 digit NACA profiles supported.")

    def getNumDigits(self):
        return self._ndigits

    def getNacaString(self):
        if self._ndigits == 4:
            naca = "%d%d%02d" % (self._maxCamberAmt, self._maxCamberLoc, self._maxThickness)
        elif self._ndigits == 5:
            naca = "%d%d%f%02d" % (self._designLift, self._maxCamberLoc, bool(self._hasReflexCamber), self._maxThickness)
        else:
            raise RuntimeError("NACA number of digits not set")
        return naca

    def getBoundRadius(self):
        return np.max(abs(self.getPoints()))

    def _addArtist(self, axes, artist):
        axes.add_artist(artist)
        self._artists.append(artist)


    def draw_measure_lines(self, axes):
        axes.add_artist( lines.Line2D((-0.15,-0.05), (0,0), color='black') )
        axes.add_artist( lines.Line2D((0,0), (-0.45,-0.55), color='black') )


    def draw(self, axes):
        profile = self.getNacaString()
        x,y,cx,cy = naca.naca(profile, Airfoil.N_POINTS, False, True)
        xy = np.vstack((x,y)).transpose()

        while self._artists:
            a = self._artists.pop()
            if a in axes.get_children():
                a.remove()

        color = "green" if naca.isCanonical(profile)    \
            else "orange" if naca.isReasonable(profile) \
            else "red"

        # Foil solid:
        self._addArtist(axes, patches.Polygon(xy, color=color, alpha=0.50, zorder=4))
        # Foil camber line:
        self._addArtist(axes, lines.Line2D(cx, cy, color=color, zorder=5))

        mult = 5 if len(profile)==5 else 10

        # Max camber position:
        loc = 0.01 * float(self._maxCamberLoc * mult)
        self._addArtist(axes, lines.Line2D((loc,loc), (-0.55,0.55), color='black', alpha=0.4, zorder=2))
        self._addArtist(axes, lines.Line2D((0,loc), (-0.5,-0.5), color='black'))


        # Max camber amount:
        if( len(profile)==4 ):
            amt = 0.01 * self._maxCamberAmt
            y = si.interp1d(cx, cy)(loc)
            self._addArtist(axes, lines.Line2D((-0.15,1.15), (y,y), color='black', alpha=0.4, zorder=2))
            self._addArtist(axes, lines.Line2D((-0.1,-0.1), (0,y), color='black'))

        if naca.isCanonical(profile):
            data  = naca.nacaImage(profile)
            bbox  = axes.bbox.extents
            x = bbox[2]-data.shape[1]
            y = bbox[3]-data.shape[0]
            imbox = boxes.AnnotationBbox(boxes.OffsetImage(data), (x,y), xycoords='axes pixels')
            imbox.set_zorder(10)
#            imbox.set_offset((x,y))
            self._addArtist(axes, imbox)


    def setHasReflexCamber(self, value):
        self._hasReflexCamber = bool(value)

    def setDesignLift(self, value):
        self._designLift = value

    def setMaxCamberAmt(self, value):
        self._maxCamberAmt = value

    def setMaxCamberLoc(self, value):
        self._maxCamberLoc = value

    def setMaxThickness(self, value):
        self._maxThickness = value



class Controller(object):
    def __init__(self, airfoil, window):
        super(Controller,self).__init__()
        self._foil = airfoil
        self._win = window
        self._patch = None

        self.setAxisLimits()
        self.initializeAirfoilFromWindow()
        self.routeSpinnerSignals()
        self._foil.draw_measure_lines(self._win.mplWidget.getAxes())
        self.update()
        

    def setAxisLimits(self):
        self._win.mplWidget.axis(-0.2, 1.2, -0.6, 0.6)
        self._win.mplWidget.redraw()


    def update(self):
        self._foil.draw(self._win.mplWidget.getAxes())
        self._win.mplWidget.redraw()


    def setNacaType(self, index=0):
        # Actually use last digit of combobox label:
        tooltip = "Max. camber location in multiples of {}% of chord"
        value = int(self._win.nacaType.currentText()[-1])
        if value==4:
            self._win.hasReflexCamber.hide()
            self._win.designLift.hide()
            self._win.maxCamberAmt.show()
            self._win.maxCamberLoc.setToolTip(tooltip.format(10))
        elif value==5:
            self._win.maxCamberAmt.hide()
            self._win.hasReflexCamber.show()
            self._win.designLift.show()
            self._win.maxCamberLoc.setToolTip(tooltip.format(5))
        self._foil.setNumDigits(value)


    def setDesignLift(self, value):
        self._foil.setDesignLift(value)
        self.update()


    def setHasReflexCamber(self, value):
        self._foil.setHasReflexCamber(bool(value))
        self.update()


    def setMaxCamberAmt(self, value):
        self._foil.setMaxCamberAmt(value)
        self.update()


    def setMaxCamberLoc(self, value):
        self._foil.setMaxCamberLoc(value)
        self.update()


    def setMaxThickness(self, value):
        self._foil.setMaxThickness(value)
        if value > 9:
            self._win.maxThickness.setPrefix('')
        else:
            self._win.maxThickness.setPrefix('0')
        self.update()


    def routeSpinnerSignals(self):
        self._win.nacaType.currentIndexChanged.connect(self.setNacaType)
        self._win.designLift.valueChanged.connect(self.setDesignLift)
        self._win.hasReflexCamber.valueChanged.connect(self.setHasReflexCamber)
        self._win.maxCamberAmt.valueChanged.connect(self.setMaxCamberAmt)
        self._win.maxCamberLoc.valueChanged.connect(self.setMaxCamberLoc)
        self._win.maxThickness.valueChanged.connect(self.setMaxThickness)

    def initializeAirfoilFromWindow(self):
        self.setNacaType()
        self._foil.setDesignLift(self._win.designLift.value())
        self._foil.setHasReflexCamber(bool(self._win.hasReflexCamber.value()))
        self._foil.setMaxCamberAmt(self._win.maxCamberAmt.value())
        self._foil.setMaxCamberLoc(self._win.maxCamberLoc.value())
        self._foil.setMaxThickness(self._win.maxThickness.value())


def main():
    app = QtGui.QApplication(sys.argv)
    win = MainWindow()
    bc  = Controller(Airfoil(), win)

    win.show()
    sys.exit( app.exec_() )

if __name__ == "__main__":
    main()
