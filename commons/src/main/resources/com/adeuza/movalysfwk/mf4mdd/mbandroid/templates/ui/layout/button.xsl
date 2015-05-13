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

<!-- Specifics options for image buttons -->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton' and parameters/parameter[@name='context']='searchdialog']" 
	mode="componentAttributes"><xsl:text>
	android:src="@drawable/</xsl:text>
	 <xsl:choose>
      <xsl:when test="parameters/parameter[@name='type']='Cancel'">
     	<xsl:text>ic_btn_searchcancel</xsl:text>
      </xsl:when>
      <xsl:when test="parameters/parameter[@name='type']='Validate'">
     	<xsl:text>ic_btn_searchok</xsl:text>
      </xsl:when>
      <xsl:when test="parameters/parameter[@name='type']='Reset'">
     	<xsl:text>ic_btn_searchreset</xsl:text>
      </xsl:when>
    </xsl:choose><xsl:text>"     
	android:layout_width="wrap_content"
	android:layout_height="wrap_content"</xsl:text>
	<!-- if preceding field is a button, align to the Right of it -->
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:if test="$precedingField/component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton'">
		<xsl:if test="parameters/parameter[@name='type']='Reset'">
	android:layout_alignParentRight="true"</xsl:if>
		<xsl:if test="parameters/parameter[@name='type']!='Reset'">
	android:layout_toRightOf="@id/<xsl:value-of select="$precedingField/name"/>"</xsl:if>
    android:layout_alignTop="@id/<xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
    </xsl:if>
	<xsl:if test="$precedingField and not($precedingField/component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton')"><xsl:text>
	android:layout_below="@id/</xsl:text><xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
	</xsl:if>
</xsl:template>

<!--Specific style for search image button-->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton' and parameters/parameter[@name='context']='searchdialog']" mode="componentStyle">
	<xsl:text>SearchImageButton</xsl:text>
</xsl:template>

<!-- Specifics options for buttons -->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton']" 
	mode="componentAttributes"><xsl:text>
	android:text="@string/</xsl:text><xsl:value-of select="parameters/parameter[@name='text']"/><xsl:text>" 
	android:layout_width="wrap_content"
	android:layout_height="wrap_content"</xsl:text>
	<!-- if preceding field is a button, align to the left of it -->
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:if test="$precedingField/component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton'"><xsl:text> 
	android:layout_toRightOf="@id/</xsl:text><xsl:value-of select="$precedingField/name"/>"
    android:layout_alignTop="@id/<xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
	</xsl:if>
	<xsl:if test="$precedingField and not($precedingField/component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton')"><xsl:text>
	android:layout_below="@id/</xsl:text><xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
	</xsl:if>
</xsl:template>

	<!-- STYLE ...................................................................................................... -->

	<!--Specific style for search button-->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton' and parameters/parameter[@name='context']='searchdialog']" mode="componentStyle">
		<xsl:text>SearchButton</xsl:text>
	</xsl:template>

	<!--Default style for image button-->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton']" mode="componentStyle">
		<xsl:text>Button</xsl:text>
	</xsl:template>

	<!--Default style for button-->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton']" mode="componentStyle">
		<xsl:text>Button</xsl:text>
	</xsl:template>
</xsl:stylesheet>