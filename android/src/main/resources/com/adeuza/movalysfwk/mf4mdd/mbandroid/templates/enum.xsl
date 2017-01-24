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

	<xsl:include href="includes/imports.xsl"/>

	<xsl:template match="enum">
		<xsl:text>package </xsl:text><xsl:value-of select="package"/>;
		<xsl:apply-templates select="." mode="declare-imports"/>

		/**
		 * 
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Enumération : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 */
		public enum <xsl:value-of select="name"/><xsl:text> implements Enum</xsl:text>	
			<xsl:text>&#13;//@non-generated-start[class-signature]&#13;</xsl:text>
				<xsl:value-of select="non-generated/bloc[@id='class-signature']"/>
			<xsl:text>//@non-generated-end&#13;</xsl:text>	
		<xsl:text>{&#13;
			/**
			 * Valeur nulle
			 */
			FWK_NONE(VALUE_0),
		</xsl:text>

		<xsl:apply-templates select="enum-values/value"/>

		<xsl:apply-templates select="." mode="attributes"/>

		<xsl:apply-templates select="." mode="constructors"/>

		<xsl:apply-templates select="." mode="methods"/>

		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="value">
		/**
		 * Valeur <xsl:value-of select="."/>
		 */
		<xsl:value-of select="."/>
		<xsl:text>(VALUE_</xsl:text>
		<xsl:value-of select="position()"/>
		<xsl:text>)</xsl:text>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:text>&#13;//@non-generated-start[enumeration]&#13;</xsl:text>
					<xsl:value-of select="/*/non-generated/bloc[@id='enumeration']"/>
				<xsl:text>//@non-generated-end&#13;</xsl:text>	
				<xsl:text>;&#13;</xsl:text>
			</xsl:when>

			<xsl:otherwise>
				<xsl:text>,</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="enum" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.Enum</import>
	</xsl:template>

	<xsl:template match="enum" mode="attributes">
		/**
		 * La valeur en base
		 */
		private int baseId ;
		
		<xsl:text>&#13;//@non-generated-start[attributes]&#13;</xsl:text>
			<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="enum" mode="constructors">
		/**
		 * Constucteur
		 * 
		 * @param p_iBaseId la valeur en base
		 */
		private <xsl:value-of select="name"/>(int p_iBaseId) {
			this.baseId = p_iBaseId;
		}
	</xsl:template>

	<xsl:template match="enum" mode="methods">
		/**
		 * Retourne la valeur de l'enumération corresponde à l'entier passé en paramètre
		 * 
		 * @param p_i<xsl:value-of select="name"/> la valeur en base de la valeur de l'énumération recherchée
		 * 
		 * @return la valeur l'énumération correspondante à l'entrée
		 */
		public static <xsl:value-of select="name"/> valueOf(int p_i<xsl:value-of select="name"/>) {
			<xsl:variable name="returnObject">r_o<xsl:value-of select="name"/></xsl:variable>
			<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="$returnObject"/>;
			switch (p_i<xsl:value-of select="name"/>) {
			case VALUE_0 :
				<xsl:value-of select="$returnObject"/> = FWK_NONE;
				break;
			<xsl:for-each select="enum-values/value">
			case VALUE_<xsl:value-of select="position()"/>:
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

		@Override
		public <xsl:value-of select="name"/> fromBaseId(int p_iBaseId) {
			return valueOf(p_iBaseId);
		}
		
		<xsl:text>&#13;//@non-generated-start[methodes]&#13;</xsl:text>
			<xsl:value-of select="non-generated/bloc[@id='methodes']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>	
	</xsl:template>
</xsl:stylesheet>
