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

	<xsl:include href="includes/class.xsl"/>

	<xsl:template match="pojo-factory">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<xsl:template match="pojo-factory" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.AbstractEntityFactory</import>
	</xsl:template>

<!-- 	<xsl:template match="node()" mode="documentation"> -->
<!-- 		<xsl:text>/**&#13;</xsl:text> -->
<!-- 		<xsl:text> * </xsl:text> -->
<!-- 		<xsl:value-of select="documentation"/> -->
<!-- 		<xsl:text>&#13;</xsl:text> -->
<!-- 		<xsl:text> */&#13;</xsl:text>  -->
<!-- 	</xsl:template> -->

	<xsl:template match="pojo-factory" mode="superclass">
		<xsl:text>AbstractEntityFactory&lt;</xsl:text>
		<xsl:value-of select="interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="pojo-factory" mode="interfaces">
		<xsl:value-of select="pojo-factory-interface/name"/>
	</xsl:template>

	<xsl:template match="pojo-factory[class/transient='true']" mode="attributes">
		/** current id for transient entities */
		private static long id = 0;
	</xsl:template>

	<xsl:template match="pojo-factory" mode="methods">
		/**
		 * {@inheritDoc}
		 * 
		 * @see <xsl:value-of select="package"/>.<xsl:value-of select="pojo-factory-interface/name"/>#createInstance()
		 */
		@Override
		public <xsl:value-of select="interface/@name"/> createInstance(){
			<xsl:value-of select="interface/@name"/> r_o<xsl:value-of select="interface/@name"/> = new <xsl:value-of select="class/name"/>();
			this.init(r_o<xsl:value-of select="interface/@name"/>);
			return r_o<xsl:value-of select="interface/@name"/>;
		}

		/**
		 * Méthode d'initialisation de l'objet
		 *
		 * @param p_o<xsl:value-of select="interface/@name"/> Entité d'interface <xsl:value-of select="interface/@name"/>
		 */
		protected void init(<xsl:value-of select="interface/@name"/> p_o<xsl:value-of select="interface/@name"/>){
			//@non-generated-start[init]
			<xsl:value-of select="non-generated/bloc[@id='init']"/>
			<xsl:text>//@non-generated-end</xsl:text>
			<xsl:if test="./class/transient='true'">
				p_o<xsl:value-of select="interface/@name"/>.
				<xsl:value-of select="./class/identifier/attribute/set-accessor"/>
				(id++);
			</xsl:if>
		}
	</xsl:template>
</xsl:stylesheet>
