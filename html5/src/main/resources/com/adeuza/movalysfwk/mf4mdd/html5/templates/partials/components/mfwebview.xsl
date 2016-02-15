<?xml version="1.0" encoding="UTF-8"?>
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  extension-element-prefixes="xsi">


    <xsl:template match="HTML-attribute[visualfield/component='MFWebView']" mode="partial-component-generation"  priority="1000">
        <xsl:param name="viewModel"/>
        <xsl:param name="overide-text"/>
        <xsl:param name="ignoreFormAttribute">false</xsl:param>



        <xsl:comment> Optional : mf-hide-label</xsl:comment>

        <xsl:text disable-output-escaping="yes"> &lt;div mf-webview mf-field="</xsl:text>

        <xsl:choose>
            <xsl:when test="$viewModel and $viewModel != ''">
                <xsl:value-of select="$viewModel"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>viewModel</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>.</xsl:text>
        <xsl:choose>
            <xsl:when test="not($overide-text='')">
                <xsl:value-of select="$overide-text"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="field-name"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>"</xsl:text>

        <xsl:choose>
            <xsl:when test="visualfield/create-label = 'false'">
                <xsl:text>mf-hide-label="true"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>mf-label="</xsl:text><xsl:value-of select="visualfield/label"/><xsl:text>"</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$ignoreFormAttribute = 'false'">
            <xsl:text>mf-form="</xsl:text><xsl:value-of select="../../viewName"/>Form<xsl:text>"</xsl:text>
        </xsl:if>

        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>

        <xsl:text disable-output-escaping="yes"> &lt;/div&gt;</xsl:text>



    </xsl:template>

</xsl:stylesheet>