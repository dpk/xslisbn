# ISBN processing for XSLT 2.0 and above

This package implements ISBN validation and formatting for XSLT programs. You can probably also use it with XQuery somehow, but I haven’t tried that.

Should work with any XSLT 2.0 processor, even those without XML Schema validation like Saxon HE.

**PLEASE NOTE** that these functions are going to be slow no matter what you do. The formatting one especially is slow and will get slower as more ISBN 13 registration prefixes are assigned, because it has to make an O(*n*) scan over the list of them every time. (Yes, this sucks; no, there’s not a lot I can do about it without giving up XSLT 2.0 support in favour of 3.0, of which no free implementation exists at this time. I *could* use a kind of trie-in-code where it would look at only one character at a time to determine which registration group the ISBN is in, but that’d be super hard to generate with XSLT.)

## Building

To be able to use the format function you need to download the ISBN range message file. If you have `curl` installed you should be able to just type `make` (or `gmake` on BSD systems) and it will download the file and compile the `isbn:format` function with Saxon, assuming `saxon` is in your `$PATH`.

## Usage

Include the `isbn.xslt` file, which exports functions into the `tag:nonceword.org,2016:isbn` URI namespace. This will be called `isbn:` in QNames below.

### `isbn:validate(isbn)`

```xslt
<xsl:choose>
  <xsl:when test="isbn:validate(.)">
    <xsl:text>This ISBN is valid</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>Invalid ISBN</xsl:text>
  </xsl:otherwise>
</xsl:choose>
```

Checks that a given ISBN is valid. Returns `true()` if it is and `false()` if it isn’t. This does not produce an error if the function is called with obvious nonsense.

To validate an ISBN of a specific length (10 or 13) and reject the other length, there are the `isbn:validate-10` and `isbn:validate-13` functions respectively.

### `isbn:format(isbn)`

```xslt
<xsl:value-of select="isbn:format(.)" />
```

Adds hyphens in the appropriate places based on the length, registration group, and registrant of the ISBN. This will error if the given ISBN is not 10 or 13 digits long, but doesn’t otherwise validate its input.

Notably, this will produce ISBNs with technically ‘incorrect’ formatting if the given ISBN doesn’t appear to have valid details in the range file. If you want to be sure it’s correct you should check the output to see if there are four (ISBN 13) or three (ISBN 10) hyphens; if there are fewer, the ISBN isn’t correctly formatted. Nonetheless what formatting it *can* do in this scenario should help humans to read and enter the number.

To format an ISBN of a specific length (10 or 13) and cause monkeys to fly out of your screen if you give it the other length, there are the `isbn:format-10` and `isbn:format-13` functions respectively.

### `isbn:unformat(isbn)`

Remove hyphens, spaces, and other garbage from an ISBN. This will not actually check that it’s even a remotely valid ISBN, just take all the possible ISBN characters from the given element and return them as a string. Usually there should be no need to run this as it is run implicitly by all the other functions.
