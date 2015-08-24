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

	<xsl:include href="commons/import.xsl"/>

	<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="pojo-factory">
		<xsl:text>'use strict';&#10;</xsl:text>
		<xsl:apply-templates select="." mode="factory-documentation"/>
		
		<xsl:text>&#10;//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="factory-prototype"/>
		<xsl:text>{&#10;</xsl:text>
			<xsl:apply-templates select="class" mode="factory-body"/>
		<xsl:text>}]);&#10;</xsl:text>
		
	</xsl:template>


	<xsl:template match="pojo-factory" mode="factory-documentation">
		<xsl:text>/**&#10;</xsl:text>
		<xsl:text>* Factory class for object </xsl:text><xsl:value-of select="name"/><xsl:text>&#10;</xsl:text>
		<xsl:text>*/&#10;</xsl:text>
	</xsl:template>
	

	<xsl:template match="pojo-factory" mode="factory-prototype">
		<xsl:text>angular.module('data').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>', [</xsl:text>
			<xsl:apply-templates select="." mode="declare-protocol-imports"/>
		
	</xsl:template>
	
	
	<xsl:template match="class" mode="factory-body">
	    <xsl:text>return {&#10; createInstance: function () {&#10; var result = new </xsl:text>
	    
	    <xsl:value-of select="name"/><xsl:text>();&#10;</xsl:text>
		
		<!-- 		All attributes are initialised differently depending on their type, if they're attributes or association, and (if association) their association's type -->
<!-- 		<xsl:if test="transient != 'true'"> -->
		
			<!-- // IDENTIFIER ATTRIBUTES -->
			<xsl:for-each select="./identifier/attribute">
				<xsl:choose>
					<xsl:when test="@type-name='Long'">
						<xsl:text>result.</xsl:text><xsl:value-of select="@name"/><xsl:text> = -1;&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>result.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<!-- // ATTRIBUTES -->
			<xsl:for-each select="./attribute">
				<xsl:choose>
					<!--  if NOT enum -->
					<xsl:when test="not(@enum) or @enum = 'false'">
						<!-- 	default case -->
						<xsl:text>result.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!--  if enum -->
						<xsl:text>result.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>.</xsl:text><xsl:value-of select="enumeration-values/enum-value"/><xsl:text>;&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<!-- // ASSOCIATIONS -->
			<xsl:for-each select="./association[(@type='one-to-many' or @type='many-to-many' or @type='many-to-one') and @opposite-navigable='true']">
				<xsl:text>result.</xsl:text><xsl:value-of select="@name"/><xsl:text> = [];&#10;</xsl:text>
			</xsl:for-each>
			
			<xsl:text>&#10;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">child-instantiation-factory</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:for-each select="./association[(@type='many-to-one' or (@type='one-to-one') or @type='one-to-many')]">	
							<xsl:text>&#10;// uncomment the following line (and add imports) only if you want to instantiate the child object here	&#10;</xsl:text>				
							<xsl:text>//result.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>

<!-- 		</xsl:if> -->

		<xsl:text>&#10;//@non-generated-start[createInstance]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='createInstance']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:text>&#10;return result;&#10;&#10; }&#10;</xsl:text>
		
		<xsl:text>&#10;//@non-generated-start[functions]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='functions']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:text>};&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="pojo-factory" mode="declare-extra-imports">
	</xsl:template>
	
	
</xsl:stylesheet>