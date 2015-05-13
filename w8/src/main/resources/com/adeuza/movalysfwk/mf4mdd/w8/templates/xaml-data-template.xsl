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


<xsl:template match="layout">

	<xsl:call-template name="xaml-file-start" />
	<xsl:call-template name="xaml-content" />
	<xsl:call-template name="xaml-file-close" />

</xsl:template>


<xsl:template name="xaml-content">	
	<xsl:text>&lt;DataTemplate x:Key="</xsl:text>
	<xsl:value-of select="name" />
	<xsl:text>"&gt;</xsl:text>
	<xsl:text>&lt;Grid x:Name="rootLayout"&gt;</xsl:text>
		<xsl:text>&lt;Grid.RowDefinitions&gt;</xsl:text>
			<xsl:apply-templates select="visualfields/visualfield"  mode="create-row-definition" />
			<xsl:if test="count(buttons) > 0">
				<xsl:text>&lt;RowDefinition Height="*" &#47;&gt;</xsl:text>
			</xsl:if>
		<xsl:text>&lt;&#47;Grid.RowDefinitions&gt;</xsl:text>		
		<xsl:if test="/layout/parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='FIXED_LIST'">
			<xsl:text>&lt;Grid.ColumnDefinitions&gt;</xsl:text>
                <xsl:text>&lt;ColumnDefinition Width="*"&#47;&gt;</xsl:text>
                <xsl:text>&lt;ColumnDefinition Width="Auto"&#47;&gt;</xsl:text>
            <xsl:text>&lt;&#47;Grid.ColumnDefinitions&gt;</xsl:text>
		</xsl:if>
	<xsl:apply-templates select="buttons" mode="display-buttons-without-navigation" />
	<xsl:call-template name="create-visual-fields" />
	<xsl:call-template name="xaml-delete-button" />
	<xsl:text>&lt;&#47;Grid&gt;</xsl:text>
	<xsl:text>&lt;&#47;DataTemplate&gt;</xsl:text>
</xsl:template>


<xsl:template name="xaml-delete-button">
	<xsl:if test="/layout/parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='FIXED_LIST'">
		<xsl:text>&lt;mf:MFButton Grid.RowSpan="2147483647" Grid.Column="1"</xsl:text> 
           <xsl:text> HorizontalAlignment="Center"</xsl:text> 
           <xsl:text> VerticalAlignment="Center"</xsl:text>
           <xsl:text> Tag="{Binding Path=Id_id}"</xsl:text>
           <xsl:text> mf:ButtonContent="Delete"&gt;</xsl:text>
           <xsl:text>&lt;mf:MFButton.FWKEvents&gt;</xsl:text>
           <xsl:text>&lt;mf:EventManagerCollection&gt;</xsl:text>
           <xsl:text>&lt;mf:EventManager EventName="Tapped" MethodName="Lst</xsl:text>
           <xsl:value-of select="/layout/visualfields/visualfield/parameters/parameter[@name='fixedListVm']"/>
           <xsl:text>DeleteButton_Tapped"&#47;&gt;</xsl:text>
           <xsl:text>&lt;&#47;mf:EventManagerCollection&gt;</xsl:text>
           <xsl:text>&lt;&#47;mf:MFButton.FWKEvents&gt;</xsl:text>
        <xsl:text>&lt;&#47;mf:MFButton&gt;</xsl:text>
    </xsl:if>
</xsl:template>


<xsl:template name="create-visual-fields">
	<xsl:choose>
		<xsl:when test="/layout/parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED'">
			<xsl:for-each select="visualfields/visualfield">
				<xsl:if test="parameters/parameter[@name='inCombo']='true'">
					<xsl:apply-templates select="."  mode="display-visualfields" />
				</xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="visualfields/visualfield"  mode="display-visualfields" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="xaml-file-start">

	<xsl:text>&lt;ResourceDictionary </xsl:text>
	<xsl:text> xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"</xsl:text>
	<xsl:text> xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"</xsl:text>
   	<xsl:text> xmlns:mf="using:mdk_common.UI" </xsl:text>
	<xsl:text> xmlns:conv="using:mdk_common.Converters"&gt;</xsl:text>
	<xsl:text>&lt;ResourceDictionary.MergedDictionaries&gt;</xsl:text>
	<xsl:if test="ExternalAdapters/adapter or adapter">
		<xsl:apply-templates select="adapter/layouts/layout[@id = 'listitem1']" mode="include-data-template" />
		<xsl:apply-templates select="ExternalAdapters/adapter/layouts/layout" mode="include-data-template" />
	</xsl:if>
	<xsl:apply-templates select="visualfields/visualfield/parameters"/>
	<xsl:text>&lt;&#47;ResourceDictionary.MergedDictionaries&gt;</xsl:text>
	
	<xsl:text>&lt;conv:BoolToVisibility x:Key="BoolToVisibility" &#47;&gt;</xsl:text>
	<xsl:text>&lt;conv:ErrorMessageConverter x:Key="ErrorMessageConverter" &#47;&gt;</xsl:text>
	<xsl:text>&lt;conv:DateTimeToDateTimeOffsetConverter x:Key="DateTimeToDateTimeOffsetConverter" &#47;&gt;</xsl:text>
</xsl:template>


<xsl:template match="parameters">
	<xsl:if test="parameter/@name = 'enum'">
		<xsl:text>&lt;ResourceDictionary Source="../DataTemplates/</xsl:text>
		<xsl:value-of select="parameter"/>
		<xsl:text>_radioenum_datatemplate.xaml"/&gt;</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template name="xaml-file-close">
	<xsl:text>&lt;&#47;ResourceDictionary&gt;</xsl:text>
</xsl:template>

</xsl:stylesheet>