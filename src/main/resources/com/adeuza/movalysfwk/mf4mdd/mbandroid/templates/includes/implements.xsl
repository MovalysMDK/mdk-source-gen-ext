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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		
	<xsl:template match="node()" mode="declare-implements">
		<xsl:variable name="implements">
			<implements>
				<xsl:apply-templates select="implements/interface" mode="declare-standard-implements"/>
				<xsl:apply-templates select="." mode="declare-extra-implements"/>
			</implements>
		</xsl:variable>

		<xsl:apply-templates select="exsl:node-set($implements)/implements/interface" mode="write-implement">
		</xsl:apply-templates>

	</xsl:template>	

	<xsl:template match="interface" mode="declare-standard-implements">
		<interface><xsl:value-of select="@name"/></interface>
	</xsl:template>
	
	<xsl:template match="interface" mode="write-implement">
		<xsl:if test="position() != 1">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:value-of select="."/>
	</xsl:template>

		
</xsl:stylesheet>