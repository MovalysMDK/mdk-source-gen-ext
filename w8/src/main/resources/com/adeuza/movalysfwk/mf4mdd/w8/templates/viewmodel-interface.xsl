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

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/interface.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/replace-all.xsl"/>
<xsl:include href="ui/viewmodel/updateFromIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/modifyToIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>

<xsl:template match="viewmodel">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="implements/interface/@name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	<xsl:call-template name="viewmodel-imports" />
	
	<xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>[ScopePolicyAttribute(ScopePolicy.</xsl:text>
	<xsl:choose>
		<xsl:when test="type/name='MASTER'">
			<xsl:text>Singleton</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Prototype</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>)]&#13;</xsl:text>
	<xsl:text>public interface </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> : </xsl:text>
	<xsl:value-of select="./type/item"/>
	<xsl:if test="type/name='LISTITEM_2'">
		<xsl:text>, IMFIsOpenItem</xsl:text>
	</xsl:if>
	<xsl:if test="type/name='MASTER' and type/is-list='false' and dataloader-impl/dao-interface/dao/class/association[@type='many-to-one']">
		<xsl:text>, IMFIsChildItem</xsl:text>
	</xsl:if>
	<xsl:text> {&#13;</xsl:text>
	
	<xsl:text>&#13;//@non-generated-start[class-signature]&#13;</xsl:text>
	<xsl:value-of select="/*/non-generated/bloc[@id='class-signature']"/>
	<xsl:text>&#13;//@non-generated-end</xsl:text>
	
	<xsl:text>&#13;</xsl:text>
			
	<xsl:text>&#13;#region Properties&#13;</xsl:text>
	
	<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="attribute" mode="vmAttributes"/>
		<xsl:apply-templates select="subvm/viewmodel" mode="subVmAttributes"/>
		<xsl:apply-templates select="." mode="generate-combo-attribute"/>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">custom-properties</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		
	<xsl:text>&#13;#endregion&#13;&#13;</xsl:text>
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text>
	<xsl:if test="dataloader-impl">
		<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Update the view model with the given data loader.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:text>/// &lt;param name="p_dataloader"&gt; Data loader to retrieve the information to insert in the view model.&lt;/param&gt;&#13;</xsl:text>
		<xsl:text>void UpdateFromDataLoader(</xsl:text><xsl:value-of select="dataloader-impl/dataloader-interface/name"/><xsl:text> p_dataloader);
		</xsl:text>
	</xsl:if>

	<xsl:text>void ExecuteSave</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(Object parameter);&#13;</xsl:text>
	<xsl:text>void ExecuteDelete</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(Object parameter);&#13;</xsl:text>
	<xsl:for-each select="./navigations/navigation">
		<xsl:text>void Execute</xsl:text><xsl:value-of select="target/name"/><xsl:text>Navigation(object parameter);&#13;</xsl:text>
	</xsl:for-each>

	<xsl:apply-templates select="attribute[@derived='true']" mode="generate-calculate-method-header"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="mapping" mode="generate-method-clear-header"/>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>
		
	<xsl:text>&#13;#endregion&#13;&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="attribute" mode="vmAttributes">

	<xsl:text>MFProperty&lt;</xsl:text>
	<!-- <xsl:variable name="name" select="./@name" /> -->
	<xsl:value-of select="@type-short-name" />
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="@name-capitalized"/>
	<xsl:text> { get; set; }&#13;</xsl:text>

</xsl:template>


<xsl:template match="attribute[contains(@name,'_id')='true']" mode="vmAttributes">
	<xsl:value-of select="@type-short-name" /><xsl:text> </xsl:text><xsl:value-of select="@name-capitalized"/>
	<xsl:text> { get; set; }&#13;</xsl:text>
</xsl:template>


<!-- Cas particulier des picker list, et des pickerlist contenues dans des fixed list -->
<xsl:template match="viewmodel" mode="generate-combo-attribute">

	<xsl:apply-templates select="external-lists/external-list/viewmodel|.//subvm/viewmodel" mode="generate-combo-selected-attribute"/>
	<xsl:apply-templates select=".//subvm/viewmodel" mode="generate-combo-lst-attribute-for-fixed-list"/>
	<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-combo-lst-attribute"/>
	
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="generate-combo-attribute">
	<xsl:apply-templates select="external-lists/external-list/viewmodel|.//subvm/viewmodel" mode="generate-combo-selected-attribute-for-picker-in-fixedList"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-selected-attribute-for-picker-in-fixedList">
	<!-- <xsl:text>@property (nonatomic, strong) </xsl:text> -->
	<xsl:value-of select="type/item"/><xsl:text> Selected</xsl:text><xsl:value-of select="type/item"/>
	<xsl:text> { get; set; }&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-selected-attribute">
	<xsl:value-of select="type/item"/><xsl:text> Selected</xsl:text><xsl:value-of select="type/item"/>
	<xsl:text> { get; set; }&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-combo-selected-attribute">
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="generate-combo-lst-attribute-for-fixed-list">
		<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-combo-lst-attribute"/>
</xsl:template>


<xsl:template match="viewmodel" mode="generate-combo-lst-attribute-for-fixed-list">
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-lst-attribute">
		<xsl:value-of select="implements/interface/@name"/><xsl:text> Lst</xsl:text><xsl:value-of select="implements/interface/@name"/>
		<xsl:text> { get; set; }&#13;</xsl:text>
</xsl:template>
<!-- Fin du cas particulier -->

<xsl:template match="viewmodel" mode="subVmAttributes">
<xsl:value-of select="implements/interface/@name"/><xsl:text> </xsl:text><xsl:value-of select="property-name"/>
<xsl:text> { get; set; }&#13;</xsl:text>
</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

<xsl:template match="attribute" mode="generate-calculate-method-header">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Method to compute the field derived </xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>void Calculate</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>();</xsl:text>
</xsl:template>

</xsl:stylesheet>