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

<xsl:template match="button[@type='ADD']" mode="method-click-impl">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>

<xsl:template match="button[@type='SAVE']" mode="method-click-impl">
	<xsl:if test="/page/in-workspace='false' and /page/in-multi-panel='false'">
		<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
		<xsl:text>public void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
		<xsl:text>&#13;{&#13;</xsl:text>
		<xsl:text>((</xsl:text><xsl:value-of select="../../../vm"></xsl:value-of><xsl:text>)this.DataContext).</xsl:text>
		<xsl:text>ExecuteSave</xsl:text><xsl:value-of select="../../../vm"></xsl:value-of><xsl:text>(e);</xsl:text>
		<xsl:text>&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">after-<xsl:value-of select="@action-name"/>-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="button[@type='DELETE']" mode="method-click-impl">
	<!--
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;</xsl:text>
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

	<xsl:text>&#13;public async void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>IMFResourcesHelper resourceLoader = ClassLoader.GetInstance().GetBean&lt;IMFResourcesHelper&gt;();</xsl:text>
	<xsl:text>var messageDialog = new MessageDialog(resourceLoader.getResource("DeleteRecordQuestion", ResourceFileEnum.FrameWorkFile));</xsl:text>
	<xsl:text>UICommand okCmd = new UICommand(resourceLoader.getResource("Yes", ResourceFileEnum.FrameWorkFile));</xsl:text>
	<xsl:text>UICommand cancelCmd = new UICommand(resourceLoader.getResource("No", ResourceFileEnum.FrameWorkFile));</xsl:text>
	<xsl:text>messageDialog.Commands.Add(okCmd);</xsl:text>
	<xsl:text>messageDialog.Commands.Add(cancelCmd);</xsl:text>
	<xsl:text>IUICommand command = await messageDialog.ShowAsync();</xsl:text>
	<xsl:text>if (command.Equals(okCmd))</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>((</xsl:text><xsl:value-of select="../../../vm"></xsl:value-of><xsl:text>)this.DataContext).</xsl:text>
	<xsl:text>ExecuteDelete</xsl:text><xsl:value-of select="../../../vm"/><xsl:text>(e);</xsl:text>
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">after-<xsl:value-of select="@action-name"/>-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;}&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="button" mode="method-click-usercontrol-event">
	<xsl:if test="@type='NAVIGATION'">
		<xsl:text>public event RoutedEventHandler </xsl:text><xsl:value-of select="navigation/target/name"/><xsl:text>_Navigate;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="navigationV2" mode="method-click-usercontrol-event">
	<xsl:if test="@type='MASTER_DETAIL'">
		<xsl:text>public event RoutedEventHandler </xsl:text><xsl:value-of select="source/screen-name"/><xsl:text>_Navigate;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="button[@type='NAVIGATION']" mode="method-click-impl">
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="navigation/target/name"/><xsl:text>_Navigation_Click(object sender, RoutedEventArgs e)</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">before-<xsl:value-of select="navigation/target/name"/>-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="../../../navigationsV2/navigationV2[@type = 'MASTER_DETAIL']">
		<xsl:value-of select="../../../navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_AddItem(sender, e);&#13;</xsl:text>
	</xsl:if>
	<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>
</xsl:stylesheet>