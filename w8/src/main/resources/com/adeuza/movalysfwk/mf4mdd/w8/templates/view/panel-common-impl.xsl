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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/substring.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/replace-all.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/method-click-common.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/cs-panel-list2d-methods.xsl" />


	<xsl:template match="page | dialog">

		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="name" />.cs</xsl:with-param>
		</xsl:apply-templates>
		<xsl:call-template name="panel-imports" />
		<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-impl-imports" />
		<xsl:if test="in-workspace = 'true' and in-multi-panel = 'true' and (./chained-delete='true' or ./chained-save='true')">
			<xsl:text>// Chained Action headers</xsl:text>
			<xsl:text>&#13;using </xsl:text><xsl:value-of select="master-package" /><xsl:text>.action.chainedactions;&#13;</xsl:text>
		</xsl:if>

		<xsl:text>using </xsl:text><xsl:value-of select="viewmodel/package"/><xsl:text>;&#13;</xsl:text>

		<xsl:text>&#13;&#13;namespace </xsl:text><xsl:value-of select="package" /><xsl:text></xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>public partial class </xsl:text><xsl:value-of select="name" /><xsl:text> : </xsl:text>
		<xsl:call-template name="IsList" />
		<xsl:text> </xsl:text><xsl:value-of select="./implements/interface/@name" />
		<xsl:if test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
			<xsl:call-template name="add-interface-imfcomponentdictionary" />
		</xsl:if>
		<xsl:text>{</xsl:text>

		<!--==================-->
		<!--Region Constructor-->
		<!--==================-->
		<xsl:text>&#13;#region Constructors&#13;&#13;</xsl:text>

		<xsl:text>public </xsl:text><xsl:value-of select="name" /><xsl:text> ()&#13;{&#13;</xsl:text>

		<xsl:text>if(!IsInDesignMode()){&#13;</xsl:text>
		<xsl:text>this.InitializeComponent();&#13;</xsl:text>
		<xsl:if test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
			<xsl:text>this.ComponentDictionary.Add(this.</xsl:text>
			<xsl:value-of select="layout/visualfields/visualfield[component = 'MFList2D']/name" />
			<xsl:text>.Name , this.</xsl:text>
			<xsl:value-of select="layout/visualfields/visualfield[component = 'MFList2D']/name" />
			<xsl:text>);</xsl:text>
		</xsl:if>
		<xsl:text>}&#13;</xsl:text>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">constructor</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:if test="not(viewmodel/dataloader-impl/dataloader-interface/name)">
					<xsl:text>// Add your dataloader here&#13;</xsl:text>
					<xsl:text>//Loader = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
					<xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name" />
					<xsl:text>&gt;();&#13;</xsl:text>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>

		<xsl:text>}&#13;</xsl:text>

		<xsl:text>&#13;&#13;#endregion&#13;&#13;</xsl:text>

		<!--==============-->
		<!--Region Methods-->
		<!--==============-->
		<xsl:text>&#13;#region Methods&#13;</xsl:text><xsl:text></xsl:text>

		<xsl:text>&#13;/// &lt;inheritDoc/&gt;</xsl:text>
		<xsl:text>&#13; public Boolean IsToDisplay(</xsl:text>
		<xsl:call-template name="IsList" />
		<xsl:text> uc)</xsl:text>
		<xsl:text>&#13;{</xsl:text>
		<xsl:text>&#13; return this == uc;</xsl:text>
		<xsl:text>&#13;}</xsl:text>

		<xsl:if test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
			<xsl:call-template name="add-list2d-methods" />
		</xsl:if>

		<xsl:if test="in-multi-panel='false' and in-workspace='false' and not(contains(layout/parameters/parameter/@vmtype, 'LIST'))">
			<xsl:call-template name="ActionErrorMethod" />
		</xsl:if>

		<xsl:text>&#13;&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">other-methods</xsl:with-param>
		</xsl:call-template>

		<xsl:text>&#13;#endregion&#13;</xsl:text>

		<xsl:apply-templates select="layout/buttons/button" mode="method-click-impl" />

		<xsl:text>}</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template name="IsList">
		<xsl:choose>
			<xsl:when test="adapter">
				<xsl:text>MFListUserControl</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>MFUserControl</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
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
			<xsl:value-of select="./layout/buttons/button[@type='SAVE']/@action-name" />
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
		<xsl:text>&#13;}</xsl:text>
	</xsl:template>

	<!--
	<xsl:template match="page | dialog" mode="method-create-viewmodel-detail-list2d">
		<xsl:text>Button senderButton = sender as Button;</xsl:text>
		<xsl:if test="./in-workspace = 'false'">
			<xsl:text>if (this.</xsl:text><xsl:value-of
				select="../../navigations/navigation[@type = 'NAVIGATION_DETAIL']/target/name" /><xsl:text>_Navigate != null)</xsl:text>
			<xsl:text>this.</xsl:text><xsl:value-of
				select="../../navigations/navigation[@type = 'NAVIGATION_DETAIL']/target/name" /><xsl:text>_Navigate(this, e);</xsl:text>
		</xsl:if>
		<xsl:value-of
				select="../../navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized" /><xsl:text>_AddItemEvent myevent = new </xsl:text><xsl:value-of
			select="../../navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized" /><xsl:text>_AddItemEvent((long)senderButton.Tag);</xsl:text>
		<xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>
	-->

</xsl:stylesheet>
