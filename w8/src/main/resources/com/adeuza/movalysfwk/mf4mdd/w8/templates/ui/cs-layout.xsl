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

<xsl:output method="text"/>

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/partial-class.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/method-click.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/page-type.xsl"/>



<xsl:template match="layout">
	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>

	<xsl:call-template name="layout-imports"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="." mode="declare-impl-imports"/>	
	
	<xsl:text>&#13;namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:call-template name="partial-class">
			<xsl:with-param name="BaseClass"><xsl:call-template name="layout-type"/></xsl:with-param>
			<xsl:with-param name="Class"><xsl:value-of select="screen-name"/></xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;{</xsl:text>

	<xsl:text>String selectPicture = ClassLoader.GetInstance().GetBean&lt;IMFResourcesHelper&gt;().getResource("SelectPicture", ResourceFileEnum.FrameWorkFile);&#13;</xsl:text>

	<xsl:text>&#13;#region Constructors&#13;</xsl:text>
	
	<xsl:text>public </xsl:text><xsl:value-of select="screen-name"/><xsl:text> ()</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>this.InitializeComponent();</xsl:text>
	<xsl:text>GC.Collect();</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">constructor</xsl:with-param>
	</xsl:call-template>
	<xsl:text>}</xsl:text>
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	

	<xsl:for-each select="buttons/button">
	<xsl:apply-templates select="." mode="method-click" />
	</xsl:for-each>
	
    <xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// REINIT Application&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>&#13;private async void ResetApplication()</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text disable-output-escaping="yes"><![CDATA[
	            await ClassLoader.GetInstance().GetBean<IMFApplication>().ReInitAsync();
	]]></xsl:text>
	<xsl:text>}</xsl:text>
	
		<xsl:if test="menus">
	<xsl:text disable-output-escaping="yes"><![CDATA[
		    /// <summary>
		    /// Gestion de la navigation avec le menu de la TopAppBar
		    /// </summary>
		    /// <param name="sender">Menu item</param>
		    /// <param name="e">RoutedEventArgs</param>
		]]></xsl:text>
			<xsl:text>private void NavButton_Click(object sender, RoutedEventArgs e)</xsl:text>
			<xsl:text>{</xsl:text>
			    <xsl:text>Button b = sender as Button;</xsl:text>
			    <xsl:text>if (b != null &#38;&#38; b.Tag != null)</xsl:text>
			    <xsl:text>{</xsl:text>
			        <xsl:text>Type pageType = Type.GetType(b.Tag.ToString());</xsl:text>
			        <xsl:text>this.Frame.Navigate(pageType);</xsl:text>
			    <xsl:text>}</xsl:text>
			<xsl:text>}</xsl:text>
		</xsl:if>

	<xsl:if test="main = 'true'">
		<xsl:if test="is-store = 'false'">
			<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
	        <xsl:text>/// Gestion de la reprise après selection d'un fichier via file picker&#13;</xsl:text>
	        <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	        <xsl:text>/// &lt;param name="args"&gt;Argument lié au retour du file picker&gt;/param&gt;&#13;</xsl:text>
	        <xsl:text>public void ContinueFileOpenPicker(Windows.ApplicationModel.Activation.FileOpenPickerContinuationEventArgs args)&#13;</xsl:text>
	        <xsl:text>{&#13;</xsl:text>
            <xsl:text>if (args.Files.Count > 0)</xsl:text>
            <xsl:text>{&#13;</xsl:text>
            <xsl:text>var fichier = args.Files[0];</xsl:text>
            <xsl:text>if (args.ContinuationData["Operation"].ToString() == selectPicture)</xsl:text>
            <xsl:text>{&#13;</xsl:text>
    		<xsl:text>FrameworkElement objetParent;</xsl:text>
    		<xsl:text>if (args.ContinuationData.ContainsKey("PopupParent"))</xsl:text>
    		<xsl:text>{&#13;</xsl:text>
        	<xsl:text>objetParent = MFTools.FindFirstOpenPopupByName(args.ContinuationData["PopupParent"].ToString()).Child as FrameworkElement;</xsl:text>
    		<xsl:text>}&#13;</xsl:text>
    		<xsl:text>else</xsl:text>
    		<xsl:text>{&#13;</xsl:text>
        	<xsl:text>objetParent = Window.Current.Content as FrameworkElement;</xsl:text>
    		<xsl:text>}&#13;</xsl:text>

    		<xsl:text>if(objetParent != null)</xsl:text>
    		<xsl:text>{&#13;</xsl:text>
        	<xsl:text>var photo = MFTools.FindFirstChildByName(args.ContinuationData["ObjetPhoto"].ToString(), objetParent) as MFPhotoThumbnail;</xsl:text>
        	<xsl:text>if(photo != null)</xsl:text>
            <xsl:text>photo.ContinueFilePicker(fichier);</xsl:text>
    		<xsl:text>}&#13;</xsl:text>
    		<xsl:text>}&#13;</xsl:text>
	        <xsl:text>}&#13;</xsl:text>
	        <xsl:text>}&#13;</xsl:text>
     	</xsl:if>
	</xsl:if>
	


	<xsl:text>&#13;#endregion&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>

	
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}</xsl:text>
		
</xsl:template>


</xsl:stylesheet>