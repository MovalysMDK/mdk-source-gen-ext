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

	<!-- ###################################################
						GESTION DES SUPER-INTERFACES
		################################################### -->

	<xsl:template match="node()" mode="extends">
		<xsl:variable name="superinterfaces">
			<xsl:apply-templates select="." mode="superinterfaces"/>
		</xsl:variable>
		
		<xsl:if test="string-length($superinterfaces) > 0">
			<xsl:text> : &#13;</xsl:text>
			<xsl:text>//@non-generated-start[class-signature]&#13;</xsl:text>
			<xsl:value-of select="$superinterfaces"/>
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="node()" mode="superinterfaces">
		<xsl:apply-templates select="./linked-interface" mode="superinterface"/>
	</xsl:template>

	<xsl:template match="linked-interface" mode="superinterface">
		<xsl:if test="./position > 1">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:value-of select="./name"/>
	</xsl:template>
	
</xsl:stylesheet>