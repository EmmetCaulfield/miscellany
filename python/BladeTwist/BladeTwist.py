#!/usr/bin/env python

import os
import sys
import inspect

from PySide import QtUiTools
from PySide import QtGui
from PySide import QtCore
import BtMainWindow

import matplotlib.transforms as trx
import matplotlib.patches as patches
import matplotlib.lines as lines

import numpy as np

# Include library directory on Python module search path if it's
# included with this script:
lib_dir = os.path.realpath(os.path.join(os.path.split(
            inspect.getfile(inspect.currentframe()))[0], 'lib'))
if os.path.isdir(lib_dir) and lib_dir not in sys.path:
    sys.path.insert(0, lib_dir)

import aero.naca as naca

MACH1=340

# Monkey patch to make this work with PySide rather than PyQt4
def MainWindow():
    win = QtGui.QMainWindow()
    ui  = BtMainWindow.Ui_MainWindow()
    ui._win = win
    ui.show = win.show
    ui.setupUi(win)
    return ui



class SliderProxy(object):
    def __init__(self, win, name, callback):
        super(SliderProxy,self).__init__()
        self._slider   = eval( 'win.'+name+'Slider' )
        self._value    = eval( 'win.'+name+'Value' )
        self._label    = eval( 'win.'+name+'Label' )
        self._callback = callback
#        QtCore.QObject.connect(self._slider, QtCore.SIGNAL('valueChanged(int)'), self._connect)
        self._slider.valueChanged.connect( self._connect )

    def _connect(self, value):
        flt = float(value)/10.0
        self._value.setText( "%0.1f" % flt )
        self._callback(flt)

    def setValue(self, value):
        intValue = int(np.round(10.0*value))
        strValue = str(intValue)[:-1]+'.'+str(intValue)[-1]
        self._slider.setValue( intValue )
        self._value.setText(strValue)
        
    def maximum(self):
        return float(self._slider.maximum())/10.0

    def setMaximum(self, value):
        self._slider.setMaximum(int(np.ceil(10.0*value)))



class Blade(object):
    def __init__(self,
                 naca_profile="4721",   # 4 digits as a string
                 tip_speed_ratio=6.0,   # 2-20
                 overall_length=54.0,   # In meters, current record is 82m
                 angle_of_attack=10.0,  # A few degrees, no more than 20, probably
                 chord_length=3.0,      # Base chord length in meters
                 hub_radius=2.0,        # In meters
                 dead_length=0):        # Cylindrical length of blade near hub (m)
        super(Blade,self).__init__()
        self.setNacaProfile( naca_profile )
        self._tsr         = tip_speed_ratio
        self._length      = overall_length
        self._alpha       = angle_of_attack
        self._chord       = chord_length
        self._hub         = hub_radius
        self._dead_length = dead_length
        self._scale       = 1.0/chord_length


    def setNacaProfile(self, naca4str):
        self._profile = naca4str
        x,y,xc,yc = naca.naca(naca4str, 60)
        ctr = [np.average(x, weights=abs(y)), 0]
        x = ctr[0]-x
        self._points = (x,y)

    def getSection(self, distance=0):
        return self._points

    def getBoundRadius(self):
        x,y=self._points
        return max(np.max(x), np.max(y))

    def getNacaProfile(self):
        return self._profile

    def setAngleOfAttack(self, aoa):
        self._alpha = aoa

    def getAngleOfAttack(self):
        return self._alpha

    def setBaseChordLength(self, bcl):
        self._chord = bcl 

    def getBaseChordLength(self):
        return self._chord

    def setHubRadius(self, hr):
        self._hub = hr

    def getHubRadius(self):
        return self._hub

    def setDeadLength(self, dl):
        self._dead_length = dl 

    def getDeadLength(self):
        return self._dead_length

    def setLength(self, dl):
        self._length = dl 

    def getLength(self):
        return self._length

    def getDeadRadius(self):
        return self._hub + self._dead_length

    def setTsr(self, tsr):
        self._tsr = tsr

    def getTsr(self):
        return self._tsr


class WindArrow(object):
    def __init__(self, ax, nock, tip, color='blue', width=3):
        self._ax   = ax
        self._line = lines.Line2D((nock[0], tip[0]), (nock[1], tip[1]))
        self._line.set_color(color)
        self._line.set_linewidth(width)
        ax.add_line(self._line)

    def moveNock(self, nock):
        x = list(self._line.get_xdata())
        y = list(self._line.get_ydata())
        x[0] = nock[0]
        y[0] = nock[1]
        self._line.set_data(x,y)



