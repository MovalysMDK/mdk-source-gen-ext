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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" indent="no"/>

	<xsl:template match="schema">
		<xsl:apply-templates select="./table" />
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="./table/indexes/index" />
		<xsl:text>&#10;</xsl:text>

	</xsl:template>

	<!-- Template for table creation-->
	<xsl:template match="table">
		<xsl:text>CREATE TABLE IF NOT EXISTS </xsl:text>
		<xsl:value-of select="./@name" />
		<xsl:text>(&#10;</xsl:text>

		<xsl:variable name="fieldName" select="primary-key/field/."/>
		<!-- We generate primary key only there is no AUTOINCREMENT PRIMARY KEY in field definitions -->
		<xsl:variable name="isAutoIncPk"
			select="count(primary-key/field) = 1 and count(fields/field[@name=$fieldName]/sequence) = 1"/>

		<xsl:apply-templates
			select="./fields/field">
			<xsl:with-param name="isAutoIncPk" select="$isAutoIncPk"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="./primary-key">
			<xsl:with-param name="isAutoIncPk" select="$isAutoIncPk"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="./foreign-keys/foreign-key" />
		<xsl:apply-templates select="./unique-constraints/unique-constraint" />		
		<xsl:text>);&#10;&#10;</xsl:text>
	</xsl:template>

	<!-- Template for field of a table-->
	<xsl:template match="field">
		<xsl:param name="isAutoIncPk"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="./@name" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="./@type" />
		<xsl:if test="./@not-null = 'true'">
			<xsl:text> NOT NULL</xsl:text>
		</xsl:if>
		<xsl:if test="count(sequence) = 1 and ./@type ='INTEGER'">
			<xsl:text> PRIMARY KEY AUTOINCREMENT UNIQUE</xsl:text>
		</xsl:if>
		<xsl:if test="position() != last() or $isAutoIncPk != 'false' or count(../../foreign-keys/foreign-key) != 0 or count(../../unique-constraints/unique-constraint) != 0">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>		
	</xsl:template>

	<!-- Template for primary key -->
	<xsl:template match="primary-key">
		<xsl:param name="isAutoIncPk"/>
		<xsl:if test="$isAutoIncPk = false">

		<xsl:text>	CONSTRAINT </xsl:text>
		<xsl:value-of select="./@name" />
		<xsl:text> PRIMARY KEY (</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./field">
			<xsl:value-of select="." />
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
		
		<xsl:if test="count(../foreign-keys/foreign-key) != 0 or count(../unique-constraints/unique-constraint) != 0">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
		</xsl:if>
	
	</xsl:template>


	<!-- Template pour les foreign key -->
	<xsl:template match="foreign-key">
		<xsl:text>	CONSTRAINT </xsl:text>
		<xsl:value-of select="./@name" />
		<xsl:text> FOREIGN KEY(</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./field">
			<xsl:value-of select="." />
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>) REFERENCES </xsl:text>
		<xsl:value-of select="./table-ref/@name" />
		<xsl:text>(</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./table-ref/field">
			<xsl:value-of select="." />
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>) ON UPDATE CASCADE</xsl:text>
		<xsl:if test="@delete-cascade = 'true'">
			<xsl:text> ON DELETE CASCADE</xsl:text>
		</xsl:if>
		<xsl:if test="count(following-sibling::foreign-key) != 0 or count(../../unique-constraints/unique-constraint) != 0">
			<xsl:text>,</xsl:text> 
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<!-- Template for unique constraints -->
	<xsl:template match="unique-constraint">

		<xsl:text>	CONSTRAINT </xsl:text>
		<xsl:value-of select="./@name" />
		<xsl:text> UNIQUE(</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./field">
			<xsl:value-of select="." />
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
		<xsl:if test="count(following-sibling::unique-constraint) != 0">
			<xsl:text>,</xsl:text> 
		</xsl:if>
		<xsl:text>&#10;</xsl:text>

	</xsl:template>
	
	
		<!--  Template for index creation -->
	<xsl:template match="index">

			<xsl:text>CREATE </xsl:text>
			<xsl:if test="./@unique = 'true'">
				<xsl:text> UNIQUE </xsl:text>
			</xsl:if>
			<xsl:text>INDEX  IF NOT EXISTS </xsl:text>
			<xsl:value-of select="./@name" />
			<xsl:text> ON </xsl:text>
			<xsl:value-of select="../../@name" />
			<xsl:text> (</xsl:text>
			<!-- BOUCLE -->
			<xsl:for-each select="./field">
				<xsl:value-of select="." />
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>);&#10;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>