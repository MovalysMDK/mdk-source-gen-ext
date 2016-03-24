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
		<xsl:text>angular.module('data').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>',&#10;</xsl:text>
		<xsl:text>	[</xsl:text>
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="declare-extra-imports">
	
		<objc-import import="MFUtils" import-in-function="MFUtils" scope="local"/>
		<objc-import import="MFDaoProxyAbstract" import-in-function="MFDaoProxyAbstract" scope="local"/>
		
	</xsl:template>
	
	
</xsl:stylesheet>