class BladeController(object):
    def __init__(self, blade, window, wind_speed=11.5):
        super(BladeController,self).__init__()
        self._blade    = blade
        self._bladeAngle = 0.0
        self._bladeScale = 0.0
        self._win      = window
        self._trueWind = wind_speed
        self._distance = 0.0
        self.drawWindVectors()
        x,y = blade.getSection()
        self._win.mplWidget.set_xlabel('Induced/Rotational Wind (m/s)')
        self._win.mplWidget.set_ylabel('True Wind (m/s)')        
        self._mplPolygon = patches.Polygon(zip(x,y), color="red", alpha=0.50, zorder=4)
        self._win.mplWidget.add_patch(self._mplPolygon)
        self._win.mplWidget.plot(0,0, 'or')
        self.routeSliderSignals()
        self.setSliderValues()

    #1
    def setWindspeed(self, ws):
        self._trueWind = ws
        self.update()

    def getWindspeed(self):
        return self._trueWind

    def getMaxWindspeed(self):
        return min(self.windSlider.maximum() * self.getTsr(), MACH1)

    def getInducedWind(self):
        tipSpeed = self.getTsr() * self.getWindspeed()
        return -tipSpeed * self.getDistance() / self.getLength()

    def getApparentWindVector(self):
        return (self.getInducedWind(), self.getWindspeed())


    #2
    def setLength(self, length):
        self._blade.setLength(length)
        self._blade.setDeadLength(0.05*length)
        self.distanceSlider.setMaximum(length)

    def getLength(self):
        return self._blade.getLength()

    
    #3 FIXME
    def setTsr(self, tsr):
        self._blade.setTsr(tsr)
        self.updateWindVectors()
        self.update()

    def getTsr(self):
        return self._blade.getTsr()

    def drawBlade(self):
        angle = self.getAlpha() + self.getWindAngle()
        scale = self.getBladeScale()

        ax = self._win.mplWidget.getAxes()
        trans = trx.Affine2D().scale(scale).rotate_deg(angle) \
            + ax.transData
        self._mplPolygon.set_transform(trans)

    #4
    def setAlpha(self, alpha):
        self._blade.setAngleOfAttack(alpha)
        self.update()
    
    def setBladeScale(self, factor=0.5):
        self._bladeScale = factor * self.getMaxWindspeed()
        bound = int(np.ceil(self._bladeScale * self._blade.getBoundRadius()))
        return bound

    def getBladeScale(self):
        return self._bladeScale

    def getAlpha(self):
        return self._blade.getAngleOfAttack()

    #5
    def setDistance(self, dist):
        self._distance = dist
        self.updateWindVectors()
        self.update()
 
    def getDistance(self):
        return self._distance
        

    def getWindAngle(self):
        x, y = self.getApparentWindVector()
        try:
            return np.rad2deg(np.arctan(float(y)/float(x)))
        except:
            return -90.0

    def drawWindVectors(self):
        ax = self._win.mplWidget.getAxes()
        x, y = self.getApparentWindVector()
        self._apparentWindArrow = WindArrow(ax, (-x, -y), (0,0), 'black')
        self._inducedWindArrow  = WindArrow(ax, (-x, 0), (0,0), 'blue')
        self._trueWindArrow     = WindArrow(ax, (0, -y), (0,0), 'green')


    def updateWindVectors(self):
        try:
            x, y = self.getApparentWindVector()
            self._trueWindArrow.moveNock( (0, -y) )
            self._inducedWindArrow.moveNock( (-x, 0) )
            self._apparentWindArrow.moveNock( (-x, -y) )
        except:
            pass


    def update(self):
        self.updateWindVectors()
        radius = self.setBladeScale()
        self.drawBlade()

        curMax  = int(np.ceil(1.05*self.getMaxWindspeed()))
        xmin = -int(1.5*radius)
        xmax = curMax
        ymin = -curMax
        ymax = radius

        self._win.mplWidget.axis(xmin, xmax, ymin, ymax)
        self._win.mplWidget.redraw()


    def routeSliderSignals(self):
        self.distanceSlider = SliderProxy(self._win, "distance", self.setDistance)
        self.tsrSlider      = SliderProxy(self._win, "tsr",      self.setTsr)
        self.alphaSlider    = SliderProxy(self._win, "alpha",    self.setAlpha)
        self.rotorSlider    = SliderProxy(self._win, "rotor",    self.setLength)
        self.windSlider     = SliderProxy(self._win, "wind",     self.setWindspeed)


    def setSliderValues(self):
        self.distanceSlider.setValue(self.getDistance())
        self.tsrSlider.setValue(self.getTsr())
        self.alphaSlider.setValue(self.getAlpha())
        self.rotorSlider.setValue(self.getLength())
        self.windSlider.setValue(self.getWindspeed())




def main():
    app = QtGui.QApplication(sys.argv)
    win = MainWindow()
    bc = BladeController(Blade(), win)

    win.show()
    sys.exit( app.exec_() )

if __name__ == "__main__":
    main()
