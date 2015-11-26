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


	<xsl:template match="layout[parameters/parameter[@name='vmtype']='LISTITEM_1' and widget-variant='mdkwidget']" mode="item-list" priority="99">
		<xsl:variable name="vmprefix"><xsl:value-of select="substring-before(visualfields/visualfield[1]/name, '__')"/></xsl:variable>
		<xsl:variable name="presenterId"><xsl:value-of select="$vmprefix"/>__presenter__value</xsl:variable>


		<com.soprasteria.movalysmdk.widget.basic.MDKPresenterView
			android:layout_centerVertical="true">
			<xsl:attribute name="android:layout_alignParentLeft"><xsl:text>true</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_alignParentStart"><xsl:text>true</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_width"><xsl:text>86dp</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_height"><xsl:text>wrap_content</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_marginLeft"><xsl:text>5dip</xsl:text></xsl:attribute>
			<xsl:attribute name="android:id"><xsl:text>@+id/</xsl:text><xsl:value-of select="$presenterId"/></xsl:attribute>
		</com.soprasteria.movalysmdk.widget.basic.MDKPresenterView>

		<RelativeLayout>
			<xsl:attribute name="android:id"><xsl:text>@+id/</xsl:text><xsl:value-of select="name"/><xsl:text>2</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_toRightOf"><xsl:text>@+id/</xsl:text><xsl:value-of select="$presenterId"/></xsl:attribute>
			<xsl:attribute name="android:layout_alignParentRight"><xsl:text>true</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_centerVertical"><xsl:text>true</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_width"><xsl:text>match_parent</xsl:text></xsl:attribute>
			<xsl:attribute name="android:layout_height"><xsl:text>wrap_content</xsl:text></xsl:attribute>

			<xsl:apply-templates select="." mode="item-list-inner"/>

		</RelativeLayout>

	</xsl:template>

	<xsl:template match="layout[contains(parameters/parameter[@name='vmtype'],'LISTITEM')]" mode="item-list">
		<xsl:apply-templates select="." mode="item-list-inner"/>
	</xsl:template>


	<xsl:template match="layout" mode="item-list-inner">
		<xsl:variable name="addscroll"><xsl:value-of select="./parameters/parameter[@name ='addscroll']"/></xsl:variable>
		<xsl:variable name="addtitle"><xsl:value-of select="./title"/></xsl:variable>

		<xsl:if test="$addtitle != ''">
			<TextView
				android:layout_height="wrap_content" android:layout_width="match_parent"
				android:gravity="center" style="?attr/mdkTitleStyle">
				<xsl:attribute name="android:id">@+id/<xsl:value-of select="$addtitle" /></xsl:attribute>
				<xsl:attribute name="android:text">@string/<xsl:value-of select="$addtitle" /></xsl:attribute>
			</TextView>
		</xsl:if>

		<xsl:if test="parameters/parameter[@name='vmtype']='LISTITEM_2'">
			<xsl:attribute name="android:paddingLeft">0dip</xsl:attribute>
			<xsl:attribute name="android:paddingRight">5dip</xsl:attribute>
		</xsl:if>
		<xsl:if test="parameters/parameter[@name='vmtype']='LISTITEM_1' and parameters/parameter[@name='parentvmtype']='LISTITEM_2'">
			<xsl:attribute name="android:paddingLeft">5dip</xsl:attribute>
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
