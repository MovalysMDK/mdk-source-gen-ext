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

<xsl:template match="enum">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;
 
//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEnum ;

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Enumération : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
public enum <xsl:value-of select="name"/>
	<xsl:text> implements BOEnum {&#13;</xsl:text>
	<xsl:for-each select="enum-values/value">
		/**
	 	* Cascade <xsl:value-of select="."/>
	 	*/
		<xsl:value-of select="."/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="position()"/>
		<xsl:text>)</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>;</xsl:text>
		</xsl:if>
	</xsl:for-each>
	
	/**
	 * La valeur en base
	 */
	private int baseId ;
	
	/**
	 * Constucteur
	 * 
	 * @param p_iBaseId la valeur en base
	 */
	private <xsl:value-of select="name"/>(int p_iBaseId) {
		this.baseId = p_iBaseId;
	}
	
	/**
	 * Retourne la valeur de l'enumération corresponde à l'entier passé en paramètre
	 * 
	 * @param p_iLivingCode la valeur en base de la valeur de l'énumération recherchée
	 * 
	 * @return la valeur l'énumération correspondante à l'entrée
	 */
	public static <xsl:value-of select="name"/> valueOf(int p_i<xsl:value-of select="name"/>) {
		<xsl:variable name="returnObject">r_o<xsl:value-of select="name"/></xsl:variable>
		<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="$returnObject"/> = null;
		switch (p_i<xsl:value-of select="name"/>) {
		<xsl:for-each select="enum-values/value">
		case <xsl:value-of select="position()"/>:
			<xsl:value-of select="$returnObject"/> = <xsl:value-of select="."/>;
			break;
		</xsl:for-each>
		default:
			throw new IllegalStateException(" L'entier "+p_i<xsl:value-of select="name"/>+" n'existe pas dans l'énumération");
		}
		return <xsl:value-of select="$returnObject"/>;
	}
	
	/**
	 * Retourne l'objet baseId
	 * @return Objet baseId
	 */
	public int getBaseId() {
		return this.baseId;
	}
}

</xsl:template>
</xsl:stylesheet>