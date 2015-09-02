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
		
		<xsl:text>//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="enum-prototype"/>
		<xsl:text>{&#10;</xsl:text>
			<xsl:apply-templates select="." mode="enum-body"/>
		<xsl:text>}]);&#10;</xsl:text>
		
	</xsl:template>



	<xsl:template match="enum" mode="enum-documentation">
		<xsl:text>&#10;/**&#10;</xsl:text>
		<xsl:text>* EnumerationConverter class : </xsl:text><xsl:value-of select="name"/><xsl:text>Converter</xsl:text>
		<xsl:text>&#10;*/&#10;</xsl:text>
	</xsl:template>
	

	<xsl:template match="enum" mode="enum-prototype">
		<xsl:text>angular.module('data').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>Converter', ['</xsl:text><xsl:value-of select="name"/><xsl:text>', function (</xsl:text><xsl:value-of select="name"/><xsl:text>)&#10;</xsl:text>
	</xsl:template>


	
	
	<xsl:template match="enum" mode="enum-body">

		<xsl:text>&#10;&#10;var </xsl:text><xsl:value-of select="name"/><xsl:text>Converter </xsl:text>
		<xsl:text> = function </xsl:text><xsl:value-of select="name"/><xsl:text>Converter </xsl:text>
		<xsl:text>() {&#10;//constructor&#10;};&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="viewmodelFromEnum"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="enumFromViewmodel"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="toItemList"/>
		
		<xsl:text>&#10;//@non-generated-start[custom-converter]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='custom-converter']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		
		<xsl:text>&#10;&#10;return </xsl:text><xsl:value-of select="name"/><xsl:text>Converter;&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="enum" mode="viewmodelFromEnum">
		<xsl:value-of select="name"/><xsl:text>Converter.displayedFromEnum = function (value) {&#10;</xsl:text>
        <xsl:text>if (angular.isUndefinedOrNull(value)) {&#10;</xsl:text>
        <xsl:text>return value;&#10;}&#10;</xsl:text>
        <xsl:text>return  { value: value.value, key: 'enum__' + value._type + '__' + value.key };&#10;};&#10;</xsl:text>
	
	</xsl:template>
	
	<xsl:template match="enum" mode="enumFromViewmodel">
	    <xsl:value-of select="name"/><xsl:text>Converter.enumFromDisplayed = function (value) {&#10;</xsl:text>
        <xsl:text>return </xsl:text><xsl:value-of select="name"/><xsl:text>.values[value.value];&#10;};&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="enum" mode="toItemList">
	    <xsl:value-of select="name"/><xsl:text>Converter.toItemsList = function (name) {&#10;</xsl:text>
	    <xsl:text>var list = [];&#10;</xsl:text>
	    <xsl:text>var values = </xsl:text><xsl:value-of select="name"/><xsl:text>.values;&#10;</xsl:text>
	    <xsl:text>for (var value in values) {&#10;</xsl:text>
	    <xsl:text>if (values.hasOwnProperty(value)) {&#10;</xsl:text>
	    <xsl:text>list.push( </xsl:text><xsl:value-of select="name"/><xsl:text>Converter.displayedFromEnum(values[value]));&#10;}&#10;}&#10;</xsl:text>
	    <xsl:text>return list;&#10;};&#10;</xsl:text>
    </xsl:template>



</xsl:stylesheet> 