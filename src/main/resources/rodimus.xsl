<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:html="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="html saxon">
  <xsl:param name="todo-text" select="'_TODO'" />
  <xsl:output method="xml" encoding="us-ascii" indent="yes" saxon:indent-spaces="2" saxon:character-representation="decimal" />
  
  <!-- buffer -->
  <xsl:template match="/">
    <xsl:variable name="out1">
      <xsl:apply-templates select="node()" />
    </xsl:variable>
    <xsl:apply-templates select="$out1" mode="post-process" />
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="post-process">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="post-process" />
    </xsl:copy>
  </xsl:template>

  <!-- Eliminate empty nodes that have no attributes -->
  <xsl:template match="*[count(@*|node())=0]" priority="2" mode="post-process" />

  <!-- Eliminate elements containing only whitespace -->
  <xsl:template match="*[not(@*|*) and normalize-space()='']" priority="1" mode="post-process" />

  <!-- Convert URLs to <a>'s -->
  <xsl:template match="text()[not(ancestor::html:a)]" mode="post-process">
    <xsl:analyze-string select="." regex="http[s]?://\S*[^.?!:;,&quot;&apos;\s]">
      <xsl:matching-substring>
        <a href="{.}" target="_blank" title="{$todo-text}">
          <xsl:copy-of select="." />
        </a>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="." />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!-- identity template -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- add required items to the head. -->
  <xsl:template match="html:head">
    <xsl:copy>
      <xsl:apply-templates select="@*|*[not(self::html:title)]"/>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <title><xsl:value-of select="$todo-text"/></title>
    </xsl:copy>
  </xsl:template>

  <!-- remove the old content type. -->
  <xsl:template match="html:meta[@name='Content-Type']"/>

  <!-- convert p.list_Paragraph into li in ul -->
  <xsl:template match="html:p[@class='list_Paragraph' and not(preceding-sibling::html:p[@class='list_Paragraph'])]" priority="2">
    <ul>
      <xsl:apply-templates select="." mode="convert-list" />
    </ul>
  </xsl:template>
  <xsl:template match="html:p[@class='list_Paragraph']" priority="1"></xsl:template>
  <xsl:template match="html:p[@class='list_Paragraph']" mode="convert-list">
    <li><xsl:apply-templates select="node()" /></li>
    <xsl:apply-templates select="following-sibling::html:p[1][@class='list_Paragraph']" mode="convert-list" />
  </xsl:template>
  
  <!-- Improve tables -->
  
  <!-- Get table and decide whether to build a thead -->
  <xsl:template match="html:table" priority="2">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:if test="html:tbody[1]/html:tr[1]/html:td[1]/html:p[1]/node()[1][self::html:b]">
        <xsl:apply-templates select="html:tbody" mode="table-head" />
      </xsl:if>
      <xsl:apply-templates select="node()" mode="table-body" />
    </xsl:copy>
  </xsl:template>
  
  <!-- mode="table-head" transforms all table contents into just the head row -->
  <xsl:template match="html:tbody" mode="table-head">
    <thead>
      <xsl:apply-templates select="@*|node()" mode="table-head" />
    </thead>
  </xsl:template>
  
  <xsl:template match="html:tr[1][html:td[1]/html:p[1]/node()[1][self::html:b]]" mode="table-head" priority="2">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="html:td" mode="table-head" />
    </xsl:copy>  
  </xsl:template>

  <xsl:template match="html:tr" mode="table-head"/>
  
  <xsl:template match="html:td" mode="table-head">
    <th>
      <xsl:apply-templates select="@*|html:p/html:b/node()" />
    </th>
  </xsl:template>
  
  <!-- mode="table-body" removes head row from body and cleans out p tags -->
  <xsl:template match="html:tbody" mode="table-body">
    <xsl:copy>
      <xsl:apply-templates select="@*|html:tr" mode="table-body" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="html:tr[1][html:td[1]/html:p[1]/node()[1][self::html:b]]" mode="table-body" priority="2"/>
    
  <xsl:template match="html:tr" mode="table-body">
    <xsl:copy>
      <xsl:apply-templates select="@*|html:td" mode="table-body" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="html:td" mode="table-body">
    <xsl:copy>
      <xsl:apply-templates select="@*|html:p/node()" />
    </xsl:copy>
  </xsl:template>
  
  <!-- remove whitespace between elements -->
  <xsl:template match="text()[normalize-space()='']" />
  
  <!-- removes leading and trailing whitespace from text nodes -->
  <xsl:template match="text()[normalize-space()!='']">
    <xsl:copy-of select="normalize-space()" />
  </xsl:template>
    
  <!-- replace b tags with strong tags -->
  <xsl:template match="html:b">
    <xsl:text> </xsl:text>
    <strong><xsl:apply-templates select="node()" /></strong>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <!-- replace i tags with em tags -->
  <xsl:template match="html:i">
    <xsl:text> </xsl:text>
    <em><xsl:apply-templates select="node()" /></em>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <!-- remove a tags without an href -->
  <xsl:template match="html:a[not(@href)]" priority="2" />
  
  <!-- make links open in new a window and add title tags -->
  <xsl:template match="html:a" priority="1">
    <xsl:text> </xsl:text>
    <a href="{@href}" target="_blank" title="{$todo-text}"><xsl:apply-templates select="node()" /></a>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <!-- strip alt tags and remind user to replace them -->
  <xsl:template match="html:img/@alt">
    <xsl:attribute name="{name()}"><xsl:value-of select="$todo-text" /></xsl:attribute>
  </xsl:template>
  
  <!-- convert p._Section_Header to h1 and label new sections -->
  <xsl:template match="html:p[@class='_Section_Header']">
    <xsl:comment>NEW_SECTION</xsl:comment>
    <xsl:text>
    </xsl:text>
    <h1><xsl:apply-templates select="node()" /></h1>
  </xsl:template>
  
  <!-- take images out of paragraphs -->
  <xsl:template match="html:p">
    <xsl:if test="count(node()[not(self::html:img)])&gt;0">
      <xsl:copy>
        <xsl:apply-templates select="node()[not(self::html:img)]|@*" />
      </xsl:copy>
    </xsl:if>
    <xsl:apply-templates select="html:img" />
  </xsl:template>

</xsl:stylesheet>
