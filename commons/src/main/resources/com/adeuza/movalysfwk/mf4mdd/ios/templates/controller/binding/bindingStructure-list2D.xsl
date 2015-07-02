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

<xsl:template match="controller" mode="createBindingStructure-method-list2D">
    MFTableConfiguration *tableConfiguration = [MFTableConfiguration createTableConfigurationForObjectWithBinding:self];
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">createBindingStructure-table</xsl:with-param>
			<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="./sections/section[@isNoTable = 'false' and sectionType = 'LISTCELL']" mode="createBindingStructure-method-list2D-cell"/>		
			<xsl:apply-templates select="./sections/section[@isNoTable = 'false' and sectionType = 'LISTSECTION']" mode="createBindingStructure-method-list2D-section"/>		
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="createBindingStructure-method-list2D-cell">
    MFBindingCellDescriptor *<xsl:value-of select="@name"/>CellDescriptor =
    [MFBindingCellDescriptor cellDescriptorWithIdentifier:@"<xsl:value-of select="../../cellClassName"/>"
    withCellHeight:@(<xsl:value-of select="@frameHeight"/>)
    withCellBindingFormat:<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-component-binding"/>
    	<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-component-associated-label"/>
    	<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-label-binding"/>
    	<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-component-parameters"/>
     nil];
    [tableConfiguration create1DTableCellWithDescriptor:<xsl:value-of select="@name"/>CellDescriptor];
</xsl:template>

<xsl:template match="section" mode="createBindingStructure-method-list2D-section">
    MFBindingViewDescriptor *<xsl:value-of select="@name"/>SectionViewDescriptor =
    [MFBindingViewDescriptor viewDescriptorWithIdentifier:@"<xsl:value-of select="../../sectionFormName"/>"
    withViewHeight:@(<xsl:value-of select="@frameHeight"/>)
    withViewBindingFormat:<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-component-binding"/>
    	<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-component-associated-label"/>
    	<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-label-binding"/>
    	<xsl:apply-templates select="./subViews/subView" mode="createBindingStructure-method-list2D-section-subview-component-parameters"/>
     nil];
    [tableConfiguration create2DTableHeaderViewWithDescriptor:<xsl:value-of select="@name"/>SectionViewDescriptor];
</xsl:template>

<xsl:template match="subView" mode="createBindingStructure-method-list2D-section-subview-component-binding">
       <xsl:text>@"outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>.binding : c.data&lt;-&gt;vm.</xsl:text>
       <xsl:value-of select="binding"/>
       <xsl:text>", </xsl:text>
</xsl:template>

<xsl:template match="subView" mode="createBindingStructure-method-list2D-section-subview-label-binding">
	<xsl:if test="@visibleLabel = 'true'">
	<xsl:text>@"outlet.</xsl:text>
        <xsl:value-of select="propertyName"/>
        <xsl:text>Label.binding : c.data&lt;-i18n.</xsl:text>
		<xsl:value-of select="@labelView"/>
		<xsl:text>", </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="subView" mode="createBindingStructure-method-list2D-section-subview-component-parameters">
	<xsl:if test="@readOnly = 'true' or @mandatory = 'false' or options/*'">
       <xsl:text>@"outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>.attributes : </xsl:text>
       <xsl:if test="@readOnly = 'true'">editable=NO, </xsl:if>
       <xsl:if test="@mandatory = 'false'">mandatory=NO, </xsl:if>
       <xsl:apply-templates select="./options/entry" mode="createBindingStructure-method-list2D-section-subview-component-parameters-bytype"/>
       <xsl:text>", &#13;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="subView" mode="createBindingStructure-method-list2D-section-subview-component-associated-label">
	<xsl:if test="@visibleLabel = 'true'">
       <xsl:text>@"outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>.associatedLabel : outlet.</xsl:text>
       <xsl:value-of select="propertyName"/>
       <xsl:text>Label", </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="entry" mode="createBindingStructure-method-list2D-section-subview-component-parameters-bytype">
	<xsl:value-of select="@key"/><xsl:text>=</xsl:text><xsl:value-of select="."/><xsl:text>, </xsl:text>
</xsl:template>	

</xsl:stylesheet>


