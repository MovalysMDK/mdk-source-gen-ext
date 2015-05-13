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

	<xsl:output method="text" />

	<xsl:template match="page" mode="attributes-import">
		<xsl:apply-templates select="adapter/full-name" mode="declare-import">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="mastercomponenttypeFull[../adapter]" mode="declare-import">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>

		<xsl:if test="external-adapters/adapter[short-adapter='AbstractConfigurableSpinnerAdapter' and viewmodel/type/component-name='MMSpinner']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.abstractviews.MMSpinnerAdapterHolder</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
			<xsl:apply-templates select="external-adapters/adapter/viewmodel/entity-to-update/full-name" mode="declare-import"/>
			<xsl:apply-templates select="external-adapters/adapter/viewmodel/implements/interface/@full-name" mode="declare-import"/>
		</xsl:if>

		<xsl:if test="external-adapters/adapter[short-adapter='AbstractConfigurableSpinnerAdapter' and viewmodel/type/component-name='MMSearchSpinner']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.abstractviews.MMSpinnerAdapterHolder</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSearchSpinner</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
			<xsl:apply-templates select="external-adapters/adapter/viewmodel/entity-to-update/full-name" mode="declare-import"/>
			<xsl:apply-templates select="external-adapters/adapter/viewmodel/implements/interface/@full-name" mode="declare-import"/>
		</xsl:if>

		<xsl:if test="viewmodel/subvm/viewmodel[type/component-name='MMFixedListView']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMAdaptableFixedListView</import>
		</xsl:if>
		<xsl:if test="viewmodel/subvm/viewmodel[type/component-name='MMPhotoFixedListView']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMAdaptableFixedListView</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPhotoFixedListView</import>
		</xsl:if>

		<xsl:if test="viewmodel/multiInstance='true'">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericLoadDataForDisplayDetailAction</import>
			<import><xsl:value-of select="viewmodel/parent-viewmodel/master-interface/@full-name"/></import>
			<import><xsl:value-of select="master-package"/>.viewmodel.ViewModelCreator</import>
		</xsl:if>

	</xsl:template>

	<xsl:template match="page" mode="methods-import">
		<!-- <import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import> -->

		<import>java.util.List</import>
		<import>android.view.ViewGroup</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity</import>
		<import><xsl:value-of select="master-package" />.R</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReload</import>
		
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnActionSuccess</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericUpdateVMForDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnActionSuccessEvent</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.InUpdateVMParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.OutUpdateVMParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReloadEvent</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.AbstractConfigurableListAdapter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity</import>
		<!-- <import><xsl:value-of select="master-package" />.viewmodel.ViewModelCreator</import> -->



		<xsl:apply-templates select="events/event" mode="declare-import">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
		
<!-- 
		<import><xsl:value-of select="screen-vm-interface-fullname"/></import>

		<xsl:apply-templates select="viewmodel/full-name" mode="declare-import">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="viewmodel-interface/full-name" mode="declare-import">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
-->
		 
		<xsl:copy-of select="import"/>
		<!-- <xsl:copy-of select="pages/page/import"/> -->

		 <xsl:if test="actions/action[action-type='SAVEDETAIL']">
			<!-- import>android.app.Activity</import>
			<import>android.content.Intent</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnActionSuccess</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnActionSuccessEvent</import-->
			<xsl:apply-templates select="actions/action[action-type='SAVEDETAIL']/class/implements/interface/@full-name" mode="declare-import">
				<xsl:with-param name="debug"></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if> 

		<!-- <xsl:if test="viewmodel/read-only='false'">
			<import>android.content.DialogInterface</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.application.AndroidApplication</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.application.AndroidApplicationR</import>
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.dialog.MMCustomDialogFragment</import>
			<xsl:apply-templates select="pages/page/viewmodel/full-name" mode="generate-import"/>
		</xsl:if> -->
		
		<!-- <xsl:if test="pages/page[@pos='1']/adapter/viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']
						and pages/page[@pos='1']/navigations/navigation[@name = 'navigationdetail']">
			<import>android.content.Intent</import>
			<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.listener.ListenerOnBusinessNotification</import>
		</xsl:if> -->


		<xsl:apply-templates select="page" mode="doFillAction-imports">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="page" mode="doOnReload-imports">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>

		<xsl:if test="count(menus/menu)>0">
			<import>android.view.Menu</import>
			<import>android.view.MenuInflater</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnMenuItemClick</import>
		</xsl:if>

		<xsl:if test="in-workspace='true' and count(menus/menu)>0">
			<import>android.os.Bundle</import>
		</xsl:if>


		<xsl:apply-templates select="." mode="extra-methods-imports">
		<xsl:with-param name="debug"></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="page" mode="extra-methods-imports"/>

	<xsl:template match="event" mode="declare-import">
	<xsl:param name="debug"></xsl:param>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.listener.ListenerOnBusinessNotification</import>
		<xsl:apply-templates select="action/@full-name" mode="declare-import">
		<xsl:with-param name="debug"><xsl:value-of select="$debug"></xsl:value-of></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="entity/@full-name" mode="declare-import">
		<xsl:with-param name="debug"><xsl:value-of select="$debug"></xsl:value-of></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
