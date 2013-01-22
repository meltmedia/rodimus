<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:html="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="html">
  <xsl:param name="param1" select="'defaultval1'" />
  <xsl:variable name="map" select="document('map.xml')"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="html:p[@class='list_Paragraph' and not(preceding-sibling::html:p[@class='list_Paragraph'])]" priority="2">
    <ul>
      <xsl:apply-templates select="." mode="convert-list"/>
    </ul>
  </xsl:template>
  <xsl:template match="html:p[@class='list_Paragraph']" priority="1"></xsl:template>
  <xsl:template match="html:p[@class='list_Paragraph']" mode="convert-list">
    <li><xsl:apply-templates select="node()"/></li>
    <xsl:apply-templates select="following-sibling::html:p[1][@class='list_Paragraph']" mode="convert-list"/>
  </xsl:template>

  <!-- Eliminate empty nodes that have no attributes -->
  <xsl:template match="*[count(node()|@*)=0]" priority="2" />

  <!-- Eliminate elements containing only whitespace -->
  <xsl:template match="*[not(@*|*) and normalize-space()='']" priority="1" />

  <!-- remove whitespace between elements -->
  <xsl:template match="text()[normalize-space()='']" />

  <!-- removes leading and trailing whitespace from text nodes -->
  <xsl:template match="text()[normalize-space()!='']">
    <xsl:copy-of select="normalize-space()" />
  </xsl:template>
</xsl:stylesheet>