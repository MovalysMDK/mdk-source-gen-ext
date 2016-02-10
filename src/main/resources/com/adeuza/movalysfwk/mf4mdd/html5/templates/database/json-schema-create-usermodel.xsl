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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" indent="no"/>

	<xsl:template match="json_usermodel">
	<xsl:text>&#10;{</xsl:text>
		<xsl:apply-templates select="./class" />
		<xsl:text>&#10;}</xsl:text>
	</xsl:template>

	<!-- Template for table creation -->
	<xsl:template match="class">
		<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#34;</xsl:text><xsl:value-of select="./uml-name"/><xsl:text>&#34;:&#10;</xsl:text>
		<xsl:text>{&#34;keyPath&#34;:&#34;</xsl:text><xsl:value-of select="./identifier/attribute/parameter-name"/><xsl:text>&#34;,&#10;</xsl:text>
		<xsl:text>&#34;createIndex&#34;:[</xsl:text>
		<xsl:for-each select="./association[(@type='many-to-one' or (@type='one-to-one' and @relation-owner='true' and @transient='false')) and @opposite-navigable='true']">
				<xsl:variable name="nameValue" select="@name"/>
				<xsl:variable name="nameLower" select="translate($nameValue, $uppercase, $smallcase)"/>

				<xsl:text>&#10;{&#34;name&#34;:&#34;</xsl:text><xsl:value-of select="$nameLower"/><xsl:text>Index&#34;, &#34;keyPath&#34;:&#34;</xsl:text><xsl:value-of select="$nameLower"/><xsl:text>id&#34;,</xsl:text>
				<xsl:text>&#34;unique&#34;:false }&#10;</xsl:text>
				<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:text>]&#10;}&#10;</xsl:text>
	<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
	</xsl:template>

	
</xsl:stylesheet>