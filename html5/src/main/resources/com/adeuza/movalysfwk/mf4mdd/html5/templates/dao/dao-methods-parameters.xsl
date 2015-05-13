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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
xmlns:str="http://exslt.org/strings"
extension-element-prefixes="exsl">

<xsl:output method="text"/>

	<xsl:template match="node()" mode="methods-parameters">
		<xsl:param name="methodNameToken"/>
		<xsl:param name="methodParameterToken"/>	
	
		<xsl:choose>
			<xsl:when test="	($methodNameToken = 'getNextId')
							or	($methodNameToken = 'getNbEntities')
							or	($methodNameToken = 'getTableName')">
				<xsl:text>p_context</xsl:text>							<!-- parameter 1 -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$methodParameterToken and not($methodParameterToken='')">
					<xsl:value-of select="$methodParameterToken"/> 		<!-- parameter 1 -->
					<xsl:text>, </xsl:text>
				</xsl:if> 
				<xsl:text>p_context</xsl:text> 							<!-- parameter 2 -->					
				<xsl:text>, p_cascadeSet</xsl:text> 					<!-- parameter 3 -->		  
				<xsl:if test="not(substring($methodNameToken, 1, 3) = 'get')">
					<xsl:text>, p_toSync</xsl:text> 					<!-- parameter 4 -->
				</xsl:if>
				<xsl:if test="(substring($methodNameToken, 1, 6) = 'update') or (substring($methodNameToken, 7, 6) = 'Update')">
					<xsl:text>, p_cascadeSetForDelete</xsl:text> 		<!-- parameter 5 -->
				</xsl:if>		
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>