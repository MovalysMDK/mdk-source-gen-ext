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

<xsl:template match="xib-container" mode="createBindingStructure-method-pickerlist-section-subview-selected-item">
    MFBindingViewDescriptor *viewDescriptor =
    [MFBindingViewDescriptor viewDescriptorWithIdentifier:@"<xsl:value-of select="name"/>"
    withViewHeight:@(<xsl:value-of select="@frameHeight"/>)
    withViewBindingFormat:<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-component-binding"/>
    	<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-component-associated-label"/>
    	<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-label-binding"/>
    	<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-component-parameters"/>
     nil];
	   		 [pickerListConfiguration createPickerSelectedItemWithDescriptor:viewDescriptor];
</xsl:template>

<xsl:template match="xib-container" mode="createBindingStructure-method-pickerlist-section-subview-list-item">
    MFBindingCellDescriptor *cellDescriptor =
    [MFBindingCellDescriptor cellDescriptorWithIdentifier:@"<xsl:value-of select="name"/>"
    withCellHeight:@(<xsl:value-of select="@frameHeight"/>)
    withCellBindingFormat:<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-component-binding"/>
    	<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-component-associated-label"/>
    	<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-label-binding"/>
    	<xsl:apply-templates select="./components/component" mode="createBindingStructure-method-pickerlist-section-subview-component-parameters"/>
     nil];
	   		 [pickerListConfiguration createPickerListItemWithDescriptor:cellDescriptor];
</xsl:template>

<xsl:template match="component" mode="createBindingStructure-method-pickerlist-section-subview-component-binding">
       <xsl:text>@"outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>.binding : c.data&lt;-&gt;vm.</xsl:text>
       <xsl:value-of select="binding"/>
       <xsl:text>", </xsl:text>
</xsl:template>

<xsl:template match="component" mode="createBindingStructure-method-pickerlist-section-subview-label-binding">
	<xsl:if test="@visibleLabel = 'true'">
	<xsl:text>@"outlet.</xsl:text>
        <xsl:value-of select="propertyName"/>
        <xsl:text>Label.binding : c.data&lt;-i18n.</xsl:text>
		<xsl:value-of select="@labelView"/>
		<xsl:text>", </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="component" mode="createBindingStructure-method-pickerlist-section-subview-component-parameters">
	<xsl:if test="@readOnly = 'true' or @mandatory = 'false' or options/*'">
       <xsl:text>@"outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>.attributes : </xsl:text>
       <xsl:if test="@readOnly = 'true'">editable=NO, </xsl:if>
       <xsl:if test="@mandatory = 'false'">mandatory=NO, </xsl:if>
       <xsl:apply-templates select="./options/entry" mode="createBindingStructure-method-pickerlist-section-subview-component-parameters-bytype"/>
       <xsl:text>", &#13;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="component" mode="createBindingStructure-method-pickerlist-section-subview-component-associated-label">
	<xsl:if test="@visibleLabel = 'true'">
       <xsl:text>@"outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>.associatedLabel : outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>Label", </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="entry" mode="createBindingStructure-method-pickerlist-section-subview-component-parameters-bytype">
	<xsl:value-of select="@key"/><xsl:text>=</xsl:text><xsl:value-of select="."/><xsl:text>, </xsl:text>
</xsl:template>	

</xsl:stylesheet>


