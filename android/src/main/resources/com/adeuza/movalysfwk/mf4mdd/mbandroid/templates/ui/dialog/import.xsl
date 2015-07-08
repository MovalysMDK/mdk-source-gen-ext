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

	<xsl:template match="dialog" mode="declare-extra-imports">
		<import>java.util.HashMap</import>
		<import>java.util.Map</import>
		<import>android.content.Context</import>
		<import>android.os.Bundle</import>
		<import>android.view.View</import>
		<import>android.view.View.OnClickListener</import>
		<import>android.content.DialogInterface.OnDismissListener</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMDialogFragment</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericLoadDataForDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericUpdateVMForDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.InUpdateVMParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.adapters.MDKBaseAdapter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.adapters.MDKSpinnerAdapter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.adapters.connectors.MDKViewConnectorWrapper</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.component.configurable.WidgetWrapperHelper</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReload</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReloadEvent</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		<import><xsl:value-of select="master-package" />.R</import>
		<xsl:apply-templates select="viewmodel-creator/full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel-interface/import" mode="declare-import"/>
		<xsl:apply-templates select="class/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="adapter/full-name" mode="declare-import"/>
		<xsl:apply-templates select="mastercomponenttypeFull[../adapter]" mode="declare-import"/>
		<xsl:if test="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSpinner</import>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>