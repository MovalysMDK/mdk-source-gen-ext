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

<!-- Options for standard alignement -->
<xsl:template match="visualfield" mode="standard-alignment">
	<xsl:param name="titleId"/>
	<xsl:param name="labelFeature" select="contains(./component, 'com.soprasteria.movalysmdk.widget') or component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMFixedList'"/>
	
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:variable name="navButtons" select="../../buttons/button[@type='NAVIGATION']"/>
	
	<xsl:if test="(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') or (../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
		<xsl:if test="$precedingField">
			android:layout_below="@id/<xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
		</xsl:if>
	</xsl:if>

	<xsl:if test="create-label = 'true' and not(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not(../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not($labelFeature)">
		android:layout_below="@id/<xsl:value-of select="./label"/><xsl:text>" </xsl:text>
	</xsl:if>		

	<xsl:if test="(create-label = 'false' or $labelFeature) and $precedingField and not(../../parameters/parameter[@name='vmtype-itemlayoutforinnerlist']='LIST_1__ONE_SELECTED') and not(../../parameters/parameter[@name='vmtype-selecteditemlayoutforinnerlist']='LIST_1__ONE_SELECTED')">
		android:layout_below="@id/<xsl:value-of select="$precedingField/name"/><xsl:text>" </xsl:text>
	</xsl:if>
	<xsl:if test="(create-label = 'false' or /widget-variant='mdkwidget' or $labelFeature) and not($precedingField) and $titleId">
		android:layout_below="@id/<xsl:value-of select="$titleId"/><xsl:text>" </xsl:text>
	</xsl:if>
	<xsl:if test="not($precedingField) and count($navButtons) > 0 and not (../../parameters/parameter[@name='vmtype']='LIST_1' or ../../parameters/parameter[@name='vmtype']='LIST_2' or ../../parameters/parameter[@name='vmtype']='LIST_3')">
		android:layout_below="@id/<xsl:value-of select="$navButtons[last()]/@name"/><xsl:text>" </xsl:text>
	</xsl:if>	

</xsl:template>

</xsl:stylesheet>

