<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:isbn="tag:nonceword.org,2016:isbn">

  <xsl:function name="isbn:unformat">
    <xsl:param name="isbn" />
    <xsl:variable name="string-isbn" select="string($isbn)" />

    <xsl:value-of select="translate($string-isbn, translate($string-isbn, '012456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')" />
  </xsl:function>
</xsl:stylesheet>
