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
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>
	
	<xsl:template match="events">
		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName">MFEvent.cs</xsl:with-param>
		</xsl:apply-templates>
		<xsl:text>&#13;using System;&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-impl-imports"/>		
		<xsl:text>&#13;namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
		<xsl:text>{</xsl:text>	
		
		<xsl:apply-templates select="event/navigationV2/source" mode="create-event" />
		
		<xsl:text>}</xsl:text>	
	</xsl:template>

	<xsl:template match="source" mode="create-event" >
		<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_SelectionChangedEvent.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:text>public class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_SelectionChangedEvent : EventArgs</xsl:text>	
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;#region Constructor&#13;</xsl:text>	
            <xsl:text>public </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_SelectionChangedEvent(long _id)</xsl:text>	
            <xsl:text>{</xsl:text>	
            <xsl:text>Id = _id;</xsl:text>	
            <xsl:text>}</xsl:text>
            <xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">constructor</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
			
			<xsl:text>&#13;#region Properties&#13;</xsl:text>
            <xsl:text>public long Id { get; set; }</xsl:text>
            <xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">custom-properties</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
        <xsl:text>}</xsl:text>	
    	<xsl:text>&#13;</xsl:text>
    	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_AddItemEvent.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    	<xsl:text>public class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_AddItemEvent : EventArgs</xsl:text>	
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;#region Constructor&#13;</xsl:text>		
           	<xsl:text>public </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_AddItemEvent(long _id)</xsl:text>	
            <xsl:text>{</xsl:text>	
            <xsl:text>Id = _id;</xsl:text>
            <xsl:text>}</xsl:text>
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">constructor</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
			
			<xsl:text>&#13;#region Properties&#13;</xsl:text>
            <xsl:text>public long Id { get; set; }</xsl:text>
            <xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">custom-properties</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
        <xsl:text>}</xsl:text>
    	<xsl:text>&#13;</xsl:text>
    	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_DeleteItemEvent.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>		
		<xsl:text>public class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_DeleteItemEvent : EventArgs</xsl:text>	
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;#region Constructor&#13;</xsl:text>		
           	<xsl:text>public </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_DeleteItemEvent()</xsl:text>	
            <xsl:text>{</xsl:text>	
            <xsl:text>}</xsl:text>	
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">constructor</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
			
			<xsl:text>&#13;#region Properties&#13;</xsl:text>
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">custom-properties</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
        <xsl:text>}</xsl:text>
        <xsl:text>&#13;</xsl:text>
        <xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_ReloadEvent.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>	
        <xsl:text>public class </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_ReloadEvent : EventArgs</xsl:text>	
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;#region Constructor&#13;</xsl:text>		
           	<xsl:text>public </xsl:text><xsl:value-of select="component-name-capitalized"/><xsl:text>_ReloadEvent()</xsl:text>	
            <xsl:text>{</xsl:text>	
            <xsl:text>}</xsl:text>	
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">constructor</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
			
			<xsl:text>&#13;#region Properties&#13;</xsl:text>
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">custom-properties</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
        <xsl:text>}</xsl:text>	
    	<xsl:text>&#13;</xsl:text>
    	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Class </xsl:text><xsl:value-of select="../../../parent-viewmodel"/><xsl:text>_DeleteItemEvent.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>		
		<xsl:text>public class </xsl:text><xsl:value-of select="../../../parent-viewmodel"/><xsl:text>_DeleteItemEvent : EventArgs</xsl:text>	
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;#region Constructor&#13;</xsl:text>		
           	<xsl:text>public </xsl:text><xsl:value-of select="../../../parent-viewmodel"/><xsl:text>_DeleteItemEvent()</xsl:text>	
            <xsl:text>{</xsl:text>	
            <xsl:text>}</xsl:text>	
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">constructor</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
			
			<xsl:text>&#13;#region Properties&#13;</xsl:text>
			<xsl:text>&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">custom-properties</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
            <xsl:text>&#13;#endregion&#13;</xsl:text>	
        <xsl:text>}</xsl:text>
        <xsl:text>&#13;</xsl:text>
	</xsl:template>

</xsl:stylesheet>