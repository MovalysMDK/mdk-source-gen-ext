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

<xsl:template match="button[@type='NAVIGATION']" mode="method-click-listener-impl">
</xsl:template>

<xsl:template match="button[@type='ADD']" mode="method-click-listener-impl">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>

<xsl:template match="button[@type='SAVE']" mode="method-click-listener-impl">
	<xsl:if test="../../../in-workspace='false' and ../../../in-multi-panel='false'">
		<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>	/// Listener on Success of </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
		<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
		<xsl:text>	/// &lt;param name="e">Out parameter of the save action&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;[MFOnActionAttribute(typeof(</xsl:text><xsl:value-of select="@action-name"/><xsl:text>), ActionLauncher.ActionResult.Success)]&#13;</xsl:text>
		<xsl:text>public void DoOn</xsl:text><xsl:value-of select="@action-name"/><xsl:text>_Success(Object sender, CUDActionArgs e)&#13;</xsl:text>
		<xsl:text>{&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId"><xsl:value-of select="@action-name"/>-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
		<xsl:text>}&#13;&#13;</xsl:text>
		<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>	/// Listener on Failed of </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
		<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
		<xsl:text>	/// &lt;param name="e">Out parameter of the save action&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;[MFOnActionAttribute(typeof(</xsl:text><xsl:value-of select="@action-name"/><xsl:text>), ActionLauncher.ActionResult.Failed)]&#13;</xsl:text>
		<xsl:text>public void DoOn</xsl:text><xsl:value-of select="@action-name"/><xsl:text>_Failed(Object sender, CUDActionArgs e)&#13;</xsl:text>
		<xsl:text>{&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId"><xsl:value-of select="@action-name"/>-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="button[@type='DELETE']" mode="method-click-listener-impl">
	<!--<xsl:text>&#13;/// &lt;inheritDoc/&gt;</xsl:text>
	<xsl:if test="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL'] and ../../../identifier[@in-workspace = 'true']">
		<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
		<xsl:text>&#13;/// Delete workspace item</xsl:text>
		<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
		<xsl:text>&#13;/// &lt;param name="sender">&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;/// &lt;param name="e">&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="../../../parent-viewmodel"/><xsl:text>_DeleteItemEvent))]</xsl:text>
		<xsl:text>&#13;public void DoOnDeleteWorkspace_item(Object sender, </xsl:text><xsl:value-of select="../../../parent-viewmodel"/><xsl:text>_DeleteItemEvent e)&#13;</xsl:text>
		<xsl:text>{&#13;</xsl:text>
			<xsl:value-of select="@name"/><xsl:text>_Click(sender,null);</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">after-DoOnDeleteWorkspace_item-method</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
			</xsl:call-template>
		<xsl:text>}&#13;&#13;</xsl:text>
	</xsl:if>-->

	<!-- action delete code :
		<xsl:text>CUDActionArgs deleteActionArgs = new CUDActionArgs();</xsl:text>
		<xsl:text>deleteActionArgs.viewModel = ((</xsl:text><xsl:value-of select="../../../../../vm"/><xsl:text>)ViewModel).</xsl:text><xsl:value-of select="../../../viewmodel/name"/><xsl:text>;</xsl:text>
		<xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().LaunchAction(typeof(</xsl:text><xsl:value-of select="@action-name"/><xsl:text>), this, deleteActionArgs);</xsl:text>
		<xsl:if test="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']">
			<xsl:value-of select="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_ReloadEvent();</xsl:text>
			<xsl:text>if (this.</xsl:text><xsl:value-of select="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/screen-name"/><xsl:text>_Navigate != null)</xsl:text>
			<xsl:text>this.</xsl:text><xsl:value-of select="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/screen-name"/><xsl:text>_Navigate(this, e);</xsl:text>
		</xsl:if>
		<xsl:text>}&#13;</xsl:text>-->

	<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>	/// Listener on Success of </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
	<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;[MFOnActionAttribute(typeof(</xsl:text><xsl:value-of select="@action-name"/><xsl:text>), ActionLauncher.ActionResult.Success)]&#13;</xsl:text>
	<xsl:text>public void DoOn</xsl:text><xsl:value-of select="@action-name"/><xsl:text>_Success(Object sender, CUDActionArgs e)&#13;</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>_context.Post(delegate&#13;</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>((</xsl:text><xsl:value-of select="../../../../../vm"/><xsl:text>)ViewModel).</xsl:text><xsl:value-of select="../../../viewmodel/name"/><xsl:text>.Clear();</xsl:text>
	<xsl:text>}, null);</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">after-<xsl:value-of select="@action-name"/>-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;&#13;</xsl:text>
	<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>	/// Listener on Failed of </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
	<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;[MFOnActionAttribute(typeof(</xsl:text><xsl:value-of select="@action-name"/><xsl:text>), ActionLauncher.ActionResult.Failed)]&#13;</xsl:text>
	<xsl:text>public void DoOn</xsl:text><xsl:value-of select="@action-name"/><xsl:text>_Failed(Object sender, CUDActionArgs e)&#13;</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId"><xsl:value-of select="@action-name"/>-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>