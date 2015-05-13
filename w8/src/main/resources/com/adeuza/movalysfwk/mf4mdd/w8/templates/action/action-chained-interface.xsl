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

<xsl:output method="text"/>

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/action/imports-action.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/action/action-type.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>
 
<xsl:template match="action-interface">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName">
			<xsl:choose>
				<xsl:when test="./action-type='SAVEDETAIL'">ISave</xsl:when>
				<xsl:when test="./action-type='DELETEDETAIL'">IDelete</xsl:when>
			</xsl:choose>
			<xsl:text>Chained</xsl:text><xsl:value-of select="chained-action"/><xsl:text>.cs</xsl:text>
		</xsl:with-param>
	</xsl:apply-templates>

	<xsl:call-template name="action-imports"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	
	<xsl:text>&#13;&#13;namespace </xsl:text><xsl:value-of select="namespace-action"/><xsl:text>.action.chainedactions</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:apply-templates select="action-type" mode="action-chained-interface" />
	<xsl:text>&#13;}</xsl:text>

</xsl:template>


</xsl:stylesheet>