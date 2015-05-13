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

<!-- 
Construit le where à partir d'un noeud method-signature
 -->
<xsl:template name="criteria">
	<xsl:param name="use-aliases" select="'true'"/>
	
<!-- on prend tous les fields sauf ceux qui concernent une clé de jointure -->
<xsl:for-each select="method-parameter/attribute/field | method-parameter/association/field | method-parameter/association/join-table/crit-fields/field">
<xsl:if test="$use-aliases = 'true'">
<xsl:if test="not(parent::crit-fields)">
	<xsl:text>{0}.</xsl:text>
</xsl:if>
<xsl:if test="parent::crit-fields">
	<xsl:text>{3}.</xsl:text>
</xsl:if>
</xsl:if>
<xsl:value-of select="@name"/><xsl:text> = ?</xsl:text>
<xsl:if test="position() != last()">
	<xsl:text> AND </xsl:text>
</xsl:if>
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>