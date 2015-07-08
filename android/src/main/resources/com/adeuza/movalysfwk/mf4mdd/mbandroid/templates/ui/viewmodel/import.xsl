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

	<xsl:template match="viewmodel" mode="declare-extra-imports">
		<xsl:variable name="workspace" select="boolean(./workspace-vm='true')"/>
		<xsl:variable name="rootVmIsList" select="boolean(string-length(./type/list)>0)"/>
		<xsl:variable name="subVmIsList" select="boolean(string-length(./subvm/viewmodel/type/list)>0)"/>

		<import>java.util.Set</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.DataLoaderParts</import>

		<xsl:if test="subvm/viewmodel/multiInstance='true'">
			<import>import java.util.HashMap</import>
			<import>import java.util.Map</import>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="customizable='true'">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractCustomizableViewModel</import>
			</xsl:when>
			<xsl:when test="not(entity-to-update)">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractViewModel</import>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractItemViewModelId</import>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractItemViewModelIdentifier</import>
			</xsl:when>
			<xsl:otherwise>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractItemViewModel</import>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="subvm/viewmodel/import" mode="declare-import"/>
		<xsl:apply-templates select=".//external-lists/external-list/viewmodel/import[1]" mode="declare-import"/>

		<xsl:if test="mapping/entity">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>

			<xsl:if test="mapping//entity[@mapping-type='vmlist']">
				<import>java.util.ArrayList</import>
				<import>java.util.List</import>
				<import>java.util.Map</import>
				<import>java.util.TreeMap</import>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.listener.FixedListViewModel</import>
			</xsl:if>

			<xsl:if test="mapping//entity[@mapping-type='vm' or @mapping-type='vmlist']">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.ExtBeanType</import>
				<import><xsl:value-of select="master-package"/>.viewmodel.ViewModelCreator</import>
			</xsl:if>
		</xsl:if>

		<xsl:if test="dataloader-impl">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.ExtBeanType</import>
			<import><xsl:value-of select="master-package"/>.viewmodel.ViewModelCreator</import>
		</xsl:if>

		<xsl:if test="count(subvm/viewmodel[type/name='FIXED_LIST']|external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']) &gt; 0">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModelImpl</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.clonable.NonClonableViewModel</import>
		</xsl:if>

		<xsl:if test="$rootVmIsList or $subVmIsList">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModelImpl</import>
		</xsl:if>

		<xsl:if test="$workspace">
			<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.MIdentifiable</import>
		</xsl:if>
		
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.listener.ListenerOnFieldModified</import>
		
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2']" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModelImpl</import>
		<xsl:apply-templates select="subvm/viewmodel/import" mode="declare-import"/>
		<xsl:apply-templates select=".//external-lists/external-list/viewmodel/import[1]" mode="declare-import"/>
		<xsl:if test="dataloader-impl">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.ExtBeanType</import>
			<import><xsl:value-of select="master-package"/>.viewmodel.ViewModelCreator</import>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
