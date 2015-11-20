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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" />

    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/constructor.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>


    <xsl:template match="screen">

        <xsl:apply-templates select="." mode="file-header">
            <xsl:with-param name="fileName"><xsl:value-of select="name"/>Controller.cs</xsl:with-param>
        </xsl:apply-templates>

        <xsl:text>using </xsl:text><xsl:value-of select="./package" /><xsl:text>.ViewModel;&#13;</xsl:text>
        <xsl:apply-templates select="." mode="declare-impl-imports" />
        <xsl:call-template name="controller-imports"/>

        <xsl:text>&#13;&#13;</xsl:text>

        <xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
        <xsl:text>&#13;&#13;/// &lt;summary&gt;&#13;</xsl:text>
        <xsl:text>/// Class </xsl:text><xsl:value-of select="./name" /><xsl:text>Controller.&#13;</xsl:text>
        <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
        <xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]&#13;</xsl:text>
        <xsl:text>public class </xsl:text><xsl:value-of select="./name" /><xsl:text>Controller : MDKScreenController</xsl:text>
        <xsl:text>{</xsl:text>

        <xsl:text>&#13;&#13;#region Constructor&#13;</xsl:text>

        <xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text>Controller() {&#13;</xsl:text>

        <xsl:text>this.ViewModel = (</xsl:text><xsl:value-of select="vm"/><xsl:text>) ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="vm"/><xsl:text>&gt;();&#13;</xsl:text>
        <xsl:call-template name="non-generated-bloc">
            <xsl:with-param name="blocId">constructor</xsl:with-param>
        </xsl:call-template>
        <xsl:text>}&#13;&#13;</xsl:text>

        <xsl:text>&#13;#endregion&#13;</xsl:text>

        <xsl:text>&#13;#region Properties&#13;</xsl:text>

        <xsl:text>&#13;#endregion&#13;</xsl:text>

        <xsl:text>&#13;#region Methods&#13;</xsl:text>

        <xsl:text>&#13;#endregion&#13;</xsl:text>

        <xsl:text>}&#13;</xsl:text>
        <xsl:text>}&#13;</xsl:text>

    </xsl:template>

</xsl:stylesheet>