# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'NbMainWindow.ui'
#
# Created: Mon May 19 08:12:16 2014
#      by: pyside-uic 0.2.13 running on PySide 1.1.0
#
# WARNING! All changes made in this file will be lost!

from PySide import QtCore, QtGui

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtGui.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.verticalLayout = QtGui.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.mplWidget = MplWidget(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mplWidget.sizePolicy().hasHeightForWidth())
        self.mplWidget.setSizePolicy(sizePolicy)
        self.mplWidget.setObjectName("mplWidget")
        self.verticalLayout.addWidget(self.mplWidget)
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        spacerItem = QtGui.QSpacerItem(40, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.nacaType = QtGui.QComboBox(self.centralwidget)
        self.nacaType.setMaxVisibleItems(2)
        self.nacaType.setObjectName("nacaType")
        self.nacaType.addItem("")
        self.nacaType.addItem("")
        self.horizontalLayout.addWidget(self.nacaType)
        self.firstDigit = QtGui.QSpinBox(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.firstDigit.sizePolicy().hasHeightForWidth())
        self.firstDigit.setSizePolicy(sizePolicy)
        self.firstDigit.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.firstDigit.setMaximum(9)
        self.firstDigit.setProperty("value", 2)
        self.firstDigit.setObjectName("firstDigit")
        self.horizontalLayout.addWidget(self.firstDigit)
        self.maxCamberLoc = QtGui.QSpinBox(self.centralwidget)
        self.maxCamberLoc.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.maxCamberLoc.setMaximum(9)
        self.maxCamberLoc.setProperty("value", 2)
        self.maxCamberLoc.setObjectName("maxCamberLoc")
        self.horizontalLayout.addWidget(self.maxCamberLoc)
        self.maxThickness = QtGui.QSpinBox(self.centralwidget)
        self.maxThickness.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.maxThickness.setSuffix("")
        self.maxThickness.setPrefix("")
        self.maxThickness.setMinimum(1)
        self.maxThickness.setProperty("value", 21)
        self.maxThickness.setObjectName("maxThickness")
        self.horizontalLayout.addWidget(self.maxThickness)
        spacerItem1 = QtGui.QSpacerItem(40, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem1)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.gridLayout.addLayout(self.verticalLayout, 0, 0, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtGui.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.actionQuit = QtGui.QAction(MainWindow)
        self.actionQuit.setObjectName("actionQuit")

        self.retranslateUi(MainWindow)
        self.nacaType.setCurrentIndex(0)
        QtCore.QObject.connect(self.actionQuit, QtCore.SIGNAL("triggered()"), MainWindow.close)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtGui.QApplication.translate("MainWindow", "NACA 4-Digit Profile Browser", None, QtGui.QApplication.UnicodeUTF8))
        self.nacaType.setToolTip(QtGui.QApplication.translate("MainWindow", "Choose 4 or 5 digit NACA profile", None, QtGui.QApplication.UnicodeUTF8))
        self.nacaType.setItemText(0, QtGui.QApplication.translate("MainWindow", "NACA 4", None, QtGui.QApplication.UnicodeUTF8))
        self.nacaType.setItemText(1, QtGui.QApplication.translate("MainWindow", "NACA 5", None, QtGui.QApplication.UnicodeUTF8))
        self.firstDigit.setToolTip(QtGui.QApplication.translate("MainWindow", "Maximum camber as percentage of chord.", None, QtGui.QApplication.UnicodeUTF8))
        self.maxCamberLoc.setToolTip(QtGui.QApplication.translate("MainWindow", "Maximum camber location", None, QtGui.QApplication.UnicodeUTF8))
        self.maxThickness.setToolTip(QtGui.QApplication.translate("MainWindow", "Maximum thickness", None, QtGui.QApplication.UnicodeUTF8))
        self.actionQuit.setText(QtGui.QApplication.translate("MainWindow", "&Quit", None, QtGui.QApplication.UnicodeUTF8))
        self.actionQuit.setToolTip(QtGui.QApplication.translate("MainWindow", "Quit", None, QtGui.QApplication.UnicodeUTF8))
        self.actionQuit.setShortcut(QtGui.QApplication.translate("MainWindow", "Ctrl+Q", None, QtGui.QApplication.UnicodeUTF8))

from qt4ui.MplWidget import MplWidget
