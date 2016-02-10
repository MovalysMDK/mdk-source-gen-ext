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
	
	<xsl:template match="attribute" mode="definePropertyForAttribute">
			
			<xsl:text>&#10;'</xsl:text><xsl:value-of select="@name"/><xsl:text>': {&#10;</xsl:text>
	                 
	         <xsl:apply-templates select="." mode="define-getter-method">
	         	<xsl:with-param name="name" select="@name"/>
	         </xsl:apply-templates>
	         
	         <xsl:if test="not(@derived='true')">
		         <xsl:apply-templates select="." mode="define-setter-method">
		         	<xsl:with-param name="name" select="@name"/>
		         	<xsl:with-param name="parameter-name" select="parameter-name" />
		         </xsl:apply-templates>
	         </xsl:if>
	         <xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId"><xsl:text>attribute-</xsl:text><xsl:value-of select="@name"/><xsl:text>-settings</xsl:text></xsl:with-param>
				<xsl:with-param name="defaultSource">
	         		<xsl:text>&#10;&#10;enumerable:true,&#10;configurable:false&#10;</xsl:text>
		        </xsl:with-param>
			</xsl:call-template>
		
	         <xsl:text>&#10;}</xsl:text>
	         
	         <xsl:if test="@primitif = 'true' and parent::identifier">
        	 	<xsl:apply-templates select="." mode="define-idToString-property"/>
        	 </xsl:if>
	         
	         <xsl:if test="position() != last()">
	         	<xsl:text>,&#10;</xsl:text>
	         </xsl:if>
	</xsl:template>
	
</xsl:stylesheet>