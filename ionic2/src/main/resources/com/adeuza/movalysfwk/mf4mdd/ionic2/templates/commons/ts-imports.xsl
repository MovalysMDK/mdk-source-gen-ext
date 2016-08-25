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
	
	<xsl:template match="node()" mode="declare-imports">
		<xsl:variable name="imports">
			<imports>
				<xsl:copy-of select="association"/>
			</imports>
		</xsl:variable>
		<xsl:apply-templates select="exsl:node-set($imports)/imports/association/interface/name" mode="ts-import-preparation"/>
	
		<!-- Add class specific imports -->
		<xsl:apply-templates select="." mode="declare-specific-imports"/>
	</xsl:template>
	
	<xsl:template match="*" mode="declare-protocol-imports" priority="-900">
		<xsl:comment>//No headers</xsl:comment>
	</xsl:template>
	
	<xsl:template match="*" mode="ts-import-preparation">
		<xsl:call-template name="ts-import">
			<xsl:with-param name="class"><xsl:value-of select="."/></xsl:with-param>
			<xsl:with-param name="from">./<xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="ts-import"> <!-- Generate import {} from ''  -->
		<xsl:param name="class" />
		<xsl:param name="from" />
		<xsl:text>import {</xsl:text><xsl:value-of select="$class"/><xsl:text>} from '</xsl:text><xsl:value-of select="$from"/><xsl:text>';&#10;</xsl:text> 
	</xsl:template>
</xsl:stylesheet>