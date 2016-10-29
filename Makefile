.PHONY: clean all

all: format.xslt

isbn_ranges.xml:
	curl -s -o isbn_ranges.xml https://www.isbn-international.org/export_rangemessage.xml

format.xslt: meta/format.xslt isbn_ranges.xml
	saxon -xsl:meta/format.xslt -s:isbn_ranges.xml > $@

clean:
	rm -rf export_rangemessage.xml

