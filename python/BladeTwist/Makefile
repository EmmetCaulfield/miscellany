NAME=BladeTwist
DISTFILES=$(NAME).py README BtMainWindow.py

default: BtMainWindow.py

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
	rm -f *~ *.pyc BtMainWindow.py $(NAME).zip
	rm -rf $(NAME)
