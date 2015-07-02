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
	<xsl:include href="ui/menus/screenmenu.xsl"/>
	<xsl:include href="ui/navigation/navigation.xsl"/>
	<xsl:include href="ui/menus/import.xsl"/>
	
	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="screen">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="screen" mode="declare-extra-imports">
		<xsl:call-template name="menuImports"/>

		<import><xsl:value-of select="master-package"/>.R</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity</import>
		<import>java.util.List</import>
		
		<xsl:if test="main = 'true'">
			<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.displaymain.MFRootActivity</import>
		</xsl:if>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	<xsl:template match="screen" mode="superclass">
		<xsl:text>AbstractMMActivity</xsl:text>
	</xsl:template>
	
	<!-- IMPLEMENTS ..................................................................................................... -->

	<xsl:template match="screen[main='true']"  
		mode="declare-extra-implements">
		<interface>MFRootActivity</interface>
	</xsl:template>

	<!-- ATTRIBUTES ................................................................................................. -->

	<xsl:template match="screen" mode="attributes">		
		<xsl:apply-templates select="." mode="requestCodeConstant"/>
	</xsl:template>
	
	<xsl:template match="screen" mode="requestCodeConstant">
		/** 
		 * Result code use with method startActivityForResult.
		 * In support-v7, only the last five digits of the result code are read.
		 * If the result value is greater, an exception will be raised.
		 */
		public static final int <xsl:value-of select="request-code-constant"/> = <xsl:value-of select="name"/>.class.getSimpleName().hashCode() &amp; REQUEST_CODE_MASK;
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="screen" mode="methods">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity#onCreate(android.os.Bundle)
		 */
		@Override
		protected void onCreate(android.os.Bundle p_oSavedInstanceState) {
			super.onCreate(p_oSavedInstanceState);
			this.setContentView(R.layout.<xsl:value-of select="screenname"/>);

			//@non-generated-start[on-create]
			<xsl:value-of select="non-generated/bloc[@id='on-create']"/>
			<xsl:text>//@non-generated-end</xsl:text>
		}

		<!-- options menu -->
		<xsl:apply-templates select="." mode="activityOptionsMenu"/>
	</xsl:template>

	<xsl:template match="non-generated"/>
	<xsl:template match="master-package"/>
</xsl:stylesheet>
