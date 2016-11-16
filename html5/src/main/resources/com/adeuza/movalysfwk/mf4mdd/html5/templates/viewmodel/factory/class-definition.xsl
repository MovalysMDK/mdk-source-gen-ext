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

	<xsl:template match="node()" mode="class-prototype">
	
		<xsl:apply-templates select="." mode="class-detail-comment"/>
	
		<xsl:text>angular&#10;</xsl:text>
		<xsl:text>.module('</xsl:text><xsl:value-of select="viewName"/><xsl:text>')&#10;</xsl:text>
		<xsl:text>.factory('</xsl:text><xsl:value-of select="nameFactory"/>
		<xsl:text>',</xsl:text><xsl:value-of select="nameFactory"/><xsl:text>); &#10;</xsl:text>

		<xsl:apply-templates select="." mode="declare-protocol-imports">
			<xsl:with-param name="functionName" select="nameFactory"/>
		</xsl:apply-templates>
		<!-- L'héritage d'autres classes se fait en fin de  classe -->
		<!-- 		TODO : FIXEDLIST -->
	</xsl:template>
	
	
	<!-- 	default case, or with entity-to-update, or external list for a combobox -->
	<xsl:template match="*" mode="define-class-module">
		<xsl:text>',[</xsl:text>
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>

		</xsl:template>

	

	
	
	<xsl:template match="node()" mode="class-heritage">
		<!-- HERE is managed the heritage of the entity -->
		<xsl:text>/**&#10;</xsl:text>
       	<xsl:text>* Heritage of the factory&#10;</xsl:text>
        <xsl:text>*/&#10;</xsl:text>
		<xsl:text>MFUtils.extendFromInstance(</xsl:text><xsl:value-of select="nameFactory"/><xsl:text>, MFAbstractViewModelFactory);&#10;</xsl:text>
	</xsl:template>
	
	
		<xsl:template match="*" mode="class-detail-comment">
		<xsl:if test="type/is-list='true'">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text>* We are here in the general viewmodel for the List&#10;</xsl:text>
			<xsl:text>*/&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3' or type/name='FIXED_LIST_ITEM'">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text>* We are here in the item viewmodel for the List (in the detail)&#10;</xsl:text>
			<xsl:text>*/&#10;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="declare-extra-imports">
		<objc-import import="MFMappingHelper" import-in-function="MFMappingHelper" scope="local"/>
		<objc-import import="MFUtils" import-in-function="MFUtils" scope="local"/>
		<objc-import import="MFAbstractViewModelFactory" import-in-function="MFAbstractViewModelFactory" scope="local"/>
	</xsl:template>
	
</xsl:stylesheet>