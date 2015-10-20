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

<xsl:template name="adapterConstructor">

	/**
	 * Constructor for <xsl:value-of select="name"/>
	 <xsl:apply-templates select="." mode="generate-constructor-parameters-javadoc"/>
	 */
	public <xsl:value-of select="name"/>
		<xsl:text>(</xsl:text>
		<xsl:apply-templates select="." mode="generate-constructor-parameters"/>
		<xsl:text>)</xsl:text> {
			
			super(<xsl:apply-templates select="." mode="generate-super-constructor-parameters"/>);
			
			//@non-generated-start[constructor]
			<xsl:value-of select="non-generated/bloc[@id='constructor']"/>
			//@non-generated-end
			
			<xsl:apply-templates select="." mode="generate-constructor-init"/>
	}

</xsl:template>

<!-- Constructor params for MultiSelect -->
<xsl:template match="adapter[short-adapter='MultiSelectedExpandableListAdapter']" mode="generate-constructor-init">
	//on définis une couche qui va englober chaque items enfant de l'ExpandableListView
	setChildCoat(R.layout.fwk_component__multi_selected_expandable_list_item__master, R.id.component__multi_selected_expandable_list_item__content);
</xsl:template>

<xsl:template match="adapter" mode="generate-constructor-init"/>

<!-- Constructor params javadoc for Spinner -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableSpinnerAdapter']" mode="generate-constructor-parameters-javadoc">
	* @param p_oMasterVM the parent view model
	* @param p_bUseEmptyValue true if the spinner uses the empty value
</xsl:template>

<!-- Constructor params javadoc for Flipper -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableFlipperExpandableListAdapter' or short-adapter='MDKFlipperAdapter']" 
	mode="generate-constructor-parameters-javadoc">
	* @param p_oMasterVM the parent view model
</xsl:template>

<xsl:template match="adapter[short-adapter='AbstractConfigurableExpandableListAdapter' or short-adapter='MDKExpandableAdapter' or short-adapter='MultiSelectedExpandableListAdapter']"
	mode="generate-constructor-parameters-javadoc">
	* @param p_oMasterVM the parent view model
</xsl:template>

<!-- Constructor params javadoc for List -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableListAdapter' or short-adapter='MDKAdapter']" mode="generate-constructor-parameters-javadoc">
	* @param p_oMasterVM the parent view model
</xsl:template>

<!--  Constructor params javadoc for FixedList -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableFixedListAdapter']" mode="generate-constructor-parameters-javadoc">
</xsl:template>

<!-- Default constructor javadoc -->
<xsl:template match="adapter" mode="generate-constructor-parameters-javadoc">
	* @param p_oMasterVM the parent view model
</xsl:template>

<!-- Constructor params for Spinner -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableSpinnerAdapter']"
	mode="generate-constructor-parameters">
	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>> p_oMasterVM, boolean p_bUseEmptyValue</xsl:text>
</xsl:template>

<!-- Constructor params for Flipper -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableFlipperExpandableListAdapter' or short-adapter='MDKFlipperAdapter']"
	mode="generate-constructor-parameters">
	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text>> p_oMasterVM</xsl:text>
</xsl:template>

<!-- Constructor params for expandable -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableExpandableListAdapter' or short-adapter='MDKExpandableAdapter' or short-adapter='MultiSelectedExpandableListAdapter']"
	mode="generate-constructor-parameters">
	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text>> p_oMasterVM</xsl:text>
</xsl:template>

<!-- Constructor params for List -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableListAdapter' or short-adapter='MDKAdapter']" mode="generate-constructor-parameters">
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text> p_oMasterVM</xsl:text>
</xsl:template>

<!--  Constructor params for FixedList -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableFixedListAdapter']" mode="generate-constructor-parameters">
</xsl:template>

<!--  Constructor params for widget FixedList -->
<xsl:template match="adapter[short-adapter='MDKFixedListAdapter']" mode="generate-constructor-parameters">
	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt; p_oMasterVM</xsl:text>
</xsl:template>

<!-- Default constructor -->
<xsl:template match="adapter" mode="generate-constructor-parameters">
	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text>&gt; p_oMasterVM</xsl:text>
</xsl:template>


<!-- Constructor.super() params for Spinner -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableSpinnerAdapter' and not(name='ConfigurableSpinnerAdapter')]" mode="generate-super-constructor-parameters">
	<xsl:variable name="selectedComponent">
		<xsl:choose>
			<xsl:when test="layouts/layout[1]/visualfields/visualfield[contains(component, 'MMSpinnerCheckedTextView') and string-length(substring-after(component, 'MMSpinnerCheckedTextView')) = 0]">
				<xsl:value-of select="./layouts/layout[1]/visualfields/visualfield[contains(component, 'MMSpinnerCheckedTextView') and string-length(substring-after(component, 'MMSpinnerCheckedTextView')) = 0][1]/name"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./layouts/layout[1]/visualfields/visualfield[1]/name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	p_oMasterVM,
	R.layout.<xsl:value-of  select="./layouts/layout[2]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[2]/name"/>,
	R.layout.<xsl:value-of  select="./layouts/layout[1]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[1]/name"/>,
	R.id.<xsl:value-of  select="$selectedComponent"/>,
	R.id.<xsl:value-of select="./layouts/layout[2]/visualfields/visualfield[1]/name"/>,
	p_bUseEmptyValue
