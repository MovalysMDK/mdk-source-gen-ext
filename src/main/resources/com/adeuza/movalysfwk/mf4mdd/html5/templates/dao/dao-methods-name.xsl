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

	<xsl:template match="node()" mode="methods-name">
		<xsl:param name="methodNameToken"/>
		<xsl:param name="methodParameterToken"/>
	
		<xsl:value-of select="$methodNameToken"/>
		<xsl:choose>
			<xsl:when test="($methodParameterToken='p_id')">
				<xsl:value-of select="//uml-name"/>
				<xsl:text>ById</xsl:text>
			</xsl:when>
			<xsl:when test="($methodParameterToken='p_ids')">
				<xsl:value-of select="//uml-name"/>
				<xsl:text>ByIds</xsl:text>
			</xsl:when>			
			<xsl:when test="	(not($methodNameToken = 'getNextId'))
							and	(not($methodNameToken = 'getNbEntities'))
							and	(not($methodNameToken = 'getTableName'))
							and (not(contains($methodNameToken, 'By')))">
				<xsl:value-of select="//uml-name"/>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>