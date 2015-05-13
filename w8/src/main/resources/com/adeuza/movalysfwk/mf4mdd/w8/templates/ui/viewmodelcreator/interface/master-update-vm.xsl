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

	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Update a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel </xsl:text><xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:if test="entity-to-update"><xsl:text>/// &lt;param name="data"&gt; An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text></xsl:if>
	<xsl:text>/// &lt;returns&gt;The viewmodel representation</xsl:text><xsl:if test="entity-to-update"><xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance</xsl:text></xsl:if><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/><xsl:text> update</xsl:text><xsl:value-of select="implements/interface/@name"/>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-declaration"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list/viewmodel" mode="add-picker-list-declaration"/>
	<xsl:text>(</xsl:text>
	<xsl:if test="entity-to-update">
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> data</xsl:text>
	</xsl:if>
	<xsl:if test="external-lists/external-list/viewmodel">
		<xsl:for-each select="./external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="subvm/viewmodel/external-lists/external-list/viewmodel">
		<xsl:for-each select="./subvm/viewmodel/external-lists/external-list/viewmodel">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="." mode="add-picker-list-parameter"/>
		</xsl:for-each>
	</xsl:if>
	<xsl:text> );&#13;</xsl:text>
	<xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
</xsl:template>


<!-- 
Update method for viewmodel : data parameter
 -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vm">

	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Update a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel </xsl:text><xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:if test="entity-to-update"><xsl:text>/// &lt;param name="data"&gt; An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text></xsl:if>
	<xsl:text>/// &lt;returns&gt;The viewmodel representation</xsl:text><xsl:if test="entity-to-update"><xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance</xsl:text></xsl:if><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
	<xsl:value-of select="type/item"/><xsl:text> update</xsl:text><xsl:value-of select="type/item"/>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-declaration"/>
	<xsl:text>(</xsl:text>
	<xsl:if test="entity-to-update">
		<xsl:value-of select="entity-to-update/name"/>
		<xsl:text> data</xsl:text>
	</xsl:if>
	<xsl:if test="external-lists/external-list/viewmodel">
		<xsl:text>, </xsl:text>
		<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="add-picker-list-parameter"/>
	</xsl:if>
	<xsl:text> );&#13;</xsl:text>
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
		
		<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Update a viewmodel </xsl:text><xsl:if test="./external-lists/external-list/viewmodel/type/item"><xsl:text> using a </xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/></xsl:if><xsl:text>.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:if test="./external-lists/external-list/viewmodel/type/item"><xsl:text>/// &lt;param name="data"&gt; An instance of </xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text></xsl:if>
		<xsl:text>/// &lt;returns&gt;The viewmodel representation</xsl:text><xsl:if test="./external-lists/external-list/viewmodel/type/item"><xsl:text> of an </xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/><xsl:text> instance</xsl:text></xsl:if><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
		<xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/><xsl:text> update</xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./external-lists/external-list/viewmodel/entity-to-update/name"/>
		<xsl:text> data);&#13;</xsl:text>
	
	</xsl:if>
</xsl:template>



<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist">
	<xsl:text>WithLst</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text>(o</xsl:text>
	<xsl:value-of select="../../../dataloader-impl/name"/>
	<xsl:text>.getList</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>())</xsl:text>
</xsl:template>

<!-- 
add list to the updater of the page  viewmodel (if pickerList)
 -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-declaration">
	 <xsl:text>WithLst</xsl:text>
	 <xsl:value-of select="entity-to-update/name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-parameter">
	 <xsl:text> List&lt;</xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>&gt; p_oLst</xsl:text>
	 <xsl:value-of select="uml-name"/>
</xsl:template>


<xsl:template match="viewmodel[dataloader-impl and type/name ='MASTER']" mode="update-vm-using-loader">

	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Retreive a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel into the cache. Here, there isn't creation or update.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="dataLoader"&gt; dataLoader.&#13;</xsl:text>
	<xsl:text>/// &lt;returns&gt;The viewmodel representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.&lt;/returns&gt;&#13;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> update</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>WithDataLoaderInContext(</xsl:text>
	<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
	<xsl:text> dataLoader, IMFContext context);&#13;</xsl:text>

</xsl:template>

</xsl:stylesheet>