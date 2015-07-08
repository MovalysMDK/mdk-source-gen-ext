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

<xsl:template match="class" mode="attribute-declaration">

		<xsl:for-each select="//*[((name() = 'attribute' and @derived = 'false') or name()= 'association') and not(ancestor::association)]">
	
		/**
		 * <xsl:value-of select="documentation/doc-attribute"/>
		 * <xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/>
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 *<xsl:text> </xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text> type=</xsl:text>
			<xsl:value-of select="@type-short-name"/>
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="@nullable = 'false'"/>
			<xsl:if test="@unique and @unique='true'">
				<xsl:text> unique=</xsl:text>
				<xsl:value-of select="@unique and @unique='true'"/>
			</xsl:if>
			<xsl:if test="@unique-key">	
				<xsl:variable name="unique-key" select="@unique-key"/>
				<xsl:text> unique-key=true</xsl:text>
				<xsl:text> unique-key-name=</xsl:text><xsl:value-of select="@unique-key"/>
				<xsl:text> unique-key-relation=</xsl:text>
				
				<xsl:for-each select="//pojo/class/identifier/attribute[@unique-key=$unique-key and field/@name!=$name] | //pojo/class/attribute[@unique-key=$unique-key and field/@name!=$name]">
					<xsl:value-of select="field/@name"/>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="name()= 'association'">
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Cascade <xsl:value-of select="@cascade-name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 *<xsl:text> </xsl:text>
			 <!-- type de relation -->
			<xsl:if test="@type = 'many-to-one'">
				<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
				<xsl:text>Relation ManyToOne</xsl:text>
				<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
			</xsl:if>
			<xsl:if test="@type = 'one-to-many'">
				<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
				<xsl:text>Relation OneToMany</xsl:text>
				<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
			</xsl:if>
			<xsl:if test="@type = 'one-to-one'">
				<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
				<xsl:text>Relation OneToOne</xsl:text>
				<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
			</xsl:if>
			<xsl:if test="@type = 'many-to-many'">
				<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
				<xsl:text>Relation ManyToMany</xsl:text>
				<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
			</xsl:if>
			<!-- objet cible -->
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text> targetEntity=</xsl:text>
			<xsl:value-of select="interface/name"/>
			<!-- obligatoire -->
			<xsl:if test="@type = 'many-to-one' or @type = 'one-to-one'">
				<xsl:text> mandatory=</xsl:text>
				<xsl:value-of select="@optional != 'true'"/>
			</xsl:if>
			<!-- proprietaire de la relation -->
			<xsl:text> relationOwner=</xsl:text>
			<xsl:value-of select="@relation-owner"/>
			<!-- transient -->
			<xsl:text> transient=</xsl:text>
			<xsl:value-of select="@transient"/>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		 */
		<xsl:variable name="attribute" select="concat('attribute-', @name)"/>
		//@non-generated-start[attribute-<xsl:value-of select="@name"/>]
	<xsl:value-of select="/class/non-generated/bloc[@id=$attribute]"/>
	<xsl:text>	//@non-generated-end[attribute-</xsl:text><xsl:value-of select="@name"/>]
		<xsl:apply-templates select="annotations/annotation"/>
		<xsl:value-of select="@visibility"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@type-short-name"/>
			<xsl:if test="@contained-type-short-name">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="@contained-type-short-name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/> ;
	
		</xsl:for-each>
</xsl:template>

<xsl:template match="annotation">
	<xsl:text>@</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>