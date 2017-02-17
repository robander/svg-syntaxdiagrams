<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
<xsl:param name="OUTEXT"></xsl:param>
<xsl:param name="PATH2PROJ">
<xsl:apply-templates select="/processing-instruction('path2project')[1]" mode="get-path2project"/>
</xsl:param>
<xsl:param name="msgprefix">meep</xsl:param>

<xsl:template name="commonattributes"></xsl:template>
<xsl:template name="setidaname"></xsl:template>

<xsl:template name="href">
<xsl:apply-templates select="." mode="determine-final-href"/>
</xsl:template>
<xsl:template match="*" mode="determine-final-href">
<xsl:choose>
<xsl:when test="normalize-space(@href)='' or not(@href)"/>
<!-- For non-DITA formats - use the href as is -->
<xsl:when test="(not(@format) and (@type='external' or @scope='external')) or (@format and not(@format='dita' or @format='DITA'))">
<xsl:value-of select="@href"/>
</xsl:when>
<!-- For DITA - process the internal href -->
<xsl:when test="starts-with(@href,'#')">
<xsl:call-template name="parsehref">
<xsl:with-param name="href" select="@href"/>
</xsl:call-template>
</xsl:when>
<!-- It's to a DITA file - process the file name (adding the html extension)
    and process the rest of the href -->
<!-- for local links respect dita.extname extension 
      and for peer links accept both .xml and .dita bug:3059256-->
<xsl:when test="(not(@scope) or @scope='local' or @scope='peer') and (not(@format) or @format='dita' or @format='DITA')">
<xsl:call-template name="replace-extension">
<xsl:with-param name="filename" select="@href"/>
<xsl:with-param name="extension" select="$OUTEXT"/>
<xsl:with-param name="ignore-fragment" select="true()"/>
</xsl:call-template>
<xsl:if test="contains(@href, '#')">
<xsl:text>#</xsl:text>
<xsl:call-template name="parsehref">
<xsl:with-param name="href" select="substring-after(@href, '#')"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- "/" is not legal in IDs - need to swap it with two underscores -->
<xsl:template name="parsehref">
<xsl:param name="href"/>
<xsl:choose>
<xsl:when test="contains($href,'/')">
<xsl:value-of select="substring-before($href,'/')"/>__<xsl:value-of select="substring-after($href,'/')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


  <xsl:template match="*|@*|comment()|text()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|comment()|text()|processing-instruction()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
