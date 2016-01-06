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
		

<xsl:template match="button" mode="method-click">
	<xsl:if test="@type='DELETE'">
		<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// </xsl:text><xsl:value-of select="@name"/><xsl:text> click method.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:text>/// &lt;param name="sender"&gt; object sender of the click event.&lt;/param&gt;&#13;</xsl:text>
		<xsl:text>/// &lt;param name="action"&gt; type action to execute.&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender,  Type action);</xsl:text>
		<xsl:text>&#13;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="navigation" mode="method-click">
<xsl:if test="@type='NAVIGATION_DETAIL'">
<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>	/// Navigation to </xsl:text><xsl:value-of select="target/name"/><xsl:text>&#13;</xsl:text>
<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>

<xsl:text>&#13;private void </xsl:text><xsl:value-of select="target/name"/><xsl:text>_Navigation_Click(object sender, RoutedEventArgs e)</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>{</xsl:text>
<xsl:text>this.Frame.Navigate(typeof(</xsl:text><xsl:value-of select="target/name"/><xsl:text>));</xsl:text>
<xsl:text>&#13;}&#13;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="navigationV2" mode="method-click">
<xsl:if test="@type='MASTER_DETAIL'">
<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>	/// Navigation to </xsl:text><xsl:value-of select="source/screen-name"/><xsl:text>&#13;</xsl:text>
<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>

<xsl:text>&#13;private void </xsl:text><xsl:value-of select="source/screen-name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>{</xsl:text>
<xsl:text>this.Frame.Navigate(typeof(</xsl:text><xsl:value-of select="source/screen-name"/><xsl:text>));</xsl:text>
<xsl:text>&#13;}&#13;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="button" mode="method-click-event">
<xsl:if test="@type='NAVIGATION'">
<xsl:value-of select="../../../name"/><xsl:text>.</xsl:text><xsl:value-of select="navigation/target/name"/><xsl:text>_Navigate += new RoutedEventHandler(</xsl:text><xsl:value-of select="navigation/target/name"/><xsl:text>_Click);&#13;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="navigation" mode="method-click-event">
<xsl:if test="@type='NAVIGATION_DETAIL'">
<xsl:value-of select="../../name"/><xsl:text>.</xsl:text><xsl:value-of select="target/name"/><xsl:text>_Navigate += new RoutedEventHandler(</xsl:text><xsl:value-of select="target/name"/><xsl:text>_Click);&#13;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="navigationV2" mode="method-click-event">
<xsl:if test="@type='MASTER_DETAIL'">
<xsl:value-of select="../../name"/><xsl:text>.</xsl:text><xsl:value-of select="source/screen-name"/><xsl:text>_Navigate += new RoutedEventHandler(</xsl:text><xsl:value-of select="source/screen-name"/><xsl:text>_Click);&#13;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="button[@type='NAVIGATION']" mode="method-click-usercontrol">
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="navigation/target/name"/><xsl:text>_Navigation_Click(object sender, RoutedEventArgs e)</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">before-<xsl:value-of select="navigation/target/name"/>-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
	<xsl:text>&#13;}&#13;</xsl:text>
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

<xsl:template match="button[@type='ADD']" mode="method-click-usercontrol">
<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>	/// </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>
<xsl:text>&#13;private void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>{</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-<xsl:value-of select="@name"/>-method</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
<xsl:text>&#13;Section.</xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(sender,typeof(</xsl:text><xsl:value-of select="."/><xsl:text>));</xsl:text>
<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>

<xsl:template match="button[@type='SAVE']" mode="method-click-usercontrol">
<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>	/// </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>
<xsl:text>&#13;private void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>{</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-<xsl:value-of select="@name"/>-method</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
<xsl:text>&#13;Section.</xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(sender,typeof(</xsl:text><xsl:value-of select="."/><xsl:text>));</xsl:text>
<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>

<xsl:template match="button[@type='DELETE']" mode="method-click-usercontrol">
<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>	/// </xsl:text><xsl:value-of select="@action-name"/><xsl:text>&#13;</xsl:text>
<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
<xsl:text>	/// &lt;param name="e">&lt;/param&gt;</xsl:text>
<xsl:text>&#13;private void </xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(object sender, RoutedEventArgs e)</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>{</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-<xsl:value-of select="@name"/>-method</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
<xsl:text>&#13;Section.</xsl:text><xsl:value-of select="@name"/><xsl:text>_Click(sender,typeof(</xsl:text><xsl:value-of select="."/><xsl:text>));</xsl:text>
<xsl:text>&#13;}&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>