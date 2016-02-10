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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/class.xsl"/>

	<xsl:output method="text"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="dao-extends">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- DOCUMENTATION .............................................................................................. -->

	<xsl:template match="dao-extends" mode="documentation">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * &#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"> * <![CDATA[<p>Classe de DAO : ]]>
		</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	<xsl:template match="dao-extends" mode="superclass">
		<xsl:value-of select="dao/name"/>
	</xsl:template>

	<!-- INTERFACES ................................................................................................. -->

	<xsl:template match="dao-extends" mode="declare-extra-implements">
		<interface><xsl:value-of select="dao-interface/name"/></interface>
	</xsl:template>

	<!-- CLASS BODY ................................................................................................. -->

	<xsl:template match="dao-extends" mode="class-body">
<xsl:text>//@non-generated-start[class]&#13;</xsl:text>
<xsl:value-of select="non-generated/bloc[@id='class']"/>
<xsl:text>//@non-generated-end&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