</xsl:template>

<!-- Constructor.super() params for Spinner -->
<xsl:template match="adapter[(short-adapter='AbstractConfigurableSpinnerAdapter' and name='ConfigurableSpinnerAdapter') or name='MDKSpinnerAdapter']" mode="generate-super-constructor-parameters">
	<xsl:variable name="selectedComponent">
		<xsl:choose>
			<xsl:when test="layouts/layout[1]/visualfields/visualfield[contains(component, 'MMSpinnerCheckedTextView') and string-length(substring-after(component, 'MMSpinnerCheckedTextView')) = 0]">
				<xsl:value-of select="./layouts/layout[1]/visualfields/visualfield[contains(component, 'MMSpinnerCheckedTextView') and string-length(substring-after(component, 'MMSpinnerCheckedTextView')) = 0][1]/name"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./layouts/layout[1]/visualfields/visualfield[1]/name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:text>R.layout.</xsl:text><xsl:value-of  select="./layouts/layout[2]/name"/><xsl:text>, R.id.</xsl:text>
	<xsl:choose>
		<xsl:when test="./layouts/layout[2]/visualfields[count(visualfield)>1]">
			<xsl:value-of select="./layouts/layout[2]/name"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="./layouts/layout[2]/visualfields/visualfield[1]/name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,&#13;</xsl:text>
	<xsl:text>R.layout.</xsl:text><xsl:value-of  select="./layouts/layout[1]/name"/><xsl:text>, R.id.</xsl:text>
	<xsl:choose>
		<xsl:when test="./layouts/layout[1]/visualfields[count(visualfield)>1]">
			<xsl:value-of select="./layouts/layout[1]/name"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="./layouts/layout[1]/visualfields/visualfield[1]/name"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,&#13;</xsl:text>
	R.id.<xsl:value-of  select="$selectedComponent"/>,
	R.id.<xsl:value-of select="./layouts/layout[2]/visualfields/visualfield[1]/name"/>
</xsl:template>

<!-- Constructor.super() params for flipper -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableFlipperExpandableListAdapter' or short-adapter='MDKFlipperAdapter']" mode="generate-super-constructor-parameters">
p_oMasterVM,
R.layout.<xsl:value-of  select="./layouts/layout[2]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[2]/name"/>,
R.layout.<xsl:value-of  select="./layouts/layout[3]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[3]/name"/>,
R.layout.<xsl:value-of  select="./layouts/layout[4]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[4]/name"/>
</xsl:template>

<!-- Constructor.super() params for expandable list -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableExpandableListAdapter' or short-adapter='MDKExpandableAdapter' or short-adapter='MultiSelectedExpandableListAdapter']" mode="generate-super-constructor-parameters">
p_oMasterVM,
R.layout.<xsl:value-of  select="./layouts/layout[2]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[2]/name"/>,
R.layout.<xsl:value-of  select="./layouts/layout[3]/name"/>, R.id.<xsl:value-of  select="./layouts/layout[3]/name"/>
</xsl:template>


<!-- Constructor params.super() for list -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableListAdapter' or short-adapter='MDKAdapter']" mode="generate-super-constructor-parameters">
	
	<xsl:text>p_oMasterVM, R.layout.</xsl:text>
	<xsl:value-of  select="./layouts/layout[2]/name"/>
	<xsl:text>, R.id.</xsl:text>
	<xsl:value-of  select="./layouts/layout[2]/name"/>
	
</xsl:template>

	<!-- Constructor params.super() for FixedList -->
	<xsl:template match="adapter[short-adapter='AbstractConfigurableFixedListAdapter']" mode="generate-super-constructor-parameters">
		<xsl:text>R.layout.</xsl:text>
		<xsl:value-of  select="./layouts/layout[1]/name"/>
		<xsl:text>, R.id.</xsl:text>
		<xsl:value-of  select="./layouts/layout[1]/name"/>,
		<xsl:text>R.layout.</xsl:text>
		<xsl:value-of  select="./layouts/layout[2]/name"/>
	</xsl:template>
	
<!--  Constructor params for widget FixedList -->
<xsl:template match="adapter[short-adapter='MDKFixedListAdapter']" mode="generate-super-constructor-parameters">
	<xsl:text>p_oMasterVM, </xsl:text>
	<xsl:text>R.layout.</xsl:text>
	<xsl:value-of  select="./layouts/layout[1]/name"/>
	<xsl:text>, R.id.</xsl:text>
	<xsl:value-of  select="./layouts/layout[1]/name"/>,
	<xsl:text>R.layout.</xsl:text>
	<xsl:value-of  select="./layouts/layout[2]/name"/>
</xsl:template>
	
</xsl:stylesheet>


