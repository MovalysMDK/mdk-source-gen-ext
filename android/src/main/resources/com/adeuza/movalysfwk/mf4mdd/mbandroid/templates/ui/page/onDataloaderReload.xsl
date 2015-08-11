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

	<xsl:template match="screen" mode="doOnReload-method">
		<xsl:apply-templates select="pages/page[viewmodel/dataloader-impl and not(viewmodel/multiInstance='true')]" mode="doOnReload-method"/>
	</xsl:template>

	<xsl:template match="dialog|page" mode="doOnReload-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericLoadDataForDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericUpdateVMForDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.InUpdateVMParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReload</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReloadEvent</import>
		<xsl:apply-templates select="./viewmodel/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="./viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
	</xsl:template>
	
	<xsl:template match="dialog|page" mode="doOnReload-method">
		<xsl:param name="launchFrom" select="local-name(.)"/>
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		<xsl:if test="(count(preceding-sibling::page[viewmodel/dataloader-impl/implements/interface/@name=$dataloader]) = 0) and $dataloader">
		/**
		 * Listener on <xsl:value-of select="$dataloader"/> reload
		 * @param p_oEvent the event sent from the dataloader
		 */
		@ListenerOnDataLoaderReload(<xsl:value-of select="$dataloader"/>.class)
		public void doOnReload<xsl:value-of select="$dataloader"/>(ListenerOnDataLoaderReloadEvent&lt;<xsl:value-of select="$dataloader"/>&gt; p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnReload<xsl:value-of select="$dataloader"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="generate-doOnReload-body">
						<xsl:with-param name="launchFrom" select="$launchFrom"/>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
		
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="page|dialog" mode="generate-doOnReload-body">
		<xsl:param name="viewmodel" select="./viewmodel/implements/interface/@name"/>
		<xsl:param name="isVmScreen" select="false"/>
		<xsl:param name="launchFrom" select="local-name(.)"/>
		<xsl:variable name="dataloaderName" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		<xsl:variable name="currentPosition" select="count(preceding-sibling::page[viewmodel/dataloader-impl/implements/interface/@name])"/>
		<xsl:if test="viewmodel/multiInstance='true' and not(local-name(..))">
			<xsl:text>if (this.getTag().equals(p_oEvent.getKey())) {&#13;</xsl:text>
		</xsl:if>
		
		<xsl:if test="../../workspace = 'true' and ../../workspace-type = 'MASTERDETAIL' and ./viewmodel/dataloader-impl/dataloader-interface/type != 'LIST'">
			this.getWlayout().unHideDetailColumns(true);
		</xsl:if>

		<xsl:apply-templates select="." mode="generate-action-parameter">
			<xsl:with-param name="launchFrom" select="$launchFrom"/>
			<xsl:with-param name="currentPosition" select="position()"/>
			<xsl:with-param name="viewmodel" select="$viewmodel"/>
			<xsl:with-param name="isVmScreen" select="$isVmScreen"/>
			
		</xsl:apply-templates>

		<xsl:for-each select="following-sibling::page[viewmodel/dataloader-impl/implements/interface/@name=$dataloaderName]">
			
			<xsl:variable name="siblingNumber" select="count(preceding-sibling::page[viewmodel/dataloader-impl/implements/interface/@name=$dataloaderName])"/>
			<xsl:apply-templates select="." mode="generate-action-parameter">
				<xsl:with-param name="launchFrom" select="$launchFrom"/>
				<xsl:with-param name="siblingNumber" select="$siblingNumber"/>
				<xsl:with-param name="isVmScreen" select="$isVmScreen"/>
				<xsl:with-param name="viewmodel">
					<xsl:choose>
						<xsl:when test="$isVmScreen = 'true'"><xsl:value-of select="$viewmodel"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="./viewmodel/implements/interface/@name"/></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="currentPosition" select="$currentPosition"/>
			</xsl:apply-templates>
		</xsl:for-each>
		<xsl:if test="viewmodel/multiInstance='true' and not(local-name(..))">
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="page|dialog" mode="generate-action-parameter">
		<xsl:param name="launchFrom"/>
		<xsl:param name="siblingNumber"/>
		<xsl:param name="isVmScreen"/>
		<xsl:param name="viewmodel" select="./viewmodel/implements/interface/@name"/>
		<xsl:param name="currentPosition"/>
				
		final InUpdateVMParameter oActionParameter<xsl:value-of select="$siblingNumber"/> = new InUpdateVMParameter();
		oActionParameter<xsl:value-of select="$siblingNumber"/>.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );		
		<xsl:choose>
			<xsl:when test="viewmodel/multiInstance='true' and not(local-name(..))">
				oActionParameter.setVm(this.oVm);
			</xsl:when>
			<xsl:otherwise>
				oActionParameter<xsl:value-of select="$siblingNumber"/>.setVm( <xsl:value-of select="$viewmodel"/>.class );
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not($isVmScreen = 'true')">
			<xsl:apply-templates select="." mode="generate-adapter-registration">
				<xsl:with-param name="siblingNumber" select="$siblingNumber"/>
				<xsl:with-param name="currentPosition" select="$currentPosition"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test="$launchFrom = 'page'">
			<xsl:text>this</xsl:text> 
		</xsl:if>
		<xsl:if test="$launchFrom = 'dialog'">
			<xsl:text>((AbstractMMActivity)this.getOwnerActivity())</xsl:text> 
		</xsl:if>
		<xsl:text>.launchAction(GenericUpdateVMForDisplayDetailAction.class, oActionParameter</xsl:text><xsl:value-of select="$siblingNumber"/><xsl:text>);&#13;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="page|dialog" mode="generate-adapter-registration">
		<xsl:param name="currentPosition"/>
		<xsl:param name="siblingNumber"/>
		<xsl:apply-templates select="adapter" mode="generate-adapter-registration">
			<xsl:with-param name="adapterName">this.mAdapter</xsl:with-param>
			<xsl:with-param name="position" select="$siblingNumber"/>
		</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>
