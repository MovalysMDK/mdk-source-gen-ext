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

	<!-- Spinner adapter Imports  -->
	<xsl:template match="adapter[short-adapter='AbstractConfigurableSpinnerAdapter']" mode="generate-imports">
		<import><xsl:value-of select="./viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
	</xsl:template>

	<!-- Flipper adapter Imports -->
	<xsl:template match="adapter[short-adapter='AbstractConfigurableFlipperExpandableListAdapter' or short-adapter='MDKFlipperAdapter']" mode="generate-imports">
		<xsl:call-template name="displayDetailImports"/>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.AbstractBusinessEvent</import>
		<import><xsl:value-of select="./viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
	</xsl:template>

	<!-- ExpandableListAdapter Imports -->
	<xsl:template match="adapter[short-adapter='AbstractConfigurableExpandableListAdapter' or short-adapter='MDKExpandableAdapter']" mode="generate-imports">
		<xsl:call-template name="displayDetailImports"/>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.AbstractBusinessEvent</import>
		<import><xsl:value-of select="./viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
	</xsl:template>

	<!-- ExpandableListAdapter Imports -->
	<xsl:template match="adapter[short-adapter='MultiSelectedExpandableListAdapter']" mode="generate-imports">
		<xsl:call-template name="displayDetailImports"/>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.AbstractBusinessEvent</import>
		<import><xsl:value-of select="./viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
	</xsl:template>

	<!-- List adapter imports -->
	<xsl:template match="adapter[short-adapter='AbstractConfigurableListAdapter' or short-adapter='MDKAdapter']" mode="generate-imports">
		<xsl:call-template name="displayDetailImports"/>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.AbstractBusinessEvent</import>
		<import><xsl:value-of select="./viewmodel/entity-to-update/full-name"/></import>
		<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@full-name"/></import>
	</xsl:template>

	<!--  FixedList adapter imports -->
	<xsl:template match="adapter[short-adapter='AbstractConfigurableFixedListAdapter' or short-adapter='MDKFixedListAdapter']" mode="generate-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
		<import><xsl:value-of select="./viewmodel/import"/></import>
		<import><xsl:value-of select="./viewmodel/import"/>Factory</import>
		<import><xsl:value-of select="./master-package"/>.viewmodel.ViewModelCreator</import>
		<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
	</xsl:template>

	<!--  Display detail imports -->
	<xsl:template name="displayDetailImports">
		<import>android.view.View</import>
		<import>android.view.View.OnClickListener</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>
	</xsl:template>
</xsl:stylesheet>

