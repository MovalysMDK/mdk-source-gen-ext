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
xmlns:android="http://schemas.android.com/apk/res/android">

	<xsl:output method="xml" indent="yes"/>

	<!--  Specifics options for workspace component -->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMMultiSectionLayout' or component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMMultiSectionFragmentLayout']" >	

			<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="./component"/>
			android:id="@+id/<xsl:value-of select="./name"/><xsl:text>" </xsl:text>
			<xsl:apply-templates select="." mode="dimensions-matchparent"/>
     		android:orientation="vertical"
     		movalys:sectionsize="<xsl:value-of select="count(./multipanel-config/managment-details/column[@pos='1']/managment-detail)"/>"
     		
     		<xsl:apply-templates select="./multipanel-config/managment-details/column[@pos='1']/managment-detail" mode="genSectionAttr">
     			<xsl:sort select="../@pos" data-type="number"/>
				<xsl:sort select="@section" data-type="number"/>
     		</xsl:apply-templates>
     		<!-- 
			<xsl:for-each select="./multipanel-config/managment-details/column[@pos='1']/managment-detail">
				<xsl:sort select="../@pos" data-type="number"/>
				<xsl:sort select="@section" data-type="number"/>
				
			</xsl:for-each>
			 -->
			<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
			
			<xsl:apply-templates select="." mode="multisection-children"/>
			
			<xsl:text disable-output-escaping="yes"><![CDATA[</]]></xsl:text><xsl:value-of select="./component"/>
			<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
	</xsl:template>
	
	
	<xsl:template match="managment-detail[ancestor::visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMMultiSectionLayout']]" mode="genSectionAttr">
	<xsl:text>
				movalys:section</xsl:text><xsl:value-of select="position()"/>="<xsl:value-of select="."/>"
	</xsl:template>
	
	<xsl:template match="managment-detail[ancestor::visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMMultiSectionFragmentLayout']]" mode="genSectionAttr">
	<xsl:text>
				movalys:section</xsl:text><xsl:value-of select="position()"/>="<xsl:value-of select="."/>#<xsl:value-of select="@container-id"/>"
	</xsl:template>
	
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMMultiSectionFragmentLayout']"
		mode="multisection-children">
			<xsl:apply-templates select="multipanel-config/managment-details//managment-detail" mode="genFrameLayout"/>        
	</xsl:template>
		
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMMultiSectionLayout']"
		mode="multisection-children">
	</xsl:template>
	
	<xsl:template match="managment-detail" mode="genFrameLayout">
		<FrameLayout android:layout_height="0dp" android:layout_width="match_parent" android:layout_weight="1">
	       	 <xsl:attribute name="android:id">@+id/<xsl:value-of select="@container-id"/></xsl:attribute>
	    </FrameLayout>
	</xsl:template>

</xsl:stylesheet>
