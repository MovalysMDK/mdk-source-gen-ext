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

	<xsl:template name="first-letter-to-uppercase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate(substring($text,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring($text,2)"/>
	</xsl:template>


	<xsl:template name="add-id-for-by">
		<xsl:param name="text"/>
		<xsl:param name="interface"/>

		<xsl:variable name="byMethodNameSuffixe"><xsl:value-of select="substring-after($text,$interface)"/></xsl:variable>
		<xsl:variable name="byMethodNamePrefixe"><xsl:value-of select="substring-before($text,$byMethodNameSuffixe)"/></xsl:variable>
		<xsl:value-of select="$byMethodNamePrefixe"/>Id<xsl:value-of select="$byMethodNameSuffixe"/>
	</xsl:template>


	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:param name="to"/>

		<xsl:choose>
			<xsl:when test="contains($text, $from)">
				<xsl:variable name="before" select="substring-before($text, $from)"/>
				<xsl:variable name="after" select="substring-after($text, $from)"/>
				<xsl:variable name="prefix" select="concat($before, $to)"/>

				<xsl:value-of select="$before"/>
				<xsl:value-of select="$to"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="$after"/>
					<xsl:with-param name="from" select="$from"/>
					<xsl:with-param name="to" select="$to"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>