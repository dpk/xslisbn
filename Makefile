.PHONY: clean all

all: build/format.xslt

build/isbn_ranges.xml: | build
	curl -s -o build/isbn_ranges.xml https://www.isbn-international.org/export_rangemessage.xml

build/format.xslt: src/meta/format.xslt build/isbn_ranges.xml | build
	saxon -xsl:src/meta/format.xslt -s:build/isbn_ranges.xml > $@

build:
	mkdir build

clean:
	rm -rf build
