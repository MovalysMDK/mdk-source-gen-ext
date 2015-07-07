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

<!-- Specifics options for MMFixedListView -->
<xsl:template match="visualfield[contains(component, 'MMFixedListView') or contains(component, 'MMPhotoFixedListView')]">
	<xsl:param name="titleId"/>

	<xsl:variable name="precedingField" select="preceding-sibling::visualfield[1]"/>

	<xsl:text disable-output-escaping="yes"><![CDATA[
	<]]></xsl:text><xsl:value-of select="./component"/>
	android:id="@+id/<xsl:value-of select="./name"/>"
	<xsl:if test="not($precedingField) and $titleId">
		<xsl:text>android:layout_below="@id/</xsl:text>
		<xsl:value-of select="$titleId"/>
		<xsl:text>"</xsl:text>
	</xsl:if>
	<xsl:if test="$precedingField">
		android:layout_below="@id/<xsl:value-of select="$precedingField/name"/>"
	</xsl:if>
	android:text="@string/<xsl:value-of select="label"/><xsl:text>" </xsl:text>
	<xsl:apply-templates select="." mode="dimensions-matchparent"/>
	/<xsl:text disable-output-escaping="yes">>
	</xsl:text>
</xsl:template>

</xsl:stylesheet>
