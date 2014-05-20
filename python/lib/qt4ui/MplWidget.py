import matplotlib
matplotlib.use('Qt4Agg')
matplotlib.rcParams['backend.qt4']='PySide'
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure

class MplWidget(FigureCanvas):
    def __init__(self, parent=None):
        self._fig = Figure( (8,5), dpi=96 )
        super(MplWidget, self).__init__(self._fig)
        self.setParent(parent)
        self._fontspec = {
            'family' : 'sans-serif',
            'weight' : 'normal',
            'size'   : 11
        }
        matplotlib.rcParams.update({'figure.autolayout':True})
        matplotlib.rc('font', **self._fontspec)

        self._axes = self._fig.add_subplot('111')
        self._axes.grid(True, which='both', ls='-', color='0.75')
        self._axes.set_aspect('equal')


    def __getattr__(self, name):
        attr=None
        if name in dir(self._axes):
            attr = getattr(self._axes, name)
            if callable(attr):
                return attr

        if name in dir(self._fig):
            attr = getattr(self._fig, name)
            if callable(attr):
                return attr

        raise AttributeError(attr)


    def axis(self, xmin, xmax, ymin, ymax):
        self._axes.set_xlim((xmin, xmax))
        self._axes.set_ylim((ymin, ymax))

    def getAxes(self):
        return self._axes

    def redraw(self):
        return self._fig.canvas.draw()

#    def add_patch(self, *args, **kwargs):
#        return self._axes.add_patch(*args, **kwargs)

#    def plot(self, *args, **kwargs):
#        return self._axes.plot(*args, **kwargs)
        
