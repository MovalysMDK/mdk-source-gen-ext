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

	<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>

	<xsl:include href="includes/interface.xsl"/>

	<xsl:template match="pojo-factory-interface">
		<xsl:apply-templates select="." mode="declare-interface"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="pojo-factory-interface" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.Scope</import>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.ScopePolicy</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.EntityFactory</import>

		<xsl:variable name="package" select="concat(package/text(), '.')"/>
		<xsl:copy-of select="//import[string-length(substring-after(text(), $package)) = 0 or contains(substring-after(text(), $package), '.') = 'true']" />
	</xsl:template>

	<!-- ANNOTATIONS ................................................................................................ -->

	<xsl:template match="pojo-factory-interface" mode="class-annotations">
		<xsl:text>@Scope(ScopePolicy.SINGLETON)</xsl:text>
	</xsl:template>

	<!-- SUPERINTERFACES ............................................................................................ -->

	<xsl:template match="pojo-factory-interface" mode="superinterfaces">
		<xsl:text>EntityFactory&lt;</xsl:text>
		<xsl:value-of select="interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="pojo-factory-interface" mode="methods">
		/**
		 * Méthode de création de l'objet d'interface <xsl:value-of select="interface/@name"/> avec l'enregistrement des changements.
		 *
		 * @return <xsl:value-of select="interface/@name"/>
		 */
		@Override
		public <xsl:value-of select="interface/@name"/> createInstance();
	</xsl:template>
</xsl:stylesheet>
