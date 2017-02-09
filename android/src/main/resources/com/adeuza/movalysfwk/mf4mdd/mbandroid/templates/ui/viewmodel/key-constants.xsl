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

	<xsl:template match="viewmodel" mode="generate-constant-declaration">
		<xsl:apply-templates select="./mapping/attribute|./mapping//entity|./mapping/entity//attribute|attribute[@derived='true']" mode="generate-constant-declaration"/>
	</xsl:template>

	<!-- derived attribute of viewmodel -->
	<xsl:template match="attribute[@derived='true']" mode="generate-constant-declaration">
		<xsl:if test="not(@vm-attr='id_id') and not(@vm-attr='id_identifier')">
			<xsl:text>/**
			 * Key used to identify the </xsl:text><xsl:value-of select="@name"/><xsl:text> derived attribute
			 */
			protected static final String KEY_</xsl:text><xsl:value-of select="@name-uppercase"/><xsl:text> = &quot;</xsl:text>
			<xsl:value-of select="@name"/><xsl:text>&quot;&#13;;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- mapped attribute of viewmodel -->
	<xsl:template match="attribute" mode="generate-constant-declaration">
		<xsl:if test="not(@vm-attr='id_id') and not(@vm-attr='id_identifier')">
			<xsl:text>/**
			 * Key used to identify the </xsl:text><xsl:value-of select="@vm-attr"/><xsl:text> attribute
			 */
			protected static final String KEY_</xsl:text><xsl:value-of select="translate(@vm-attr, $smallcase, $uppercase)"/><xsl:text> = &quot;</xsl:text>
			<xsl:value-of select="@vm-attr"/><xsl:text>&quot;&#13;;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- mapped entity of viewmodel -->
	<xsl:template match="entity[@vm-attr]" mode="generate-constant-declaration">
		<xsl:choose>
			<xsl:when test="@aggregate-type='AGGREGATE'">
				<xsl:text>/**
				 * Key used to identify the </xsl:text><xsl:value-of select="@vm-type"/><xsl:text> entity attribute
				 */
				protected static final String KEY_</xsl:text><xsl:value-of select="translate(@vm-type, $smallcase, $uppercase)"/><xsl:text> = &quot;</xsl:text>
						<xsl:value-of select="@vm-type"/><xsl:text>&quot;&#13;;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>/**
				 * Key used to identify the </xsl:text><xsl:value-of select="@vm-attr"/><xsl:text> entity attribute
				 */
				protected static final String KEY_</xsl:text><xsl:value-of select="translate(@vm-attr, $smallcase, $uppercase)"/><xsl:text> = &quot;</xsl:text>
						<xsl:value-of select="@vm-attr"/><xsl:text>&quot;&#13;;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="entity" mode="generate-constant-declaration"/>

</xsl:stylesheet>
