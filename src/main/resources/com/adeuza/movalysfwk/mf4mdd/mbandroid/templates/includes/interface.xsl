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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/imports.xsl"/>

	<xsl:template match="node()[package and name]" mode="declare-interface">
		package <xsl:value-of select="package"/>;

		<xsl:apply-templates select="." mode="declare-imports"/>

		<xsl:apply-templates select="." mode="documentation"/>
		<xsl:apply-templates select="." mode="class-annotations"/>
		<xsl:text>public interface </xsl:text><xsl:value-of select="name"/>
				<xsl:apply-templates select="." mode="extends"/>
				//@non-generated-start[class-signature]
				<xsl:value-of select="/*/non-generated/bloc[@id='class-signature']"/>
				<xsl:text>//@non-generated-end</xsl:text>
		{
			<xsl:apply-templates select="." mode="constants"/>

			//@non-generated-start[constants]
			<xsl:value-of select="/*/non-generated/bloc[@id='constants']"/>
			<xsl:text>//@non-generated-end&#13;&#13;</xsl:text>

			<xsl:apply-templates select="method-signature" mode="declare-method"/>
			<xsl:apply-templates select="." mode="methods"/>

			//@non-generated-start[methods]
			<xsl:value-of select="/*/non-generated/bloc[@id='methods']"/>
			<xsl:value-of select="/*/non-generated/bloc[@id='methodes']"/>
			<xsl:text>//@non-generated-end</xsl:text>
		}
	</xsl:template>

	<!-- ###################################################
						GESTION DE LA DOCUMENTATION
		################################################### -->

	<xsl:template match="node()" mode="documentation">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * </xsl:text><xsl:value-of select="documentation"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
	</xsl:template>

	<!-- ###################################################
						GESTION DES SUPER-INTERFACES
		################################################### -->

	<xsl:template match="node()" mode="extends">
		<xsl:variable name="superinterfaces">
			<xsl:apply-templates select="." mode="superinterfaces"/>
		</xsl:variable>

		<xsl:if test="string-length($superinterfaces) > 0">
			<xsl:text> extends </xsl:text>
			<xsl:value-of select="$superinterfaces"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="superinterfaces">
		<xsl:apply-templates select="./linked-interface" mode="superinterface"/>
	</xsl:template>

	<xsl:template match="linked-interface" mode="superinterface">
		<xsl:if test="./position > 1">
			<xsl:text>,</xsl:text>
		</xsl:if>

		<xsl:value-of select="./name"/>

		<xsl:if test="count(./generic-parameters/param) > 0">
			<xsl:text>&lt;</xsl:text>
			<xsl:for-each select="./generic-parameters/param">
				<xsl:if test="position() > 1">
					<xsl:text>,</xsl:text>
				</xsl:if>
				<xsl:value-of select="./@name"/>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
	</xsl:template>


	<!-- ###################################################
						TEMPLATES PAR DEFAUT
		################################################### -->

	<xsl:template match="node()" mode="class-annotations"/>

	<xsl:template match="node()" mode="constants"/>

	<!-- ###################################################
						METHODES
		################################################### -->

	<xsl:template match="method-signature" mode="declare-method">
		<xsl:apply-templates select="." mode="declare-method-documentation"/>
		<xsl:value-of select="@visibility"/><xsl:text> </xsl:text><xsl:apply-templates select="return-type" mode="declare-method"/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:text>(</xsl:text>
		<xsl:apply-templates select="method-parameter" mode="declare-method"/>
		<xsl:text>);</xsl:text>
	</xsl:template>

	<xsl:template match="method-signature" mode="declare-method-documentation">
		/** 
		 * <xsl:value-of select="./javadoc"/>
		 */
	</xsl:template>

	<xsl:template match="return-type" mode="declare-method">
		<xsl:value-of select="@short-name"/>
		<xsl:if test="count(./parameterized/param) > 0">
			<xsl:text>&lt;</xsl:text>
			<xsl:apply-templates select="parameterized/param" mode="declare-method"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="method-parameter" mode="declare-method">
		<xsl:if test="position() > 1">
			<xsl:text>, </xsl:text>
		</xsl:if>

		<xsl:value-of select="@type-short-name"/>
		<xsl:if test="count(./parameterized/param) > 0">
			<xsl:text>&lt;</xsl:text>
			<xsl:apply-templates select="parameterized/param" mode="declare-method"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>

		<xsl:value-of select="@name"/>
	</xsl:template>

	<xsl:template match="parameterized/param" mode="declare-method">
		<xsl:if test="position() > 1">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:value-of select="@type-short-name"/>
	</xsl:template>

	<xsl:template match="node()" mode="methods"/>

	<!-- ###################################################
							IMPORTS
		################################################### -->

	<xsl:template match="node()" mode="declare-extra-imports"/>
</xsl:stylesheet>	
