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

<!-- >>>>> TEMPLATES DEDIES A LA GENERATION DES TYPES PARAMETRES EN FONCTION DE L'ADAPTEUR -->

<!-- Cas du AbstractConfigurableSpinnerAdapter (combo) -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableSpinnerAdapter' or short-adapter='AbstractConfigurableFixedListAdapter']" mode="generate-parameter-types">
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>,
	ListViewModel&lt;<xsl:value-of select="./viewmodel/entity-to-update/name"/>, <xsl:value-of select="./viewmodel/implements/interface/@name"/>&gt;
</xsl:template>

<!-- Expandable List 3 -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableFlipperExpandableListAdapter']" mode="generate-parameter-types">
	<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>,	
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
</xsl:template>


<!-- Expandable List 2 -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableExpandableListAdapter']" mode="generate-parameter-types">
	<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
</xsl:template>

<!-- Expandable List 2 en mode multisélection-->
<xsl:template match="adapter[short-adapter='MultiSelectedExpandableListAdapter']" mode="generate-parameter-types">
	<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
</xsl:template>


<!-- Expandable List 1 -->
<xsl:template match="adapter[short-adapter='AbstractConfigurableListAdapter']" mode="generate-parameter-types">
	<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>,
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
</xsl:template>

</xsl:stylesheet>