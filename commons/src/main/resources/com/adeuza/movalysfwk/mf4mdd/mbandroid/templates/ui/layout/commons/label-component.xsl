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

<!-- LABEL WIDGET GENERATION (for legacy widget)-->
<xsl:template match="visualfield[create-label = 'true']" mode="generate-label">
	<xsl:param name="titleId"/>
	
	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>
	<xsl:variable name="navButtons" select="../../buttons/button[@type='NAVIGATION']"/>
		
	<xsl:text disable-output-escaping="yes"><![CDATA[<com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMTextView android:id="@+id/]]></xsl:text>
	<xsl:value-of select="./label"/>" 
	android:text="@string/<xsl:value-of select="./label"/>"
	<xsl:apply-templates select="." mode="dimensions-wrap"/>
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
	
</xsl:template>

<!-- fallback template -->
<xsl:template match="visualfield" mode="generate-label">

</xsl:template>

</xsl:stylesheet>