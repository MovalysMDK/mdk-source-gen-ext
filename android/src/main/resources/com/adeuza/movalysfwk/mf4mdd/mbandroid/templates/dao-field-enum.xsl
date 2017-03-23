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

<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>	

<xsl:template match="pojo">
	<xsl:apply-templates select="interface"/>
</xsl:template>

<xsl:template match="dao-interface">

<xsl:variable name="dao" select="dao"/>
<xsl:variable name="interface" select="dao/interface"/>
<xsl:variable name="class" select="dao/class"/>

<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

import com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.Field;

<xsl:text disable-output-escaping="yes"><![CDATA[	/**
	 * Enumération des champs
	 */]]></xsl:text><!-- génération de l'énumeration des champs -->
	public enum <xsl:value-of select="$interface/name"/><xsl:text>Field implements Field</xsl:text>
		<xsl:text>&#13;//@non-generated-start[class-signature]&#13;</xsl:text>
			<xsl:value-of select="non-generated/bloc[@id='class-signature']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>	
	<xsl:text> {</xsl:text>
	<xsl:for-each select="$class/identifier/attribute/field | $class/attribute[@transient='false']/field | $class/identifier/association/field | $class/association/field | $class/attribute//properties/property[@transient='false']/field">
		/**
		 * Field <xsl:value-of select="@name"/>
		 * type=<xsl:value-of select="@type"/> not-null=<xsl:value-of select="@not-null"/>
		 */
		<xsl:value-of select="@name"/>(<xsl:value-of select="position()"/>
		<xsl:if test="../@type-short-name = 'I18nValue'">
			<xsl:text>, true</xsl:text>
		</xsl:if>
		<xsl:text>)</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text> ,</xsl:text>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>&#13;//@non-generated-start[enumeration]&#13;</xsl:text>
				<xsl:value-of select="/*/non-generated/bloc[@id='enumeration']"/>
			<xsl:text>//@non-generated-end&#13;</xsl:text>	
			<xsl:text> ;</xsl:text>
		</xsl:if>
	</xsl:for-each>
		/**
		 * Index de la column
		 */
		private final int columnIndex ;

		<xsl:text>&#13;//@non-generated-start[attributes]&#13;</xsl:text>
			<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>	

		/**
		 * Constructeur
		 * @param p_iColumnIndex index de la column
		 */
		<xsl:value-of select="$interface/name"/>Field( int p_iColumnIndex ) {
			this.columnIndex = p_iColumnIndex ;
		}

		/**
		 * Retourne l'index de la colonne
		 * @return index de la colonne
		 */
		@Override
		public int getColumnIndex() {
			return this.columnIndex ;
		}
		
		<xsl:text>&#13;//@non-generated-start[methods]&#13;</xsl:text>
			<xsl:value-of select="non-generated/bloc[@id='methods']"/>
			<xsl:value-of select="non-generated/bloc[@id='methodes']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>	
	}
</xsl:template>
</xsl:stylesheet>
