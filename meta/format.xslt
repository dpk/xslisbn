<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:axsl="tag:nonceword.org,2016:isbn/xsl-transform-alias"
                xmlns:isbn="tag:nonceword.org,2016:isbn">
  <xsl:import href="../unformat.xslt" />

  <xsl:output method="xml" indent="yes" />
  <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

  <!-- there's quite a bit of code duplication in this generator, but it's the best way i could think to do this without having any means of dynamic function references, and without having to special case the 979 prefixes for ISBN 13 -->

  <xsl:template match="/ISBNRangeMessage/*" priority="1">
  </xsl:template>
  <xsl:template match="/ISBNRangeMessage/RegistrationGroups" priority="2">
    <axsl:stylesheet>
      <axsl:import href="util.xslt" />
      <axsl:import href="unformat.xslt" />

      <axsl:function name="isbn:format">
        <axsl:param name="isbn" />
        <axsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />

        <axsl:choose>
          <axsl:when test="string-length($raw-isbn) = 13">
            <axsl:value-of select="isbn:format-13($isbn)" />
          </axsl:when>
          <axsl:when test="string-length($raw-isbn) = 10">
            <axsl:value-of select="isbn:format-10($isbn)" />
          </axsl:when>
          <axsl:otherwise>
            <axsl:value-of select="error(QName('tag:nonceword.org,2016:isbn', 'isbn:invalid-length'), 'ISBNs must be 10 or 13 characters long to format')" />
          </axsl:otherwise>
        </axsl:choose>
      </axsl:function>

      <!-- so we return a string instead of a set of text nodes -->
      <axsl:function name="isbn:format-10">
        <axsl:param name="isbn" />
        <axsl:value-of select="string(isbn:format-10-internal($isbn))" />
      </axsl:function>
      <axsl:function name="isbn:format-13">
        <axsl:param name="isbn" />
        <axsl:value-of select="string(isbn:format-13-internal($isbn))" />
      </axsl:function>

      <axsl:function name="isbn:format-10-internal">
        <axsl:param name="isbn" />

        <axsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />

        <axsl:choose>
          <xsl:for-each select="./Group">
            <!-- longer prefixes take precedence over shorter ones -->
            <xsl:sort select="string-length(isbn:unformat(./Prefix))" order="descending" />
            <xsl:if test="starts-with(isbn:unformat(./Prefix), '978')">
              <xsl:call-template name="isbn:when10-registration-group" />
            </xsl:if>
          </xsl:for-each>
          <axsl:otherwise>
            <axsl:call-template name="isbn:mask10">
              <axsl:with-param name="isbn" select="$raw-isbn" />
              <axsl:with-param name="registration-group-length" select="0" />
              <axsl:with-param name="registrant-length" select="0" />
            </axsl:call-template>
          </axsl:otherwise>
        </axsl:choose>
      </axsl:function>
      <axsl:function name="isbn:format-13-internal">
        <axsl:param name="isbn" />

        <axsl:variable name="raw-isbn" select="isbn:unformat($isbn)" />

        <axsl:choose>
          <xsl:for-each select="./Group">
            <!-- longer prefixes take precedence over shorter ones -->
            <xsl:sort select="string-length(isbn:unformat(./Prefix))" order="descending" />
            <xsl:call-template name="isbn:when13-registration-group" />
          </xsl:for-each>
          <axsl:otherwise>
            <axsl:call-template name="isbn:mask13">
              <axsl:with-param name="isbn" select="$raw-isbn" />
              <axsl:with-param name="registration-group-length" select="0" />
              <axsl:with-param name="registrant-length" select="0" />
            </axsl:call-template>
          </axsl:otherwise>
        </axsl:choose>
      </axsl:function>

      <axsl:template name="isbn:mask13">
        <axsl:param name="isbn" />
        <axsl:param name="registration-group-length" />
        <axsl:param name="registrant-length" />

        <!-- A sequence of more than one item is not allowed as the first argument of string() -->
        <wrap>
          <!-- prefix element -->
          <axsl:value-of select="substring($isbn, 1, 3)" />
          <axsl:text>-</axsl:text>
          <axsl:choose>
            <axsl:when test="$registration-group-length = 0">
              <!-- registration group + registrant + publication -->
              <axsl:value-of select="substring($isbn, 4, 9)" />
              <axsl:text>-</axsl:text>
            </axsl:when>
            <axsl:when test="$registrant-length = 0">
              <!-- registration group -->
              <axsl:value-of select="substring($isbn, 4, $registration-group-length)" />
              <axsl:text>-</axsl:text>
              <!-- registrant + publication -->
              <axsl:value-of select="substring($isbn, 4 + $registration-group-length, (13 - $registration-group-length - 4))" />
              <axsl:text>-</axsl:text>
            </axsl:when>
            <axsl:otherwise>
              <!-- registration group -->
              <axsl:value-of select="substring($isbn, 4, $registration-group-length)" />
              <axsl:text>-</axsl:text>
              <!-- registrant -->
              <axsl:value-of select="substring($isbn, 4 + $registration-group-length, $registrant-length)" />
              <axsl:text>-</axsl:text>
              <!-- publication -->
              <axsl:value-of select="substring($isbn, 4 + $registration-group-length + $registrant-length, (13 - $registration-group-length - $registrant-length - 4))" />
              <axsl:text>-</axsl:text>
            </axsl:otherwise>
          </axsl:choose>
          <!-- check code -->
          <axsl:value-of select="substring($isbn, 13)" />
        </wrap>
      </axsl:template>
      <axsl:template name="isbn:mask10">
        <axsl:param name="isbn" />
        <axsl:param name="registration-group-length" />
        <axsl:param name="registrant-length" />

        <!-- A sequence of more than one item is not allowed as the first argument of string() -->
        <wrap>
          <axsl:choose>
            <axsl:when test="$registration-group-length = 0">
              <!-- registration group + registrant + publication -->
              <axsl:value-of select="substring($isbn, 1, 9)" />
              <axsl:text>-</axsl:text>
            </axsl:when>
            <axsl:when test="$registrant-length = 0">
              <!-- registration group -->
              <axsl:value-of select="substring($isbn, 1, $registration-group-length)" />
              <axsl:text>-</axsl:text>
              <!-- registrant + publication -->
              <axsl:value-of select="substring($isbn, 1 + $registration-group-length, (10 - $registration-group-length - 1))" />
              <axsl:text>-</axsl:text>
            </axsl:when>
            <axsl:otherwise>
              <!-- registration group -->
              <axsl:value-of select="substring($isbn, 1, $registration-group-length)" />
              <axsl:text>-</axsl:text>
              <!-- registrant -->
              <axsl:value-of select="substring($isbn, 1 + $registration-group-length, $registrant-length)" />
              <axsl:text>-</axsl:text>
              <!-- publication -->
              <axsl:value-of select="substring($isbn, 1 + $registration-group-length + $registrant-length, (10 - $registration-group-length - $registrant-length - 1))" />
              <axsl:text>-</axsl:text>
            </axsl:otherwise>
          </axsl:choose>
          <!-- check code -->
          <axsl:value-of select="substring($isbn, 10)" />
        </wrap>
      </axsl:template>
    </axsl:stylesheet>
  </xsl:template>

  <xsl:template name="isbn:when13-registration-group">
    <xsl:variable name="prefix-length" select="string-length(isbn:unformat(./Prefix))" />
    <xsl:variable name="registration-group-length" select="$prefix-length - 3" />

    <axsl:when>
      <xsl:attribute name="test">starts-with($raw-isbn, '<xsl:value-of select="isbn:unformat(./Prefix)" />')</xsl:attribute>

      <axsl:variable name="next-section">
        <xsl:attribute name="select">substring($raw-isbn, <xsl:value-of select="$registration-group-length + 4" />)</xsl:attribute>
      </axsl:variable>

      <axsl:choose>
        <xsl:for-each select="./Rules/Rule">
          <xsl:call-template name="isbn:when13-registrant">
            <xsl:with-param name="registration-group-length" select="$registration-group-length" />
          </xsl:call-template>
        </xsl:for-each>
        <axsl:otherwise>
          <axsl:call-template name="isbn:mask13">
            <axsl:with-param name="isbn" select="$raw-isbn" />
            <axsl:with-param name="registration-group-length" select="{$registration-group-length}" />
            <axsl:with-param name="registrant-length" select="0" />
          </axsl:call-template>
        </axsl:otherwise>
      </axsl:choose>
    </axsl:when>
  </xsl:template>

  <xsl:template name="isbn:when13-registrant">
    <xsl:param name="registration-group-length" />

    <xsl:variable name="this" select="." />

    <xsl:analyze-string select="./Range" regex="^([0-9]+)-([0-9]+)$">
      <xsl:matching-substring>
        <axsl:when>
          <xsl:attribute name="test">('<xsl:value-of select="regex-group(1)" />' &lt;= $next-section) and ($next-section &lt;= '<xsl:value-of select="regex-group(2)" />')</xsl:attribute>

          <axsl:call-template name="isbn:mask13">
            <axsl:with-param name="isbn" select="$raw-isbn" />
            <axsl:with-param name="registration-group-length" select="{$registration-group-length}" />

            <axsl:with-param name="registrant-length">
              <xsl:attribute name="select"><xsl:value-of select="$this/Length" /></xsl:attribute>
            </axsl:with-param>
          </axsl:call-template>
        </axsl:when>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="isbn:when10-registration-group">
    <xsl:variable name="short-prefix" select="substring(isbn:unformat(./Prefix), 4)" />
    <xsl:variable name="registration-group-length" select="string-length($short-prefix)" />

    <axsl:when>
      <xsl:attribute name="test">starts-with($raw-isbn, '<xsl:value-of select="$short-prefix" />')</xsl:attribute>

      <axsl:variable name="next-section">
        <xsl:attribute name="select">substring($raw-isbn, <xsl:value-of select="$registration-group-length + 1" />)</xsl:attribute>
      </axsl:variable>

      <axsl:choose>
        <xsl:for-each select="./Rules/Rule">
          <xsl:call-template name="isbn:when10-registrant">
            <xsl:with-param name="registration-group-length" select="$registration-group-length" />
          </xsl:call-template>
        </xsl:for-each>
        <axsl:otherwise>
          <axsl:call-template name="isbn:mask10">
            <axsl:with-param name="isbn" select="$raw-isbn" />
            <axsl:with-param name="registration-group-length" select="{$registration-group-length}" />
            <axsl:with-param name="registrant-length" select="0" />
          </axsl:call-template>
        </axsl:otherwise>
      </axsl:choose>
    </axsl:when>
  </xsl:template>

  <xsl:template name="isbn:when10-registrant">
    <xsl:param name="registration-group-length" />

    <xsl:variable name="this" select="." />

    <xsl:analyze-string select="./Range" regex="^([0-9]+)-([0-9]+)$">
      <xsl:matching-substring>
        <axsl:when>
          <xsl:attribute name="test">('<xsl:value-of select="regex-group(1)" />' &lt;= $next-section) and ($next-section &lt;= '<xsl:value-of select="regex-group(2)" />')</xsl:attribute>

          <axsl:call-template name="isbn:mask10">
            <axsl:with-param name="isbn" select="$raw-isbn" />
            <axsl:with-param name="registration-group-length" select="{$registration-group-length}" />

            <axsl:with-param name="registrant-length">
              <xsl:attribute name="select"><xsl:value-of select="$this/Length" /></xsl:attribute>
            </axsl:with-param>
          </axsl:call-template>
        </axsl:when>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
</xsl:stylesheet>
