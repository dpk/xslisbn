<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:isbn="tag:nonceword.org,2016:isbn">
  <xsl:import href="../isbn.xslt" />

  <xsl:output method="text" />
  <xsl:strip-space elements="tests isbn"/>

  <xsl:template match="/tests/isbn">
    <xsl:variable name="isbn" select="string(.)" />
    <xsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />
    <xsl:variable name="expected-check-digit" select="isbn:check-digit($isbn)" />
    <xsl:variable name="check-digit">
      <xsl:choose>
        <xsl:when test="string-length($raw-isbn) = 13">
          <xsl:value-of select="substring($raw-isbn, 13, 1)" />
        </xsl:when>
        <xsl:when test="string-length($raw-isbn) = 10">
          <xsl:value-of select="substring($raw-isbn, 10, 1)" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="isbn-no-check">
      <xsl:choose>
        <xsl:when test="string-length($raw-isbn) = 13">
          <xsl:value-of select="substring($raw-isbn, 1, 12)" />
        </xsl:when>
        <xsl:when test="string-length($raw-isbn) = 10">
          <xsl:value-of select="substring($raw-isbn, 1, 9)" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="formatted-isbn" select="isbn:format($raw-isbn)" />
    
    <xsl:value-of select="$isbn" />
    <xsl:text>&#x0A;</xsl:text>

    <xsl:choose>
      <xsl:when test="isbn:validate($isbn) = true()">
        <xsl:text>   PASS: validates&#x0A;</xsl:text>

        <xsl:analyze-string select="'0123456789X'" regex=".">
          <xsl:matching-substring>
            <xsl:if test="not(string(.) = $check-digit)">
              <xsl:choose>
                <xsl:when test="isbn:validate(concat($isbn-no-check, .)) = true()">
                  <xsl:text>     FAIL: validates despite wrong replacement check digit </xsl:text>
                  <xsl:value-of select="." />
                  <xsl:text>&#x0A;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>     PASS: doesn't validate with wrong replacement check digit </xsl:text>
                  <xsl:value-of select="." />
                  <xsl:text>&#x0A;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:matching-substring>
        </xsl:analyze-string>

        <xsl:choose>
          <xsl:when test="$formatted-isbn = $isbn">
            <xsl:text>   PASS: re-formats correctly&#x0A;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>   FAIL: incorrectly reformats to</xsl:text>
            <xsl:value-of select="$formatted-isbn" />
            <xsl:text>&#x0A;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>   FAIL: does not validate, expected check digit </xsl:text>
        <xsl:value-of select="$expected-check-digit" />
        <xsl:text>, got </xsl:text>
        <xsl:value-of select="$check-digit" />
        <xsl:text>&#x0A;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
