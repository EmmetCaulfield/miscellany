NAME=BladeTwist
DISTFILES=$(NAME).py README.txt BtMainWindow.py

default: BtMainWindow.py

run: BladeTwist.py BtMainWindow.py
	PYTHONPATH=../lib python $<

zip: $(NAME).zip

$(NAME).zip: $(DISTFILES)
	mkdir $(NAME)
	cp $(DISTFILES) $(NAME)
	cp -r ../lib $(NAME)
	find ./$(NAME) -name '*.pyc' -exec rm {} \;
	find ./$(NAME) -name '*~' -exec rm {} \;
	zip -r $@ $(NAME)
	rm -rf $(NAME)

%.py: %.ui
	pyside-uic $< > $@

clean:
	rm -f *~ *.pyc BtMainWindow.py $(NAME).zip
	rm -rf $(NAME)
