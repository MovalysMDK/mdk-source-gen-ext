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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		
<!-- DTN - EN COURS DE TRAITEMENT -->

				
<xsl:template match="visualfield[component = 'MFFixedList']" mode="create-component">

		<xsl:text>&lt;mf:MFFixedList x:Name="</xsl:text>
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="property-name-c"/>
			<xsl:with-param name="replace" select="'.'"/>
			<xsl:with-param name="by" select="'_'"/>
		</xsl:call-template>
		<xsl:text>" Grid.Row="</xsl:text>
		<xsl:value-of select="component-position"/>
		<xsl:text>" Grid.Column="0"</xsl:text>
		<xsl:text> mf:Value="{Binding Path=</xsl:text>
		<xsl:value-of select="viewmodel-interface-name"/>
		<xsl:text>, Mode=TwoWay}"</xsl:text>
		<xsl:apply-templates select="../../ExternalAdapters/adapter" mode="external-adapter">
			<xsl:with-param name="listName"><xsl:value-of select="parameters/parameter[@name = 'fixedListVm']" /></xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="../../buttons/button[@type='SAVE']">
			<xsl:text> mf:OnValidationCommand="{Binding SaveCommand}"</xsl:text>
		</xsl:if>
		<xsl:text>&#47;&gt;</xsl:text>
</xsl:template>


<xsl:template match="adapter" mode="external-adapter">
	<xsl:param name="listName"/>

	<xsl:if test="viewmodel/full-name = $listName">
		<xsl:text> mf:PopupTemplate="{StaticResource </xsl:text>
		<xsl:value-of select="layouts/layout[@id = 'selitem']/name" />
		<xsl:text>}"</xsl:text>
		<xsl:text> mf:ItemTemplate="{StaticResource </xsl:text>
		<xsl:value-of select="layouts/layout[@id = 'listitem']/name" />
		<xsl:text>}"</xsl:text>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>