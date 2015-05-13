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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Generate getter/setter for viewmodel non derived attribute -->
<xsl:template match="viewmodel" mode="generate-subvm-get-and-set">
	
<xsl:choose>
	<xsl:when test="parameters/parameter[@name='baseName'] or type/name='LIST_1'">
		<xsl:text>private </xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text> _lst</xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text>;&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text> Lst</xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text>&#13;</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>get { return _lst</xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text>; }&#13;</xsl:text>
		<xsl:text>set{_lst</xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text> = value;</xsl:text>
		<xsl:text>OnPropertyChanged("Lst</xsl:text><xsl:value-of select="implements/interface/@name" /><xsl:text>");</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>private </xsl:text><xsl:value-of select="name"/><xsl:text> _</xsl:text><xsl:value-of select="property-name"/><xsl:text>;&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="property-name"/><xsl:text>&#13;</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>get { return _</xsl:text><xsl:value-of select="property-name"/><xsl:text>; }&#13;</xsl:text>
		<xsl:text>set{_</xsl:text><xsl:value-of select="property-name"/><xsl:text> = value;</xsl:text>
		<xsl:text>OnPropertyChanged("</xsl:text><xsl:value-of select="property-name"/><xsl:text>");</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
 	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-combo-attribute">

	<xsl:apply-templates select="external-lists/external-list/viewmodel|.//subvm/viewmodel" mode="generate-combo-selected-attribute"/>
	<xsl:apply-templates select=".//subvm/viewmodel" mode="generate-combo-lst-attribute-for-fixed-list"/>
	<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-combo-lst-attribute"/>
	
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="generate-combo-attribute">
	<xsl:apply-templates select="external-lists/external-list/viewmodel|.//subvm/viewmodel" mode="generate-combo-selected-attribute-for-picker-in-fixedList"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-selected-attribute-for-picker-in-fixedList">

	<xsl:text>private </xsl:text><xsl:value-of select="type/item"/><xsl:text> _selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>;&#13;</xsl:text>
	<xsl:text>public </xsl:text><xsl:value-of select="type/item"/><xsl:text> Selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>get { return _selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>; }&#13;</xsl:text>
	<xsl:text>set{_selected</xsl:text><xsl:value-of select="type/item"/><xsl:text> = value;</xsl:text>
	<xsl:text>OnPropertyChanged("Selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>");</xsl:text>
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-selected-attribute">
	<xsl:text>private </xsl:text><xsl:value-of select="type/item"/><xsl:text> _selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>;&#13;</xsl:text>
	<xsl:text>public </xsl:text><xsl:value-of select="type/item"/><xsl:text> Selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>get { return _selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>; }&#13;</xsl:text>
	<xsl:text>set{_selected</xsl:text><xsl:value-of select="type/item"/><xsl:text> = value;</xsl:text>
	<xsl:text>OnPropertyChanged("Selected</xsl:text><xsl:value-of select="type/item"/><xsl:text>");</xsl:text>
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-combo-selected-attribute">
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="generate-combo-lst-attribute-for-fixed-list">
		<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-combo-lst-attribute"/>
</xsl:template>


<xsl:template match="viewmodel" mode="generate-combo-lst-attribute-for-fixed-list">
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-lst-attribute">
	<xsl:text>private </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> _lst</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>;&#13;</xsl:text>
	<xsl:text>public </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> Lst</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>&#13;</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>get { return _lst</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>; }&#13;</xsl:text>
	<xsl:text>set{_lst</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> = value;</xsl:text>
	<xsl:text>OnPropertyChanged("Lst</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>");</xsl:text>
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>