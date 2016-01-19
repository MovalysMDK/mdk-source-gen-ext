<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:template match="viewmodel" mode="compute-update-method-name">
        <xsl:text>update</xsl:text><xsl:value-of select="implements/interface/@name"/>
        <xsl:for-each select="./external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text>WithLst</xsl:text><xsl:value-of select="./entity-to-update/name"/>
        </xsl:for-each>
        <xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text>WithLst</xsl:text><xsl:value-of select="./entity-to-update/name"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="compute-update-method-name">
        <xsl:text>update</xsl:text><xsl:value-of select="type/item"/>
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