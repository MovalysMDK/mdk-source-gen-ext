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

	<xsl:output method="text" indent="yes"
		doctype-public="-//Hibernate/Hibernate Mapping DTD 3.0//EN"
		doctype-system="http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd"
		omit-xml-declaration="no"/>	

	<xsl:template match="schema">
		<xsl:apply-templates select="./table"/>
	</xsl:template>

	<xsl:template match="table">
		<xsl:apply-templates select="./fields/field[starts-with(@type, 'I18NVALUE')]"/>
	</xsl:template>

	<xsl:template match="field[starts-with(@type, 'I18NVALUE')]">
		<xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
	
		<xsl:text>INSERT INTO T_I18NCOLUMN (TABLE_NAME, COLUMN_NAME, ORACLE_TYPE, MANDATORY_DATA, UNIQUE_DATA, COLUMN_COMMENT, ADD_INDEX) VALUES (</xsl:text>
		<xsl:text>'</xsl:text><xsl:value-of select="../../@name"/><xsl:text>',</xsl:text>
		<xsl:text>'</xsl:text><xsl:value-of select="$name"/><xsl:text>',</xsl:text>
		<xsl:text>'VARCHAR2</xsl:text><xsl:value-of select="substring-after(@type, 'I18NVALUE')"/><xsl:text>',</xsl:text>
		<xsl:choose>
			<xsl:when test="@not-null = 'true'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>

		<!-- UNIQUE CONSTRAINT -->
		<xsl:choose>
			<xsl:when test="count(../../unique-constraints/unique-constraint[field/text() = $name]/field)=1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>

		<xsl:text>,null,</xsl:text>	

		<!-- INDEX -->
		<xsl:choose>
			<xsl:when test="count(../../indexes/index[field/text() = $name]/field)=1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>

		<xsl:text>);
</xsl:text>
  	</xsl:template>
</xsl:stylesheet>