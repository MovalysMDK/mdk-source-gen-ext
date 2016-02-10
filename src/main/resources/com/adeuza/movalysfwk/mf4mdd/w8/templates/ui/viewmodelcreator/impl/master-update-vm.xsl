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
<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
<xsl:text>public </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> update</xsl:text><xsl:value-of select="implements/interface/@name"/>
<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration-declaration"/>
<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration-declaration"/>
<xsl:text>(</xsl:text>

	<xsl:if test="entity-to-update">
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> data</xsl:text>
	</xsl:if>
	<xsl:if test="external-lists/external-list/viewmodel">
		<xsl:for-each select="./external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-to-declaration-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="subvm/viewmodel/external-lists/external-list/viewmodel">
		<xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-to-declaration-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:text> ){ &#13;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> r_oMasterViewModel = this.CreateVM&lt;</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>&gt;();&#13;</xsl:text>
	
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-content-update"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-to-content-update"/>
	
	<xsl:if test="entity-to-update">
		<xsl:text>r_oMasterViewModel.UpdateFromIdentifiable(data);&#13;</xsl:text>
	</xsl:if>

<xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
<xsl:text>}&#13;</xsl:text>

<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>

</xsl:template>

<!-- For pickerlist in fixedList -->
<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="update-vm">
 <xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']"> 
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="update-item-vm-for-pickerlist-in-fixedlist"/>
	<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
</xsl:if>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-main-vm-for-pickerlist-in-fixedlist">
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>&gt;();&#13;&#13; if (p_oLst</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text> != null) {&#13;foreach (</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> o</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> in p_oLst</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>) {&#13;list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>.ListViewModel.Add(this.update</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text>(o</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> ));&#13;}&#13;}&#13;r_oMasterViewModel.Lst</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> = list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>;&#13; r_oMasterViewModel.UpdateFromIdentifiable(data);&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="update-main-vm-for-pickerlist-in-fixedlist">
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-item-vm-for-pickerlist-in-fixedlist">
<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
<xsl:text>public </xsl:text><xsl:value-of select="type/item"/><xsl:text> update</xsl:text><xsl:value-of select="type/item"/><xsl:text>(</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> data)&#13;{</xsl:text>
	
    <xsl:value-of select="type/item"/>
    <xsl:text> r_oMasterViewModel = this.CreateVM&lt;</xsl:text><xsl:value-of select="type/item"/><xsl:text>&gt;();&#13;</xsl:text>
    <xsl:text>r_oMasterViewModel.UpdateFromIdentifiable(data);&#13;</xsl:text>
    <xsl:text>return r_oMasterViewModel;&#13;}&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="update-item-vm-for-pickerlist-in-fixedlist">
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vm">
<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
<xsl:text>public </xsl:text><xsl:value-of select="type/item"/><xsl:text> update</xsl:text><xsl:value-of select="type/item"/>
<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-declaration-declaration"/>
<xsl:text>(</xsl:text>
	<xsl:if test="entity-to-update">
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> data</xsl:text>
	</xsl:if>
	<xsl:if test="external-lists/external-list/viewmodel">
		<xsl:for-each select="./external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-to-declaration-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:text> ){ &#13;</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text> r_oMasterViewModel = this.CreateVM&lt;</xsl:text><xsl:value-of select="type/item"/><xsl:text>&gt;();&#13;</xsl:text>
	
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-content-update"/>
	
	<xsl:if test="entity-to-update">
		<xsl:text>r_oMasterViewModel.UpdateFromIdentifiable(data);&#13;</xsl:text>
	</xsl:if>

<xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
<xsl:text>}&#13;</xsl:text>

<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>

</xsl:template>


<!-- 
add list to the updater of the page  viewmodel (if pickerList)
 -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-declaration-declaration">
	 <xsl:text>WithLst</xsl:text>
	 <xsl:value-of select="entity-to-update/name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-declaration-parameter">
	 <xsl:text> List&lt;</xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>&gt; p_oLst</xsl:text>
	 <xsl:value-of select="uml-name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-content-update">
    <xsl:value-of select="implements/interface/@name"/>
    <xsl:text> list</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
    <xsl:value-of select="implements/interface/@name"/>
    <xsl:text>&gt;();&#13;</xsl:text>
    <xsl:text>list</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text>.Clear(); &#13; &#13;</xsl:text>
    <xsl:text>if (p_oLst</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text> != null) {&#13;foreach (</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
    <xsl:text> o</xsl:text>
    <xsl:value-of select="entity-to-update/name"/>
    <xsl:text> in p_oLst</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text>) {&#13;list</xsl:text>
    <xsl:value-of select="uml-name"/>
    <xsl:text>.ListViewModel.Add(this.update</xsl:text>
    <xsl:value-of select="type/item"/>
	<xsl:text>(o</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text>));&#13;}&#13;}&#13;r_oMasterViewModel.Lst</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> = list</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>;&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="viewmodel[dataloader-impl and type/name ='MASTER']" mode="update-vm-using-loader">
<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
<xsl:text>public </xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> update</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>WithDataLoaderInContext(</xsl:text>
	<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
	<xsl:text> dataLoader, IMFContext context </xsl:text>
	<xsl:text>){&#13;</xsl:text>
	
	<xsl:text>return this.update</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-to-call-declaration"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-to-call-declaration"/>
	<xsl:text>(dataLoader.GetData()</xsl:text>
	<xsl:if test="external-lists/external-list/viewmodel">
		<xsl:for-each select="./external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-to-call-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="subvm/viewmodel/external-lists/external-list/viewmodel">
		<xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-to-call-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:apply-templates select=".//external-list" mode="generate-parameter-loader"/>
	<xsl:text>);&#13;</xsl:text>
	
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-call-declaration">
	 <xsl:text>WithLst</xsl:text>
	 <xsl:value-of select="entity-to-update/name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-call-parameter">
	 <xsl:text> dataLoader.GetList</xsl:text>
	 <xsl:value-of select="uml-name"/>
	 <xsl:text>()</xsl:text>
</xsl:template>

</xsl:stylesheet>