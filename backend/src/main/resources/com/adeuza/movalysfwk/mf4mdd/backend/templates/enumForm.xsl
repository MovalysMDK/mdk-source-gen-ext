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

<xsl:template match="form">
<xsl:text>package </xsl:text><xsl:value-of select="interface/package"/>.<xsl:value-of select="$SubPackageName"/>;

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.Field;

//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

/**
 * Enumération pour la classe 
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */

public enum <xsl:value-of select="interface/name"/>Enum implements Field {
	
	/**
	 * Nom de l'entité
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>,

	/**
	 * Nom du Formulaire
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>_form,
	
	/**
	 * Id
	 */
	<xsl:value-of select="translate(interface/name,$uppercase,$smallcase)"/>_id,
		<xsl:for-each select="class/attribute">
		<xsl:if test="not(starts-with(@name,'adm'))">
		
	/**
	 * Champ <xsl:value-of select="method-crit-name"/>
	 */
	<xsl:value-of select="translate(../../interface/name,$uppercase,$smallcase)"/>_<xsl:value-of select="translate(method-crit-name,$uppercase,$smallcase)"/>,
		</xsl:if>
	</xsl:for-each>
	
	//@non-generated-start[attributes]
	<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
	<xsl:text>//@non-generated-end</xsl:text>
}

</xsl:template>
</xsl:stylesheet>