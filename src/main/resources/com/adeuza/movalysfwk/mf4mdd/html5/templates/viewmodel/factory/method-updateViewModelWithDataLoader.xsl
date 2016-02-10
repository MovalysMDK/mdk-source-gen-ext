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
		
	<xsl:template match="viewmodel[dataloader-impl]" mode="update-viewmodel-with-dataloader">
	
		<xsl:text>&#10;/**&#10;</xsl:text>
		<xsl:text> * Update the viewmodel </xsl:text><xsl:value-of select="name"/><xsl:text>with the data of its corresponding dataloader&#10;</xsl:text>
		<xsl:text> */&#10;</xsl:text>
		
		<xsl:value-of select="nameFactory"/><xsl:text>.prototype.updateViewModelWithDataLoader = function(viewModel, dataLoader) {&#10;</xsl:text>
		<xsl:text>console.log('</xsl:text><xsl:value-of select="nameFactory"/><xsl:text>.updateViewModelWithDataLoader');&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="update-viewmodel-with-dataloader-body"/>
		<xsl:text>};&#10;&#10;&#10;</xsl:text>
		
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="update-viewmodel-with-dataloader">
	</xsl:template>
	
	<xsl:template match="*" mode="update-viewmodel-with-dataloader-body">
	</xsl:template>
	
	<!-- 	Default case, and combobox case -->
	<xsl:template match="viewmodel[entity-to-update and type/is-list = 'false']" mode="update-viewmodel-with-dataloader-body">
		<xsl:text>var entity = dataLoader.dataModel;&#10;</xsl:text>
        <xsl:text>if (angular.isUndefinedOrNull(dataLoader.dataModel)) {&#10;</xsl:text>
        <xsl:text>entity = </xsl:text><xsl:value-of select="entity-to-update/factory-name"/><xsl:text>.createInstance();&#10;</xsl:text>
        <xsl:text>}&#10;</xsl:text>
        <!-- possible values for combo (included those in a fixed list) -->       
        <xsl:apply-templates select="mapping/entity | subvm/viewmodel/mapping/entity" mode="update-viewmodel-with-dataloader-for-combo"/>
        <!-- regular attributes -->
		<xsl:text>this.updateViewModelWithEntity(viewModel, entity);&#10;</xsl:text>
	</xsl:template>
	
	<!-- 	List case -->
	<xsl:template match="viewmodel[type/is-list = 'true' and is-screen-viewmodel='false']" mode="update-viewmodel-with-dataloader-body">
		<xsl:text>var entities = dataLoader.dataModel;&#10;</xsl:text>
        <xsl:text>if (angular.isUndefinedOrNull(dataLoader.dataModel)) {&#10;</xsl:text>
        <xsl:text>entities = [];&#10;</xsl:text>
        <xsl:text>}&#10;</xsl:text>
		<xsl:text>this.updateViewModelWithEntity(viewModel, entities);&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="entity[@mapping-type='vm_comboitemselected']" mode="update-viewmodel-with-dataloader-for-combo">
		<!-- 	TODO : A REVOIR UNE FOIS LE DATALOADER DE GENERE -->
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:text>update-viewmodel-with-dataloader-for-combo-</xsl:text><xsl:value-of select="@vm-attr"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>&#10;this.setViewModelListWithEntities(</xsl:text>
				<xsl:choose>
					<xsl:when test="../../type/name='FIXED_LIST'">
						<xsl:value-of select="../../factory-name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>this</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>.singleton</xsl:text><xsl:value-of select="@vm-type"/><xsl:text>, dataLoader.combo</xsl:text><xsl:value-of select="@type"/><xsl:text>DataModel, </xsl:text><xsl:value-of select="@vm-type-factory"/><xsl:text>);&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*" mode="update-viewmodel-with-dataloader-for-combo">
	</xsl:template>
	
</xsl:stylesheet>