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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ionic2/templates/commons/import.xsl"/>

	<xsl:include href="action/save-action.xsl"/>
	<xsl:include href="action/delete-action.xsl"/>

	<xsl:output method="text"/>

	<xsl:template match="master-action">
		<xsl:apply-templates select="action" mode="genereAction">
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="savecascades" mode="cascades">
		<xsl:text>[</xsl:text>
		<xsl:for-each select="cascade">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="savecascades" mode="cascades-workspace">
		<xsl:if test="position() = 1">
			<xsl:text>[</xsl:text>
		</xsl:if>
		<xsl:if test="../entity-to-update/name = ../../../../class/name">
			
			<xsl:for-each select="cascade">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>]</xsl:text>
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="action" mode="genereAction">
	</xsl:template>
	
</xsl:stylesheet>
