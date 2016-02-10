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

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>

<xsl:template match="factory-interface">

	<xsl:apply-templates select="pojo-factory-interface" mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="pojo-factory-interface/name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:call-template name="pojo-factory-interface-using"/>
	<xsl:for-each select="class/import">
		<xsl:text>using </xsl:text><xsl:value-of select="."/><xsl:text>;</xsl:text>
	</xsl:for-each>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	
	<xsl:text>namespace </xsl:text><xsl:value-of select="pojo-factory-interface/package"/><xsl:text></xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]&#13;</xsl:text>
	<xsl:text>public interface </xsl:text><xsl:value-of select="pojo-factory-interface/name"/>
	<xsl:choose>
		<xsl:when test="pojo-factory/class/create-from-expandable-processor = 'true'">
			<!-- Dans le cas d'une factory d'une classe d'association ou contenant uniquement des champs en BD sans clé primaire (Id), l'interface n'implémente pas IEntityFactory<T> where T : IMEntity -->
			<xsl:text>&#13;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text><![CDATA[ : IEntityFactory<]]></xsl:text><xsl:value-of select="pojo-factory-interface/interface/@name"/><xsl:text><![CDATA[>]]>&#13;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>{&#13;</xsl:text>
	
	<xsl:choose>
		<xsl:when test="pojo-factory/class/create-from-expandable-processor = 'true'">
			<!-- Dans le cas d'une factory d'une classe d'association ou contenant uniquement des champs en BD sans clé primaire (Id), pas de mot clé new -->
			<xsl:text>&#13;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>new </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="pojo-factory-interface/interface/@name"/><xsl:text> CreateInstance();</xsl:text>
	
	<xsl:text>&#13;</xsl:text>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>&#13;</xsl:text>
	
	<xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text>

</xsl:template>
</xsl:stylesheet>