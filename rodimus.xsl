<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:html="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="html">
  <xsl:param name="todo-text" select="'_TODO'" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <!-- identity template -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- convert p.list_Paragraph into li in ul -->
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
  
  <!-- remove p tags from table cells -->
  <xsl:template match="html:*[self::html:td or self::html:th]/html:p">
    <xsl:apply-templates select="node()" />
  </xsl:template>
  
  <!-- replace b tags with strong tags -->
  <xsl:template match="html:b">
    <strong><xsl:apply-templates select="node()" /></strong>
  </xsl:template>
  
  <!-- replace i tags with em tags -->
  <xsl:template match="html:i">
    <em><xsl:apply-templates select="node()" /></em>
  </xsl:template>
  
  <!-- remove a tags without an href -->
  <xsl:template match="html:a[not(@href)]" />
  
  <!-- strip alt tags and remind user to replace them -->
  <xsl:template match="html:img/@alt">
    <xsl:attribute name="{name()}"><xsl:value-of select="$todo-text"/></xsl:attribute>
  </xsl:template>
  
  <!-- convert p._Section_Header to h1 -->
  <xsl:template match="html:p[@class='_Section_Header']">
    <h1><xsl:apply-templates select="node()" /></h1>
  </xsl:template>
  
  <!-- take images out of paragraphs -->
  <xsl:template match="html:p">
    <xsl:if test="count(element()[not(self::html:img)])&gt;0">
      <xsl:copy>
        <xsl:apply-templates select="node()[not(self::html:img)]|@*"/>
      </xsl:copy>
    </xsl:if>
    <xsl:apply-templates select="html:img"/>
  </xsl:template>

</xsl:stylesheet>