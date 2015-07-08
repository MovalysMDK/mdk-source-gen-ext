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
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/implements.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/incremental/nongenerated.xsl"/>

	<xsl:template match="node()[package and name]" mode="declare-class">
		<xsl:text>package </xsl:text><xsl:value-of select="package"/><xsl:text>;&#13;</xsl:text>

		<xsl:apply-templates select="." mode="declare-imports"/>

		<xsl:apply-templates select="." mode="documentation"/>
		<xsl:apply-templates select="." mode="class-annotations"/>
		<xsl:apply-templates select="." mode="class-prototype"/>
		<xsl:text>{&#13;</xsl:text>
			<xsl:apply-templates select="." mode="class-body"/>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="node()" mode="class-prototype">
		<xsl:text>public class </xsl:text><xsl:value-of select="name"/>
		<xsl:apply-templates select="." mode="extends"/>
		<xsl:apply-templates select="." mode="implements"/>
		<xsl:text>&#13;//@non-generated-start[class-signature]&#13;</xsl:text>
		<xsl:value-of select="non-generated/bloc[@id='class-signature']"/>
		<xsl:value-of select="non-generated/bloc[@id='implements']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="node()" mode="class-body">
		<xsl:apply-templates select="." mode="attributes"/>

		<xsl:text>//@non-generated-start[attributes]&#13;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='attributes']"/>
		<xsl:text>//@non-generated-end&#13;&#13;</xsl:text>

		<xsl:apply-templates select="." mode="constructors"/>

		<xsl:apply-templates select="." mode="methods"/>

		<xsl:text>&#13;//@non-generated-start[methods]&#13;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='methods']"/>
		<xsl:value-of select="/*/non-generated/bloc[@id='methodes']"/>
		<xsl:text>//@non-generated-end&#13;</xsl:text>

		<xsl:apply-templates select="." mode="inner-classes"/>
	</xsl:template>

	<!-- ###################################################
						GESTION DE LA DOCUMENTATION
		################################################### -->

	<xsl:template match="node()" mode="documentation">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * </xsl:text>
		<xsl:value-of select="documentation"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text> 
	</xsl:template>

	<!-- ###################################################
						GESTION DE LA SUPER CLASSE
		################################################### -->

	<xsl:template match="node()" mode="extends">
		<xsl:variable name="superclass">
			<xsl:apply-templates select="." mode="superclass"/>
		</xsl:variable>

		<xsl:if test="string-length($superclass) > 0">
			<xsl:text>&#13;</xsl:text><xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">class-signature-extends</xsl:with-param>
				<xsl:with-param name="defaultSource">extends <xsl:value-of select="$superclass"/><xsl:text>&#13;</xsl:text></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="superclass"/>

	<!-- ###################################################
						GESTION DES INTERFACES
		################################################### -->

	<xsl:template match="node()" mode="implements">
		<xsl:variable name="interfaces">
			<xsl:apply-templates select="." mode="declare-implements"/>
		</xsl:variable>
 
		<xsl:if test="string-length($interfaces) > 0">
			<xsl:text> implements </xsl:text>
			<xsl:value-of select="$interfaces"/>
		</xsl:if>

	</xsl:template>

	<!-- ###################################################
						TEMPLATES PAR DEFAUT
		################################################### -->

	<xsl:template match="node()" mode="class-annotations"/>

	<xsl:template match="node()" mode="attributes"/>

	<xsl:template match="node()" mode="constructors"/>

	<xsl:template match="node()" mode="methods"/>

	<xsl:template match="node()" mode="inner-classes"/>

	<!-- ###################################################
							IMPORTS
		################################################### -->

	<xsl:template match="node()" mode="declare-extra-imports">
		<xsl:apply-templates select="." mode="superclass-import"/>
		<xsl:apply-templates select="." mode="interfaces-import"/>
		<xsl:apply-templates select="." mode="attributes-import"/>
		<xsl:apply-templates select="." mode="methods-import"/>
	</xsl:template>

</xsl:stylesheet>
