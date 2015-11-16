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
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:android="http://schemas.android.com/apk/res/android">

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="layout[contains(parameters/parameter[@name='vmtype'],'LISTITEM')]" mode="item-list">
		<xsl:apply-templates select="." mode="item-list-inner"/>
	</xsl:template>
	
	
	<xsl:template match="layout" mode="item-list-inner">
		<xsl:variable name="addscroll"><xsl:value-of select="./parameters/parameter[@name ='addscroll']"/></xsl:variable>
		<xsl:variable name="addtitle"><xsl:value-of select="./title"/></xsl:variable>

		<xsl:if test="$addtitle != ''">
			<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>
				<xsl:attribute name="android:layout_width">match_parent</xsl:attribute>
				<xsl:attribute name="android:layout_height">match_parent</xsl:attribute>
				<xsl:attribute name="android:gravity">center</xsl:attribute>
				<xsl:attribute name="style">?attr/SectionTitle</xsl:attribute>
				<xsl:attribute name="android:id">@+id/<xsl:value-of select="$addtitle"/></xsl:attribute>
				<xsl:attribute name="android:text">@string/<xsl:value-of select="$addtitle"/></xsl:attribute>
			</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>
		</xsl:if>
		
		<xsl:if test="parameters/parameter[@name='vmtype']='LISTITEM_2'">
			<xsl:attribute name="android:paddingLeft">35dip</xsl:attribute>
			<xsl:attribute name="android:paddingRight">5dip</xsl:attribute>
		</xsl:if>
		<xsl:if test="parameters/parameter[@name='vmtype']='LISTITEM_1' and parameters/parameter[@name='parentvmtype']='LISTITEM_2'">
			<xsl:attribute name="android:paddingLeft">40dip</xsl:attribute>
			<xsl:attribute name="android:paddingRight">5dip</xsl:attribute>
		</xsl:if>
		<!--Default style for ListItem-->
		<xsl:attribute name="style"><xsl:text>?attr/</xsl:text><xsl:value-of select="./parameters/parameter[@name='vmtype']"/></xsl:attribute>
		<xsl:if test="parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='FIXED_LIST'">
			<xsl:attribute name="style">?attr/fixedListItemBloc</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="buttons/button[@type='NAVIGATION']"/>
		<xsl:apply-templates select="visualfields/visualfield">
			<xsl:with-param name="titleId"><xsl:value-of select="$addtitle"/></xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="buttons/button[@type!='NAVIGATION']"/>

	</xsl:template>
	
</xsl:stylesheet>