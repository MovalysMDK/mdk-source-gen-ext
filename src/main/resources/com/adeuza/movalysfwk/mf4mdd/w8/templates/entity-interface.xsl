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

<xsl:template match="pojo">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="interface/name"/>.cs</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-impl-imports" />

<xsl:call-template name="model-interface-using"/>

<xsl:text>&#13;&#13;</xsl:text>

<xsl:text>namespace </xsl:text><xsl:value-of select="interface/package"/><xsl:text></xsl:text>
<xsl:text>{&#13;</xsl:text>
<xsl:text>[ScopePolicyAttribute(ScopePolicy.Prototype)]&#13;</xsl:text>
<xsl:if test="class/transient != 'true' or class/create-from-expandable-processor != 'true'">
	<xsl:text>[Table("</xsl:text><xsl:value-of select="class/table-name"/><xsl:text>")]&#13;</xsl:text>
</xsl:if>
<xsl:text>public interface </xsl:text><xsl:value-of select="interface/name"/>
<xsl:choose>
	<xsl:when test="class/create-from-expandable-processor = 'true'">
		<!-- Dans le cas d'une classe contenant uniquement des champs en BD, l'interface n'implémente pas IMEntity -->
		<xsl:text></xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:choose>
		<xsl:when test="class/@join-class='true'">
			<xsl:text> : IMEntity</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text> : IMIdentifiable</xsl:text>
		</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="class/stereotypes/stereotype[@name = 'Mm_Photo']">
			<xsl:text>, IMFPhoto</xsl:text>
		</xsl:if>
	</xsl:otherwise>
</xsl:choose>
<xsl:text>{</xsl:text>

<xsl:text>&#13;#region Properties&#13;&#13;</xsl:text>
<!-- <xsl:if test="not(class/stereotypes/stereotype) or class/stereotypes/stereotype[@name != 'Mm_Photo']"> -->
<xsl:if test="class/stereotypes/stereotype[@name = 'Mm_model'] or class/@join-class = 'true'">
	<xsl:for-each select="//*[((name() = 'attribute' and not(parent::association)))]">
	<xsl:if test="field and parent::identifier and //class/@join-class != 'true' or //class/stereotypes/stereotype[@name = 'Mm_Photo']">
		<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	</xsl:if>
	<xsl:if test="field and (not(//class/create-from-expandable-processor) or //class/create-from-expandable-processor != 'true')">
		<xsl:choose>
			<xsl:when test="parent::identifier and (not(//class/@join-class) or //class/@join-class != 'true')">
				<xsl:text>[PrimaryKey, Column("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>")]&#13;</xsl:text>
			</xsl:when>
			<xsl:when test="name() = 'attribute' and @kind = 'basic'">
				<xsl:if test="@enum = 'false'">
					<xsl:text>[Column("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>")]&#13;</xsl:text>
				</xsl:if>
				<xsl:if test="@enum = 'true'">
					<xsl:text>[MaxLength(10), Column("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>")]&#13;</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="name() = 'attribute' and @kind = 'composite'">
				<xsl:text>[Ignore]&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>[Column("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>")]&#13;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="not(field) and //class/transient = 'false'">
		<xsl:text>[Complex]&#13;</xsl:text>
	</xsl:if>
	
	<xsl:choose>
		<xsl:when test="name() = 'association'">
			<xsl:value-of select="attribute/@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name-capitalized"/><xsl:value-of select="attribute/@name-capitalized"/>
		</xsl:when>
		<xsl:when test="parent::identifier and //class/@join-class != 'true' or //class/stereotypes/stereotype[@name = 'Mm_Photo']">
			<xsl:text>new </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name-capitalized"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name-capitalized"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>{</xsl:text>
	<xsl:text>get; set;</xsl:text>
	<xsl:text>}</xsl:text>
	<xsl:text>&#13;&#13;</xsl:text>
	</xsl:for-each>
</xsl:if>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
</xsl:call-template>

<xsl:text>&#13;#endregion&#13;</xsl:text>

<xsl:text>&#13;#region Associations&#13;&#13;</xsl:text><xsl:text></xsl:text>

<xsl:for-each select="//*[(name() = 'association' and not(parent::association))]">
<xsl:if test="@type='one-to-one' or @type='many-to-one'">
<xsl:text>[ForeignKey("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>","</xsl:text><xsl:value-of select="attribute/field/@name"/><xsl:text>")]&#13;</xsl:text>
</xsl:if>
<xsl:if test="not(@type='one-to-one' or @type='many-to-one')">
<xsl:if test="//*[class/table-name]">
	<xsl:text>[Ignore]&#13;</xsl:text>
</xsl:if>
</xsl:if>

<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text></xsl:text>
<xsl:text>{</xsl:text>
<xsl:text>get; set;</xsl:text>
<xsl:text>}</xsl:text>
<xsl:text>&#13;&#13;</xsl:text>
</xsl:for-each>

<xsl:text>#endregion&#13;</xsl:text>

<xsl:text>}</xsl:text>
<xsl:text>}</xsl:text>

</xsl:template>

</xsl:stylesheet>