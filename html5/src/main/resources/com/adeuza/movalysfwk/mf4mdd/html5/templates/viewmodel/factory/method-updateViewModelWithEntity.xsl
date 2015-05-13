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

	<xsl:template match="*" mode="update-viewmodel-with-entity">
		<xsl:text>&#10;/**&#10;</xsl:text>
		<xsl:text> * Update the viewmodel </xsl:text><xsl:value-of select="name"/><xsl:text>with the data of its corresponding entity&#10;</xsl:text>
		<xsl:text> */&#10;</xsl:text>
		<xsl:value-of select="nameFactory"/>
		<xsl:text>.prototype.updateViewModelWithEntity = function(viewModel, entity) {&#10;</xsl:text>
        
        <xsl:if test="count(mapping/attribute) > 0 or count(external-lists/external-list) > 0">
			<xsl:text>MFMappingHelper.convertLeftIntoRight(entity,</xsl:text><xsl:value-of select="nameFactory"/><xsl:text>.mapping, null, viewModel);&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="is-screen-viewmodel='false'">
        	<xsl:apply-templates select="."  mode="mapping-to-vmlist"/>
        </xsl:if>

        <xsl:text>};&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="mapping-to-vmlist">
	       	
	    <xsl:for-each select="mapping/entity[@mapping-type = 'vmlist' and getter]">
	       	<xsl:call-template name="setViewModelListWithEntities">
	       		<xsl:with-param name="vmList">viewModel.<xsl:value-of select="@vm-attr"/></xsl:with-param>
	       		<xsl:with-param name="entityList">entity.<xsl:value-of select="getter/@name"/></xsl:with-param>
	       		<xsl:with-param name="vmFactory"><xsl:value-of select="@vm-type-factory"/></xsl:with-param>
	       	</xsl:call-template>
       	</xsl:for-each>
       	
	</xsl:template>
	
	<xsl:template match="viewmodel[type/name = 'LIST_1' or type/name = 'LIST_2' or type/name = 'LIST_3']" mode="mapping-to-vmlist">
	       	
       	<xsl:call-template name="setViewModelListWithEntities">
       		<xsl:with-param name="vmList">viewModel.list</xsl:with-param>
       		<xsl:with-param name="entityList">entity</xsl:with-param>
       		<xsl:with-param name="vmFactory"><xsl:value-of select="subvm/viewmodel/factory-name"/></xsl:with-param>
       	</xsl:call-template>
       	
	</xsl:template>
	
	
	<xsl:template name="setViewModelListWithEntities">
		<xsl:param name="vmList"/>
		<xsl:param name="entityList"/>
		<xsl:param name="vmFactory"/>
	
		<xsl:text>this.setViewModelListWithEntities(</xsl:text>
       	<xsl:value-of select="$vmList"/>
       	<xsl:text>, </xsl:text><xsl:value-of select="$entityList"/><xsl:text>, </xsl:text>
       	<xsl:value-of select="$vmFactory"/>
       	<xsl:text>);&#10;</xsl:text>
	</xsl:template>

</xsl:stylesheet>