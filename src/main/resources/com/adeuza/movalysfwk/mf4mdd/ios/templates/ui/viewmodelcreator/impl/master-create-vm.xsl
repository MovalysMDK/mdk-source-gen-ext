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

<!-- 
Create method for screen viewmodel : have a parent viewmodel parameter
 -->
<xsl:template match="screen/viewmodel[type/name='MASTER' and not(../workspace='true') and not(../multi-panel='true')]" mode="create-vm">
- (<xsl:value-of select="implements/interface/@name"/>*) create<xsl:value-of select="implements/interface/@name"/>:(id&lt;MFFormViewControllerProtocol&gt;)formController {
	<xsl:value-of select="implements/interface/@name"/> *r_oMasterViewModel = [self createVM:@"<xsl:value-of select="implements/interface/@name"/><xsl:text>"];&#13;</xsl:text>
    <xsl:text>r_oMasterViewModel.form = formController;&#13;</xsl:text>
    
    <xsl:for-each select="../pages/page/viewmodel">
    	<!-- create viewmodel for the panel -->
    	<xsl:text>r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/>
    	<xsl:text> = [self createVM:@"</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>"];&#13;</xsl:text>
    	<!-- set parent viewmodel on it -->
		<xsl:text>r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/><xsl:text>.parentViewModel = r_oMasterViewModel;&#13;</xsl:text>
		<xsl:text>r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/>.parentViewModelPrefix = @"<xsl:value-of select="property-name"/>";
    </xsl:for-each>
    
    <xsl:for-each select="../pages/page/viewmodel[entity-to-update]">
    	<xsl:text>[r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/><xsl:text> updateFromIdentifiable:nil];&#13;</xsl:text>
    </xsl:for-each>
    
    [r_oMasterViewModel resetChanged];
    <xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
}
</xsl:template>

<!-- 
Prevent create method for workspace
 -->
<xsl:template match="screen/viewmodel[type/name='MASTER' and ../workspace='true' and ../multi-panel='true']" mode="create-vm">
</xsl:template>


<!-- 
Create method for page viewmodel (without screen/viewmodel) : have a form parameter
 -->
<xsl:template match="viewmodel[(not(ancestor::screen[viewmodel]) and type/name='MASTER') or ((ancestor::screen[workspace='true'] or  ancestor::screen[multi-panel='true']) and type/name='MASTER')]" mode="create-vm">
- (<xsl:value-of select="implements/interface/@name"/>*) create<xsl:value-of select="implements/interface/@name"/>:(id&lt;MFFormViewControllerProtocol&gt;)formController {
	<xsl:value-of select="implements/interface/@name"/> *r_oMasterViewModel = [self createVM:@"<xsl:value-of select="implements/interface/@name"/>"];
 
	 <xsl:choose>
		 <xsl:when test="ancestor::screen[viewmodel and stereotypes/stereotype[@name = 'Mm_iOS_singleController']]">
		     <xsl:for-each select="../pages/page/viewmodel">
		    	<!-- create viewmodel for the panel -->
		    	<xsl:text>r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/>
		    	<xsl:text> = [self createVM:@"</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>"];&#13;</xsl:text>
		    	<!-- set parent viewmodel on it -->
				<xsl:text>r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/><xsl:text>.parentViewModel = r_oMasterViewModel;&#13;</xsl:text>
				<xsl:text>r_oMasterViewModel.</xsl:text><xsl:value-of select="property-name"/>.parentViewModelPrefix = @"<xsl:value-of select="property-name"/>";
		    </xsl:for-each>
		 </xsl:when>
		 <xsl:otherwise>
		 <xsl:if test="parent-viewmodel/master-interface">
		 		<xsl:value-of select="parent-viewmodel/master-interface/@name"/><xsl:text> *r_oParentViewModel</xsl:text>
		    	<xsl:text> = [[MFBeanLoader getInstance] getBeanWithKey:@"</xsl:text><xsl:value-of select="parent-viewmodel/master-interface/@name"/><xsl:text>"];&#13;</xsl:text>
		    	<!-- set parent viewmodel on it -->
				<xsl:text>r_oMasterViewModel.parentViewModel = r_oParentViewModel;&#13;</xsl:text>
				<xsl:text>r_oMasterViewModel.parentViewModelPrefix = @"</xsl:text><xsl:value-of select="property-name"/>";
		 </xsl:if>
		 </xsl:otherwise>
	</xsl:choose>
    
    <xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-content-create"/>
    <xsl:text>r_oMasterViewModel.form = formController;&#13;</xsl:text>
    <xsl:if test="entity-to-update">
    	<xsl:text>[r_oMasterViewModel updateFromIdentifiable:nil];&#13;</xsl:text>
    </xsl:if>
    <xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
}

</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="create-vm">
- (<xsl:value-of select="type/item"/>*) create<xsl:value-of select="type/item"/>:(id&lt;MFFormViewControllerProtocol&gt;)formController {
	<xsl:value-of select="type/item"/> *r_oMasterViewModel = [self createVM:@"<xsl:value-of select="type/item"/>"];
    
    <xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-content-create"/>
    <xsl:text>r_oMasterViewModel.form = formController;&#13;</xsl:text>
    <xsl:if test="entity-to-update">
    	<xsl:text>[r_oMasterViewModel updateFromIdentifiable:nil];&#13;</xsl:text>
    </xsl:if>
    <xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
}
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-content-create">
    <xsl:text>r_oMasterViewModel.lst</xsl:text>
    <xsl:value-of select="name"/>
    <xsl:text>= [[MFBeanLoader getInstance] getBeanWithKey: @"</xsl:text>
    <xsl:value-of select="name"/>
    <xsl:text>"];&#13;</xsl:text>
</xsl:template>  
    
<!-- 
Create method for page viewmodel (with screen/viewmodel)
 -->
<xsl:template match="page/viewmodel[ancestor::screen[viewmodel] and type/name='MASTER' and ancestor::screen[workspace='false'] and ancestor::screen[multi-panel='false']]" mode="create-vm">
	<!-- normal: no createVm for viewmodel having a parent viewmodel -->
/**
 * <xsl:value-of select="ancestor::screen/workspace"/>
 * <xsl:value-of select="type/name"/>
 */
</xsl:template>

</xsl:stylesheet>