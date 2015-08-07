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
	<xsl:include href="ui/page/common-page-methods.xsl"/>
	<xsl:include href="ui/page/onDataloaderReload.xsl"/>

	<xsl:output method="text"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template match="/">
		<xsl:apply-templates select="page" mode="declare-class"/>
	</xsl:template>
	
	<xsl:template match="page" mode="superclass">
		<xsl:text>AbstractMMTabbedFragment</xsl:text>
	</xsl:template>

	<xsl:template match="page" mode="superclass-import">
		<import>com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractMMTabbedFragment</import>
		<import><xsl:value-of select="master-package"/>.R</import>
	</xsl:template>
	
	<xsl:template match="page" mode="methods-import">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericUpdateVMForDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.InUpdateVMParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailActionParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReload</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReloadEvent</import>
		<xsl:apply-templates select="./tabs/page/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="./tabs/page/viewmodel/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="./viewmodel/implements/interface/@full-name" mode="declare-import"/>
	</xsl:template>

	<xsl:template match="page" mode="methods">
		@Override
		protected int getRealTabContentId() {
			return R.id.realcontent;
		}
	
		@Override
		public int getLayoutId() {
			return R.layout.<xsl:value-of select="layout"/>;
		}
		
		<xsl:apply-templates select="." mode="doFillAction-method"/>
		<xsl:apply-templates select="./tabs/page" mode="doOnReloadTabs-method"/>
	</xsl:template>
	
	<xsl:template match="page[parameters/parameter[@name='workspace-panel-type']='master']" mode="doOnReloadTabs-method">
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		/**
		 * Listener on <xsl:value-of select="$dataloader"/> reload
		 * @param p_oEvent the event sent from the dataloader
		 */
		@ListenerOnDataLoaderReload(<xsl:value-of select="$dataloader"/>.class)
		public void doOnReload<xsl:value-of select="$dataloader"/>(ListenerOnDataLoaderReloadEvent&lt;<xsl:value-of select="$dataloader"/>&gt; p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnReload</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="generate-doOnReload-body">
						<xsl:with-param name="viewmodel" select="/page/viewmodel/implements/interface/@name"/>
						<xsl:with-param name="isVmScreen" select="'true'"/>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="page" mode="doOnReloadTabs-method">
	</xsl:template>

</xsl:stylesheet>
