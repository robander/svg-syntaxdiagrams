<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ditamsg dita-ot xs">

    <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
    <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
    
    <xsl:variable name="msgprefix" select="'DOTX'"/>
    
    <xsl:template match="*[contains(@class,' pr-d/groupcomp ')]">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()" mode="groupcomp-child"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/kwd ') or contains(@class,' pr-d/delim ') or contains(@class,' pr-d/sep ') 
        or contains(@class,' pr-d/var ') or contains(@class,' pr-d/oper ')][not(@importance) or @importance='required']" mode="groupcomp-child">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][contains(@class,' pr-d/kwd ') or contains(@class,' pr-d/delim ') or contains(@class,' pr-d/sep ') 
                or contains(@class,' pr-d/var ') or contains(@class,' pr-d/oper ')][not(@importance) or @importance='required']">
                <!-- Already grouped -->
            </xsl:when>
            <xsl:when test="following-sibling::*[1][contains(@class,' pr-d/kwd ') or contains(@class,' pr-d/delim ') or contains(@class,' pr-d/sep ') 
                or contains(@class,' pr-d/var ') or contains(@class,' pr-d/oper ')][not(@importance) or @importance='required']">
                <groupcomp class="+ topic/figgroup pr-d/groupcomp " outputclass="generated-group">
                    <xsl:copy>
                        <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
                    </xsl:copy>
                    <xsl:apply-templates select="following-sibling::*[1]" mode="add-to-groupcomp"/>
                </groupcomp>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="add-to-groupcomp"/>
    <xsl:template match="*[contains(@class,' pr-d/kwd ') or contains(@class,' pr-d/delim ') or contains(@class,' pr-d/sep ') 
        or contains(@class,' pr-d/var ') or contains(@class,' pr-d/oper ')][not(@importance) or @importance='required']" mode="add-to-groupcomp">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
        <xsl:apply-templates select="following-sibling::*[1]" mode="add-to-groupcomp"/>
    </xsl:template>
    
    <!-- Ensure revision text doesn't fall into diagram -->
    <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]//
        *[contains(@class, ' ditaot-d/ditaval-startprop ') or contains(@class,' ditaot-d/ditaval-endprop ')]//startflag">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="alt-text">
                <xsl:attribute name="alt"><xsl:value-of select="alt-text"/></xsl:attribute>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]//
        *[contains(@class, ' ditaot-d/ditaval-startprop ') or contains(@class,' ditaot-d/ditaval-endprop ')]//endflag">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="alt-text">
                <xsl:attribute name="alt"><xsl:value-of select="alt-text"/></xsl:attribute>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    <!-- Right now, no rev marking works in diagrams, but it can throw off spacing when extra elements show up.
         Suppress anything that doesn't apply to the whole diagram until we find a way to handle. -->
    <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]//
        *[contains(@class, ' ditaot-d/ditaval-startprop ') or contains(@class,' ditaot-d/ditaval-endprop ')]">
        <xsl:if test="parent::*[contains(@class,' pr-d/syntaxdiagram ')]">
            <xsl:next-match/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*|@*|text()|processing-instruction()|comment()" mode="groupcomp-child">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*|@*|text()|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>