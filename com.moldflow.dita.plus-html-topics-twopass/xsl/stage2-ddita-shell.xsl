<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:svg="http://www.w3.org/2000/svg" 
xmlns:xlink="http://www.w3.org/1999/xlink" 
xmlns:svgobject="http://www.moldflow.com/namespace/2008/dita/svgobject" 
xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
exclude-result-prefixes="svg xlink svgobject ditaarch"
version="1.0">

<xsl:import href="../../../xsl/dita2xhtml.xsl"></xsl:import>
<!--
<xsl:import href="../../com.moldflow.dita.plus-allhtml-svgobject/xsl/fixup-html.xsl"/>
-->

<xsl:template match="div">
  <div>
  <xsl:apply-templates select="*|@*|comment()|text()|processing-instruction()" mode="fixup-html-diagrams"/>
  </div>
</xsl:template>

<xsl:template match="@*|*|text()" mode="fixup-html-diagrams">
  <xsl:copy>
  <xsl:apply-templates select="*|@*|comment()|text()|processing-instruction()" mode="fixup-html-diagrams"/>
  </xsl:copy>
</xsl:template>
<xsl:template match="comment()|processing-instruction()" mode="fixup-html-diagrams">
</xsl:template>

<!--<xsl:template match="*[ancestor-or-self::div]" priority="-1">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:element>
</xsl:template>-->

<!--<xsl:template match="*[ancestor-or-self::div]/@*" priority="-1">
  <xsl:copy-of select="."/>
</xsl:template>-->

<xsl:template match="@svgobject:target"  mode="fixup-html-diagrams"/>

<!-- Fix up width and height of external object references. -->
<xsl:template match="object/@svgobject:width" mode="fixup-html-diagrams">
<xsl:attribute name="width">
<xsl:value-of select="document(../@data, /)/svg:svg[1]/@width" xmlns:svg="http://www.w3.org/2000/svg"/>
</xsl:attribute>
</xsl:template>

<xsl:template match="object/@svgobject:height" mode="fixup-html-diagrams">
<xsl:attribute name="height">
<xsl:value-of select="document(../@data, /)/svg:svg[1]/@height" xmlns:svg="http://www.w3.org/2000/svg"/>
</xsl:attribute>
</xsl:template>

<xsl:template match="@svgobject:baseline-shift"  mode="fixup-html-diagrams">
<xsl:if test="document(string(.), /)">
<xsl:attribute name="style">
<xsl:text>vertical-align: </xsl:text>
<xsl:value-of select="0 - document(string(.), /)"/>
<xsl:text>px;</xsl:text>
</xsl:attribute>
</xsl:if>
</xsl:template>

<xsl:template match="img/@svgobject:usemap"  mode="fixup-html-diagrams">
<xsl:if test="document(string(.), /)/map/*">
<xsl:attribute name="usemap">
<xsl:value-of select="concat('#', generate-id(document(string(.), /)/map))"/>
</xsl:attribute>
<xsl:attribute name="border">0</xsl:attribute>
</xsl:if>
</xsl:template>

<xsl:template match="processing-instruction('plus-svgobject-raster-imagemap')" mode="fixup-html-diagrams">
<xsl:if test="document(string(.), /)/map/*">
<map name="{generate-id(document(string(.), /)/map)}">
<xsl:apply-templates select="document(string(.), /)/map/*" mode="copy-map"/>
</map>
</xsl:if>
</xsl:template>

<xsl:template match="*" mode="copy-map">
<xsl:copy>
<xsl:apply-templates select="@* | node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="*[namespace-uri() = ''] | *[namespace-uri() = 'http://www.w3.org/1999/xhtml']" mode="copy-map">
<xsl:element name="{local-name()}">
<xsl:apply-templates select="@* | node()"/>
</xsl:element>
</xsl:template>

<xsl:template match="text() | processing-instruction() | @*" mode="copy-map">
<xsl:copy/>
</xsl:template>

</xsl:stylesheet>