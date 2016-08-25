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


	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ionic2/templates/commons/nongenerated.xsl"/>

	<xsl:template match="node()" mode="declare-protocol-imports">
		<xsl:param name="useClass">false</xsl:param>
		<xsl:variable name="currentId" select="generate-id(.)"/>
		<xsl:variable name="ancestorId" select="generate-id(/node())"/>

		<xsl:variable name="imports">
			<objc-imports>
				<xsl:copy-of select="objc-imports/objc-import"/>
				<xsl:if test="$currentId != $ancestorId">
					<xsl:copy-of select="/node()/objc-imports/objc-import"/>
				</xsl:if>
				<xsl:apply-templates select="." mode="declare-extra-imports"/>
			</objc-imports>
		</xsl:variable>

		<xsl:text>&#10;//@non-generated-start[dependencies-names]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='dependencies-names']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>

		<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[not(@self) or @self != '$useClass']) > 0">
			<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[not(@self) or @self != '$useClass']" mode="write-import">
				<xsl:sort/>
			</xsl:apply-templates>
		</xsl:if>
		
		<xsl:text>&#10;</xsl:text>
		<xsl:text>function(</xsl:text>
		<xsl:text>&#10;//@non-generated-start[dependencies-classes]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='dependencies-classes']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[not(@self) or @self != '$useClass']) > 0">
				<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[not(@self) or @self != '$useClass']" mode="write-import-in-function">
					<xsl:sort/>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:text>&#10;</xsl:text>
		<xsl:text>)</xsl:text>
	</xsl:template>
	
	<xsl:template match="objc-import" mode="write-import">
		<xsl:variable name="currentImport" select="text()"/>
		<xsl:if test="count(preceding-sibling::objc-import[text()=$currentImport]) = 0">
			<xsl:text>'</xsl:text><xsl:value-of select="@import"/><xsl:text>',</xsl:text>
			<xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="objc-import" mode="write-import-in-function">
		<xsl:variable name="currentImport" select="text()"/>
		<xsl:if test="count(preceding-sibling::objc-import[text()=$currentImport]) = 0">
			<xsl:text></xsl:text><xsl:value-of select="@import-in-function"/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="declare-protocol-imports" priority="-900">
		<xsl:comment>//No headers</xsl:comment>
	</xsl:template>

</xsl:stylesheet>