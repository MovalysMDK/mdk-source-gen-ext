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

<xsl:output method="xml" indent="yes"/>

<!-- Default visualfield generation -->
<xsl:template match="visualfield">
	<xsl:param name="titleId"/>
	<xsl:param name="addNamespace"/>
	<xsl:text>
	</xsl:text>
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	
	<!-- Label of component -->
	<xsl:if test="not(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not(../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
		<xsl:apply-templates select="." mode="generate-label">
			<xsl:with-param name="titleId" select="$titleId"/>
		</xsl:apply-templates>
	</xsl:if>
	
	<!--  Component -->
	<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text>
	<xsl:value-of select="./component"/>
	<xsl:if test="$addNamespace!=''">
		xmlns:android="http://schemas.android.com/apk/res/android" 
		xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
	</xsl:if>
	android:id="@+id/<xsl:value-of select="./name"/><xsl:text>"</xsl:text>

	<xsl:apply-templates select="." mode="declare-component-style"/>
	<xsl:apply-templates select="." mode="componentAttributes">
		<xsl:with-param name="titleId" select="$titleId"/>
	</xsl:apply-templates>
	<xsl:text disable-output-escaping="yes">></xsl:text>
	<xsl:apply-templates select="." mode="componentContent"/>
	<xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text>
	<xsl:value-of select="./component"/>
	<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
</xsl:template>


<!-- Label generation (optional)-->
<xsl:template match="visualfield" mode="generate-label">
	<xsl:param name="titleId"/>
	
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:variable name="navButtons" select="../../buttons/button[@type='NAVIGATION']"/>
		
	<xsl:if test="create-label = 'true'">
	<xsl:text disable-output-escaping="yes"><![CDATA[<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMTextView android:id="@+id/]]></xsl:text>
	<xsl:value-of select="./label"/>" 
	android:text="@string/<xsl:value-of select="./label"/>"
	android:layout_width="wrap_content"
	android:layout_height="wrap_content"
	style="?attr/detail_label"
	android:freezesText="true"
	<xsl:choose>
		<xsl:when test="$precedingField">
		<xsl:text>android:layout_below="@id/</xsl:text>
		<xsl:value-of select="$precedingField/name"/>
		<xsl:text>"</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="$titleId">
				<xsl:text>android:layout_below="@id/</xsl:text>
				<xsl:value-of select="$titleId"/>
				<xsl:text>"</xsl:text>
	</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:if test="not($precedingField) and count($navButtons) > 0">
		<xsl:text>android:layout_below="@id/</xsl:text>
		<xsl:value-of select="$navButtons[last()]/@name"/>
		<xsl:text>"</xsl:text>
	</xsl:if>
	<xsl:text disable-output-escaping="yes"><![CDATA[/>]]>
	</xsl:text>
	</xsl:if>

</xsl:template>


<!-- Default attributs on component -->
<xsl:template match="visualfield" mode="componentAttributes">
	<xsl:param name="titleId"/>
	
	<xsl:call-template name="standard-alignment">
		<xsl:with-param name="titleId" select="$titleId"/>
	</xsl:call-template>
	<xsl:apply-templates select="." mode="view-focusable"/>	
	android:layout_width="match_parent"
	android:layout_height="wrap_content"
	<xsl:if test="count(mandatory) > 0">movalys:mandatory="<xsl:value-of select="mandatory"/>" </xsl:if>
	
	<!-- for list item, add vertical center and use minHeight -->
	<xsl:if test="../../parameters/parameter[@name='vmtype'] = 'LISTITEM_1'">
		android:gravity="center_vertical"
    	android:minHeight="40dp"
	</xsl:if>
</xsl:template>	

	<!-- STYLE ...................................................................................................... -->

	<xsl:template match="visualfield" mode="declare-component-style">
		<xsl:variable name="style">
			<xsl:apply-templates select="." mode="componentStyle"/>
		</xsl:variable>
		<xsl:if test="string-length($style) > 0">
			<xsl:text>
			style="?attr/</xsl:text>
			<xsl:value-of select="$style"/>
			<xsl:text>"</xsl:text>
		</xsl:if>
</xsl:template>

	<!-- No style by default -->
	<xsl:template match="visualfield" mode="componentStyle">
	</xsl:template>

	<!-- CONTENT .................................................................................................... -->

<!-- Default content on component -->
<xsl:template match="visualfield" mode="componentContent">
	<!-- Default: nothing -->
</xsl:template>

<!-- Options for standard alignement -->
<xsl:template name="standard-alignment">
	<xsl:param name="titleId"/>
	
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:variable name="navButtons" select="../../buttons/button[@type='NAVIGATION']"/>

	<xsl:if test="(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') or (../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
		<xsl:if test="$precedingField">
			android:layout_below="@id/<xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
		</xsl:if>
	</xsl:if>

	<xsl:if test="create-label = 'true' and not(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not(../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
		android:layout_below="@id/<xsl:value-of select="./label"/><xsl:text>" </xsl:text>
	</xsl:if>		

	<xsl:if test="create-label = 'false' and $precedingField and not(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not(../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
		android:layout_below="@id/<xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
	</xsl:if>
	<xsl:if test="create-label = 'false' and not($precedingField) and $titleId">
		android:layout_below="@id/<xsl:value-of select="$titleId"/><xsl:text>" </xsl:text>
	</xsl:if>
	<xsl:if test="not($precedingField) and count($navButtons) > 0">
		android:layout_below="@id/<xsl:value-of select="$navButtons[last()]/@name"/><xsl:text>" </xsl:text>
	</xsl:if>	

</xsl:template>

<!-- We generate focusable to false only in readonly list -->
<xsl:template match="visualfield[(/layout/parameters/parameter[@name='vmtype'] = 'LISTITEM_1' or /layout/parameters/parameter[@name='vmtype'] = 'LISTITEM_2' or /layout/parameters/parameter[@name='vmtype'] = 'LISTITEM_3') and /layout/parameters/parameter[@name='vmreadonly'] = 'true']" 
	mode="view-focusable">
	android:focusable='false'
</xsl:template>

<xsl:template match="visualfield" mode="view-focusable">
	<!-- nothing by default -->
</xsl:template>

</xsl:stylesheet>
