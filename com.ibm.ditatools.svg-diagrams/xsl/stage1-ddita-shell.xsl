<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
<xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>

<xsl:import href="stage1-ddita.xsl"></xsl:import>
<xsl:import href="stage1-svgobject-ddita.xsl"></xsl:import>    
<xsl:import href="syntax-svgobject-ddita.xsl"></xsl:import>
<!--<xsl:import href="../../com.moldflow.dita.plus-allhtml-svgobject/xsl/stage1.xsl"/>
<xsl:import href="../../com.moldflow.dita.plus-allhtml-syntaxdiagram-svgobject/xsl/ddita.xsl"/>-->
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="//*[contains(@class,' pr-d/synnoteref ')] | 
                            //*[contains(@class,' pr-d/groupseq ') or contains(@class,' pr-d/groupcomp ') or contains(@class,' pr-d/groupchoice ')]/*[contains(@class,' topic/title ')]">
                <xsl:variable name="updatedoc" as="document-node()">
                    <xsl:document>
                        <xsl:apply-templates select="/*" mode="convert-title-group-to-fragment">
                            <xsl:with-param name="synnotes" as="element()"><startnode/></xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:document>
                </xsl:variable>
                
                <!--<xsl:result-document href="file:/c:/dcs/2.3.1/temp/syntest{generate-id(/*)}.xml">
                    <xsl:copy-of select="$updatedoc"/></xsl:result-document>-->
                <xsl:apply-templates select="$updatedoc/*"/>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:result-document href="file:/c:/dcs/2.3.1/temp/syntest.xml">
                    <xsl:copy-of select="/*"/></xsl:result-document>-->
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*|*|text()" mode="convert-title-group-to-fragment">
        <xsl:param name="synnotes" as="element()?"/>
        <xsl:copy>
            <xsl:apply-templates select="@*|text()|*" mode="convert-title-group-to-fragment">
                <xsl:with-param name="synnotes" select="$synnotes"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]" mode="convert-title-group-to-fragment">
        <xsl:param name="synnotes" as="element()?"/>
        <xsl:variable name="collectnotes" as="element()?">
            <xsl:choose>
                <xsl:when test=".//*[contains(@class,' pr-d/synnote ')]"><startnode><xsl:apply-templates mode="collect-synnotes"/></startnode></xsl:when>
                <xsl:otherwise><startnode/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--<debug><xsl:copy-of select="$collectnotes"/></debug>-->
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="convert-title-group-to-fragment"/>
            <xsl:for-each select="*">
                <xsl:apply-templates select="." mode="convert-title-group-to-fragment">
                    <xsl:with-param name="synnotes" select="$collectnotes"/>
                </xsl:apply-templates>
                <xsl:if test="(contains(@class,' pr-d/groupseq ') or 
                    contains(@class,' pr-d/groupcomp ') or 
                    contains(@class,' pr-d/groupchoice ')) and *[contains(@class,' topic/title ')]">
                    <xsl:apply-templates select="." mode="create-fragments">
                        <xsl:with-param name="synnotes" select="$collectnotes"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:apply-templates select=".//*[contains(@class,' pr-d/groupseq ') or 
                    contains(@class,' pr-d/groupcomp ') or 
                    contains(@class,' pr-d/groupchoice ')]" mode="create-fragments">
                    <xsl:with-param name="synnotes" select="$collectnotes"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/synnoteref ')]" mode="convert-title-group-to-fragment">
        <xsl:param name="synnotes" as="element()?"/>
        <xsl:variable name="noteid" select="substring-after(@href,'/')"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="convert-title-group-to-fragment"/>
            <xsl:choose>
                <xsl:when test="$synnotes/*[@id=$noteid][@callout]"><xsl:value-of select="$synnotes/*[@id=$noteid][@callout]"/></xsl:when>
                <xsl:when test="$synnotes/*[@id=$noteid]"><xsl:value-of select="count($synnotes/*[@id=$noteid][1]/preceding-sibling::*)+1"/></xsl:when>
                <xsl:otherwise>C<xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/groupseq ') or 
        contains(@class,' pr-d/groupcomp ') or 
        contains(@class,' pr-d/groupchoice ')][*[contains(@class,' topic/title ')]]" mode="convert-title-group-to-fragment">
        <xsl:param name="synnotes" as="element()?"/>
        <fragref class="+ topic/xref pr-d/fragref ">
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]/text() | *[contains(@class,' topic/title ')]/*" mode="convert-title-group-to-fragment">
                <xsl:with-param name="synnotes" select="$synnotes"/>
            </xsl:apply-templates>
        </fragref>
    </xsl:template>
    
    <xsl:template match="*" mode="create-fragments">
        <xsl:param name="synnotes" as="element()?"/>
        <xsl:if test="*[contains(@class,' topic/title ')]">
            <fragment class="+ topic/figgroup pr-d/fragment ">
                <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="convert-title-group-to-fragment">
                    <xsl:with-param name="synnotes" select="$synnotes"/>
                </xsl:apply-templates>
                <xsl:copy>
                    <xsl:apply-templates select="@*|*[not(contains(@class,' topic/title '))]" mode="convert-title-group-to-fragment">
                        <xsl:with-param name="synnotes" select="$synnotes"/>
                    </xsl:apply-templates>
                </xsl:copy>
            </fragment>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>