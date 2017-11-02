<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:isbn="tag:nonceword.org,2016:isbn">
  <xsl:include href="../isbn.xslt" />

  <xsl:output method="text" />
  <xsl:strip-space elements="testdata test"/>

  <xsl:template match="//test">
    <xsl:variable name="in" select="./input" />
    <xsl:variable name="expected" select="string(./output)" />
    <xsl:variable name="actual" select="isbn:format(./input)" />

    <xsl:choose>
      <xsl:when test="$expected = $actual">
        <xsl:text>PASS: "</xsl:text>
          <xsl:value-of select="@that" />
        <xsl:text>"&#x0A;</xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>FAIL: "</xsl:text>
          <xsl:value-of select="@that" />
        <xsl:text>"&#x0A;</xsl:text>

        <xsl:text>  exp "</xsl:text>
          <xsl:value-of select="$expected" />
        <xsl:text>"&#x0A;</xsl:text>

        <xsl:text>  got "</xsl:text>
          <xsl:value-of select="$actual" />
        <xsl:text>"&#x0A;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
