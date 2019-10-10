<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:opentopic="http://www.idiominc.com/opentopic"
xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
xmlns:svgobject="http://www.moldflow.com/namespace/2008/dita/svgobject"
xmlns:dcs="http://rtpdoc01.rtp.raleigh.ibm.com:9082/kc/dcs"
exclude-result-prefixes="ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs svgobject dcs"
version="2.0">

<!-- Diagram is in temp directory; do NOT look for it in source directory -->
<xsl:template match="*[contains(@class,' topic/object ')][@dcs:object='syntaxdiagram'][@dcs:pathfrommap]">

<xsl:variable name="imageFile" select="@dcs:urisyntaxpath">
</xsl:variable>
<xsl:variable name="unparsedSVG" select="unparsed-text($imageFile)"></xsl:variable>
<xsl:variable name="imageWidth" select="if (contains($unparsedSVG,'width=&quot;'))
then substring-before(substring-after($unparsedSVG,'width=&quot;'),'&quot;')
else @width"/>
<xsl:variable name="imageHeight" select="if (contains($unparsedSVG,'height=&quot;'))
then substring-before(substring-after($unparsedSVG,'height=&quot;'),'&quot;')
else @height"/>

<!--<xsl:message>DEBUG: WORKING WITH THE SYNTAX DIAGRAM IMAGE: 
href: <xsl:value-of select="@href"/>
work.dir.url: <xsl:value-of select="$work.dir.url"/>
height: <xsl:value-of select="$imageHeight"/>
<xsl:if test="number($imageHeight) &gt; 700">THAT WAS REALLY BIG WE SHOULD SCALE
</xsl:if>
width: <xsl:value-of select="$imageWidth"/>
<xsl:if test="number($imageWidth) &gt; 525">THAT WAS REALLY BIG WE SHOULD SCALE
</xsl:if>
</xsl:message>-->

<xsl:variable name="scaleimage">
<image class="- topic/image " href="{@dcs:pathfrommap}" outputclass="syntax-svg">
<xsl:copy-of select="@scale"/>
<xsl:if test="number($imageWidth) &gt; 525 or number($imageHeight) &gt; 700">
<xsl:attribute name="scalefit">yes</xsl:attribute>
</xsl:if>
<alt><xsl:value-of select="@dcs:alt"/></alt>
</image>
</xsl:variable>
<fo:inline xsl:use-attribute-sets="image__inline">
<xsl:call-template name="commonattributes"/>
<xsl:apply-templates select="$scaleimage" mode="placeImage">
<xsl:with-param name="imageAlign" select="@align"/>
<xsl:with-param name="href" select="$imageFile"/>
<xsl:with-param name="height" select="if (number($imageWidth) &lt; 526 and number($imageHeight) &lt; 701) then $imageHeight else ''"/>
<xsl:with-param name="width" select="if (number($imageWidth) &lt; 526 and number($imageHeight) &lt; 701) then $imageWidth else ''"/>
</xsl:apply-templates>
</fo:inline>
</xsl:template>

</xsl:stylesheet>
