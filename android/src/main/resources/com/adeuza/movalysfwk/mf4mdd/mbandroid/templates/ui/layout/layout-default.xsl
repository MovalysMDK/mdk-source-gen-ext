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

	<xsl:template match="layout[widget-variant='mdkwidget' and (parameters/parameter[@name='vmtype']='LIST_1' or parameters/parameter[@name='vmtype']='LIST_2' or parameters/parameter[@name='vmtype']='LIST_3')]" mode="layout-default">
		<xsl:param name="addtitle"/>
		
		<android.support.design.widget.CoordinatorLayout
				
				android:layout_height="match_parent"
				android:layout_width="match_parent"
				xmlns:android="http://schemas.android.com/apk/res/android"
				xmlns:mdk="http://schemas.android.com/apk/res-auto" xmlns:movalys="http://www.adeuza.com/movalys/mm/android">
				
				<xsl:attribute name="android:id">@+id/<xsl:value-of select="./name" /></xsl:attribute>

			<xsl:if test="$addtitle != ''">
				<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle
					android:layout_width="match_parent" android:layout_height="wrap_content"
					android:gravity="center" style="?attr/SectionTitle">
					<xsl:attribute name="android:id">@+id/<xsl:value-of
						select="$addtitle" /></xsl:attribute>
					<xsl:attribute name="android:text">@string/<xsl:value-of
						select="$addtitle" /></xsl:attribute>
				</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>
			</xsl:if>

			<xsl:apply-templates select="." mode="layout-default-inner-scroll">
				<xsl:with-param name="addtitle"><xsl:value-of select="$addtitle"/></xsl:with-param>
			</xsl:apply-templates>
			
			<android.support.design.widget.FloatingActionButton
				android:id="@+id/fab"
				android:layout_width="wrap_content"
				android:layout_height="wrap_content"
				android:layout_gravity="bottom|end"
				android:src="@android:drawable/ic_menu_add"/>

		</android.support.design.widget.CoordinatorLayout>

	</xsl:template>

	<xsl:template match="layout" mode="layout-default">
		<xsl:param name="addtitle"/>
		
		<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
			xmlns:movalys="http://www.adeuza.com/movalys/mm/android" xmlns:mdk="http://schemas.android.com/apk/res-auto"
			android:layout_width="match_parent" android:layout_height="match_parent">
			<xsl:attribute name="android:id">@+id/<xsl:value-of select="./name" /></xsl:attribute>

			<xsl:if test="$addtitle != ''">
				<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle
					android:layout_width="match_parent" android:layout_height="wrap_content"
					android:gravity="center" style="?attr/SectionTitle">
					<xsl:attribute name="android:id">@+id/<xsl:value-of
						select="$addtitle" /></xsl:attribute>
					<xsl:attribute name="android:text">@string/<xsl:value-of
						select="$addtitle" /></xsl:attribute>
				</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>
			</xsl:if>

			<xsl:apply-templates select="." mode="layout-default-inner-scroll">
				<xsl:with-param name="addtitle"><xsl:value-of select="$addtitle"/></xsl:with-param>
			</xsl:apply-templates>
			
		</RelativeLayout>

	</xsl:template>
	
	
	<xsl:template match="layout[parameters/parameter/@name ='addscroll']" mode="layout-default-inner-scroll">
		<xsl:param name="addtitle"/>
		<xsl:variable name="addscroll"><xsl:value-of select="./parameters/parameter[@name ='addscroll']"/></xsl:variable>

		<ScrollView android:layout_width="match_parent"
			android:layout_height="match_parent">

			<xsl:attribute name="android:id">@+id/<xsl:value-of
				select="substring-before($addscroll, '__master')" />scroll__visualpanel</xsl:attribute>
			<xsl:if test="$addtitle != ''">
				<xsl:attribute name="android:layout_below">@id/<xsl:value-of
					select="$addtitle" /></xsl:attribute>
			</xsl:if>

			<RelativeLayout android:layout_width="match_parent"
				android:layout_height="match_parent">
				<xsl:attribute name="android:id">@+id/<xsl:value-of
					select="substring-before($addscroll, '__master')" />__visualpanel</xsl:attribute>
					
					<xsl:apply-templates select="." mode="layout-default-inner">
						<xsl:with-param name="addtitle"><xsl:value-of select="$addtitle"/></xsl:with-param>
					</xsl:apply-templates>
					
			</RelativeLayout>
		</ScrollView>

	</xsl:template>
	
	<xsl:template match="*" mode="layout-default-inner-scroll">
		<xsl:param name="addtitle"/>
		
		<xsl:apply-templates select="." mode="layout-default-inner">
			<xsl:with-param name="addtitle"><xsl:value-of select="$addtitle"/></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="layout" mode="layout-default-inner">
		<xsl:param name="addtitle"/>
		<xsl:if test="parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='FIXED_LIST'">
			<xsl:attribute name="style">?attr/fixedListItemBloc</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="buttons/button[@type='NAVIGATION']" />
		<xsl:apply-templates select="visualfields/visualfield">
			<xsl:with-param name="titleId">
				<xsl:value-of select="$addtitle" />
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="buttons/button[@type!='NAVIGATION']" />
	</xsl:template>
	
</xsl:stylesheet>