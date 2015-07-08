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

<!-- bindedProperties method -->
<xsl:template match="viewmodel" mode="bindedProperties-method">
-(NSArray *)getBindedProperties {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">binded-properties</xsl:with-param>
	<xsl:with-param name="defaultSource">
    	<xsl:text>return @[&#13;</xsl:text>
		<xsl:apply-templates select="mapping/attribute|mapping//entity[@mapping-type='vmlist']|mapping//entity/attribute|attribute[@derived='true']|mapping//entity/attribute|." mode="bindedProperties"/>
		<xsl:text>];&#13;</xsl:text>
	</xsl:with-param>
</xsl:call-template>
}
</xsl:template>	

<xsl:template match="attribute[@derived = 'true']" mode="bindedProperties">
	<xsl:text>		@"</xsl:text>
	<!-- TODO: supprimer les types complexes -->
	<xsl:value-of select="@name"/>
	<xsl:text>",&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="bindedProperties">
	<xsl:text>		@"</xsl:text>
	<!-- TODO: supprimer les types complexes -->
	<xsl:value-of select="@vm-attr"/>
	<xsl:text>",&#13;</xsl:text>
</xsl:template>

<xsl:template match="entity[@mapping-type='vmlist']" mode="bindedProperties">
	<xsl:text>		@"</xsl:text>
	<!-- TODO: supprimer les types complexes -->
	<xsl:value-of select="@vm-property-name"/>
	<xsl:text>",&#13;</xsl:text>
</xsl:template>


<!-- Cas particulier des picker list, et des pickerlist contenues dans des fixed list -->
<xsl:template match="viewmodel" mode="bindedProperties">
	<xsl:apply-templates select="external-lists/external-list/viewmodel|.//subvm/viewmodel" mode="bindedProperties-combo-selected-item"/>
	<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="bindedProperties-combo-list-item"/>
	<xsl:apply-templates select=".//subvm/viewmodel" mode="bindedProperties-combo-list-item-for-fixed-list"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="bindedProperties">
	<xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
		<xsl:text>		@"</xsl:text>
		<xsl:text>selected</xsl:text><xsl:value-of select="external-lists/external-list/viewmodel/name"/><xsl:text>Item</xsl:text>
		<xsl:text>",&#13;</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="bindedProperties-combo-selected-item">
	<xsl:text>		@"</xsl:text>
	<xsl:text>selected</xsl:text><xsl:value-of select="type/item"/>
	<xsl:text>",&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="bindedProperties-combo-selected-item">
</xsl:template>


<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="bindedProperties-combo-list-item-for-fixed-list">
		<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="bindedProperties-combo-list-item"/>
</xsl:template>


<xsl:template match="viewmodel" mode="bindedProperties-combo-list-item-for-fixed-list">
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="bindedProperties-combo-list-item">
	<xsl:text>		@"</xsl:text>
	<xsl:text>lst</xsl:text><xsl:value-of select="name"/>
	<xsl:text>",&#13;</xsl:text>
</xsl:template>
<!-- Fin du cas particulier -->

</xsl:stylesheet>
