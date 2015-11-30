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

	<xsl:template name="xaml-content" mode="screen">

		<xsl:text>&lt;Grid x:Name="rootLayout"&gt;</xsl:text>
			<xsl:choose>
			  <xsl:when test="workspace = 'true'">
				<xsl:text>&lt;UserControl x:Name="workspace" Content="{Binding MFPanels[MFWorkspace]}" &#47;&gt;</xsl:text>
			  </xsl:when>
			  <xsl:when test="multi-panel = 'true'">
			  	<xsl:for-each select="pages/page">
					<xsl:text>&lt;UserControl x:Name="</xsl:text>
					<xsl:value-of select="name"/>
					<xsl:text>" Content="{Binding MFPanels[</xsl:text>
					<xsl:value-of select="name"/>
					<xsl:text>]}"&#47;&gt;</xsl:text>
				</xsl:for-each>
			  </xsl:when>
	  		  <xsl:when test="search-screen = 'true'">
			  </xsl:when>
			  <xsl:otherwise>
			  	<xsl:for-each select="pages/page">
					<xsl:text>&lt;uc:</xsl:text>
					<xsl:value-of select="name"/>
					<xsl:text> x:Name="</xsl:text>
					<xsl:value-of select="name"/>
					<xsl:text>"&#47;&gt;</xsl:text>
				</xsl:for-each>
			  </xsl:otherwise>
			</xsl:choose>		
		<xsl:text>&lt;&#47;Grid&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template name="xaml-resource" mode="screen">

		<xsl:choose>
		  <xsl:when test="workspace = 'true'">
			<xsl:text>&lt;mf:MFWorkspace.Resources&gt;</xsl:text>
			<xsl:apply-templates select="pages/page" />
		  </xsl:when>
		  <xsl:when test="multi-panel = 'true'">
			<xsl:text>&lt;mf:MFMultiPanels.Resources&gt;</xsl:text>
			<xsl:apply-templates select="pages/page" />
		  </xsl:when>
  		  <xsl:when test="search-screen = 'true'">
			<xsl:text>&lt;phone:PhoneApplicationPage.Resources&gt;</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:text>&lt;phone:PhoneApplicationPage.Resources&gt;</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>&lt;conv:BoolToVisibility x:Key="BoolToVisibility"&#47;&gt;</xsl:text>
        <xsl:text>&lt;conv:StringFormatConverter x:Key="StringFormatConverter" &#47;&gt;</xsl:text>
        <xsl:text>&lt;conv:ErrorMessageConverter x:Key="ErrorMessageConverter" &#47;&gt;</xsl:text>			
	</xsl:template>
	
	<xsl:template match="page" mode="screen">
		<xsl:text>&lt;System:String x:Key="MFP_</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>"&gt;</xsl:text>
		<xsl:value-of select="full-name"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="number(parameters/parameter[@name = 'grid-column-parameter'])"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="number(parameters/parameter[@name = 'grid-section-parameter'])"/>
		<xsl:text>&lt;&#47;System:String&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template name="xaml-file-start">
		<xsl:choose>
		  <xsl:when test="workspace = 'true'">
			<xsl:text>&lt;mf:MFWorkspace </xsl:text>
		  </xsl:when>
		  <xsl:when test="multi-panel = 'true'">
			<xsl:text>&lt;mf:MFMultiPanels </xsl:text>
		  </xsl:when>
  		  <xsl:when test="search-screen = 'true'">
			<xsl:text>&lt;phone:PhoneApplicationPage </xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:text>&lt;phone:PhoneApplicationPage </xsl:text>
		  </xsl:otherwise>
		</xsl:choose>


		<xsl:text>x:Class="</xsl:text><xsl:value-of select="package"/><xsl:text>.</xsl:text><xsl:value-of select="name"/><xsl:text>" </xsl:text>
		<xsl:text>xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" </xsl:text>
		<xsl:text>xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" </xsl:text>
		<xsl:text>xmlns:phone="clr-namespace:Microsoft.Phone.Controls;assembly=Microsoft.Phone" </xsl:text>
		<xsl:text>xmlns:shell="clr-namespace:Microsoft.Phone.Shell;assembly=Microsoft.Phone" </xsl:text>
		<xsl:text>xmlns:d="http://schemas.microsoft.com/expression/blend/2008" </xsl:text>
		<xsl:text>xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" </xsl:text>
    	<xsl:choose>
		  <xsl:when test="workspace = 'true'">
			<xsl:text>xmlns:mf="clr-namespace:mdk_windows8.UI;assembly=mdk-phone" </xsl:text>
    		<xsl:text>xmlns:conv="clr-namespace:mdk_windows8.Converters;assembly=mdk-phone" </xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:text>xmlns:mf="clr-namespace:mdk_windows8.UI;assembly=mdk-phone" </xsl:text>
    		<xsl:text>xmlns:conv="clr-namespace:mdk_common.Converters;assembly=mdk-phone" </xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
    	<xsl:if test="page-package"><xsl:text>xmlns:uc="clr-namespace:</xsl:text><xsl:value-of select="page-package"/><xsl:text>" </xsl:text></xsl:if>
    	<xsl:text>xmlns:System="clr-namespace:System;assembly=mscorlib" </xsl:text>    
		<xsl:text>FontFamily="{StaticResource PhoneFontFamilyNormal}" </xsl:text>
		<xsl:text>FontSize="{StaticResource PhoneFontSizeNormal}" </xsl:text>
		<xsl:text>Foreground="{StaticResource PhoneForegroundBrush}" </xsl:text>
		<xsl:text>SupportedOrientations="Portrait" Orientation="Portrait" </xsl:text>
		<xsl:text>mc:Ignorable="d" </xsl:text>
		<xsl:text>shell:SystemTray.IsVisible="True" &gt;</xsl:text>
	</xsl:template>
	
	<xsl:template name="xaml-file-close">
	<!--
		 <xsl:text>&lt;phone:PhoneApplicationPage.ApplicationBar &gt;</xsl:text>
			<xsl:text>&lt;shell:ApplicationBar IsVisible="True" IsMenuEnabled="True" &gt;</xsl:text>
			<xsl:text>&lt;shell:ApplicationBar.MenuItems &gt;</xsl:text>
			<xsl:text>&lt;shell:ApplicationBarMenuItem Text="MenuItem 1" &#47;&gt;</xsl:text>
			<xsl:text>&lt;&#47;shell:ApplicationBar.MenuItems &gt;</xsl:text>
			<xsl:text>&lt;&#47;shell:ApplicationBar &gt;</xsl:text>
		<xsl:text>&lt;&#47;phone:PhoneApplicationPage.ApplicationBar &gt;</xsl:text>
	 -->
	
		<xsl:choose>
		  <xsl:when test="workspace = 'true'">
			<xsl:text>&lt;&#47;mf:MFWorkspace&gt;</xsl:text>
		  </xsl:when>
		  <xsl:when test="multi-panel = 'true'">
			<xsl:text>&lt;&#47;mf:MFMultiPanels&gt;</xsl:text>
		  </xsl:when>
  		  <xsl:when test="search-screen = 'true'">
			<xsl:text>&lt;&#47;phone:PhoneApplicationPage&gt;</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:text>&lt;&#47;phone:PhoneApplicationPage&gt;</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>