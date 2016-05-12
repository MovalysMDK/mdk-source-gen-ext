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
	
	<!-- MAIN TEMPLATE -->
	<xsl:template match="screen">
	
		<xsl:call-template name="xaml-file-start" />
		
		<xsl:call-template name="xaml-resource" />
		
		<xsl:apply-templates select="menus" mode="xaml-menu" />
		
		<xsl:apply-templates select="." mode="xaml-content" />

		<xsl:call-template name="xaml-bottom-appbar" />

		<xsl:call-template name="xaml-file-close" />
	
	</xsl:template>
	
	
	<!-- TEMPLATE DE BASE -->
	
	
	<xsl:template name="xaml-file-start">
		<xsl:text>&lt;common:MFPage </xsl:text>

		<xsl:text>x:Class="</xsl:text><xsl:value-of select="package"/><xsl:text>.</xsl:text><xsl:value-of select="name"/><xsl:text>" </xsl:text>
		<xsl:text>xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" </xsl:text>
		<xsl:text>xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" </xsl:text>
		<xsl:text>xmlns:d="http://schemas.microsoft.com/expression/blend/2008" </xsl:text>
		<xsl:text>xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" </xsl:text>
		<xsl:text>xmlns:mf="using:mdk_windows8.UI" </xsl:text>
		<xsl:text>xmlns:common="using:mdk_common.Common" </xsl:text>
	    <xsl:text>xmlns:conv="using:mdk_common.Converters" </xsl:text>
		<xsl:if test="page-package"><xsl:text>xmlns:uc="using:</xsl:text><xsl:value-of select="page-package"/><xsl:text>" </xsl:text></xsl:if>
    	<xsl:text>xmlns:System="using:System" </xsl:text>
		<xsl:text>mc:Ignorable="d" &gt;</xsl:text>
	</xsl:template>
	
	<xsl:template name="xaml-resource">
		<xsl:text>&lt;common:MFPage.Resources&gt;</xsl:text>
		
		<xsl:text>&lt;conv:BoolToVisibility x:Key="BoolToVisibility"&#47;&gt;</xsl:text>
        <xsl:text>&lt;conv:StringFormatConverter x:Key="StringFormatConverter" &#47;&gt;</xsl:text>
        <xsl:text>&lt;conv:ErrorMessageConverter x:Key="ErrorMessageConverter" &#47;&gt;</xsl:text>
        <xsl:text>&lt;conv:DateTimeToDateTimeOffsetConverter x:Key="DateTimeToDateTimeOffsetConverter" &#47;&gt;</xsl:text>

		<xsl:text>&lt;&#47;common:MFPage.Resources&gt;</xsl:text>
	</xsl:template>



	<xsl:template match="screen[workspace='true' and is-Store='false' ]" mode="xaml-content">
		<xsl:text>&lt;ScrollViewer&gt;</xsl:text>
		<xsl:text>&lt;Grid x:Name="rootLayout" Background="Black"&gt;</xsl:text>
		<xsl:text>&lt;Grid.RowDefinitions&gt;</xsl:text>
		<xsl:text>&lt;RowDefinition Height="140"&#47;&gt;</xsl:text>
		<xsl:apply-templates select="pages/page" mode="declare-grid-row" />
		<xsl:text>&lt;&#47;Grid.RowDefinitions&gt;</xsl:text>
		<xsl:text>&lt;Grid.ColumnDefinitions&gt;</xsl:text>
		<xsl:text>&lt;ColumnDefinition Width="Auto"&#47;&gt;</xsl:text>
		<xsl:text>&lt;ColumnDefinition Width="*"&#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;Grid.ColumnDefinitions&gt;</xsl:text>
		<xsl:text>&lt;Pivot Grid.Row="1" Grid.ColumnSpan="2" x:Name="</xsl:text><xsl:value-of select="name"/><xsl:text>Pivot"&gt;</xsl:text>
			<xsl:apply-templates select="pages/page" mode="declare-user-control-pivot-item" />
		<xsl:text>&lt;&#47;Pivot&gt;</xsl:text>
		<xsl:if test="main = 'false'">
			<xsl:text>&lt;Button x:Name="backButton" Click="GoBack" Grid.Row="0" Grid.Column="0" IsEnabled="{Binding Frame.CanGoBack, ElementName=pageRoot}" Style="{StaticResource BackButtonStyle}"&#47;&gt;</xsl:text>
		</xsl:if>
		<xsl:text>&lt;TextBlock x:Uid="</xsl:text><xsl:value-of select="name"/><xsl:text>" x:Name="pageTitle" Grid.Row="0" Grid.Column="1" Style="{StaticResource PageHeaderTextStyle}"&#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;Grid&gt;</xsl:text>
		<xsl:text>&lt;&#47;ScrollViewer&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="screen[workspace='true' and is-Store='true' ]" mode="xaml-content">
		<xsl:text>&lt;ScrollViewer&gt;</xsl:text>
		<xsl:text>&lt;Grid x:Name="rootLayout" Background="Black"&gt;</xsl:text>
		<xsl:text>&lt;Grid.RowDefinitions&gt;</xsl:text>
		<xsl:text>&lt;RowDefinition Height="140"&#47;&gt;</xsl:text>
		<xsl:text>&lt;RowDefinition Height="*"&#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;Grid.RowDefinitions&gt;</xsl:text>
		<xsl:text>&lt;Grid.ColumnDefinitions&gt;</xsl:text>
		<xsl:text>&lt;ColumnDefinition Width="Auto"&#47;&gt;</xsl:text>
		<xsl:text>&lt;ColumnDefinition Width="*"&#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;Grid.ColumnDefinitions&gt;</xsl:text>

		<xsl:text>&lt;Grid Grid.Column="0" Grid.Row="1" Grid.ColumnSpan="2" x:Name="workspaceLayout" Background="Black"&gt;</xsl:text>
		<xsl:text>&lt;Grid.RowDefinitions&gt;</xsl:text>
		<xsl:text>&lt;RowDefinition Height="*"&#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;Grid.RowDefinitions&gt;</xsl:text>

		<xsl:text>&lt;Grid.ColumnDefinitions&gt;</xsl:text>
		<xsl:apply-templates select="pages/page" mode="declare-grid-column" />
		<xsl:text>&lt;&#47;Grid.ColumnDefinitions&gt;</xsl:text>

		<xsl:apply-templates select="pages/page" mode="declare-user-control-workspace" />
		<xsl:text>&lt;&#47;Grid&gt;</xsl:text>

		<xsl:if test="main = 'false'">
			<xsl:text>&lt;Button x:Name="backButton" Click="GoBack" Grid.Row="0" Grid.Column="0" IsEnabled="{Binding Frame.CanGoBack, ElementName=pageRoot}" Style="{StaticResource BackButtonStyle}"&#47;&gt;</xsl:text>
		</xsl:if>
		<xsl:text>&lt;TextBlock x:Uid="</xsl:text><xsl:value-of select="name"/><xsl:text>" x:Name="pageTitle" Grid.Row="0" Grid.Column="1" Style="{StaticResource PageHeaderTextStyle}"&#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;Grid&gt;</xsl:text>
		<xsl:text>&lt;&#47;ScrollViewer&gt;</xsl:text>
	</xsl:template>


	<xsl:template match="screen" mode="xaml-content">

		<xsl:text>&lt;ScrollViewer&gt;</xsl:text>
		<xsl:text>&lt;Grid x:Name="rootLayout" Background="Black"&gt;</xsl:text>
		<xsl:text>&lt;Grid.RowDefinitions&gt;</xsl:text>
		<xsl:text>&lt;RowDefinition Height="140"&#47;&gt;</xsl:text>
		<xsl:apply-templates select="pages/page" mode="declare-grid-row" />
        <xsl:text>&lt;&#47;Grid.RowDefinitions&gt;</xsl:text>
        <xsl:text>&lt;Grid.ColumnDefinitions&gt;</xsl:text>
            <xsl:text>&lt;ColumnDefinition Width="Auto"&#47;&gt;</xsl:text>
            <xsl:text>&lt;ColumnDefinition Width="*"&#47;&gt;</xsl:text>
        <xsl:text>&lt;&#47;Grid.ColumnDefinitions&gt;</xsl:text>
		<xsl:apply-templates select="pages/page" mode="declare-user-control" />
		<xsl:if test="main = 'false'">
			<xsl:text>&lt;Button x:Name="backButton" Click="GoBack" Grid.Row="0" Grid.Column="0" IsEnabled="{Binding Frame.CanGoBack, ElementName=pageRoot}" Style="{StaticResource BackButtonStyle}"&#47;&gt;</xsl:text>
		</xsl:if>
		<xsl:text>&lt;TextBlock x:Uid="</xsl:text><xsl:value-of select="name"/><xsl:text>" x:Name="pageTitle" Grid.Row="0" Grid.Column="1" Style="{StaticResource PageHeaderTextStyle}"&#47;&gt;</xsl:text>
	  	<xsl:text>&lt;&#47;Grid&gt;</xsl:text>
		<xsl:text>&lt;&#47;ScrollViewer&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template name="xaml-file-close">
		<xsl:text>&lt;&#47;common:MFPage&gt;</xsl:text>
	</xsl:template>
	
	
	<!-- TEMPLATE SPECIFIQUE -->
				
	<xsl:template match="page" mode="declare-user-control" >
		<xsl:text>&lt;uc:</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text> x:Name="</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>" Grid.Row="</xsl:text>
		<xsl:value-of select="position()"/>
		<xsl:text>" Grid.ColumnSpan="2"</xsl:text>
		<xsl:text> DataContext="{Binding </xsl:text>
		<xsl:value-of select="viewmodel/name"/>
		<xsl:text>}" &#47;&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="page" mode="declare-user-control-workspace" >
		<xsl:text>&lt;uc:</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text> x:Name="</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>" Grid.Row="0" Grid.Column="</xsl:text>
		<xsl:value-of select="position()-1"/>
		<xsl:text>" DataContext="{Binding </xsl:text>
		<xsl:value-of select="viewmodel/name"/>
		<xsl:text>}" &#47;&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="page" mode="declare-user-control-pivot-item" >
		<xsl:text>&lt;PivotItem Header="</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>"&gt;</xsl:text>
			<xsl:text>&lt;uc:</xsl:text>
			<xsl:value-of select="name"/>
			<xsl:text> x:Name="</xsl:text>
			<xsl:value-of select="name"/>
			<xsl:text>" DataContext="{Binding </xsl:text>
			<xsl:value-of select="viewmodel/name"/>
			<xsl:text>}" &#47;&gt;</xsl:text>
		<xsl:text>&lt;&#47;PivotItem &gt;</xsl:text>
	</xsl:template>
				
	<xsl:template match="page" mode="declare-grid-row" >
		<xsl:text>&lt;RowDefinition Height="*"&#47;&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="page" mode="declare-grid-column" >
		<xsl:text>&lt;ColumnDefinition Width="*"&#47;&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="menu[/screen/is-Store='true']" mode="xaml-menu">
		<xsl:text>&lt;common:MFPage.TopAppBar&gt;</xsl:text>
		    <xsl:text>&lt;AppBar x:Name="topAppBar" Background="#00b2f0"&gt;</xsl:text>
		        <xsl:text>&lt;AppBar.Resources&gt;</xsl:text>
		            <xsl:text>&lt;Style TargetType="Button"&gt;</xsl:text>
		                <xsl:text>&lt;Setter Property="Width" Value="140"&#47;&gt;</xsl:text>
		                <xsl:text>&lt;Setter Property="Height" Value="60"&#47;&gt;</xsl:text>
		                <xsl:text>&lt;Setter Property="Margin" Value="5"&#47;&gt;</xsl:text>
		            <xsl:text>&lt;&#47;Style&gt;</xsl:text>
		        <xsl:text>&lt;&#47;AppBar.Resources&gt;</xsl:text>
		        <xsl:text>&lt;StackPanel Orientation="Horizontal"&gt;</xsl:text>
		        	<xsl:apply-templates select="." mode="create-item-menu"/>
		        <xsl:text>&lt;&#47;StackPanel&gt;</xsl:text>
		    <xsl:text>&lt;&#47;AppBar&gt;</xsl:text>
		<xsl:text>&lt;&#47;common:MFPage.TopAppBar&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="menu[/screen/is-Store='false']" mode="xaml-menu">
	</xsl:template>
	
	<xsl:template match="menu-item" mode="create-item-menu">
		<xsl:text>&lt;AppBarButton Label="</xsl:text>
		<xsl:value-of select="navigation/target/name"/>
		<xsl:text>" Command="{ Binding </xsl:text><xsl:value-of select="navigation/target/name"/>
		<xsl:text>NavigationMenuCommand}" &#47;&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template name="xaml-bottom-appbar">
		<xsl:if test="workspace = 'true' or multi-panel = 'true' or is-Store='false'">
    		<xsl:text>&lt;common:MFPage.BottomAppBar&gt;</xsl:text>
    		<xsl:text>&lt;CommandBar&gt;</xsl:text>
            <xsl:text>&lt;CommandBar.PrimaryCommands&gt;</xsl:text>
            <xsl:if test="(workspace = 'true' or multi-panel = 'true') and ./pages/page/actions/action/action-type='SAVEDETAIL'">
            	<xsl:text>&lt;AppBarButton x:Name="btnSave"   Icon="Save" Label="Save" Command="{Binding SaveCommand}" &#47;&gt;</xsl:text>
            </xsl:if>
            <xsl:text>&lt;&#47;CommandBar.PrimaryCommands&gt;</xsl:text>
            <xsl:text>&lt;CommandBar.SecondaryCommands&gt;</xsl:text>
       		<xsl:if test="workspace = 'true' and ./pages/page/actions/action/action-type='DELETEDETAIL'">
	            <xsl:text>&lt;AppBarButton</xsl:text>
	            <xsl:text> Icon="Delete"</xsl:text>
	            <xsl:text> Label="Delete" x:Name="btnDelete"&gt;</xsl:text>
	            <xsl:text>&lt;Button.Flyout&gt;</xsl:text>
	            <xsl:text>&lt;Flyout&gt;</xsl:text>
	            <xsl:text>&lt;StackPanel&gt;</xsl:text>
	            <xsl:text>&lt;TextBlock Style="{StaticResource BaseTextBlockStyle}"&gt;</xsl:text>
	            <xsl:text>Confirmez-vous la suppression ?</xsl:text>
	            <xsl:text>&lt;&#47;TextBlock&gt;</xsl:text>
	            <xsl:text>&lt;Button Command="{Binding DeleteCommand}" Margin="0,5,0,0"&gt;</xsl:text>
	            <xsl:text>Delete confirmation</xsl:text>
	            <xsl:text>&lt;&#47;Button&gt;</xsl:text>
	            <xsl:text>&lt;&#47;StackPanel&gt;</xsl:text>
	            <xsl:text>&lt;&#47;Flyout&gt;</xsl:text>
	            <xsl:text>&lt;&#47;Button.Flyout&gt;</xsl:text>
	            <xsl:text>&lt;&#47;AppBarButton&gt;</xsl:text>
            </xsl:if>
            <xsl:if test="is-Store='false'">
	       		<xsl:apply-templates select="/screen/menus/menu" mode="create-item-menu"/>
	        </xsl:if>
            <xsl:text>&lt;&#47;CommandBar.SecondaryCommands&gt;</xsl:text>
        	<xsl:text>&lt;&#47;CommandBar&gt;</xsl:text>
   		    <xsl:text>&lt;&#47;common:MFPage.BottomAppBar&gt;</xsl:text>
		  </xsl:if>
	</xsl:template>
	
</xsl:stylesheet>