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
		<xsl:text>angular.module('</xsl:text><xsl:value-of select="viewName"/><xsl:text>').factory('</xsl:text><xsl:value-of select="name"/>
		<xsl:text>',[</xsl:text> 
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>
		<!-- L'héritage d'autres classes se fait en fin de  classe -->
	</xsl:template>
	
	<xsl:template match="node()" mode="class-heritage">
		<!-- HERE is managed the heritage of the entity -->
		<xsl:text>/**&#10;</xsl:text>
		<xsl:text>* Heritage of the ViewModel&#10;</xsl:text>
		<xsl:text>*/&#10;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">heritage-<xsl:value-of select="name"/>-settings</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>&#10;MFUtils.extend(</xsl:text><xsl:value-of select="name"/><xsl:text>, MFAbstractViewModel);&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template match="*" mode="class-detail-comment">
		<xsl:if test="type/is-list='true'">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text>* We are here in the general viewmodel for the List&#10;</xsl:text>
			<xsl:text>*/&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3' or type/name='FIXED_LIST'">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text>* We are here in the item viewmodel for the List (in the detail)&#10;</xsl:text>
			<xsl:text>*/&#10;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="declare-extra-imports">
	
		<objc-import import="MFAbstractViewModel" import-in-function="MFAbstractViewModel" scope="local"/>
		<objc-import import="MFUtils" import-in-function="MFUtils" scope="local"/>
		
	</xsl:template>
	
</xsl:stylesheet>