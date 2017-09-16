<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:isbn="tag:nonceword.org,2016:isbn"
                xmlns:util="tag:nonceword.org,2016:isbn/private-internal">

  <xsl:function name="isbn:expected-check-digit-10">
    <!-- @@@ CAN ONLY BE USED WITH UNFORMATTED ISBNS -->
    <xsl:param name="raw-isbn" />
    <xsl:value-of select="11 - ((
          (10 * util:nth-digit($raw-isbn, 1))
        + ( 9 * util:nth-digit($raw-isbn, 2))
        + ( 8 * util:nth-digit($raw-isbn, 3))
        + ( 7 * util:nth-digit($raw-isbn, 4))
        + ( 6 * util:nth-digit($raw-isbn, 5))
        + ( 5 * util:nth-digit($raw-isbn, 6))
        + ( 4 * util:nth-digit($raw-isbn, 7))
        + ( 3 * util:nth-digit($raw-isbn, 8))
        + ( 2 * util:nth-digit($raw-isbn, 9))
      ) mod 11)" />
  </xsl:function>
  
  <xsl:function name="isbn:validate-10">
    <xsl:param name="isbn" />

    <xsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />
    <xsl:variable name="expected-check-digit" select="isbn:expected-check-digit-10($raw-isbn)" />

    <xsl:choose>
      <xsl:when test="not(matches($raw-isbn, '^[0-9]{9}[0-9X]$'))">
        <xsl:value-of select="false()" />
      </xsl:when>
      <xsl:when test="$expected-check-digit = util:nth-digit($raw-isbn, 10)">
        <xsl:value-of select="true()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isbn:expected-check-digit-13">
    <!-- @@@ CAN ONLY BE USED WITH UNFORMATTED ISBNS -->
    <xsl:param name="raw-isbn" />
    <xsl:value-of select="(10 - ((
          (1 * util:nth-digit($raw-isbn, 1))
        + (3 * util:nth-digit($raw-isbn, 2))
        + (1 * util:nth-digit($raw-isbn, 3))
        + (3 * util:nth-digit($raw-isbn, 4))
        + (1 * util:nth-digit($raw-isbn, 5))
        + (3 * util:nth-digit($raw-isbn, 6))
        + (1 * util:nth-digit($raw-isbn, 7))
        + (3 * util:nth-digit($raw-isbn, 8))
        + (1 * util:nth-digit($raw-isbn, 9))
        + (3 * util:nth-digit($raw-isbn, 10))
        + (1 * util:nth-digit($raw-isbn, 11))
        + (3 * util:nth-digit($raw-isbn, 12))
      ) mod 10)) mod 10" />
  </xsl:function>
  
  <xsl:function name="isbn:validate-13">
    <xsl:param name="isbn" />

    <xsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />
    <xsl:variable name="expected-check-digit" select="isbn:expected-check-digit-13($raw-isbn)" />

    <xsl:choose>
      <xsl:when test="not(matches($raw-isbn, '^[0-9]{13}$'))">
        <xsl:value-of select="false()" />
      </xsl:when>
      <xsl:when test="$expected-check-digit = util:nth-digit($raw-isbn, 13)">
        <xsl:value-of select="true()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isbn:check-digit">
    <xsl:param name="isbn" />

    <xsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />
    <xsl:variable name="isbn-length" select="string-length($raw-isbn)" />

    <xsl:choose>
      <xsl:when test="$isbn-length = 10">
        <xsl:value-of select="isbn:expected-check-digit-10($raw-isbn)" />
      </xsl:when>
      <xsl:when test="$isbn-length = 13">
        <xsl:value-of select="isbn:expected-check-digit-13($raw-isbn)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isbn:validate">
    <xsl:param name="isbn" />

    <xsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />
    <xsl:variable name="isbn-length" select="string-length($raw-isbn)" />

    <xsl:choose>
      <xsl:when test="$isbn-length = 10">
        <xsl:value-of select="isbn:validate-10($raw-isbn)" />
      </xsl:when>
      <xsl:when test="$isbn-length = 13">
        <xsl:value-of select="isbn:validate-13($raw-isbn)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
