<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:svg="http://www.w3.org/2000/svg" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:syntaxdiagram-svgobject="http://www.moldflow.com/namespace/2008/plus-allhtml-syntaxdiagram-svgobject" 
    xmlns:svgobject="http://www.moldflow.com/namespace/2008/dita/svgobject" 
    xmlns:syntaxdiagram2svg="http://www.moldflow.com/namespace/2008/syntaxdiagram2svg" 
    xmlns:dcs="http://rtpdoc01.rtp.raleigh.ibm.com:9082/kc/dcs"
    exclude-result-prefixes="syntaxdiagram-svgobject syntaxdiagram2svg xs dcs">

    
<xsl:import href="plugin:com.moldflow.dita.syntaxdiagram2svg:xsl/syntaxdiagram2svg.xsl"/>

    <xsl:param name="plus-syntaxdiagram-format" select="&apos;svgobject&apos;"></xsl:param>
    <xsl:param name="plus-allhtml-syntaxdiagram-svgobject-csspath" select="&apos;&apos;"></xsl:param>
    <xsl:param name="plus-allhtml-syntaxdiagram-svgobject-jspath" select="&apos;&apos;"></xsl:param>

    <xsl:param name="CURRENTDIR"></xsl:param>
    <xsl:param name="CURRENTFILE"></xsl:param>

    <xsl:variable name="syntaxnewline"><xsl:text>
