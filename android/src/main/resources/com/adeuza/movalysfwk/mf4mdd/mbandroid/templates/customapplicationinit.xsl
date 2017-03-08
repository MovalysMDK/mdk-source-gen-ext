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
	<xsl:include href="includes/incremental/nongenerated.xsl"/>

	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="/application">
		<xsl:text>package </xsl:text><xsl:value-of select="./domain/rootPackage"/><xsl:text>;&#13;&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-imports"/>
		<xsl:call-template name="genClass"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="application" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.CustomInit</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.CustomApplicationInit</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.RunInit</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.RunInitError</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
	</xsl:template>

	<!-- CLASS ...................................................................................................... -->

	<xsl:template name="genClass">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text>* Does the implementation of custom behavior&#13;</xsl:text>
		<xsl:text>*/&#13;</xsl:text>
		<xsl:text>public class  CustomApplicationInitImpl implements CustomApplicationInit&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">implements</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		<xsl:text>{&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">attributes</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
	
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public CustomInit getCustomInit() {&#13;</xsl:text>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">getCustomInit</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>return BeanLoader.getInstance().getBean(CustomInit.class);&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	
		<xsl:text>	}&#13;&#13;</xsl:text>

		<xsl:call-template name="non-generated-bloc-rename">
			<xsl:with-param name="blocIdOld">methodes</xsl:with-param>
			<xsl:with-param name="blocId">methods</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>	

	<xsl:text>}&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
