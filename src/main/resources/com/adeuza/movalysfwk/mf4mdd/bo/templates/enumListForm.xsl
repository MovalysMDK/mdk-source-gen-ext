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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/02/xpath-functions">

<xsl:output method="text"/>	

<xsl:param name="SubPackageName"/>
<xsl:param name="NamingSuffix"/>

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="listForm">
package com.adeuza.movalys.dbgen.classic.intervention.cii.model.<xsl:value-of select="$SubPackageName"/>;

/**
 * Enumération pour la classe <xsl:value-of select="interface/name"/><xsl:value-of select="$NamingSuffix"/>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
public enum <xsl:value-of select="interface/name"/><xsl:value-of select="$NamingSuffix"/>Enum {
	/**
	 * Identifiant de la liste contenant les éléments supprimés
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>_<xsl:value-of select="translate(substring(interface/name,0,3),$smallcase,$uppercase)"/>ListIdListDeletedItems,
	/**
	 * Indentifiant de la liste
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>_<xsl:value-of select="translate(substring(interface/name,0,3),$smallcase,$uppercase)"/>List,
	/**
	 * Identifiant du champ id
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>_<xsl:value-of select="translate(substring(interface/name,0,3),$smallcase,$uppercase)"/>AttrId,
	<xsl:for-each select="class/attribute">
		<xsl:if test="not(starts-with(@name,'adm'))">
	/**
	 * Identifiant du champ <xsl:value-of select="method-crit-name"/>
	 */
	<xsl:value-of select="translate(../../interface/name,$uppercase,$smallcase)"/>_<xsl:value-of select="translate(substring(../../interface/name,0,3),$smallcase,$uppercase)"/>Attr<xsl:value-of select="method-crit-name"/>,
		</xsl:if>
	</xsl:for-each>
	/**
	 * Nom de la section
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>_<xsl:value-of select="translate(substring(interface/name,0,3),$smallcase,$uppercase)"/>ListForm
}
</xsl:template>
</xsl:stylesheet>