</xsl:text></xsl:variable>

    <!-- Entry point. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/syntaxdiagram &apos;)]">
        <xsl:choose>
          <xsl:when test="$plus-syntaxdiagram-format = &apos;svgobject&apos;">
            <xsl:apply-templates select="." mode="syntaxdiagram-svgobject:default"></xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:next-match>
              <xsl:fallback>
                <xsl:message terminate="no">
                  <xsl:text>syntaxdiagram-svgobject: cannot fall back in XSLT 1.0.</xsl:text>
                </xsl:message>
              </xsl:fallback>
            </xsl:next-match>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Top-level syntax diagram elements. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/syntaxdiagram &apos;)]" mode="syntaxdiagram-svgobject:default">
        <fig dcs:outputclass="syntaxdiagram">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">- topic/fig </xsl:attribute>
            <!--<xsl:call-template name="commonattributes"></xsl:call-template>
            <xsl:call-template name="setidaname"></xsl:call-template>
            <xsl:call-template name="flagcheck"></xsl:call-template>-->
            <xsl:call-template name="syntaxdiagram-svgobject:process-children"></xsl:call-template>
            <xsl:if test=".//*[contains(@class,' pr-d/synnote ')]|.//*[contains(@class,' pr-d/synnoteref ')]">
                <xsl:variable name="collectnotes" as="element()">
                    <wrapper><xsl:apply-templates mode="collect-synnotes"/></wrapper>
                </xsl:variable>
                <figgroup class="- topic/figgroup ">
                    <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
                    <title class="- topic/title ">
                        <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Notes'"/>
                        </xsl:call-template>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'ColonSymbol'"/>
                        </xsl:call-template>
                    </title>
                    <sl class="- topic/sl ">
                        <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
                        <xsl:apply-templates select="$collectnotes" mode="synnote-list"/></sl>
                </figgroup>
            </xsl:if>
        </fig>
    </xsl:template>
    
    <xsl:template match="*" mode="collect-synnotes">
        <xsl:apply-templates select="*" mode="collect-synnotes"/>
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/synnote ')][not(@id)]" mode="collect-synnotes">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/synnoteref ')]" mode="collect-synnotes">
        <xsl:variable name="noteid" select="substring-after(@href,'/')"/>
        <xsl:if test="generate-id(.)=
            generate-id((ancestor::*[contains(@class,' pr-d/syntaxdiagram ')]//*[contains(@class,' pr-d/synnoteref ')]
                                [substring-after(@href,'/') = $noteid])[1])">
            <xsl:copy-of select="ancestor::*[contains(@class,' pr-d/syntaxdiagram ')]//*[contains(@class,' pr-d/synnote ')][@id=$noteid]"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="wrapper" mode="synnote-list">
        <xsl:apply-templates mode="synnote-list"></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="text()" mode="synnote-list"/>
    
    <xsl:template match="*[contains(@class,' pr-d/synnote ')]" mode="synnote-list">
        <sli class="- topic/sli ">
            <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
            <xsl:choose>
                <xsl:when test="@callout"><sup class="+ topic/ph hi-d/sup "><xsl:value-of select="@callout"/></sup></xsl:when>
                <!-- Originally used position() instead of count(). Resulted in double count, first note was 2, second was 4. --> 
                <xsl:otherwise><sup class="+ topic/ph hi-d/sup "><xsl:value-of select="number(count(preceding-sibling::*)+1)"/></sup></xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:copy-of select="text()|*|processing-instruction()"/>
        </sli>
    </xsl:template>

    <xsl:template match="*[contains(@class, &apos; pr-d/synblk &apos;)]" mode="syntaxdiagram-svgobject:default">
        <figgroup class="- topic/figgroup " outputclass="synblk">
            <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
            <!--<xsl:attribute name="class">synblk</xsl:attribute>
            <xsl:call-template name="commonattributes"></xsl:call-template>
            <xsl:call-template name="setidaname"></xsl:call-template>
            <xsl:call-template name="flagcheck"></xsl:call-template>-->
            <xsl:call-template name="syntaxdiagram-svgobject:process-children"></xsl:call-template>
        </figgroup>
    </xsl:template>

    <xsl:template match="*[contains(@class, &apos; pr-d/fragment &apos;)]" mode="syntaxdiagram-svgobject:default">
        <figgroup class="- topic/figgroup " outputclass="fragment">
            <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
            <!--<xsl:attribute name="class">fragment</xsl:attribute>
            <xsl:call-template name="commonattributes"></xsl:call-template>
            <xsl:call-template name="setidaname"></xsl:call-template>
            <xsl:call-template name="flagcheck"></xsl:call-template>-->
            <xsl:call-template name="syntaxdiagram-svgobject:process-children"></xsl:call-template>
        </figgroup>
    </xsl:template>

    <!-- Break the syntax diagram into SVG- and HTML-bits. -->
    <xsl:template name="syntaxdiagram-svgobject:process-children">
        <xsl:for-each select="*">
            <xsl:choose>
                <xsl:when test="contains(@class, &apos; topic/title &apos;)                     or contains(@class, &apos; pr-d/syntaxdiagram &apos;)                     or contains(@class, &apos; pr-d/synblk &apos;)                     or contains(@class, &apos; pr-d/fragment &apos;)">
                    <!-- syntaxdiagram, synblk, fragment all live in HTML land. -->
                    <xsl:apply-templates select="." mode="syntaxdiagram-svgobject:default"></xsl:apply-templates>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::*) = 0 or                     preceding-sibling::*[1][                     contains(@class, &apos; topic/title &apos;)                     or contains(@class, &apos; pr-d/syntaxdiagram &apos;)                     or contains(@class, &apos; pr-d/synblk &apos;)                     or contains(@class, &apos; pr-d/fragment &apos;)]">
                    <!-- Other elements start a syntax diagram. -->
                    <figgroup class="- topic/figgroup " outputclass="syntaxdiagram-piece">
                        <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
                        <xsl:variable name="syntax-pieces" as="element()">
                            <!-- Collects pieces that will be in this fragment, for evaluation in accessible portion -->
                            <wrapper><xsl:apply-templates select="." mode="syntaxdiagram2svg:collect-for-a11y"/></wrapper>
                        </xsl:variable>
                        <!--<xsl:attribute name="class">syntaxdiagram-piece</xsl:attribute>-->

                        <xsl:apply-templates select="." mode="svgobject:generate-reference">
                          <xsl:with-param name="content">
                            <xsl:call-template name="syntaxdiagram2svg:create-svg-document">
                               <xsl:with-param name="CSSPATH">
                                   <xsl:call-template name="svgobject:svgobject-reverse-path"></xsl:call-template>
                                   <xsl:value-of select="$plus-allhtml-syntaxdiagram-svgobject-csspath"></xsl:value-of>
                               </xsl:with-param>
                               <xsl:with-param name="JSPATH">
                                   <xsl:call-template name="svgobject:svgobject-reverse-path"></xsl:call-template>
                                   <xsl:value-of select="$plus-allhtml-syntaxdiagram-svgobject-jspath"></xsl:value-of>
                               </xsl:with-param>
                               <xsl:with-param name="BASEPATH">
                                   <xsl:call-template name="svgobject:svgobject-reverse-path"></xsl:call-template>
                                   <xsl:value-of select="escape-html-uri($CURRENTDIR)"></xsl:value-of>
                                   <xsl:text>/</xsl:text>
                                   <xsl:value-of select="replace(escape-html-uri($CURRENTFILE), &apos;\.(xml|dita)$&apos;, $OUTEXT, &apos;i&apos;)"></xsl:value-of>
                               </xsl:with-param>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="textversion">
                              <xsl:apply-templates select="$syntax-pieces" mode="syntaxdiagram2svg:create-accessible-version"/>
                          </xsl:with-param>
                          <xsl:with-param name="make-static" select="&apos;yes&apos;"></xsl:with-param>
                        </xsl:apply-templates>
                    </figgroup>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="wrapper" mode="syntaxdiagram2svg:create-accessible-version">
        <!--<xsl:apply-templates select="." mode="syntaxdiagram2svg:create-accessible-version"/>-->
        <xsl:apply-templates select="*[1]" mode="syntaxdiagram2svg:create-accessible-version">
            <xsl:with-param name="prefix" select="''" as="xs:string"/>
            <xsl:with-param name="grouplevel" select="'1'"/>
        </xsl:apply-templates>        
    </xsl:template>
    
    <xsl:template match="*" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'1'"/>
        <xsl:apply-templates select="*" mode="syntaxdiagram2svg:create-accessible-version">
            <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
            <xsl:with-param name="grouplevel" select="$grouplevel"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*" mode="accessible-prefix">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'1'"/>
        <xsl:choose>
            <xsl:when test="parent::*[contains(@class,' pr-d/groupcomp ') or contains(@class,' pr-d/groupseq ')] and
                not(preceding-sibling::*[contains(@class,' pr-d/groupchoice ')])"/>
            <xsl:when test="not(preceding-sibling::*) or 
                            preceding-sibling::*[contains(@class,' pr-d/groupchoice ')] or 
                            parent::*[contains(@class,' pr-d/groupchoice ')]">
                <xsl:value-of select="$syntaxnewline"/>
                <xsl:value-of select="if ($prefix='') then ($grouplevel) else (concat($prefix,'.',$grouplevel))"/>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@importance='default'">!</xsl:when>
            <xsl:when test="@importance='optional'">?</xsl:when>
            <xsl:when test="@importance='required'"></xsl:when>
        </xsl:choose>
        <xsl:if test="not(parent::*[contains(@class,' pr-d/groupcomp ')]) and
                      not(contains(@class,' pr-d/repsep '))"><xsl:text> </xsl:text></xsl:if>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/fragref ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="''"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:text>%</xsl:text>
        <xsl:value-of select="."/>
        <xsl:if test="parent::wrapper">
          <xsl:apply-templates select="following-sibling::*[1]" mode="syntaxdiagram2svg:create-accessible-version">
            <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
            <xsl:with-param name="grouplevel" select="$grouplevel"/>
          </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/groupcomp ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="''"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:apply-templates select="*" mode="syntaxdiagram2svg:create-accessible-version">
            <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
            <xsl:with-param name="grouplevel" select="$grouplevel"/>
        </xsl:apply-templates>
        <xsl:if test="parent::wrapper">
          <xsl:apply-templates select="following-sibling::*[1]" mode="syntaxdiagram2svg:create-accessible-version">
              <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
              <xsl:with-param name="grouplevel" select="$grouplevel"/>
          </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/groupseq ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:apply-templates select="*" mode="syntaxdiagram2svg:create-accessible-version">
            <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
            <xsl:with-param name="grouplevel" select="$grouplevel"/>
        </xsl:apply-templates>
        <xsl:if test="parent::wrapper">
          <xsl:apply-templates select="following-sibling::*[1]" mode="syntaxdiagram2svg:create-accessible-version">
              <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
              <xsl:with-param name="grouplevel" select="$grouplevel"/>
          </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/groupchoice ')]" mode="syntaxdiagram2svg:create-accessible-version">
      <xsl:param name="prefix" select="''" as="xs:string"/>
      <xsl:param name="grouplevel" select="''"/>
      <xsl:variable name="newgrouplevel" select="number($grouplevel) + 1"/>
      <xsl:apply-templates select="*" mode="syntaxdiagram2svg:create-accessible-version">
        <!--<xsl:with-param name="prefix" select="if ($prefix='') then ($newgrouplevel) else (concat($prefix,'.',$newgrouplevel))" as="xs:string"/>-->
          <xsl:with-param name="prefix" as="xs:string">
              <xsl:choose>
                  <xsl:when test="parent::wrapper"><xsl:value-of select="$prefix"/></xsl:when>
                  <xsl:when test="$prefix=''"><xsl:value-of select="$newgrouplevel"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="concat($prefix,'.',$newgrouplevel)"/></xsl:otherwise>
              </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="grouplevel" select="'1'"/>
      </xsl:apply-templates>
        <xsl:if test="parent::wrapper">
            <xsl:apply-templates select="following-sibling::*[1]" mode="syntaxdiagram2svg:create-accessible-version">
              <xsl:with-param name="prefix" select="$prefix" as="xs:string"/>
              <xsl:with-param name="grouplevel" select="$newgrouplevel"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' pr-d/repsep ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:value-of select="concat('+ ',.)"/>
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/kwd ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:value-of select="."/>
        <!--<xsl:value-of select="$syntaxnewline"/>-->
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/delim ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:value-of select="."/>
        <!--<xsl:value-of select="$syntaxnewline"/>-->
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/oper ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:value-of select="."/>
        <!--<xsl:value-of select="$syntaxnewline"/>-->
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/sep ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <xsl:value-of select="."/>
        <!--<xsl:value-of select="$syntaxnewline"/>-->
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/var ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:param name="prefix" select="''" as="xs:string"/>
        <xsl:param name="grouplevel" select="'0'"/>
        <xsl:apply-templates select="." mode="accessible-prefix"><xsl:with-param name="prefix" select="$prefix" as="xs:string"/><xsl:with-param name="grouplevel" select="$grouplevel"/></xsl:apply-templates>
        <i class="+ topic/ph hi-d/i "><xsl:value-of select="."/></i>
        <!--<xsl:value-of select="$syntaxnewline"/>-->
    </xsl:template>
    <xsl:template match="*[contains(@class,' pr-d/synnote ') or contains(@class,' pr-d/synnoteref ')]" mode="syntaxdiagram2svg:create-accessible-version">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="syntaxdiagram2svg:create-accessible-version"/>

    <!-- Title for syntaxdiagram. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/syntaxdiagram &apos;)]/*[contains(@class, &apos; topic/title &apos;)]" mode="syntaxdiagram-svgobject:default">
        <title class="- topic/title " outputclass="syntaxdiagram-title">
            <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
            <!--<xsl:attribute name="class">syntaxdiagram-title</xsl:attribute>
            <xsl:call-template name="commonattributes"></xsl:call-template>
            <xsl:call-template name="setidaname"></xsl:call-template>
            <xsl:call-template name="flagcheck"></xsl:call-template>-->
            <xsl:apply-templates></xsl:apply-templates>
        </title>
    </xsl:template>

    <!-- Title for synblk. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/synblk &apos;)]/*[contains(@class, &apos; topic/title &apos;)]" mode="syntaxdiagram-svgobject:default">
        <title class="- topic/title " outputclass="synblk-title">
            <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
            <!--<xsl:attribute name="class">synblk-title</xsl:attribute>
            <xsl:call-template name="commonattributes"></xsl:call-template>
            <xsl:call-template name="setidaname"></xsl:call-template>
            <xsl:call-template name="flagcheck"></xsl:call-template>-->
            <xsl:apply-templates></xsl:apply-templates>
        </title>
    </xsl:template>

    <!-- Title for fragment. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/fragment &apos;)]/*[contains(@class, &apos; topic/title &apos;)]" mode="syntaxdiagram-svgobject:default">
        <title class="- topic/title " outputclass="fragment-title">
            <xsl:copy-of select="ancestor-or-self::*[@xtrf][1]/@xtrf | ancestor-or-self::*[@xtrc][1]/@xtrc"/>
            <!--<xsl:attribute name="class">fragment-title</xsl:attribute>
            <xsl:call-template name="commonattributes"></xsl:call-template>
            <xsl:call-template name="setidaname"></xsl:call-template>
            <xsl:call-template name="flagcheck"></xsl:call-template>-->
            <xsl:apply-templates></xsl:apply-templates>
        </title>
    </xsl:template>

    <!-- Override fragref processing: XHTML contents as hyperlink. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/fragref &apos;)]" mode="syntaxdiagram2svg:body-only">
        <xsl:param name="role" select="&apos;forward&apos;"></xsl:param>
        <xsl:call-template name="syntaxdiagram2svg:append-notes">
            <xsl:with-param name="contents">
                <svg:a syntaxdiagram2svg:dispatch="boxed">
                    <xsl:attribute name="class">
                        <xsl:text>boxed </xsl:text>
                        <xsl:value-of select="local-name()"></xsl:value-of>
                    </xsl:attribute>
                    <xsl:attribute name="syntaxdiagram2svg:element">
                        <xsl:value-of select="local-name()"></xsl:value-of>
                    </xsl:attribute>
                    <xsl:attribute name="syntaxdiagram2svg:role">
                        <xsl:value-of select="$role"></xsl:value-of>
                    </xsl:attribute>
                    <xsl:call-template name="syntaxdiagram2svg:box-contents"></xsl:call-template>
                </svg:a>
                </xsl:with-param>
            <xsl:with-param name="role" select="$role"/>
        </xsl:call-template>
    </xsl:template>

    <!-- Override fragref processing: XHTML contents as hyperlink. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/fragref &apos;)]" mode="syntaxdiagram2svg:groupcomp-child">
        <xsl:param name="role" select="&apos;forward&apos;"></xsl:param>
        <svg:a syntaxdiagram2svg:dispatch="unboxed" syntaxdiagram2svg:role="forward">
            <xsl:attribute name="class">
                <xsl:text>unboxed </xsl:text>
                <xsl:value-of select="local-name()"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="syntaxdiagram2svg:element">
                <xsl:value-of select="local-name()"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="syntaxdiagram2svg:role">
                <xsl:value-of select="$role"></xsl:value-of>
            </xsl:attribute>
            <!--<xsl:attribute name="xlink:href">
              <xsl:call-template name="href"></xsl:call-template>
            </xsl:attribute>-->
<!--
            <xsl:if test="$plus-syntaxdiagram-format = 'svgobject'">
                <xsl:attribute name="target" select="'_parent'"/>
            </xsl:if>
-->
            <xsl:call-template name="syntaxdiagram2svg:box-contents"></xsl:call-template>
        </svg:a>
    </xsl:template>

    <!-- Override synnote processing: XHTML contents as hyperlink. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/synnote &apos;)][not(@id)]" mode="syntaxdiagram2svg:note">
        <svg:a syntaxdiagram2svg:dispatch="note" class="note">
            <!--<xsl:attribute name="xlink:href">
                <xsl:call-template name="syntaxdiagram-svgobject:get-footnote-target"></xsl:call-template>
            </xsl:attribute>-->
<!--
            <xsl:if test="$plus-syntaxdiagram-format = 'svgobject'">
                <xsl:attribute name="target" select="'_parent'"/>
            </xsl:if>
-->
            <svg:text>
                <!--<xsl:call-template name="syntaxdiagram2svg:get-callout"></xsl:call-template>-->
                <xsl:apply-templates select="." mode="get-synnote-callout"/>
            </svg:text>
        </svg:a>
    </xsl:template>
    
    <xsl:template match="*" mode="get-synnote-callout">
        <xsl:choose>
            <xsl:when test="@callout"><xsl:value-of select="@callout"/></xsl:when>
            <xsl:otherwise>
                <xsl:variable name="synid" select="generate-id(ancestor::syntaxdiagram)"/>
                <xsl:variable name="synnotes">
                    <xsl:for-each select="preceding::*[contains(@class,' pr-d/synnoteref ')][generate-id(ancestor::*[contains(@class,' pr-d/syntaxdiagram ')])=$synid]">
                        <xsl:variable name="matchref" select="@href"/>
                        <xsl:if test="not(preceding::*[contains(@class,' pr-d/synnoteref ')][@href=$matchref])">1</xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="count(preceding::*[contains(@class,' pr-d/synnote ')][not(@id)][generate-id(ancestor::*[contains(@class,' pr-d/syntaxdiagram ')])=$synid])+string-length($synnotes)+1"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Override synnote processing: XHTML contents as hyperlink. -->
    <xsl:template match="*[contains(@class, &apos; pr-d/synnote &apos;)][not(@id)]" mode="syntaxdiagram2svg:groupcomp-child">
        <svg:a syntaxdiagram2svg:dispatch="note" class="note">
            <!--<xsl:attribute name="xlink:href">
                <xsl:call-template name="syntaxdiagram-svgobject:get-footnote-target"></xsl:call-template>
            </xsl:attribute>-->
<!--
            <xsl:if test="$plus-syntaxdiagram-format = 'svgobject'">
                <xsl:attribute name="target" select="'_parent'"/>
            </xsl:if>
-->
            <svg:text>
                <!--<xsl:call-template name="syntaxdiagram2svg:get-callout"></xsl:call-template>-->
                <xsl:apply-templates select="." mode="get-synnote-callout"/>
            </svg:text>
        </svg:a>
    </xsl:template>

    <xsl:template name="syntaxdiagram-svgobject:get-footnote-target">
        <xsl:text>#fntarg_</xsl:text>
        <xsl:number format="1" count="*[contains(@class, &apos; topic/fn &apos;)]" from="/*" level="any"></xsl:number>
    </xsl:template>

    <xsl:template match="*[contains(@class, &apos; pr-d/synnoteref &apos;)][@href and @href != &apos;&apos;]" mode="syntaxdiagram2svg:note">
        <svg:a syntaxdiagram2svg:dispatch="note" class="note">
            <!--<xsl:attribute name="xlink:href">
                <xsl:call-template name="syntaxdiagram-svgobject:get-footnote-reference-target"></xsl:call-template>
            </xsl:attribute>-->
<!--
            <xsl:if test="$plus-syntaxdiagram-format = 'svgobject'">
                <xsl:attribute name="target" select="'_parent'"/>
            </xsl:if>
-->
            <svg:text>
                <!--<xsl:call-template name="syntaxdiagram2svg:get-callout-reference"></xsl:call-template>-->
                <xsl:value-of select="."/>
            </svg:text>
        </svg:a>
    </xsl:template>

    <xsl:template match="*[contains(@class, &apos; pr-d/synnoteref &apos;)][@href and @href != &apos;&apos;]" mode="syntaxdiagram2svg:groupcomp-child">
        <svg:a syntaxdiagram2svg:dispatch="note" class="note">
            <!--<xsl:attribute name="xlink:href">
                <xsl:call-template name="syntaxdiagram-svgobject:get-footnote-reference-target"></xsl:call-template>
            </xsl:attribute>-->
<!--
            <xsl:if test="$plus-syntaxdiagram-format = 'svgobject'">
                <xsl:attribute name="target" select="'_parent'"/>
            </xsl:if>
-->
            <svg:text>
                <!--<xsl:call-template name="syntaxdiagram2svg:get-callout-reference"></xsl:call-template>-->
                <xsl:value-of select="."/>
            </svg:text>
        </svg:a>
    </xsl:template>

    <xsl:template name="syntaxdiagram-svgobject:get-footnote-reference-target">
        <!-- To do?: hyperlink to a footnote in a different file. -->
        <xsl:choose>
            <xsl:when test="contains(@href, &apos;#&apos;)">
                <xsl:variable name="document" select="substring-before(@href, &apos;#&apos;)"></xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains(substring-after(@href, &apos;#&apos;), &apos;/&apos;)">
                        <xsl:variable name="topicid" select="substring-before(substring-after(@href, &apos;#&apos;), &apos;/&apos;)"></xsl:variable>
                        <xsl:variable name="targetid" select="substring-after(substring-after(@href, &apos;#&apos;), &apos;/&apos;)"></xsl:variable>
                        <xsl:value-of select="concat(&apos;#&apos;, $topicid, &apos;__&apos;, $targetid)"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>synnoteref points at entire topic.</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>synnoteref href points at entire file.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>