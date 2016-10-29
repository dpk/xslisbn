<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:isbn="tag:nonceword.org,2016:isbn"
                xmlns:util="tag:nonceword.org,2016:isbn/private-internal">

  <xsl:function name="util:nth-digit">
    <xsl:param name="isbn" />
    <xsl:param name="n" />

    <xsl:variable name="nth-char" select="substring($isbn, $n, 1)" />

    <xsl:choose>
      <xsl:when test="$nth-char = 'X'">
        <xsl:value-of select="10" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number($nth-char)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
