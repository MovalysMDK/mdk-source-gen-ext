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

	<xsl:include href="includes/class.xsl"/>
	<xsl:include href="ui/viewmodel/import.xsl"/>
	<xsl:include href="ui/viewmodel/update-from-dataloader.xsl"/>
	

	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="viewmodel">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	<xsl:template match="viewmodel" mode="superclass">
		<xsl:text>ListViewModelImpl&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="subvm/viewmodel/implements/interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<!-- CONSTRUCTOR ................................................................................................. -->
	<xsl:template match="*" mode="constructors">
		/** 
		 * Constructor
		 */
		 public <xsl:value-of select="name"/>() {
		 	super(<xsl:value-of select="subvm/viewmodel/implements/interface/@name"/>.class);
		 }
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="viewmodel" mode="methods">
		<xsl:apply-templates select="self::node()[dataloader-impl]" mode="generate-method-update-from-dataloader"/>
	</xsl:template>
</xsl:stylesheet>
