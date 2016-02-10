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

/** 
 * <p>Update a view model<xsl:if test="entity-to-update"> using a <em><xsl:value-of select="entity-to-update/name"/></em></xsl:if>.</p>
 * <xsl:if test="entity-to-update">@param data An instance of <em><xsl:value-of select="entity-to-update/name"/></em>.</xsl:if>
 * @return The view model representation<xsl:if test="entity-to-update"> of an <em><xsl:value-of select="entity-to-update/name"/></em> instance</xsl:if>.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) update<xsl:value-of select="implements/interface/@name"/>
	<xsl:if test="entity-to-update">
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> *)data</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list"/>
	<xsl:text> ;&#13;</xsl:text>
	<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
</xsl:template>


<!-- 
Update method for viewmodel : data parameter
 -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vm">

/** 
 * <p>Update a view model<xsl:if test="entity-to-update"> using a <em><xsl:value-of select="entity-to-update/name"/></em></xsl:if>.</p>
 * <xsl:if test="entity-to-update">@param data An instance of <em><xsl:value-of select="entity-to-update/name"/></em>.</xsl:if>
 * @return The view model representation<xsl:if test="entity-to-update"> of an <em><xsl:value-of select="entity-to-update/name"/></em> instance</xsl:if>.
 */
- (<xsl:value-of select="type/item"/>*) update<xsl:value-of select="type/item"/>
	<xsl:if test="entity-to-update">
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> *)data</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list"/>
	<xsl:text> ;&#13;</xsl:text>
	<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
</xsl:template>


<!-- For pickerlist in fixedList -->
<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="update-vm">

 <xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">

<!-- /** TEMPLATE3 -->
<!-- * <p>Update a view model<xsl:if test="../../entity-to-update"> using a <em><xsl:value-of select="../../entity-to-update/name"/></em></xsl:if>.</p> -->
<!-- * <xsl:if test="../../entity-to-update">@param data An instance of <em><xsl:value-of select="../../entity-to-update/name"/></em>.</xsl:if> -->
<!-- * @return The view model representation<xsl:if test="../../entity-to-update"> of an <em><xsl:value-of select="../../entity-to-update/name"/></em> instance</xsl:if>. -->
<!--  */ -->
  
<!-- - (<xsl:value-of select="../../name"/>*) update<xsl:value-of select="../../name"/> -->
<!-- <xsl:if test="../../entity-to-update"> -->
<!-- 	<xsl:text>:(</xsl:text> -->
<!-- 	<xsl:value-of select="../../entity-to-update/name"/> -->
<!-- 	<xsl:text> *)data</xsl:text> -->
<!-- </xsl:if> -->
<!-- <xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list"/> -->
<!-- <xsl:text> ;&#13;</xsl:text> -->
<!-- <xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/> -->

/** 
* <p>Update a view model<xsl:if test="./external-lists/external-list/viewmodel/type/item"> using a <em><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/></em></xsl:if>.</p>
* <xsl:if test="./external-lists/external-list/viewmodel/type/item">@param data An instance of <em><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/></em>.</xsl:if>
* @return The view model representation<xsl:if test="./external-lists/external-list/viewmodel/type/item"> of an <em><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/></em> instance</xsl:if>.
 */
 
- (<xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/> *) update<xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/>
<xsl:text>:(</xsl:text>
<xsl:value-of select="./external-lists/external-list/viewmodel/entity-to-update/name"/>
<xsl:text> *)data;&#13;</xsl:text>

</xsl:if>
</xsl:template>



<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist">
	<xsl:text> withLst</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text>:[o</xsl:text>
	<xsl:value-of select="../../../dataloader-impl/name"/>
	<xsl:text> getList</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>:context]</xsl:text>
</xsl:template>

<!-- 
add list to the updater of the page  viewmodel (if pickerList)
 -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list">
	 <xsl:text> withLst</xsl:text>
	 <xsl:value-of select="entity-to-update/name"/>
	 <xsl:text>:(NSArray*)p_oLst</xsl:text>
	 <xsl:value-of select="uml-name"/>
</xsl:template>


<xsl:template match="viewmodel[dataloader-impl and type/name ='MASTER']" mode="update-vm-using-loader">

	/**
	 * <p>@brief Retreive a view model into the cache. Here, there isn't creation or update.</p>
	 * 
	 * @param dataLoader dataLoader
	 * 
	 * @return The view model representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.
	 */
	<xsl:text>- (</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>*) update</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>WithDataLoader:(</xsl:text>
	<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
	<xsl:text>*)dataLoader inContext:(id&lt;MFContextProtocol&gt;)context;&#13;</xsl:text>

</xsl:template>

</xsl:stylesheet>