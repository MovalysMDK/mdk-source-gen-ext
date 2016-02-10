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

	<xsl:template match="node()" mode="declare-imports">
	<xsl:param name="debug"></xsl:param>
		<xsl:variable name="currentId" select="generate-id(.)"/>
		<xsl:variable name="ancestorId" select="generate-id(/node())"/>
		<xsl:variable name="imports">
			<imports>
				<xsl:copy-of select="import"/>
				<xsl:if test="$currentId != $ancestorId">
					<xsl:copy-of select="/node()/import"/>
				</xsl:if>
				<xsl:apply-templates select="." mode="declare-extra-imports">
				<xsl:with-param name="debug"></xsl:with-param>
				</xsl:apply-templates>
			</imports>
		</xsl:variable>

		<xsl:apply-templates select="exsl:node-set($imports)/imports/import[starts-with(., 'java')]" mode="write-import">
		<xsl:with-param name="debug"><xsl:value-of select="$debug"></xsl:value-of></xsl:with-param>
			<xsl:sort/>
		</xsl:apply-templates>

		<xsl:apply-templates select="exsl:node-set($imports)/imports/import[starts-with(., 'org')]" mode="write-import">
					<xsl:with-param name="debug"><xsl:value-of select="$debug"></xsl:value-of></xsl:with-param>
			
			<xsl:sort/>
		</xsl:apply-templates>

		<xsl:apply-templates select="exsl:node-set($imports)/imports/import[starts-with(., 'com')]" mode="write-import">
					<xsl:with-param name="debug"><xsl:value-of select="$debug"></xsl:value-of></xsl:with-param>
			
			<xsl:sort/>
		</xsl:apply-templates>

		<xsl:apply-templates select="exsl:node-set($imports)/imports/import[not(starts-with(., 'java')) and not(starts-with(., 'org')) and not(starts-with(., 'com'))]" mode="write-import">
					<xsl:with-param name="debug"><xsl:value-of select="$debug"></xsl:value-of></xsl:with-param>
			
			<xsl:sort/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*/text()|@*" mode="declare-import">
	<xsl:param name="debug"></xsl:param>
		<import><xsl:value-of select="."/>
		<xsl:if test="string-length($debug) > 0">
			<xsl:text>_________DEBUG_________</xsl:text>
			<xsl:value-of select="$debug"></xsl:value-of>
		</xsl:if>
		</import>
	</xsl:template>

	<xsl:template match="import" mode="write-import">
		<xsl:param name="debug"></xsl:param>
		<xsl:variable name="currentImport" select="text()"/>
		<xsl:if test="count(preceding-sibling::import[text()=$currentImport]) = 0">
			<xsl:text>import </xsl:text>
			<xsl:value-of select="."/>
			<xsl:if test="string-length($debug) > 0">
			<xsl:text>_________DEBUG_________</xsl:text>
			<xsl:value-of select="$debug"></xsl:value-of>
			</xsl:if>
			<xsl:text>;&#13;</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>