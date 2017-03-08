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

	<xsl:template name="non-generated-bloc-rename">
		<xsl:param name="blocIdOld" />
		<xsl:param name="blocId" />
		<xsl:param name="defaultSource" />
		
		<xsl:variable name="bloc" select="//non-generated/bloc[@id=$blocIdOld]" />
		<xsl:choose>
			<xsl:when test="not($bloc)">
           		<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId"><xsl:value-of select="$blocId" /></xsl:with-param>
					<xsl:with-param name="defaultSource"/>
				</xsl:call-template>	
			</xsl:when>
         <xsl:otherwise>
	        <xsl:text>//@non-generated-start[</xsl:text>
			<xsl:value-of select="$blocId" />
			<xsl:text>]</xsl:text>
			<xsl:if test="$bloc/@allow-override = 'true' or not($bloc)">
				<xsl:text>[X]&#13;</xsl:text>
				<xsl:value-of select="$defaultSource" />
			</xsl:if>
			<xsl:if test="$bloc/@allow-override = 'false'">
				<xsl:text>&#13;</xsl:text>
				<xsl:value-of select="$bloc/." />
			</xsl:if>
			<xsl:text>//@non-generated-end&#13;</xsl:text>
         </xsl:otherwise>
       </xsl:choose>
	</xsl:template>

	<xsl:template name="non-generated-bloc">
		<xsl:param name="blocId" />
		<xsl:param name="defaultSource" />
		<xsl:text>//@non-generated-start[</xsl:text>
		<xsl:value-of select="$blocId" />
		<xsl:text>]</xsl:text>
		<xsl:variable name="bloc" select="//non-generated/bloc[@id=$blocId]" />
		<xsl:if test="$bloc/@allow-override = 'true' or not($bloc)">
			<xsl:text>[X]&#13;</xsl:text>
			<xsl:value-of select="$defaultSource" />
		</xsl:if>
		<xsl:if test="$bloc/@allow-override = 'false'">
			<xsl:text>&#13;</xsl:text>
			<xsl:value-of select="$bloc/." />
		</xsl:if>
		<xsl:text>//@non-generated-end&#13;</xsl:text>
	</xsl:template>


</xsl:stylesheet>