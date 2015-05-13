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
	<xsl:text disable-output-escaping="yes">-- Script de création
--

--
-- /!\ Attention a bien conserver en fin de script la création de la table T_PROPERTIES 
-- /!\ Mettre a jour le numéro de version inséré dans T_PROPERTIES afin d'être syncho avec dbgen
--


</xsl:text>
<xsl:apply-templates select="./table"/>

<xsl:apply-templates select="./table/foreign-keys/foreign-key"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="./table/indexes/index"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="./table/unique-constraints/unique-constraint"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="./table/fields/field/sequence"/>

</xsl:template>

	<xsl:template match="table">
		<xsl:text>CREATE TABLE </xsl:text><xsl:value-of select="./@name"/><xsl:text>(
</xsl:text>

		<xsl:apply-templates select="./fields/field[not(starts-with(@type, 'I18NVALUE'))]"/>
		<xsl:apply-templates select="./primary-key"/>
		<xsl:text>);

</xsl:text>
	</xsl:template>

	<xsl:template match="field">
		<xsl:text>	</xsl:text><xsl:value-of select="./@name"/><xsl:text> </xsl:text><xsl:value-of select="./@type"/>
		<xsl:apply-templates select="." mode="default-value"/>
		<xsl:if test="./@not-null = 'true'"><xsl:text> NOT NULL</xsl:text></xsl:if>
		<xsl:text>,
</xsl:text>
	</xsl:template>

	<xsl:template match="field" mode="default-value" priority="1">
	</xsl:template>

	<xsl:template match="field[@default-value and @data-type = 'NUMERIC']" mode="default-value" priority="2">
		<xsl:text> DEFAULT </xsl:text>
		<xsl:value-of select="@default-value"/>
	</xsl:template>

	<xsl:template match="field[@default-value and @jdbc-type = 'VARCHAR']" mode="default-value" priority="2">
		<xsl:text> DEFAULT '</xsl:text>
		<xsl:value-of select="substring-before(substring-after(@default-value, '&quot;'), '&quot;')"/>
		<xsl:text>'</xsl:text>
	</xsl:template>

	<xsl:template match="field[@default-value and @jdbc-type = 'BOOLEAN']" mode="default-value" priority="3">
		<xsl:text> DEFAULT </xsl:text>
		<xsl:choose>
			<xsl:when test="@default-value = 'true'">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field[@default-value and @data-type='DATE']" mode="default-value" priority="2">
		<xsl:text> DEFAULT SYSDATE</xsl:text>
	</xsl:template>

	<xsl:template match="primary-key">
		<xsl:text>	CONSTRAINT </xsl:text><xsl:value-of select="./@name"/><xsl:text> PRIMARY KEY (</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./field">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)
</xsl:text>
	</xsl:template>

<!-- ALTER TABLE MIT_INTERTYPETASKMODEL ADD CONSTRAINT MIFK_MIT_IN_MIT_TA_TASKMO FOREIGN KEY(TASKMODELID) REFERENCES MIT_TASKMODEL(ID); -->
	<xsl:template match="foreign-key">
		<xsl:text>ALTER TABLE </xsl:text><xsl:value-of select="../../@name"/>
		<xsl:text> ADD CONSTRAINT </xsl:text><xsl:value-of select="./@name"/>
		<xsl:text> FOREIGN KEY(</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./field">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>) REFERENCES </xsl:text><xsl:value-of select="./table-ref/@name"/>
		<xsl:text>(</xsl:text>
		<!-- BOUCLE -->
		<xsl:for-each select="./table-ref/field">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
		<xsl:if test="@delete-cascade = 'true'">
			<xsl:text> ON DELETE CASCADE </xsl:text>
		</xsl:if>
		<xsl:text>;
</xsl:text>
	</xsl:template>

	<!-- CREATE INDEX MIIN_MIT_TASKM_TASKMODEL ON MIT_INTERTYPETASKMODEL (TASKMODELID); -->
	<xsl:template match="index">
		<xsl:variable name="hasI18NField">
			<xsl:apply-templates select="." mode="hasI18NField"/>
		</xsl:variable>

		<xsl:if test="$hasI18NField = 'false'">
			<xsl:text>CREATE </xsl:text>
			<xsl:if test="./@unique = 'true'"><xsl:text> UNIQUE </xsl:text></xsl:if>
			<xsl:text>INDEX </xsl:text><xsl:value-of select="./@name"/>
			<xsl:text> ON </xsl:text><xsl:value-of select="../../@name"/>
			<xsl:text> (</xsl:text>
			<!-- BOUCLE -->
			<xsl:for-each select="./field">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>);
</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- CREATE SEQUENCE MISEQ_MIT_INTERTYP_I2 INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999 MINVALUE 1 NOCACHE NOCYCLE ORDER ; -->
	<xsl:template match="sequence">
		<xsl:text>CREATE SEQUENCE </xsl:text><xsl:value-of select="./@name"/>
		<xsl:text> INCREMENT BY </xsl:text><xsl:value-of select="./@step"/>
		<xsl:text> START WITH </xsl:text><xsl:value-of select="./@initial-value"/>
		<xsl:text> MAXVALUE </xsl:text><xsl:value-of select="./@max-value"/>
		<xsl:text> MINVALUE </xsl:text><xsl:value-of select="./@initial-value"/>
		<xsl:if test="./@cached = 'true'"><xsl:text> CACHE</xsl:text></xsl:if>
		<xsl:if test="./@cached = 'false'"><xsl:text> NOCACHE</xsl:text></xsl:if>
		<xsl:if test="./@cycle = 'true'"><xsl:text> CYCLE</xsl:text></xsl:if>
		<xsl:if test="./@cycle = 'false'"><xsl:text> NOCYCLE</xsl:text></xsl:if>
		<xsl:text> ORDER ;
</xsl:text>
	</xsl:template>

	<!-- ALTER TABLE Persons ADD CONSTRAINT uc_PersonID UNIQUE (P_Id,LastName) -->
	<xsl:template match="unique-constraint">
		<xsl:variable name="hasI18NField">
			<xsl:apply-templates select="." mode="hasI18NField"/>
		</xsl:variable>

		<xsl:if test="$hasI18NField = 'false'">
			<xsl:text>ALTER TABLE </xsl:text><xsl:value-of select="../../@name"/>
			<xsl:text> ADD CONSTRAINT </xsl:text><xsl:value-of select="./@name"/>
			<xsl:text> UNIQUE(</xsl:text>
			<!-- BOUCLE -->
			<xsl:for-each select="./field">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>);
</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="unique-constraint|index" mode="hasI18NField">
		<xsl:variable name="hasI18NField">
			<xsl:apply-templates select="field" mode="isI18N"/>
		</xsl:variable>

		<xsl:value-of select="contains($hasI18NField, 'true')"/>
	</xsl:template>

	<xsl:template match="unique-constraint/field|index/field" mode="isI18N">
		<xsl:variable name="name">
			<xsl:value-of select="text()"/>
		</xsl:variable>

		<xsl:apply-templates select="../../../fields/field[@name = $name]" mode="isI18N"/>
	</xsl:template>

	<xsl:template match="fields/field[starts-with(@type, 'I18NVALUE')]" mode="isI18N" priority="2">
		<xsl:text>true</xsl:text>
	</xsl:template>

	<xsl:template match="fields/field" mode="isI18N" priority="1">
		<xsl:text>false</xsl:text>
	</xsl:template>
</xsl:stylesheet>