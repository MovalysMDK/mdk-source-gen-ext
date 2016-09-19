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
	<xsl:include href="commons/ts-imports.xsl"/>
	<xsl:include href="commons/ts-class.xsl"/>
	<xsl:include href="commons/ts-attributes.xsl"/>
	<xsl:include href="entity/factory/ts-imports.xsl"/>
	<xsl:include href="entity/factory/class-interface.xsl"/>
	
	<xsl:template match="/">
		<xsl:call-template  name="declare-class">
		    <xsl:with-param name="name"><xsl:value-of select="pojo-factory/name"/></xsl:with-param>
		    <xsl:with-param name="heritage">false</xsl:with-param>
		    <xsl:with-param name="interface"><xsl:value-of select="pojo-factory/class/name"/></xsl:with-param>
	    </xsl:call-template>
	</xsl:template>


	<!-- Body of the class -->
	<xsl:template match="/" mode="class-body">
	
		<!--Function createInstance-->
		/**
		 * <xsl:text>Function de création de l'objet </xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>.</xsl:text>
		 * 
		 * <xsl:text>@return </xsl:text><xsl:value-of select="pojo-factory/class/name"/>
		 */
		 <xsl:text>createInstance(): </xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>{ &#10;</xsl:text>
		 <xsl:text>var r_o</xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>: </xsl:text><xsl:value-of select="pojo-factory/class/name"/>
		 <xsl:text> = new </xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text> (); &#10;</xsl:text>
		 <xsl:text>this.init(r_o</xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>); &#10;</xsl:text>
		 <xsl:text>return r_o</xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>; &#10;</xsl:text>
		 <xsl:text>} &#10;</xsl:text>


		<!--Function init-->
		/**
		 * <xsl:text>Function d'initialisation de l'objet. </xsl:text>
		 * 
		 * <xsl:text>@param p_o</xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text> Entité </xsl:text><xsl:value-of select="pojo-factory/class/name"/>
		 */
		 <xsl:text>init(p_o</xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>: </xsl:text><xsl:value-of select="pojo-factory/class/name"/><xsl:text>): void { &#10;</xsl:text>
		 <xsl:text>&#10;//@non-generated-start[init]&#10;</xsl:text>
		 <xsl:value-of select="/*/non-generated/bloc[@id='init']" />
		 <xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		 <xsl:text>} &#10;</xsl:text>

		<!-- Non Generated functions -->
		<xsl:text>&#10;//@non-generated-start[functions]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='functions']" />
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		
	</xsl:template>
	
</xsl:stylesheet>