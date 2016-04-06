CC=gcc
CFLAGS=-I. -std=c99 -pedantic -Wall -Wextra -g
LDLIBS=-lm
BINS=ip2cc

MAXMIND_FILE:=GeoIPCountryCSV.zip
MAXMIND_URL:=http://geolite.maxmind.com/download/geoip/database/${MAXMIND_FILE}
LUDOST_FILE:=country.db.gz
LUDOST_URL:=https://ip.ludost.net/raw/${LUDOST_FILE}
INPUT_FILE:=country.txt

default: $(BINS)

cbst.o: cbst.c cbst.h

ip-cbst.o: ip-cbst.c ip-cbst.h cbst.h

ip2cc.o: ip2cc.c ip-cbst.h

ip2cc: ip2cc.o ip-cbst.o cbst.o

ludost:
	wget -O ${LUDOST_FILE} ${LUDOST_URL}
	zcat ${LUDOST_FILE} > ${INPUT_FILE}

maxmind:
	wget -O ${MAXMIND_FILE} ${MAXMIND_URL}
	unzip ${MAXMIND_FILE}
	awk -F, '{print $$1, $$2, $$5}' GeoIPCountryWhois.csv | sed 's/"//g' > ${INPUT_FILE}

clean:
	rm -f $(BINS) *~ *.o core *.bin ${MAXMIND_FILE} ${LUDOST_FILE} *.csv

.PHONY: clean default ludost maxmind
