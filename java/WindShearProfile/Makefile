APP:=WindShearProfile
SRC:=CrosshairRegion.java
SRC+=$(APP).java
CLS:=$(addsuffix .class, $(basename $(SRC)))
CSS:=$(APP).css
JARGS=

jar: $(APP).jar

$(APP).jar: $(CLS) $(CSS)
	jar cfm $@ Manifest.txt $(APP)*.class CrosshairRegion*.class $(APP).css

%.class: %.java
	javac $(JARGS) $^

lint: JARGS=-Xlint:unchecked
lint: clean $(CLS)

clean:
	rm -f *.class *~

reallyclean: clean
	rm -f $(APP).jar

deploy:
	scp $(APP).jar silme:public_html/emmetcaulfield.com/applets/
