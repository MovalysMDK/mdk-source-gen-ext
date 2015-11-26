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
	
	<xsl:key name="comboEntity" match="/viewmodel/dataloader-impl/dataloader-interface/combos/combo/entity/text()" use="." />
	
	<xsl:template match="viewmodel[dataloader-impl]" mode="update-dataloader-entity-with-viewmodel">
	
		<xsl:if test="entity-to-update/factory-name">
			<xsl:text>&#10;/**&#10;</xsl:text>
			<xsl:text> * Update the entity with the data of the viewmodel </xsl:text><xsl:value-of select="name"/><xsl:text>&#10;</xsl:text>
			<xsl:text> */&#10;</xsl:text>
			<xsl:value-of select="nameFactory"/>
			<xsl:text>.prototype.updateDataLoaderEntityWithViewModel = function(dataLoader, viewModel ) {&#10;</xsl:text>
	        
	        
<!-- 	        	<xsl:text>dataLoader.dataModel = MFMappingHelper.convertRightIntoLeft(viewModel</xsl:text> -->
<!-- 	        	<xsl:if test="type/name = 'LIST_1' or type/name = 'LIST_2' or type/name = 'LIST_3'"> -->
<!--         			<xsl:text>.list</xsl:text> -->
<!--         		</xsl:if> -->
<!-- 				<xsl:text>, </xsl:text><xsl:value-of select="nameFactory"/><xsl:text>.mapping, MFDataModelCache.modelCache, null);&#10;</xsl:text> -->


	        <xsl:text>if ( angular.isUndefinedOrNull(dataLoader.dataModel)) {&#10;</xsl:text>
	        <xsl:text>    dataLoader.dataModel = </xsl:text>
	        
        	<xsl:choose>
        		<xsl:when test="type/name = 'LIST_1' or type/name = 'LIST_2' or type/name = 'LIST_3'">
        			<xsl:text>[];&#10;</xsl:text>
        		</xsl:when>
        		<xsl:otherwise>
        			<xsl:value-of select="entity-to-update/factory-name"/><xsl:text>.createInstance();&#10;</xsl:text>
        		</xsl:otherwise>
        	</xsl:choose>
	        	
	        <xsl:text>}&#10;</xsl:text>
	        
	        <xsl:text>this.updateEntityWithViewModel(dataLoader.dataModel, </xsl:text>
	        
	      	<xsl:choose>
        		<xsl:when test="type/name = 'LIST_1' or type/name = 'LIST_2' or type/name = 'LIST_3'">
        			<xsl:text>viewModel.list</xsl:text>
        		</xsl:when>
        		<xsl:otherwise>
        			<xsl:text>viewModel</xsl:text>
        		</xsl:otherwise>
        	</xsl:choose>
	        
	        <xsl:text>, MFDataModelCache.modelCache);&#10;</xsl:text>
	        
	        <!-- REATTACH ENTITY FROM DATALOADER FOR COMBO-->
        	<xsl:text>// Re-attach linked entities from data-loader&#10;</xsl:text>
			<xsl:for-each select="mapping/entity[@mapping-type='vm_comboitemselected']">
				<xsl:variable name="comboDataModelName">
					combo<xsl:value-of select="@type"/><xsl:text>DataModel</xsl:text>
				</xsl:variable>
				<xsl:variable name="entityIdToUpdate">
					<xsl:text>viewModel.</xsl:text><xsl:value-of select="@vm-attr"/>.<xsl:text>selectedItemValue</xsl:text>
				</xsl:variable>
				<xsl:text>if (!angular.isUndefinedOrNull(</xsl:text><xsl:value-of select="$entityIdToUpdate"/><xsl:text>)) {&#10;</xsl:text>
				<xsl:text>dataLoader.dataModel.</xsl:text><xsl:value-of select="getter/@name"/><xsl:text> = </xsl:text>
				<xsl:text>$filter('filter')(dataLoader.</xsl:text><xsl:value-of select="$comboDataModelName"/><xsl:text>, {id: </xsl:text><xsl:value-of select="$entityIdToUpdate"/><xsl:text> })[0]; &#10;</xsl:text>
				<xsl:text>}&#10;</xsl:text>
			</xsl:for-each>
	        
	        <xsl:text>};&#10;</xsl:text>
        </xsl:if>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="update-dataloader-entity-with-viewmodel">
	</xsl:template>
	
</xsl:stylesheet>