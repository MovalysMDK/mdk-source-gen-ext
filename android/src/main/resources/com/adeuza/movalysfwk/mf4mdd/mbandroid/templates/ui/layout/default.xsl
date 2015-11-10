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

<!-- DEFAULT GENERATION FOR WIDGET
Following templates are applied :
1- generate-label : label generation
2- declare-component-style: widget style
3- componentAttributes : widget attributes
4- componentContent: widget content
-->
<xsl:template match="visualfield">
	<xsl:param name="titleId"/>
	<xsl:param name="addNamespace"/>

	<xsl:text>
	</xsl:text>
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:variable name="labelFeature" select="contains(./component, 'com.soprasteria.movalysmdk.widget')"/>
	
	<!-- Label of component -->
	<xsl:if test="not($labelFeature) and not(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not(../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
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
		xmlns:mdk="http://schemas.android.com/apk/res-auto"
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

</xsl:stylesheet>
