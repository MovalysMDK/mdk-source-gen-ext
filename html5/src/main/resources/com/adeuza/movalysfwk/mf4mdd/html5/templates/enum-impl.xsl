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
		<xsl:text>'use strict';&#10;</xsl:text>

		<xsl:apply-templates select="." mode="enum-documentation"/>
		<xsl:apply-templates select="." mode="enum-prototype"/>
		<xsl:text>{&#10;</xsl:text>
			<xsl:apply-templates select="." mode="enum-body"/>
		<xsl:text>}]);&#10;</xsl:text>
		
	</xsl:template>



	<xsl:template match="enum" mode="enum-documentation">
		<xsl:text>&#10;/**&#10;</xsl:text>
		<xsl:text>* Enumeration class : </xsl:text><xsl:value-of select="name"/>
		<xsl:text>&#10;*/&#10;</xsl:text>
	</xsl:template>
	

	<xsl:template match="enum" mode="enum-prototype">
		<xsl:text>angular.module('data').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>', ['MFAbstractEnum', function (MFAbstractEnum)&#10;</xsl:text>
	</xsl:template>


	
	
	<xsl:template match="enum" mode="enum-body">

		<xsl:text>&#10;&#10;var </xsl:text><xsl:value-of select="name"/>
		<xsl:text> = function </xsl:text><xsl:value-of select="name"/>
		<xsl:text>() {};&#10;MFAbstractEnum.defineEnum(</xsl:text><xsl:value-of select="name"/><xsl:text>, [</xsl:text>
		
		<xsl:apply-templates select="./enum-values" mode="enum-values"/>
		<xsl:text>]);&#10;&#10;return </xsl:text><xsl:value-of select="name"/><xsl:text>;&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="value" mode="enum-values">
		<xsl:text>'</xsl:text><xsl:value-of select="."/><xsl:text>'</xsl:text>
	    <xsl:if test="position() != last()">
		 	<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet> 