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
	<xsl:output method="text"/>
	
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>

	<xsl:template match="dataloader-interface">
		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="data-loader-imports"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;summary&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///DataLoader object use to load data for </xsl:text><xsl:value-of select="name"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;&#47;summary&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;namespace </xsl:text><xsl:value-of select="package"/>
		<xsl:text>{</xsl:text>
		<xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]</xsl:text>
		<xsl:call-template name="start-class" />
		<xsl:apply-templates select="combos/combo" mode="combo-getter" />
		
		<!-- custom methods -->
		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">other-methods</xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>}}</xsl:text>
	</xsl:template>
	
	<xsl:template name="start-class">
		<xsl:text>public interface </xsl:text><xsl:value-of select="name"/><xsl:text> : </xsl:text>
		<xsl:apply-templates select="." mode="abstract-interface"/>
		<xsl:text>&lt;</xsl:text><xsl:value-of select="entity-type/name"/><xsl:text>&gt; </xsl:text>	
		<xsl:text>{</xsl:text>
	</xsl:template>	
	
	<!--  COMBO GETTER -->
	<xsl:template match="combo" mode="combo-getter">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;summary&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///Method to get ComboBox content</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;&#47;summary&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;returns&gt;return a list of </xsl:text><xsl:value-of select="entity"/><xsl:text>&lt;&#47;returns&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>List&lt;</xsl:text><xsl:value-of select="entity"/><xsl:text>&gt; GetList</xsl:text><xsl:value-of select="entity-getter-name"/><xsl:text>();&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-interface[type='SINGLE' or type='WORKSPACE']" mode="abstract-interface">
        <xsl:text>IDataLoader</xsl:text>
	</xsl:template>
	
		
	<xsl:template match="dataloader-interface[type='LIST']" mode="abstract-interface">
       	<xsl:text>IListDataLoader</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-interface" mode="abstract-interface" priority="-900">
	</xsl:template>
</xsl:stylesheet>