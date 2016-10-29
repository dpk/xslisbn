.PHONY: clean all

all: isbn_ranges.xml

isbn_ranges.xml:
	curl -s -o isbn_ranges.xml https://www.isbn-international.org/export_rangemessage.xml

clean:
	rm -rf export_rangemessage.xml

