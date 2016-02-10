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

	<!-- Screen imports -->
	<xsl:template match="action" mode="declare-extra-imports">
		<xsl:apply-templates select="." mode="generate-imports"/>
		<xsl:apply-templates select="." mode="declare-constructors-imports"/>
		<xsl:apply-templates select="." mode="declare-method-imports"/>
		<xsl:apply-templates select="events[event]" mode="declare-imports"/>
	</xsl:template>

	<!-- Imports for SAVEDETAIL and DELETEDETAIL and CREATE -->
	<xsl:template match="action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL' or action-type='CREATE']" mode="generate-imports">
		<import>java.util.TreeMap</import>
		<import>java.util.Map</import>

		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.CascadeSet</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<xsl:if test="class/transient='false'">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoException</import>
		</xsl:if>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.messages.ExtFwkErrors</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.messages.MessageLevel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ExpandableViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.ActionException</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.DataloaderException</import>		
		<xsl:apply-templates select="import" mode="declare-import"/>
		<xsl:apply-templates select="creator-name" mode="declare-import"/>
		<xsl:apply-templates select="dao-interface/full-name" mode="declare-import"/>
		<xsl:apply-templates select="dao-interface/import" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel/cascades/import-cascade" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel//cascades/import-cascade" mode="declare-import"/>
		<xsl:apply-templates select="class/implements/interface/@full-name" mode="declare-import"/>

		<xsl:apply-templates select="linked-view-models//viewmodel/full-name|linked-view-models//viewmodel/implements/interface/@full-name"  mode="declare-import"/>

		<xsl:apply-templates select="." mode="generate-specific-imports"/>
	</xsl:template>

	<xsl:template match="action[action-type='CREATE']" mode="generate-specific-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericcreate.GenericCreateActionImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>

		<xsl:apply-templates select="class/pojo-factory-interface/import"  mode="generate-import"/>
		<xsl:for-each select="class/association[@type ='many-to-one' and @relation-owner='true' and @transient='false' and @optional='false']">
			<xsl:apply-templates select="dao-interface/full-name|interface/full-name" mode="declare-import"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="action[action-type='DELETEDETAIL']" mode="generate-specific-imports">
		<import>java.util.ArrayList</import>
		<import>java.util.Collection</import>
		<xsl:choose>
			<xsl:when test="class/transient='false'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdelete.AbstractPersistentDeleteActionImpl</import>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.MObjectToSynchronizeDao</import>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.MObjectToSynchronizeField</import>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.SqlType</import>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlDelete</import>
			</xsl:when>
			<xsl:otherwise>
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdelete.AbstractDeleteActionImpl</import>
			</xsl:otherwise>
		</xsl:choose>

		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.factory.MObjectToSynchronizeFactory</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.model.MObjectToSynchronize</import>
	</xsl:template>
	
	<xsl:template match="action[action-type='SAVEDETAIL']" mode="generate-specific-imports">
		<import>java.util.ArrayList</import>
		<import>java.util.Collection</import>
		<xsl:choose>
			<xsl:when test="class/transient='false'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.AbstractPersistentSaveDetailActionImpl</import>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.MObjectToSynchronizeDao</import>
			</xsl:when>
			<xsl:otherwise>
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.AbstractSaveDetailActionImpl</import>
			</xsl:otherwise>
		</xsl:choose>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.Action</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.factory.MObjectToSynchronizeFactory</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.model.MObjectToSynchronize</import>

		<import><xsl:value-of select="class/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="class/pojo-factory-interface/import"/></import>
	</xsl:template>
	
	<!-- Imports for COMPUTE -->
	<xsl:template match="action[action-type='COMPUTE']" mode="generate-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.generic.GenericActionImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.generic.InParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<xsl:apply-templates select="import" mode="declare-import"/>
		<xsl:apply-templates select="creator-name" mode="declare-import"/>
		<xsl:apply-templates select="dao-interface/full-name" mode="declare-import"/>
		<xsl:apply-templates select="class/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="class/pojo-factory-interface/import" mode="declare-import"/>
		<xsl:apply-templates select="external-daos/dao-interface/full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel//cascades/import-cascade" mode="declare-import"/>
	</xsl:template>
	
	<!-- Imports for DIALOG -->
	<xsl:template match="action[action-type='DIALOG']" mode="generate-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMDialogFragment</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericDisplayDialogImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
		<xsl:apply-templates select="import" mode="declare-import"/>
		<xsl:apply-templates select="creator-name" mode="declare-import"/>
		<xsl:apply-templates select="dao-interface/full-name" mode="declare-import"/>
		<xsl:apply-templates select="class/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="class/pojo-factory-interface/import" mode="declare-import"/>
		<xsl:apply-templates select="external-daos/dao-interface/full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="viewmodel//cascades/import-cascade" mode="declare-import"/>
	</xsl:template>

	<xsl:template match="action[action-type='SAVEDETAIL']" mode="declare-method-imports">
		<import><xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@full-name"/></import>
	</xsl:template>

	<xsl:template match="action[action-type='DELETEDETAIL']" mode="declare-method-imports">
		<import><xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@full-name"/></import>
	</xsl:template>

	<xsl:template match="action" mode="declare-method-imports"/>

	<xsl:template match="events" mode="declare-imports">
	<xsl:param name="debug"></xsl:param>
		<xsl:if test="count(event)>1">
			<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.BusinessEvent</import>
		</xsl:if>
		<xsl:apply-templates select="event/action/@full-name" mode="declare-import">
		<xsl:with-param name="debug"><xsl:value-of select="$debug"/></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
