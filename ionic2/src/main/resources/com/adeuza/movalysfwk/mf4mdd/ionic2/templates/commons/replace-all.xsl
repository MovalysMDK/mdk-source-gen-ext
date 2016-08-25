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

	<xsl:template name="string-replace-all" >
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />

		<xsl:choose>
			<xsl:when test="string-length($text) &gt; 0 and contains($text, $replace) = 'true'">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />

				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  permet de mettre en majuscule la première lettre du texte en parametre -->
	<xsl:template name="string-uppercase-firstchar" >
		<xsl:param name="text" />
		
		<xsl:variable name="lmajuscules">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ</xsl:variable>
		<xsl:variable name="lminuscules">abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ</xsl:variable>
		
		<xsl:value-of select="translate(substring($text,1,1),$lminuscules,$lmajuscules)"/>
		<xsl:value-of select="substring($text,2)"/>		
	</xsl:template>
	
	<!--  permet de mettre en minuscules le texte en parametre -->
	<xsl:template name="string-lowercase" >
		<xsl:param name="text" />
		
		<xsl:variable name="lmajuscules">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ</xsl:variable>
		<xsl:variable name="lminuscules">abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ</xsl:variable>
		
		<xsl:value-of select="translate($text,$lmajuscules,$lminuscules)"/>	
	</xsl:template>
	
</xsl:stylesheet>