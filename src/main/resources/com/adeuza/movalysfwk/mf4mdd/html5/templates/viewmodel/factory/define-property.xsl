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
		<!-- Combo -->
		<xsl:text>&#10;</xsl:text><xsl:value-of select="nameFactory"/><xsl:text>._Parent.call(this);&#10;</xsl:text>
        <xsl:text>this.keepInstance = </xsl:text>
        <xsl:choose>
        	<xsl:when test="type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3' or type/name='FIXED_LIST' or type/name='LIST_1__ONE_SELECTED'">
        		<xsl:text>false</xsl:text>
        	</xsl:when>
        	<xsl:otherwise><xsl:text>true</xsl:text></xsl:otherwise>
        </xsl:choose>
        <xsl:text>;&#10;</xsl:text>
        <xsl:apply-templates select="external-lists/external-list" mode="define-property-combo"/>
<!--         <xsl:apply-templates select="subvm/viewmodel/external-lists/external-list" mode="define-property-combo"/> -->
        
	</xsl:template>


	<xsl:template match="external-list" mode="define-property-combo">
	
	    <xsl:text>/**&#10;</xsl:text>
        <xsl:text>* define and initialize the combo List</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text>&#10;</xsl:text>
        <xsl:text>*/&#10;</xsl:text>
        
	  	<xsl:text>var _singleton</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text> = [];&#10;</xsl:text>
		<xsl:text>Object.defineProperty(this, 'singleton</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text>', {&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="getter-property-combo"/>
		<xsl:apply-templates select="." mode="setter-property-combo"/>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:value-of select="viewmodel/name"/><xsl:text>-settings</xsl:text></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>enumerable: true,&#10;</xsl:text>
				<xsl:text>configurable: false&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>});&#10;&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="*" mode="getter-property-combo">
		<xsl:text>get: function () {&#10;</xsl:text>
		
		<xsl:text>&#10;&#10;//@non-generated-start[getter-combo]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='getter-combo']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:text> return _singleton</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text>;&#10;</xsl:text>
		<xsl:text>},&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="*" mode="setter-property-combo">
		<xsl:text>set: function (value) {&#10;</xsl:text>
		<xsl:text>_singleton</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text> = value;&#10;</xsl:text>
		
		<xsl:text>&#10;&#10;//@non-generated-start[setter-combo]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='setter-combo']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:text>},&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*" mode="define-property-combo">
	</xsl:template>

</xsl:stylesheet>