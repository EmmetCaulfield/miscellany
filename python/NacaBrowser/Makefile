NAME=NacaBrowser
DISTFILES=$(NAME).py README.txt NbMainWindow.py

default: NbMainWindow.py

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
	rm -f *~ *.pyc NbMainWindow.py $(NAME).zip
	rm -rf $(NAME)
