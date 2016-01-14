<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:template match="viewmodel" mode="compute-update-method-name">
        <xsl:text>update</xsl:text><xsl:value-of select="implements/interface/@name"/><!--<xsl:value-of select="type/item"/>-->
        <xsl:for-each select="./external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text>WithLst</xsl:text><xsl:value-of select="./entity-to-update/name"/>
        </xsl:for-each>
        <xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text>WithLst</xsl:text><xsl:value-of select="./entity-to-update/name"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="viewmodel" mode="compute-update-method-parameter-declaration">
        <xsl:if test="entity-to-update">
            <xsl:value-of select="entity-to-update/name"/><xsl:text> data</xsl:text>
        </xsl:if>
        <xsl:for-each select="./external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text> ,List&lt;</xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>&gt; p_oLst</xsl:text>
            <xsl:value-of select="uml-name"/>
        </xsl:for-each>
        <xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text> ,List&lt;</xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>&gt; p_oLst</xsl:text>
            <xsl:value-of select="uml-name"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="viewmodel" mode="compute-update-method-parameter-call">
        <xsl:if test="entity-to-update">
            <xsl:text>dataLoader.GetData()</xsl:text>
        </xsl:if>
        <xsl:for-each select="./external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text> ,dataLoader.GetList</xsl:text><xsl:value-of select="./uml-name"/><xsl:text>()</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text> ,dataLoader.GetList</xsl:text><xsl:value-of select="./uml-name"/><xsl:text>()</xsl:text>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>