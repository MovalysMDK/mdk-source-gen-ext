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
Update method for viewmodel : data parameter
 -->
<xsl:template match="viewmodel[type/name='MASTER']" mode="update-vm">
- (<xsl:value-of select="implements/interface/@name"/>*) update<xsl:value-of select="implements/interface/@name"/>

	<xsl:if test="entity-to-update">
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> *)data</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration"/>
	<xsl:text> { &#13;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> *r_oMasterViewModel = [self createVM:@"</xsl:text>
	<xsl:value-of select="implements/interface/@name"/><xsl:text>"];&#13;</xsl:text>
	
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-content-update"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-to-content-update"/>
	
	<xsl:if test="entity-to-update">
		<xsl:text>[r_oMasterViewModel updateFromIdentifiable:data];&#13;</xsl:text>
	</xsl:if>

<xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
<xsl:text>}&#13;</xsl:text>

<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>

</xsl:template>


<!-- For pickerlist in fixedList -->
<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="update-vm">

 <xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']"> 
<!-- - (<xsl:value-of select="../../name"/>*) update<xsl:value-of select="../../name"/> -->
	
	
<!-- 	<xsl:if test="../../entity-to-update"> -->
<!-- 		<xsl:text>:(</xsl:text> -->
<!-- 		<xsl:value-of select="../../entity-to-update/name"/> -->
<!-- 		<xsl:text> *)data</xsl:text>		 -->
<!-- 	</xsl:if>	 -->
<!-- 	<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration"/> -->

<!-- 	<xsl:text> &#13;{&#13;</xsl:text> -->
<!-- 	<xsl:value-of select="../../name"/> -->
<!-- 	<xsl:text>*r_oMasterViewModel = [self createVM:@"</xsl:text> -->
<!-- 	<xsl:value-of select="../../name"/> -->
<!-- 	<xsl:text>"];&#13;</xsl:text> -->
<!-- 	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="update-main-vm-for-pickerlist-in-fixedlist"/> -->
<!-- 	<xsl:text>&#13; return r_oMasterViewModel;&#13;}&#13;&#13;</xsl:text> -->
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="update-item-vm-for-pickerlist-in-fixedlist"/>

	<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
</xsl:if>
</xsl:template>



<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-main-vm-for-pickerlist-in-fixedlist">
	<xsl:value-of select="name"/>
	<xsl:text> *list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text> = [[MFBeanLoader getInstance] getBeanWithKey:@"</xsl:text>
	<xsl:value-of select="name"/>
	<xsl:text>"];&#13;&#13; if (p_oLst</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text> != nil) {&#13;for (</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> *o</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> in p_oLst</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>) {&#13;[list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>.viewModels addObject:[self update</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text>:o</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> ]];&#13;}&#13;}&#13;r_oMasterViewModel.lst</xsl:text>
	<xsl:value-of select="name"/>
	<xsl:text> = list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>;&#13;[r_oMasterViewModel updateFromIdentifiable:data];&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="update-main-vm-for-pickerlist-in-fixedlist">
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-item-vm-for-pickerlist-in-fixedlist">
- (<xsl:value-of select="type/item"/> *) update<xsl:value-of select="type/item"/>
	
	
	<xsl:text>:(</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> *)data&#13;{</xsl:text>
	
    <xsl:value-of select="type/item"/>
    <xsl:text> *r_oMasterViewModel = [self createVM:@"</xsl:text>
    <xsl:value-of select="type/item"/>
    <xsl:text>"];&#13;[r_oMasterViewModel updateFromIdentifiable:data];&#13;return r_oMasterViewModel;&#13;}&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="update-item-vm-for-pickerlist-in-fixedlist">
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vm">
- (<xsl:value-of select="type/item"/>*) update<xsl:value-of select="type/item"/>
	<xsl:if test="entity-to-update">
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> *)data</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration"/>
	<xsl:text> { &#13;</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text> *r_oMasterViewModel = [self createVM:@"</xsl:text>
	<xsl:value-of select="type/item"/><xsl:text>"];&#13;</xsl:text>
	
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-content-update"/>
	
	<xsl:if test="entity-to-update">
		<xsl:text>[r_oMasterViewModel updateFromIdentifiable:data];&#13;</xsl:text>
	</xsl:if>

<xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
<xsl:text>}&#13;</xsl:text>

<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>

</xsl:template>


<!-- 
add list to the updater of the page  viewmodel (if pickerList)
 -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-declaration">
	 <xsl:text> withLst</xsl:text>
	 <xsl:value-of select="entity-to-update/name"/>
	 <xsl:text>:(NSArray*)p_oLst</xsl:text>
	 <xsl:value-of select="uml-name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-content-update">
    <xsl:value-of select="name"/>
    <xsl:text> *list</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text> = [[MFBeanLoader getInstance] getBeanWithKey:@"</xsl:text>
    <xsl:value-of select="name"/>
    <xsl:text>"];&#13;</xsl:text>
    <xsl:text>[list</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text> clear]; &#13; &#13;</xsl:text>
    <xsl:text>if (p_oLst</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text> != nil) {&#13;for (</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
    <xsl:text> *o</xsl:text>
    <xsl:value-of select="entity-to-update/name"/>
    <xsl:text> in p_oLst</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text>) {&#13;[list</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text>.viewModels addObject:[self update</xsl:text>
    <xsl:value-of select="type/item"/>
	<xsl:text>:o</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> ]];&#13;}&#13;}&#13;r_oMasterViewModel.lst</xsl:text>
	<xsl:value-of select="name"/>
	<xsl:text> = list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>;&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="viewmodel[dataloader-impl and type/name ='MASTER']" mode="update-vm-using-loader">
<xsl:text>- (</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>*) update</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>WithDataLoader:(</xsl:text>
	<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
	<xsl:text>*)dataLoader inContext:(id&lt;MFContextProtocol&gt;)context </xsl:text>
	<xsl:text>{&#13;</xsl:text>
	
	<xsl:text>return [self update</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>:[dataLoader getLoadedData:context]</xsl:text>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-call"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-to-call"/>
	<xsl:apply-templates select=".//external-list" mode="generate-parameter-loader"/>
	<xsl:text>];&#13;</xsl:text>
	
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-call">
	 <xsl:text> withLst</xsl:text>
	 <xsl:value-of select="entity-to-update/name"/>
	 <xsl:text>:[dataLoader getList</xsl:text>
	 <xsl:value-of select="uml-name"/>
	 <xsl:text>:context</xsl:text>
	 <xsl:text>]</xsl:text>
</xsl:template>

</xsl:stylesheet>