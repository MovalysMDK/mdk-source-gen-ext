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

<xsl:include href="includes/sql-innerjoin.xsl"/>
<xsl:include href="includes/sql-criteria.xsl"/>
<xsl:include href="includes/sql-deleteby.xsl"/>
<xsl:include href="includes/sql-getby.xsl"/>
<xsl:include href="includes/sql-getnbby.xsl"/>
<xsl:include href="includes/sql-getlistby.xsl"/>

<xsl:output method="text"/>

<xsl:template match="dao">

<xsl:variable name="interface" select="interface"/>
<xsl:variable name="class" select="class"/>
<xsl:variable name="tableName" select="class/table-name"/>

<xsl:call-template name="get-by-pk">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="get-list">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="count">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="insert">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="update">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="exist-by-pk">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="delete-by-pk">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:call-template name="delete-list">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:call-template>

<xsl:apply-templates select="method-signature[@by-value = 'false']">
	<xsl:with-param name="tableName" select="$tableName"/>
</xsl:apply-templates>

</xsl:template>

<!--
Requête pour la récupèration par clé primaire 
 -->
<xsl:template name="get-by-pk">
<xsl:param name="tableName"/>

<xsl:text>sql.get-by-pk = SELECT </xsl:text> 
<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute/field | class/association/field">
<xsl:text>{0}.</xsl:text><xsl:value-of select="@name"/>
<xsl:if test="position() != last()">
<xsl:text>, </xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text> FROM </xsl:text><xsl:value-of select="$tableName"/>
<xsl:text>_{1}{2} {0} WHERE </xsl:text>
<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field">
	<xsl:text>{0}.</xsl:text>
	<xsl:value-of select="@name"/><xsl:text> = ?</xsl:text>
	<xsl:if test="position() != last()">
		<xsl:text> AND </xsl:text>
	</xsl:if>
</xsl:for-each>
<xsl:text>
</xsl:text>
</xsl:template>

<!--
Requête pour la récupèration par liste
 -->
<xsl:template name="get-list">
<xsl:param name="tableName"/>

<xsl:text>sql.get-list = SELECT </xsl:text> 
<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute/field | class/association/field">
<xsl:text>{0}.</xsl:text><xsl:value-of select="@name"/>
<xsl:if test="position() != last()">
<xsl:text>, </xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text> FROM </xsl:text><xsl:value-of select="$tableName"/><xsl:text>_{1}{2} {0} </xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!--
Requête pour le comptage
 -->
<xsl:template name="count">
<xsl:param name="tableName"/>

<xsl:text>sql.count = SELECT count({0}.</xsl:text><xsl:value-of select="class/identifier/attribute/field/@name | class/identifier/association/field/@name"/>
<xsl:text>) FROM </xsl:text><xsl:value-of select="$tableName"/><xsl:text>_{1}{2} {0} </xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>

<!--
Requête d'insertion 
 -->
<xsl:template name="insert">
<xsl:param name="tableName"/>

<xsl:text>sql.insert = INSERT INTO </xsl:text><xsl:value-of select="$tableName"/><xsl:text>(</xsl:text>
	<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute/field | class/association/field ">
		<xsl:value-of select="@name"/>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>) VALUES (</xsl:text>
	<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute/field | class/association/field ">
		<xsl:if test="sequence">
			<xsl:value-of select="sequence/@name"/><xsl:text>.NEXTVAL</xsl:text>
		</xsl:if>
		<xsl:if test="not(sequence)">
			<xsl:text>?</xsl:text>
		</xsl:if>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
<xsl:text>)
</xsl:text>
</xsl:template>

<!--
Requête d'insertion 
 -->
<xsl:template name="update">
<xsl:param name="tableName"/>

<xsl:text>sql.update = UPDATE </xsl:text><xsl:value-of select="$tableName"/><xsl:text> SET </xsl:text> 
<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute/field | class/association/field">
<xsl:value-of select="@name"/>
<xsl:text> = ?</xsl:text>
<xsl:if test="position() != last()">
<xsl:text>, </xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text> WHERE </xsl:text>
<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field">
<xsl:value-of select="@name"/>
<xsl:text> = ?</xsl:text>
<xsl:if test="position() != last()">
<xsl:text> AND </xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>
</xsl:text>
</xsl:template>

<!--
Requête d'existance 
 -->
<xsl:template name="exist-by-pk">
<xsl:param name="tableName"/>

<xsl:text>sql.exist-by-pk = SELECT count({0}.</xsl:text><xsl:value-of select="class/identifier/attribute/field/@name | class/identifier/association/field/@name"/>
<xsl:text>) FROM </xsl:text><xsl:value-of select="$tableName"/><xsl:text>_{1}{2} {0} WHERE </xsl:text>
<xsl:for-each select="class/identifier/descendant::attribute">
<xsl:text>{0}.</xsl:text>
<xsl:value-of select="field/@name"/><xsl:text> = ?</xsl:text>
<xsl:if test="position() != last()">
<xsl:text> AND </xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>
</xsl:text>
</xsl:template>


<!--
Requête pour la récupèration par clé primaire 
 -->
<xsl:template name="delete-by-pk">
<xsl:param name="tableName"/>

<xsl:text>sql.delete-by-pk = DELETE FROM </xsl:text><xsl:value-of select="$tableName"/>
<xsl:text> WHERE </xsl:text> 
<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field">
<xsl:value-of select="@name"/><xsl:text> = ?</xsl:text>
<xsl:if test="position() != last()">
<xsl:text> AND </xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:text>
</xsl:text>
</xsl:template>


<!--
Requête pour le delete de tous 
 -->
<xsl:template name="delete-list">
<xsl:param name="tableName"/>

<xsl:text>sql.delete-list = DELETE FROM </xsl:text><xsl:value-of select="$tableName"/>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>