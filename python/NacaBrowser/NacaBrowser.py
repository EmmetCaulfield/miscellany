#!/usr/bin/env python

import os
import sys
sys.path.append('../lib')
from PySide import QtUiTools
from PySide import QtGui
from PySide import QtCore
import NbMainWindow

import matplotlib.transforms as trx
import matplotlib.patches as patches
import matplotlib.lines as lines

import numpy as np

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
        self._firstDigit   = None
        self._maxCamberLoc = None
        self._maxThickness = None
        self._artists      = []
        self._ndigits      = 0

    def setNumDigits(self, value):
        if 4 <= value <= 5:
            self._ndigits = value
        else:
            raise ValueError("Only 4 & 5 digit NACA profiles supported.")

    def getNumDigits(self):
        return self._ndigits

    def getNacaString(self):
        if self._ndigits == 4:
            naca = "%d%d%02d" % (self._firstDigit, self._maxCamberLoc, self._maxThickness)
        elif self._ndigits == 5:
            naca = "%d%02d%02d" % (self._firstDigit, self._maxCamberLoc, self._maxThickness)
        else:
            raise RuntimeError("NACA number of digits not set")
        return naca

    def getBoundRadius(self):
        return np.max(abs(self.getPoints()))

    def draw(self, axes):
        profile = self.getNacaString()
        x,y,cx,cy = naca.naca(profile, Airfoil.N_POINTS)
        xy = np.vstack((1.0-x,y)).transpose()

        while self._artists:
            a = self._artists.pop()
            if a in axes.get_children():
                a.remove()

        color = "green" if naca.isCanonical(profile) else "red"
        a = patches.Polygon(xy, color=color, alpha=0.50, zorder=4)
        axes.add_artist(a)
        self._artists.append(a)
        a = lines.Line2D(1.0-cx, cy, color=color, zorder=5)
        axes.add_artist(a)
        self._artists.append(a)

    def setFirstDigit(self, value):
        '''
        The semantics of the first digit are dependent on whether the
        NACA profile is 4 or 5 digits, so a more meaningful name is
        not possible.
        '''
        self._firstDigit = value

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

        self.initializeAirfoilFromWindow()
        self.routeSpinnerSignals()
        self.setAxisLimits()
        self.update()


    def setAxisLimits(self):
        self._win.mplWidget.axis(-0.2, 1.2, -0.6, 0.6) 

    def update(self):
        self._foil.draw(self._win.mplWidget.getAxes())
        self._win.mplWidget.redraw()

    def setNacaType(self, value):
        value += 4                       # We get the spinbox index
        qsb = self._win.maxCamberLoc     # QSpinBox
        cur = qsb.value()                # Current value
        self._foil.setNumDigits(value)
        if value==4:
            cur = int(min(round(float(cur)/20.0),9))
            qsb.setValue(cur)
            qsb.setMaximum(9)
        elif value==5:
            cur = min(20*cur, 99)
            qsb.setMaximum(99)
            qsb.setValue(cur)

    def setFirstDigit(self, value):
        self._foil.setFirstDigit(value)
        self.update()

    def setMaxCamberLoc(self, value):
        self._foil.setMaxCamberLoc(value)
        if value < 9 and self._foil.getNumDigits()==5:
            self._win.maxCamberLoc.setPrefix('0')
        else:
            self._win.maxCamberLoc.setPrefix('')
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
        self._win.firstDigit.valueChanged.connect(self.setFirstDigit)
        self._win.maxCamberLoc.valueChanged.connect(self.setMaxCamberLoc)
        self._win.maxThickness.valueChanged.connect(self.setMaxThickness)

    def initializeAirfoilFromWindow(self):
        self._foil.setNumDigits(int(self._win.nacaType.currentText()[-1]))
        self._foil.setFirstDigit(self._win.firstDigit.value())
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
