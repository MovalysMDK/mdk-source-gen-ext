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
<xsl:include href="commons/constants.xsl"/>
<xsl:include href="commons/replace-all.xsl"/>
<xsl:include href="ui/viewmodel/updateFromIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/modifyToIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>

<xsl:template match="viewmodel">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.h</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-protocol-imports"/>

@interface <xsl:value-of select="name"/>
<xsl:apply-templates select="implements/interface/linked-interfaces" mode="extends"/>
<xsl:if test="dataloader-impl or parameters/parameter[@name='hasSublist']">
<xsl:text>&lt;</xsl:text>
	<xsl:choose>
		<xsl:when test="dataloader-impl and parameters/parameter[@name='hasSublist']">
			<xsl:text>MFUpdatableFromDataLoaderProtocol, MFBaseViewModelWithSublistProtocol</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="dataloader-impl">
				<xsl:text>MFUpdatableFromDataLoaderProtocol</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>MFBaseViewModelWithSublistProtocol</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&gt;</xsl:text>
</xsl:if>
<xsl:text>&#13;//@non-generated-end&#13;</xsl:text>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@property (nonatomic) BOOL isInitialized;

<xsl:apply-templates select="identifier/attribute|attribute" mode="vmAttributes"/>

<xsl:apply-templates select="subvm/viewmodel" mode="subVmAttributes"/>

<xsl:apply-templates select="." mode="generate-combo-attribute"/>

<xsl:if test="entity-to-update">
	<xsl:apply-templates select="." mode="updateFromIdentifiable-method-header"/>
	<xsl:apply-templates select="." mode="modifyToIdentifiable-method-header"/>
</xsl:if>

<xsl:apply-templates select="mapping" mode="generate-method-clear-header"/>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
</xsl:call-template>   

@end

</xsl:template>

<xsl:template match="attribute" mode="vmAttributes">

<xsl:text>@property (nonatomic</xsl:text>
<xsl:if test="not(@enum) or @enum = 'false'">
	<xsl:text>, strong</xsl:text>
</xsl:if>
<xsl:text>) </xsl:text>
<xsl:value-of select="@type-short-name"/>
<xsl:text> </xsl:text>
<xsl:if test="not(@enum) or @enum = 'false'">
	<xsl:text>*</xsl:text>
</xsl:if>
<xsl:value-of select="@name"/>
<xsl:text>;&#13;</xsl:text>

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
	<xsl:text>@property (nonatomic, strong) </xsl:text><xsl:value-of select="type/item"/>
	<xsl:text> *selected</xsl:text><xsl:value-of select="name"/><xsl:text>Item</xsl:text>
	<xsl:text>;&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-selected-attribute">
	<xsl:text>@property (nonatomic, strong) </xsl:text><xsl:value-of select="type/item"/>
	<xsl:text> *selected</xsl:text><xsl:value-of select="type/item"/>
	<xsl:text>;&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-combo-selected-attribute">
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="generate-combo-lst-attribute-for-fixed-list">
		<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-combo-lst-attribute"/>
</xsl:template>


<xsl:template match="viewmodel" mode="generate-combo-lst-attribute-for-fixed-list">
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-lst-attribute">
		<xsl:text>@property (nonatomic, strong) </xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text> *lst</xsl:text><xsl:value-of select="name"/>
		<xsl:text>;&#13;</xsl:text>
</xsl:template>
<!-- Fin du cas particulier -->

<xsl:template match="viewmodel" mode="subVmAttributes">
<!-- 	<xsl:text>@property (nonatomic, strong) </xsl:text> -->
<!-- 	<xsl:value-of select="name"/> -->
<!-- 	<xsl:text> *</xsl:text> -->
<!-- 	<xsl:value-of select="property-name"/> -->
<!-- 	<xsl:text>;&#13;</xsl:text> -->

<xsl:text>@property (nonatomic</xsl:text>
<xsl:if test="not(@enum) or @enum = 'false'">
	<xsl:text>, strong</xsl:text>
</xsl:if>
<xsl:text>) </xsl:text>
<xsl:value-of select="name"/>
<xsl:if test="not(@enum) or @enum = 'false'">
	<xsl:text>*</xsl:text>
</xsl:if>
<xsl:value-of select="property-name"/>
<xsl:text>;&#13;</xsl:text>

</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

</xsl:stylesheet>