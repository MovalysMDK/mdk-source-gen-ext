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

	<!-- common templates -->
	<xsl:include href="ui/layout/default.xsl"/>
	
	<xsl:include href="ui/layout/commons/alignment.xsl"/>
	<xsl:include href="ui/layout/commons/attributes.xsl"/>
	<xsl:include href="ui/layout/commons/content.xsl"/>
	<xsl:include href="ui/layout/commons/dimensions.xsl"/>
	<xsl:include href="ui/layout/commons/focusable.xsl"/>
	<xsl:include href="ui/layout/commons/hint.xsl"/>
	<xsl:include href="ui/layout/commons/inputtype.xsl"/>
	<xsl:include href="ui/layout/commons/label-component.xsl"/>
	<xsl:include href="ui/layout/commons/label.xsl"/>
	<xsl:include href="ui/layout/commons/mandatory.xsl"/>
	<xsl:include href="ui/layout/commons/maxlength.xsl"/>
	<xsl:include href="ui/layout/commons/style.xsl"/>
	
	<!-- legacy widgets -->
	<xsl:include href="ui/layout/button.xsl"/>
	<xsl:include href="ui/layout/datetime.xsl"/>
	<xsl:include href="ui/layout/edittext.xsl"/>
	<xsl:include href="ui/layout/enumimage.xsl"/>
	<xsl:include href="ui/layout/filterbutton.xsl"/>
	<xsl:include href="ui/layout/fixedlist.xsl"/>
	<xsl:include href="ui/layout/radiogroup.xsl"/>
	<xsl:include href="ui/layout/actionbutton.xsl"/>
	<xsl:include href="ui/layout/workspace.xsl"/>
	<xsl:include href="ui/layout/multipanel.xsl"/>
	<xsl:include href="ui/layout/viewstyle.xsl"/>
	<xsl:include href="ui/layout/spinner.xsl"/>
	<xsl:include href="ui/layout/photothumbnail.xsl"/>
	<xsl:include href="ui/layout/enumbackgroundlayout.xsl"/>
	
	<!-- mdk widgets -->
	<xsl:include href="ui/layout/mdkwidget/richedittext.xsl"/>
	
	<!-- custom widgets -->
	<xsl:include href="ui/custom-components.xsl"/>
	
	<!-- LAYOUT GENERATION -->
	<xsl:template match="layout">

		<xsl:variable name="addscroll"><xsl:value-of select="./parameters/parameter[@name ='addscroll']"/></xsl:variable>
		<xsl:variable name="addtitle"><xsl:value-of select="./title"/></xsl:variable>
		<!-- <xsl:variable name="firstVisualfieldId"><xsl:value-of select="./visualfields/visualfield[position()=1]/name"/></xsl:variable>-->
		
		<!--  dans le cas d'une page simple on ajoute le scroll vertical -->
		<xsl:choose>
			<xsl:when test="$addscroll != ''">
				<RelativeLayout
					xmlns:android="http://schemas.android.com/apk/res/android" 
					xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
					xmlns:mdk="http://schemas.android.com/apk/res-auto"
					android:layout_width="match_parent" 
					android:layout_height="match_parent">
					<xsl:attribute name="android:id">@+id/<xsl:value-of select="./name"/></xsl:attribute>
					
					<xsl:if test="$addtitle != ''">
					    <com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle
							android:layout_width="match_parent" 
							android:layout_height="wrap_content" 
							android:gravity="center" 
							style="?attr/SectionTitle">
							<xsl:attribute name="android:id">@+id/<xsl:value-of select="$addtitle"/></xsl:attribute>
					        <xsl:attribute name="android:text">@string/<xsl:value-of select="$addtitle"/></xsl:attribute>
						</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>
					</xsl:if>
					
					<ScrollView  
						android:layout_width="match_parent" 
						android:layout_height="match_parent">
						<xsl:attribute name="android:id">@+id/<xsl:value-of select="substring-before($addscroll, '__master')"/>scroll__visualpanel</xsl:attribute>
						<xsl:if test="$addtitle != ''">
							<xsl:attribute name="android:layout_below">@id/<xsl:value-of select="$addtitle"/></xsl:attribute>
						</xsl:if>
					
						<RelativeLayout
							android:layout_width="match_parent" 
							android:layout_height="match_parent">
						<xsl:attribute name="android:id">@+id/<xsl:value-of select="substring-before($addscroll, '__master')"/>__visualpanel</xsl:attribute>
						<xsl:apply-templates select="visualfields/visualfield">
							<xsl:with-param name="titleId"><xsl:value-of select="$addtitle"/></xsl:with-param>
						</xsl:apply-templates>
						<xsl:apply-templates select="buttons/button"/>
						</RelativeLayout>
					</ScrollView>
				</RelativeLayout>
			</xsl:when>
			<xsl:when test="buttons/button[@type='NAVIGATION']/navigation[@type='NAVIGATION']">
				<RelativeLayout
					xmlns:android="http://schemas.android.com/apk/res/android" 
					xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
					xmlns:mdk="http://schemas.android.com/apk/res-auto"
					android:layout_width="match_parent" 
					android:layout_height="match_parent">
					<xsl:attribute name="android:id">@+id/<xsl:value-of select="./name"/></xsl:attribute>
					
				<RelativeLayout
					android:layout_width="match_parent" 
					android:layout_height="wrap_content"
					android:layout_centerVertical="true">
				<xsl:apply-templates select="buttons/button[@type='NAVIGATION']"/>
				</RelativeLayout>
				</RelativeLayout>
			</xsl:when>
			<xsl:when test="contains(parameters/parameter[@name='vmtype'],'LISTITEM')">
				<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMCheckableRelativeLayout
					xmlns:android="http://schemas.android.com/apk/res/android" 
					xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
					xmlns:mdk="http://schemas.android.com/apk/res-auto"
					android:layout_width="match_parent" 
					android:layout_height="match_parent">
					<xsl:attribute name="android:id">@+id/<xsl:value-of select="./name"/></xsl:attribute>
					
				<xsl:if test="$addtitle != ''">
					<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle
						android:layout_width="match_parent" 
						android:layout_height="wrap_content" 
						android:gravity="center" 
						style="?attr/SectionTitle">
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
				</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMCheckableRelativeLayout>
			</xsl:when>
			<xsl:when test="parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist' or @name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED' and count(visualfields/visualfield) = 1">
				<xsl:if test="$addtitle != ''">
					<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle
						xmlns:android="http://schemas.android.com/apk/res/android" 
						xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
						xmlns:mdk="http://schemas.android.com/apk/res-auto"
						android:layout_width="match_parent" 
						android:layout_height="wrap_content" 
						android:gravity="center" 
						style="?attr/SectionTitle">
						<xsl:attribute name="android:id">@+id/<xsl:value-of select="$addtitle"/></xsl:attribute>
						<xsl:attribute name="android:text">@string/<xsl:value-of select="$addtitle"/></xsl:attribute>
					</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>				
				</xsl:if>
				<xsl:if test="parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='FIXED_LIST'">
					<xsl:attribute name="style">?attr/fixedListItemBloc</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="buttons/button[@type='NAVIGATION']"/>
				<xsl:apply-templates select="visualfields/visualfield">
					<xsl:with-param name="titleId"><xsl:value-of select="$addtitle"/></xsl:with-param>
					<xsl:with-param name="addNamespace">$addtitle=''</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="buttons/button[@type!='NAVIGATION']"/>
			</xsl:when>
			<xsl:otherwise>
				<RelativeLayout
					xmlns:android="http://schemas.android.com/apk/res/android" 
					xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
					xmlns:mdk="http://schemas.android.com/apk/res-auto"
					android:layout_width="match_parent" 
					android:layout_height="match_parent">
					<xsl:attribute name="android:id">@+id/<xsl:value-of select="./name"/></xsl:attribute>
					
				<xsl:if test="$addtitle != ''">
					<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle
						android:layout_width="match_parent" 
						android:layout_height="wrap_content" 
						android:gravity="center" 
						style="?attr/SectionTitle">
						<xsl:attribute name="android:id">@+id/<xsl:value-of select="$addtitle"/></xsl:attribute>
						<xsl:attribute name="android:text">@string/<xsl:value-of select="$addtitle"/></xsl:attribute>
					</com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle>				
				</xsl:if>
				<xsl:if test="parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='FIXED_LIST'">
					<xsl:attribute name="style">?attr/fixedListItemBloc</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="buttons/button[@type='NAVIGATION']"/>
				<xsl:apply-templates select="visualfields/visualfield">
					<xsl:with-param name="titleId"><xsl:value-of select="$addtitle"/></xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="buttons/button[@type!='NAVIGATION']"/>
				</RelativeLayout>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
