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

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- ############################################################
			ATTRIBUTS : MAPPINGSQL
		 ############################################################ -->

	<xsl:template match="dao" mode="mappingsql-attributes">
		<xsl:param name="database"/>

		<xsl:text>rightFactory: '</xsl:text><xsl:value-of select="class/pojo-factory-interface/name"/><xsl:text>',&#10;</xsl:text>
		<xsl:text>attributes: [&#10;</xsl:text>
		
		<xsl:apply-templates select="/dao/class/identifier" mode="map-attribute">
			<xsl:with-param name="database" select="$database"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="/dao/class/attribute" mode="map-attribute">
			<xsl:with-param name="database" select="$database"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="/dao/class/association" mode="map-attribute">
			<xsl:with-param name="database" select="$database"/>
		</xsl:apply-templates>
		
		<xsl:text>]&#10;</xsl:text>
		
	</xsl:template>
	
	
	
	<!-- Identifier Mapping -->
	<xsl:template match="identifier" mode="map-attribute">
		<xsl:param name="database"/>
		
		<xsl:variable name="leftAttr">
			<xsl:choose>
				<xsl:when test="$database='SQL'"><xsl:text>'</xsl:text><xsl:value-of select="attribute/@name-uppercase"/><xsl:text>'</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>'</xsl:text><xsl:value-of select="attribute/@name"/><xsl:text>'</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>{</xsl:text><xsl:value-of select="@name"/>	
		<xsl:text>leftAttr: </xsl:text><xsl:value-of select="$leftAttr"/><xsl:text>, </xsl:text>
		<xsl:text>rightAttr: '</xsl:text><xsl:value-of select="attribute/@name"/><xsl:text>', </xsl:text>
		<xsl:text>identifier: true</xsl:text>
		<xsl:text>}</xsl:text><xsl:if test="(position() != last()) or count(../association[(not(@type='one-to-many' or @type='many-to-many') and @relation-owner='true')])>0 or count(../attribute[(not(@transient='true'))])>0">,</xsl:if><xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	
	
	<!-- Attributes from MFAddressLocation or MFPhoto -->
	<xsl:template match="attribute[(@type-name='MFAddressLocation') or (@type-name='MFPhoto')]" mode="map-attribute">
		<xsl:param name="database"/>
			
		<xsl:text>{</xsl:text>
		<xsl:for-each select="properties/property">
		
			<xsl:variable name="leftAttr">
				<xsl:choose>
					<xsl:when test="$database='SQL'"><xsl:text>'</xsl:text><xsl:value-of select="../../@name-uppercase"/><xsl:text>_</xsl:text><xsl:value-of select="@name-uppercase" /><xsl:text>'</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>['</xsl:text><xsl:value-of select="../../@name"/><xsl:text>', '</xsl:text><xsl:value-of select="@name" /><xsl:text>']</xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:text>leftAttr: </xsl:text><xsl:value-of select="translate($leftAttr, '@', '')"/><xsl:text>, </xsl:text>
			<xsl:text>rightAttr: ['</xsl:text><xsl:value-of select="../../@name" /><xsl:text>', '</xsl:text><xsl:value-of select="translate(@name, '@', '')"/><xsl:text>'], </xsl:text>
			<xsl:text>rightFactory: '</xsl:text><xsl:value-of select="../../@type-name"/><xsl:text>Factory'</xsl:text>
			<xsl:apply-templates select="." mode="attribute-specific-converter"/>
			
			<xsl:if test="position() != last()"><xsl:text>},&#10;{</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:text>}</xsl:text><xsl:if test="(position() != last()) or count(../association[(not(@type='one-to-many' or @type='many-to-many') and @relation-owner='true')])>0">,</xsl:if><xsl:text>&#10;</xsl:text>
	</xsl:template>
	
		
	<!-- Basic Attributes Mapping -->
	<xsl:template match="attribute[not(@transient='true' or @derived='true' or @type-name='MFAddressLocation' or @type-name='MFPhoto')]" mode="map-attribute">
		<xsl:param name="database"/>
		
		<xsl:variable name="leftAttr">
			<xsl:choose>
				<xsl:when test="$database='SQL'"><xsl:text>'</xsl:text><xsl:value-of select="@name-uppercase" /><xsl:text>'</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>'</xsl:text><xsl:value-of select="@name" /><xsl:text>'</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>{leftAttr: </xsl:text><xsl:value-of select="$leftAttr"/><xsl:text>, </xsl:text>
		<xsl:text>rightAttr: '</xsl:text><xsl:value-of select="@name"/><xsl:text>'</xsl:text>
		<xsl:apply-templates select="." mode="attribute-specific-converter"/>
		<xsl:text>}</xsl:text><xsl:if test="(position() != last()) or count(../association[(not(@type='one-to-many' or @type='many-to-many') and @relation-owner='true')])>0">,</xsl:if><xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="attribute[@enum='true']" mode="attribute-specific-converter">
		<xsl:text>, right2leftConverter: ['MFGenericEnumConverter', 'toInteger'] </xsl:text>
		<xsl:text>, left2rightConverter: ['MFGenericEnumConverter', 'fromInteger', '</xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>']</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="attribute[field/@data-type='DATE']|property[field/@data-type='DATE']" mode="attribute-specific-converter">
		<xsl:text>, right2leftConverter: ['MFDateConverter', 'toMilliseconds']</xsl:text>
		<xsl:text>, left2rightConverter: ['MFDateConverter', 'fromMilliseconds']</xsl:text>
	</xsl:template>
	
	<xsl:template match="property[@type-short-name='MFPhotoState']" mode="attribute-specific-converter">
    	<xsl:text>, right2leftConverter:['MFGenericEnumConverter','toInteger']</xsl:text>
    	<xsl:text>, left2rightConverter:['MFGenericEnumConverter','fromInteger','MFPhotoState']</xsl:text>
	</xsl:template>
	
	<xsl:template match="attribute[field/@data-type='NUMERIC' and @type-short-name='boolean']" mode="attribute-specific-converter">
		<xsl:text>, right2leftConverter: ['MFBooleanConverter', 'toInteger']</xsl:text>
		<xsl:text>, left2rightConverter: ['MFBooleanConverter', 'fromInteger']</xsl:text>
	</xsl:template>
	
	<xsl:template match="*" mode="attribute-specific-converter">
	</xsl:template>

	
	<!-- Association  Mapping Many to many-->
	<!--<xsl:template match="association[@type='many-to-many']" mode="map-attribute">
		<xsl:param name="database"/>
		
		<xsl:variable name="leftAttr">
			<xsl:choose>
				<xsl:when test="$database='SQL'"><xsl:text>'</xsl:text><xsl:value-of select="join-table/crit-fields/field/@name"/><xsl:text>'</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>'</xsl:text><xsl:value-of select="@name"/><xsl:value-of select="translate(substring-after(join-table/crit-fields/field/@attr-name, join-table/crit-fields/@asso-name), $uppercase, $smallcase)" /><xsl:text>'</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>{leftAttr: </xsl:text><xsl:value-of select="$leftAttr"/><xsl:text>, </xsl:text>
		<xsl:text>rightAttr: ['</xsl:text><xsl:value-of select="@name"/><xsl:text>', '</xsl:text><xsl:value-of select="translate(substring-after(join-table/crit-fields/field/@attr-name, join-table/crit-fields/@asso-name), $uppercase, $smallcase)"/><xsl:text>'], </xsl:text>
		<xsl:text>rightFactory: '</xsl:text><xsl:value-of select="@contained-type-short-name"/><xsl:text>Factory', </xsl:text>
		<xsl:text>childIdentifier: true, </xsl:text>
		<xsl:text>multiple: true</xsl:text>
		<xsl:text>}</xsl:text><xsl:if test="((position() != last()) and (count(following-sibling::association[(not(@type='one-to-many') and @relation-owner='true')])>0))">,</xsl:if><xsl:text>&#10;</xsl:text>
	</xsl:template>-->
	
	
	<!-- Basic Association  Mapping -->
	<xsl:template match="association[@relation-owner='true' and not(@type='one-to-many' or @type='many-to-many')]" mode="map-attribute">
		<xsl:param name="database"/>
		
		<xsl:variable name="leftAttr">
			<xsl:choose>
				<xsl:when test="$database='SQL'"><xsl:text>'</xsl:text><xsl:value-of select="translate(field/@name, '@', '')"/><xsl:text>'</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>'</xsl:text><xsl:value-of select="translate(@name, $uppercase, $smallcase)"/><xsl:value-of select="translate(attribute/@name, $uppercase, $smallcase)" /><xsl:text>'</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>{leftAttr: </xsl:text><xsl:value-of select="$leftAttr"/><xsl:text>, </xsl:text>
		<xsl:text>rightAttr: ['</xsl:text><xsl:value-of select="@name"/><xsl:text>', '</xsl:text><xsl:value-of select="attribute/@name"/><xsl:text>'], </xsl:text>
		<xsl:text>rightFactory: '</xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>Factory', </xsl:text>
		<xsl:text>childIdentifier: true, </xsl:text>
		<xsl:text>multiple: false</xsl:text>
		<xsl:text>}</xsl:text><xsl:if test="((position() != last()) and (count(following-sibling::association[(not(@type='one-to-many' or @type='many-to-many') and @relation-owner='true')])>0))">,</xsl:if><xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="*" mode="map-attribute">
	</xsl:template>


</xsl:stylesheet>