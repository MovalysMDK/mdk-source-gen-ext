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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ionic2/templates/dao/dao-methods-name.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ionic2/templates/dao/dao-methods-parameters.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ionic2/templates/dao/dao-methods-documentation.xsl"/>



	<!-- ############################################################
			METHODES SIMPLES : GET/SAVE/UPDATE/SAVEORUPDATE/DELETE
		 ############################################################ -->

	<xsl:template match="dao" mode="simple-methods">
		<xsl:param name="methodNameToken"/>
		<xsl:param name="methodParameterToken"/>
		<xsl:param name="methodCriteriaToken" />
		
		
		<xsl:variable name="methodNameFull">
			<xsl:apply-templates select="." mode="methods-name">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
			</xsl:apply-templates>
		</xsl:variable>
				
		<xsl:variable name="parametersWithMultipleEntitiesFiltered">
			<xsl:choose>
				<xsl:when test="contains($methodParameterToken,',')">p_properties</xsl:when>
				<xsl:otherwise><xsl:value-of select="$methodParameterToken"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="methodParametersFull">
			<xsl:apply-templates select="." mode="methods-parameters">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$parametersWithMultipleEntitiesFiltered"/>
			</xsl:apply-templates>
		</xsl:variable>
				
		
		<!-- function documentation -->
		<xsl:apply-templates select="." mode="methods-documentation">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
				<xsl:with-param name="methodCriteriaToken" select="$methodCriteriaToken"/>						
		</xsl:apply-templates>

   		
		<!-- function prototype -->
		<xsl:text>	</xsl:text><xsl:value-of select="//name"/><xsl:text>.prototype.</xsl:text><xsl:value-of select="$methodNameFull"/>
		<xsl:text> = function(</xsl:text><xsl:value-of select="$methodParametersFull" /><xsl:text>) {&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
			
			
		<!-- function body -->
		<xsl:text>		return this.getDaoImpl().</xsl:text><xsl:value-of select="$methodNameFull"/>
		<xsl:text>(</xsl:text>
			<xsl:value-of select="$methodParametersFull" />
		<xsl:text>);&#10;</xsl:text>
		
		<xsl:text>	};&#10;&#10;&#10;</xsl:text>
		
	</xsl:template>

</xsl:stylesheet>