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
	
	<xsl:template match="viewmodel[type/name = 'FIXED_LIST']" mode="subvm-property-definition">
		<xsl:call-template name="definePropertyForSubVm">
			<xsl:with-param name="propertyName"><xsl:text>lst</xsl:text><xsl:value-of select="implements/interface/@name"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="viewmodel[type/name = 'LISTITEM_1' or type/name = 'LISTITEM_2' or type/name = 'LISTITEM_3']" mode="subvm-property-definition">
		<xsl:call-template name="definePropertyForSubVm">
			<xsl:with-param name="propertyName">list</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template name="definePropertyForSubVm">
		<xsl:param name="propertyName"/>
		<xsl:text>&#10;'</xsl:text><xsl:value-of select="$propertyName"/><xsl:text>': {&#10;</xsl:text>
	                 
		<xsl:apply-templates select="." mode="define-getter-method">
         	<xsl:with-param name="name"><xsl:value-of select="$propertyName"/></xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="define-setter-method">
			<xsl:with-param name="name"><xsl:value-of select="$propertyName"/></xsl:with-param>
			<xsl:with-param name="parameter-name"><xsl:value-of select="$propertyName"/></xsl:with-param>
		</xsl:apply-templates>
         
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">
				<xsl:text>attribute-</xsl:text><xsl:value-of select="property-name"/><xsl:text>-settings</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>&#10;enumerable:true,&#10;configurable:false&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	
		<xsl:text>&#10;}</xsl:text>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:text>,&#10;</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>&#10;</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>