.PHONY: clean release all test

all: build/format.xslt

build/isbn_ranges.xml: | build
	curl -sS -o build/isbn_ranges.xml 'https://www.isbn-international.org/export_rangemessage.xml'

build/format.xslt: src/meta/format.xslt build/isbn_ranges.xml | build
	saxon -xsl:src/meta/format.xslt -s:build/isbn_ranges.xml > $@

release: all | pkg
	mkdir -p pkg/isbn
	cp src/*.xslt pkg/isbn
	cp src/meta/isbn.pkg.xslt pkg/isbn.xslt
	cp build/format.xslt pkg/isbn
	cp README.md pkg
tarball: build/isbn.xslt.tar.gz

# http://unix.stackexchange.com/q/9665
build/isbn.xslt.tar.gz: release
	find pkg | env COPYFILE_DISABLE=1 pax -wd -s '/^pkg/isbn/' | gzip -9 > $@

build:
	mkdir build
pkg:
	mkdir pkg

clean:
	rm -rf build pkg

test: | build
	printf '' > build/test.log
	for testsuite in test/*.xslt; do if (echo $$testsuite; saxon -s:"$$(echo "$$testsuite" | sed -E 's/\.xslt$$/.xml/')" -xsl:"$$testsuite") | tee -a build/test.log /dev/stderr | egrep -q '^\s*FAIL:'; then exit 1; fi; done
