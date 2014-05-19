NAME=NacaBrowser
LIBFILES=../MplWidget.py ../aero/naca.py
DISTFILES=$(NAME).py README.txt NbMainWindow.py

default: NbMainWindow.py

zip: $(NAME).zip

#btmainwindow.py: bladetwist.ui
#	pyside-uic $< | sed '/^from PySide/a from BtWidgets import MplWidget' | head -n-1 >$@

%.py: %.ui
	pyside-uic $< > $@

$(NAME).zip: $(DISTFILES)
	mkdir $(NAME)
	cp $(DISTFILES) $(NAME)
	zip -r $@ $(NAME)
	rm -rf $(NAME)

clean:
	rm -f *~ *.pyc NbMainWindow.py $(NAME).zip
	rm -rf $(NAME)
