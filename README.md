# ISBN processing for XSLT 2.0 and above

This package implements ISBN validation and formatting for XSLT programs. You can probably also use it with XQuery somehow, but I haven’t tried that.

Should work with any XSLT 2.0 processor, even those without XML Schema validation like Saxon HE.

**PLEASE NOTE** that these functions are going to be slow no matter what you do. The formatting one especially is slow and will get slower as more ISBN 13 registration prefixes are assigned, because it has to make an O(*n*) scan over the list of them every time. (Yes, this sucks; no, there’s not a lot I can do about it without giving up XSLT 2.0 support in favour of 3.0, of which no free implementation exists at this time. I *could* use a kind of trie-in-code where it would look at only one character at a time to determine which registration group the ISBN is in, but that’d be super hard to generate with XSLT.)
