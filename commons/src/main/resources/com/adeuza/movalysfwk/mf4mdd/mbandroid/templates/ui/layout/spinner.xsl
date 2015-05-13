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

<!-- Specifics attribute for datetime component -->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSpinnerCheckedTextView']" mode="componentAttributes">
	<xsl:call-template name="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>	
	android:layout_height="?android:attr/listPreferredItemHeight"
	android:singleLine="true"
	android:layout_width="match_parent"
</xsl:template>

<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSpinner']"	mode="componentAttributes">
	<xsl:call-template name="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>	
	android:prompt="@string/<xsl:value-of select="parameters/parameter[@name='prompt']"/><xsl:text>" </xsl:text>
	android:layout_height="wrap_content"
	android:layout_width="match_parent"
	<xsl:if test="count(./mandatory) > 0">movalys:mandatory="<xsl:value-of select="./mandatory"/>" </xsl:if>
</xsl:template>

<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSearchSpinner']"	mode="componentAttributes">
	<xsl:call-template name="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>	
	android:prompt="@string/<xsl:value-of select="parameters/parameter[@name='prompt']"/><xsl:text>" </xsl:text>
	android:layout_height="wrap_content"
	android:layout_width="match_parent"
	style="?attr/SearchSpinnerCustom"
	<xsl:if test="count(./mandatory) > 0">movalys:mandatory="<xsl:value-of select="./mandatory"/>" </xsl:if>
</xsl:template>

	<!-- STYLE ...................................................................................................... -->

	<xsl:template match="visualfield[ancestor::layout/parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED' and substring-after(substring-after(./name, '__'), '__') = 'value']" mode="componentStyle">
		<xsl:text>simpleSpinner_dropDown</xsl:text>
	</xsl:template>

	<xsl:template match="visualfield[ancestor::layout/parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED' and substring-after(substring-after(./name, '__'), '__') = 'value']" mode="componentStyle">
		<xsl:text>simpleSpinner_Item</xsl:text>
	</xsl:template>
</xsl:stylesheet>