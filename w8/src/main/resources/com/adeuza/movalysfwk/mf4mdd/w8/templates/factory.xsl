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

<!-- DTN - EN COURS DE TRAITEMENT -->

<xsl:template match="pojo-factory">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:call-template name="pojo-factory-using"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	
	<xsl:text>namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>public class </xsl:text><xsl:value-of select="name"/>
	<xsl:for-each select="implements/interface">
		<xsl:if test="position() = '1'">
			<xsl:text> : </xsl:text><xsl:value-of select="@name"/>
		</xsl:if>
		<xsl:if test="position() != '1' and position() != last()">
			<xsl:text>, </xsl:text><xsl:value-of select="@name"/>
		</xsl:if>
		<xsl:if test="position() != '1' and position() = last()">
			<xsl:value-of select="@name"/><xsl:text>&#13;</xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>{&#13;</xsl:text>
	
	<xsl:text>public </xsl:text><xsl:value-of select="interface/@name"/><xsl:text> CreateInstance()</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:choose>
		<xsl:when test="class/@join-class='true'">
			<xsl:text>return null;&#13;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="interface/@name"/><xsl:text> </xsl:text><xsl:value-of select="class/name-uncapitalized"/>
			<xsl:text> = new </xsl:text><xsl:value-of select="class/name"/><xsl:text>();&#13;</xsl:text>
			<xsl:text>this.Init(</xsl:text><xsl:value-of select="class/name-uncapitalized"/><xsl:text>);&#13;</xsl:text>
			<xsl:text>return </xsl:text><xsl:value-of select="class/name-uncapitalized"/><xsl:text>;&#13;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>}</xsl:text>
	
	<xsl:text>&#13;&#13;</xsl:text>
	
	<xsl:text>protected void Init(</xsl:text><xsl:value-of select="interface/@name"/>
	<xsl:text> </xsl:text><xsl:value-of select="class/name-uncapitalized"/><xsl:text>)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-init</xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
	<xsl:choose>
		<xsl:when test="class/create-from-expandable-processor = 'true'">
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&#13;</xsl:text>
			<xsl:text>object IEntityFactory.CreateInstance()</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:text>return this.CreateInstance();</xsl:text>
			<xsl:text>}&#13;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:text>&#13;</xsl:text>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>&#13;</xsl:text>
	
	<xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text>

</xsl:template>
</xsl:stylesheet>