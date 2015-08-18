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
	
	<xsl:template match="node()" mode="define-property">
	           
	    <xsl:text>/**&#10;* define and initialize all of the attributes of the class </xsl:text><xsl:value-of select="../../name"/>
		<xsl:text>  &#10;*/</xsl:text>
	    <xsl:text>Object.defineProperties(this, {&#10;</xsl:text>
	    
	    <xsl:text>&#10;&#10;//@non-generated-start[attributes-settings]&#10;</xsl:text>
			<xsl:value-of select="/*/non-generated/bloc[@id='attributes-settings']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
	    <!-- attribut propre au viewmodel -->
	    <xsl:apply-templates select="identifier/attribute | attribute" mode="definePropertyForAttribute"/>
		
		<xsl:if test="count(identifier/attribute)>0 and (count(external-lists/external-list)>0 or (not(count(external-lists/external-list)>0) and (count(subvm/viewmodel)>0) and is-screen-viewmodel='false') )">
				<xsl:text>,&#10;</xsl:text>
		</xsl:if>
		
		<!-- attribut de sous viewmodel - LIST  -->
		<xsl:if test="is-screen-viewmodel='false'">
			<xsl:apply-templates select="subvm/viewmodel" mode="subvm-property-definition"/>
		</xsl:if>
		
		<xsl:if test="count(external-lists/external-list)>0 and (count(subvm/viewmodel)>0 and is-screen-viewmodel='false')">
			<xsl:text>,&#10;</xsl:text>
		</xsl:if>
		
		<!-- attribut de  COMBOBOX  -->
		<xsl:apply-templates select="mapping/entity" mode="definePropertyForCombo"/>

		<xsl:text>&#10;});&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="define-getter-method">
		<xsl:param name="name"/>
		<xsl:text>get: function () {&#10;</xsl:text>
		
		<xsl:variable name="defineGetterAttribute"><xsl:text>getter-</xsl:text><xsl:value-of select="$name"/></xsl:variable>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:value-of select="$defineGetterAttribute"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>return _</xsl:text><xsl:value-of select="$name"/><xsl:text>;&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>

		<xsl:text>},&#10;</xsl:text>
		
	</xsl:template>

	<xsl:template match="*" mode="define-setter-method">
		<xsl:param name="name"/>
		<xsl:param name="parameter-name" />
		
		<xsl:text>set: function (</xsl:text><xsl:value-of select="$parameter-name"/><xsl:text>) {&#10;</xsl:text>
		
	    <xsl:if test="not(@derived='true')">
			<xsl:text>_</xsl:text><xsl:value-of select="$name"/><xsl:text> = </xsl:text><xsl:value-of select="$parameter-name"/><xsl:text>;&#10;</xsl:text>
	    </xsl:if>

		<xsl:variable name="setter" select="concat('setter-', $name)"/>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:text>setter-</xsl:text><xsl:value-of select="$name"/></xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		
		<xsl:text>&#10;},&#10;</xsl:text>
	</xsl:template>

</xsl:stylesheet>