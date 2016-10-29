<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:isbn="tag:nonceword.org,2016:isbn">
  <xsl:import href="../validators.xslt" />

  <xsl:output method="text" />
  <xsl:strip-space elements="testdata test"/>

  <xsl:template match="//testdata[@for='validate-10']//test">
    <xsl:variable name="in" select="./input" />
    <xsl:variable name="expected" select="boolean(./valid) and not(boolean(./invalid))" />
    <xsl:variable name="actual" select="isbn:validate-10(./input)" />

    <xsl:choose>
      <xsl:when test="$expected = $actual">
        <xsl:text>pass "</xsl:text>
          <xsl:value-of select="@that" />
        <xsl:text>"&#x0A;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>fail "</xsl:text>
          <xsl:value-of select="@that" />
        <xsl:text>"&#x0A;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//testdata[@for='validate-13']//test">
    <xsl:variable name="in" select="./input" />
    <xsl:variable name="expected" select="boolean(./valid) and not(boolean(./invalid))" />
    <xsl:variable name="actual" select="isbn:validate-13(./input)" />

    <xsl:choose>
      <xsl:when test="$expected = $actual">
        <xsl:text>pass "</xsl:text>
          <xsl:value-of select="@that" />
        <xsl:text>"&#x0A;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>fail "</xsl:text>
          <xsl:value-of select="@that" />
        <xsl:text>"&#x0A;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
