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

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/method-click.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/cs-panel-list2d-methods.xsl"/>
 
<xsl:template match="page">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.xaml.cs</xsl:with-param>
	</xsl:apply-templates>

	<xsl:call-template name="panel-imports"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="." mode="declare-impl-imports"/>		
	
	
	<xsl:text>&#13;&#13;namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>public partial class </xsl:text><xsl:value-of select="name"/><xsl:text> : MFUserControl </xsl:text><xsl:value-of select="./implements/interface/@name" />
	<xsl:if test="/page/layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
		<xsl:call-template name="add-interface-imfcomponentdictionary"/>
	</xsl:if>
	<xsl:text>{</xsl:text>
	
	<!-- <xsl:apply-templates select="layout/buttons/button" mode="method-click-usercontrol-event" /> -->
	<xsl:apply-templates select="navigations/navigation" mode="method-click-usercontrol-event" />
	
	<xsl:text>private </xsl:text> <xsl:value-of select="section-interface"/><xsl:text> Section</xsl:text> 
	<xsl:text>{</xsl:text> 
	    <xsl:text>get </xsl:text> 
	    <xsl:text>{</xsl:text> 
	        <xsl:text>return base.section as </xsl:text> <xsl:value-of select="section-interface"/><xsl:text>;</xsl:text> 
	    <xsl:text>}</xsl:text> 
	    <xsl:text>set </xsl:text> 
	    <xsl:text>{</xsl:text> 
	        <xsl:text>base.section = value;</xsl:text> 
	    <xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text> 
	
	<xsl:text>&#13;&#13;#region Constructors&#13;</xsl:text>
	
	<xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text> ()</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>if(!IsInDesignMode()){</xsl:text>
	<xsl:text>Section = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="section-interface"/><xsl:text>&gt;();</xsl:text>
	<xsl:text>this.DataContext = Section.ViewModel;</xsl:text>
	<xsl:text>this.InitializeComponent();</xsl:text>
	<xsl:if test="/page/layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
	<xsl:text>this.ComponentDictionary.Add(this.</xsl:text>
	<xsl:value-of select="layout/visualfields/visualfield[component = 'MFList2D']/name"/>
	<xsl:text>.Name , this.</xsl:text>
	<xsl:value-of select="layout/visualfields/visualfield[component = 'MFList2D']/name"/>
		<xsl:text>);</xsl:text>
	</xsl:if>
	<xsl:text>}&#13;</xsl:text>
		
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">constructor</xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>}</xsl:text>
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Properties&#13;</xsl:text><xsl:text></xsl:text>
		<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
		</xsl:call-template>
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text> -->
	<xsl:text> 	&#13;/// &lt;inheritDoc/&gt;</xsl:text>
	<xsl:text> 	&#13;public Boolean IsToDisplay(AbstractView vm)</xsl:text>
	<xsl:text> 	&#13;{</xsl:text>
	<xsl:text> 	&#13;    return (Section.IsToDisplay(vm));</xsl:text>
	<xsl:text> 	&#13;}</xsl:text>
	
	
	<xsl:call-template name="pannel-chained_action" />
	
	
	<xsl:apply-templates select="layout/buttons/button" mode="method-click-usercontrol" />
	<xsl:apply-templates select="navigationsV2/navigationV2" mode="create-event" />
	<xsl:apply-templates select="layout" mode="panel-fixedlist-delete-button"/>
	<xsl:call-template name="ActionErrorMethod" />
	<xsl:if test="search-template">
	<xsl:call-template name="SearchClickMethod" />
	</xsl:if>
		<xsl:text>&#13;}&#13;</xsl:text>
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:if test="/page/layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
		<xsl:call-template name="add-list2d-methods"/>
	</xsl:if>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text>

</xsl:template>


<xsl:template match="reverse-navigationsV2/reverse-navigationV2[@type = 'MASTER_DETAIL']" mode="create-event" >

</xsl:template>

<xsl:template match="navigationsV2/navigationV2[@type = 'MASTER_DETAIL']" mode="create-event" >

    <xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
    <xsl:text>&#13;/// Select an item in the list.</xsl:text>
    <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
    <xsl:text>&#13;/// &lt;param name="sender"&gt;ListView&lt;/param&gt;</xsl:text>
    <xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChanged(object sender, SelectionChangedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
        <xsl:text>if (((ListView)sender).SelectedItem != null)</xsl:text>
        <xsl:text>{</xsl:text>
        	<!-- <xsl:if test="../../layout/buttons/button[@type='NAVIGATION']">
	            <xsl:text>if (this.</xsl:text><xsl:value-of select="../../layout/buttons/button[@type='NAVIGATION']/navigation/target/name"/><xsl:text>_Navigate != null)</xsl:text>
				<xsl:text>this.</xsl:text><xsl:value-of select="../../layout/buttons/button[@type='NAVIGATION']/navigation/target/name"/><xsl:text>_Navigate(this, e);</xsl:text>               
			</xsl:if> -->
			<xsl:if test="../../navigations/navigation[@type='NAVIGATION_DETAIL']">
	            <xsl:text>if (this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type='NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate != null)</xsl:text>
				<xsl:text>this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type='NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate(this, e);</xsl:text>               
			</xsl:if>
            <xsl:text>Section.</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChanged(((ListView)sender).SelectedItem);</xsl:text>
        <xsl:text>}</xsl:text>
    <xsl:text>}</xsl:text>
    <xsl:text>&#13;</xsl:text>
		    <xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
		    <xsl:text>&#13;/// Add an item to the list.</xsl:text>
		    <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
		    <xsl:text>&#13;/// &lt;param name="sender"&gt;ListView&lt;/param&gt;</xsl:text>
		    <xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItem(object sender, RoutedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
        <xsl:text>Section.</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItem(Section.ViewModel.CreateEmptyItem());</xsl:text>
    <xsl:text>}</xsl:text>
    <xsl:text>&#13;</xsl:text>
		    <xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
		    <xsl:text>&#13;/// Delete an item of the list.</xsl:text>
		    <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
		    <xsl:text>&#13;/// &lt;param name="sender"&gt;ListView&lt;/param&gt;</xsl:text>
		    <xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItem(object sender, RoutedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
        <xsl:text>Section.</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItem();</xsl:text>
    <xsl:text>}</xsl:text>
    
</xsl:template>

<xsl:template name="pannel-chained_action">

	<xsl:choose>
	  <xsl:when test="in-workspace = 'true'">

		<xsl:if test="viewmodel/type/is-list = 'false'">
		<xsl:text> 	&#13;&#13;/// &lt;summary&gt;</xsl:text>
		<xsl:text> 	&#13;/// Get SaveActionsArg for Chained Save</xsl:text> 
		<xsl:text>	&#13;/// &lt;/summary&gt;</xsl:text>
		<xsl:text>	&#13;/// &lt;returns&gt;&lt;/returns&gt;</xsl:text>
		<xsl:text>	&#13;public CUDActionArgs GetCUDActionArgs()</xsl:text>
		<xsl:text>	&#13;{</xsl:text>
		<xsl:text>	&#13;return Section.GetCUDActionArgs();</xsl:text>
		
		<xsl:text>	}&#13;</xsl:text>
		</xsl:if>
	  </xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="layout" mode="panel-fixedlist-delete-button">
	<xsl:if test=".//visualfields/visualfield/component='MFFixedList'">
		<xsl:text>&#13;/// DeleteButton_Tapped</xsl:text>
	    <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
	    <xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
	    <xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;private async void DeleteButton_Tapped(object sender, RoutedEventArgs e)</xsl:text>
	    <xsl:text>&#13;{</xsl:text>
	    <xsl:text>&#13;// Create the message dialog and set its content</xsl:text>
        <xsl:text>&#13;var messageDialog = new MessageDialog("Supprimer l'enregistrement ?");</xsl:text>
        <xsl:text>&#13;// Add commands and set their callbacks; both buttons use the same callback function instead of inline event handlers</xsl:text>
        <xsl:text>&#13;messageDialog.Commands.Add(new UICommand("OK"));</xsl:text>
        <xsl:text>&#13;messageDialog.Commands.Add(new UICommand("Cancel"));</xsl:text>
        <xsl:text>&#13;// Set the command that will be invoked by default</xsl:text>
        <xsl:text>&#13;messageDialog.DefaultCommandIndex = 1;</xsl:text>
        <xsl:text>&#13;// Set the command to be invoked when escape is pressed</xsl:text>
        <xsl:text>&#13;messageDialog.CancelCommandIndex = 1;</xsl:text>
        <xsl:text>&#13;// Show the message dialog</xsl:text>
        <xsl:text>&#13;IUICommand command = await messageDialog.ShowAsync();</xsl:text>
        <xsl:text>&#13;if (command.Label == "OK")</xsl:text>
        <xsl:text>&#13;{</xsl:text>
	    <xsl:text>&#13;long id = (long)((MFButton)sender).Tag;</xsl:text>
	    <xsl:text>&#13;Section.button_Delete</xsl:text>
	    <xsl:value-of select="prefix"/>
	    <xsl:text>_Click(id);</xsl:text>
	    <xsl:apply-templates select="./visualfields/visualfield" mode="get-fixedlist-component"/>
	    <xsl:text>.DeletedItem();</xsl:text>
	    <xsl:text>&#13;}</xsl:text>
	    <xsl:text>&#13;}</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="visualfield" mode="get-fixedlist-component">
	<xsl:if test="./component='MFFixedList'">
		<xsl:value-of select="./property-name-c"/>
	</xsl:if>
</xsl:template>

<xsl:template name="ActionErrorMethod">
	<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
	<xsl:text>&#13;/// Display action error message.</xsl:text>
	<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
	<xsl:text>&#13;/// &lt;param name="sender"&gt;Action&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;/// &lt;param name="e"&gt;Message&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;[MFOnEventAttribute(typeof(ActionErrorMessage))]</xsl:text>
	<xsl:text>&#13;public async void DoOnActionError(object sender, ActionErrorMessage e)</xsl:text>
	<xsl:text>&#13;{</xsl:text>
	<xsl:if test="./layout/buttons/button[@type='SAVE']">
		<xsl:text>&#13;if (sender.GetType().Equals(typeof(</xsl:text>
		<xsl:value-of select="./layout/buttons/button[@type='SAVE']/@action-name"/>
		<xsl:text>)))</xsl:text>
		<xsl:text>&#13;{</xsl:text>
	</xsl:if>
	<xsl:text>&#13;await Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, async () =></xsl:text>
	<xsl:text>&#13;{</xsl:text>
	<xsl:text>&#13;// Create the message dialog and set its content</xsl:text>
	<xsl:text>&#13;IMFResourcesHelper resourceLoader = ClassLoader.GetInstance().GetBean&lt;IMFResourcesHelper&gt;();</xsl:text>
	<xsl:text>&#13;var messageDialog = new MessageDialog(</xsl:text>
	<xsl:text>&#13;resourceLoader.getResource(e.ErrorMessage, ResourceFileEnum.FrameWorkFile), </xsl:text>
	<xsl:text>&#13;resourceLoader.getResource("ERROR_MESSAGE", ResourceFileEnum.FrameWorkFile));</xsl:text>
	<xsl:text>messageDialog.Commands.Add(new UICommand("OK"));</xsl:text>
	<xsl:text>&#13;// Show the message dialog</xsl:text>
	<xsl:text>&#13;await messageDialog.ShowAsync();</xsl:text>
	<xsl:text>});</xsl:text>
	<xsl:if test="./layout/buttons/button[@type='SAVE']">
		<xsl:text>&#13;}</xsl:text>
	</xsl:if>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">after-DoOnActionError-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>

</xsl:template>

<xsl:template name="SearchClickMethod">
    <xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
    <xsl:text>&#13;/// Launch an action of research on the list.</xsl:text>
    <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
    <xsl:text>&#13;/// &lt;param name="sender"&gt;SearchButton&lt;/param&gt;</xsl:text>
    <xsl:text>&#13;/// &lt;param name="e"&gt;Event&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="./layout/visualfields/visualfield[component = 'MFList1D']/name"/><xsl:text>_SearchClick(object sender, RoutedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:text>}</xsl:text>
</xsl:template>
</xsl:stylesheet>