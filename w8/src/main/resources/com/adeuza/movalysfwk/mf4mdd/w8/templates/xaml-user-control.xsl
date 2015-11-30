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

<xsl:include href="ui/visual-fields.xsl"/>
<xsl:include href="ui/component/button.xsl"/>

<!-- MAIN TEMPLATE -->
<xsl:template match="layout">

	<xsl:call-template name="xaml-file-start" />
		
	<xsl:call-template name="xaml-resource" />
		
	<xsl:call-template name="xaml-content" />
	
	<xsl:call-template name="xaml-file-close" />

</xsl:template>


<!-- TEMPLATE DE BASE -->
<xsl:template name="xaml-file-start">

	<xsl:text>&lt;</xsl:text><xsl:call-template name="IsList" /><xsl:text> x:Class="</xsl:text><xsl:value-of select="package"/><xsl:text>.</xsl:text><xsl:value-of select="shortname"/><xsl:text>" </xsl:text>
	<xsl:text>xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" </xsl:text>
	<xsl:text>xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" </xsl:text>
	<xsl:text>xmlns:d="http://schemas.microsoft.com/expression/blend/2008" </xsl:text>
	<xsl:text>xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" </xsl:text>
   	<xsl:text>xmlns:mf="using:mdk_windows8.UI" </xsl:text>
   	<xsl:text>xmlns:conv="using:mdk_common.Converters" </xsl:text>
	<xsl:text>mc:Ignorable="d" &gt;</xsl:text>
</xsl:template>

<xsl:template name="xaml-resource">
	<xsl:text>&lt;</xsl:text><xsl:call-template name="IsList" /><xsl:text>.Resources&gt;</xsl:text>
	<xsl:text>&lt;ResourceDictionary&gt;</xsl:text>
	<xsl:text>&lt;ResourceDictionary.MergedDictionaries&gt;</xsl:text>
	<xsl:if test="adapter or ExternalAdapters/adapter">
		<xsl:apply-templates select="adapter/layouts/layout" mode="data-template" />
		<xsl:apply-templates select="ExternalAdapters/adapter/layouts/layout" mode="data-template" />
	</xsl:if>
	<xsl:apply-templates select="visualfields/visualfield/parameters"/>
	<xsl:text>&lt;&#47;ResourceDictionary.MergedDictionaries&gt;</xsl:text>
	<xsl:text>&lt;conv:BoolToVisibility x:Key="BoolToVisibility"&#47;&gt;</xsl:text>
    <xsl:text>&lt;conv:StringFormatConverter x:Key="StringFormatConverter" &#47;&gt;</xsl:text>
    <xsl:text>&lt;conv:ErrorMessageConverter x:Key="ErrorMessageConverter" &#47;&gt;</xsl:text>
    <xsl:text>&lt;conv:DateTimeToDateTimeOffsetConverter x:Key="DateTimeToDateTimeOffsetConverter" &#47;&gt;</xsl:text>
	<xsl:text>&lt;&#47;ResourceDictionary&gt;</xsl:text>
	<xsl:text>&lt;&#47;</xsl:text><xsl:call-template name="IsList" /><xsl:text>.Resources&gt;</xsl:text>
</xsl:template>
	
<xsl:template match="parameters">
	<xsl:if test="parameter/@name = 'enum'">
		<xsl:text>&lt;ResourceDictionary Source="../DataTemplates/</xsl:text>
		<xsl:value-of select="parameter"/>
		<xsl:text>_radioenum_datatemplate.xaml"/&gt;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template name="xaml-content">
	<xsl:if test="/layout/in-workspace = 'true'">
		<xsl:text>&lt;ScrollViewer&gt;</xsl:text>
	</xsl:if>
	<xsl:text>&lt;Grid x:Name="rootLayout" Width="300" HorizontalAlignment="Center"&gt;</xsl:text>
		<xsl:text>&lt;Grid.RowDefinitions&gt;</xsl:text>
			<xsl:apply-templates select="visualfields/visualfield" mode="create-row-definition" />
			<xsl:if test="count(buttons) > 0">
				<xsl:text>&lt;RowDefinition Height="Auto" &#47;&gt;</xsl:text>
			</xsl:if>
		<xsl:text>&lt;&#47;Grid.RowDefinitions&gt;</xsl:text>			
		
	<xsl:apply-templates select="buttons" mode="display-buttons-without-navigation" />
		
	<xsl:apply-templates select="visualfields" mode="display-visualfields" />
		
	<xsl:text>&lt;&#47;Grid&gt;</xsl:text>
	<xsl:if test="/layout/in-workspace = 'true'">
		<xsl:text>&lt;&#47;ScrollViewer&gt;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template name="xaml-file-close">
	<xsl:text>&lt;&#47;</xsl:text><xsl:call-template name="IsList" /><xsl:text>&gt;</xsl:text>
</xsl:template>


<!-- TEMPLATE SPECIFIQUE -->	
<xsl:template match="ExternalAdapters/adapter/layouts/layout[@id = 'listitem']" mode="data-template" priority="200">
	<xsl:text>&lt;ResourceDictionary  Source="../DataTemplates/</xsl:text>
	<xsl:value-of select="full-name"/>
	<xsl:text>.xaml" &#47;&gt;</xsl:text>
</xsl:template>

<xsl:template match="ExternalAdapters/adapter/layouts/layout[@id = 'selitem']" mode="data-template" priority="200">
	<xsl:text>&lt;ResourceDictionary  Source="../DataTemplates/</xsl:text>
	<xsl:value-of select="full-name"/>
	<xsl:text>.xaml" &#47;&gt;</xsl:text>
</xsl:template>

<xsl:template match="adapter/layouts/layout[@id = 'listitem1']" mode="data-template" priority="200">
	<xsl:text>&lt;ResourceDictionary  Source="../DataTemplates/</xsl:text>
	<xsl:value-of select="full-name"/>
	<xsl:text>.xaml" &#47;&gt;</xsl:text>
</xsl:template>

<xsl:template match="adapter/layouts/layout[@id = 'listitem2']" mode="data-template" priority="200">
	<xsl:text>&lt;ResourceDictionary  Source="../DataTemplates/</xsl:text>
	<xsl:value-of select="full-name"/>
	<xsl:text>.xaml" &#47;&gt;</xsl:text>
</xsl:template>

<xsl:template match="adapter/layouts/layout[@id = 'listitem2_open']" mode="data-template" priority="200">
	<xsl:text>&lt;ResourceDictionary  Source="../DataTemplates/</xsl:text>
	<xsl:value-of select="full-name"/>
	<xsl:text>.xaml" &#47;&gt;</xsl:text>
</xsl:template>

<xsl:template match="adapter/layouts/layout" mode="data-template" priority="-999">
</xsl:template>

<xsl:template match="ExternalAdapters/adapter/layouts/layout" mode="data-template" priority="-999">
</xsl:template>

<xsl:template name="IsList">
	<xsl:choose>
		<xsl:when test="adapter">
			<xsl:text>mf:MFListUserControl</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>mf:MFUserControl</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>