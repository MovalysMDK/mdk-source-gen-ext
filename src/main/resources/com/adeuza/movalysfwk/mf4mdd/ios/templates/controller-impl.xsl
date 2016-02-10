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
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/constants.xsl"/>

<xsl:include href="controller/dofillaction.xsl"/>
<xsl:include href="controller/eventdofillaction.xsl"/>
<xsl:include href="controller/eventupdatevm.xsl"/>
<xsl:include href="controller/filters.xsl"/>
<xsl:include href="controller/init.xsl"/>
<xsl:include href="controller/nameOfViewModel.xsl"/>
<xsl:include href="controller/properties.xsl"/>
<xsl:include href="controller/save.xsl"/>
<xsl:include href="controller/search.xsl"/>
<xsl:include href="controller/partialViewModel.xsl"/>
<xsl:include href="controller/container.xsl"/>

<xsl:template match="controller">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="." mode="container-impl-import"/>

<xsl:apply-templates select="." mode="declare-impl-imports"/>

@interface <xsl:value-of select="name"/> ()

<xsl:apply-templates select="." mode="properties"/>

@end

<xsl:text>&#13;@implementation </xsl:text><xsl:value-of select="name"/> {
<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">instance-variables</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;</xsl:text>
}

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<xsl:text>&#13;</xsl:text>

<xsl:apply-templates select="." mode="container-impl-attirbutes"/>

<xsl:apply-templates select="." mode="methods"/>


<xsl:apply-templates select="." mode="container-impl-methods"/>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">others-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end
</xsl:template>

<xsl:template match="controller[@controllerType = 'FORMVIEW' or @controllerType='LISTVIEW' or @controllerType='LISTVIEW2D' or @controllerType='SEARCHVIEW']" mode="methods">
<xsl:apply-templates select="." mode="init-methods"/>
<xsl:apply-templates select="." mode="doFillAction-method"/>
<xsl:apply-templates select="." mode="successLoadActionMethod"/>
<xsl:apply-templates select="." mode="failLoadActionMethod"/>
<xsl:apply-templates select="." mode="successUpdateVMActionMethod"/>
<xsl:apply-templates select="." mode="nameOfViewModel-method"/>
<xsl:apply-templates select="." mode="partialViewModel-methods"/>
<xsl:apply-templates select="." mode="filter-methods"/>
<xsl:apply-templates select="." mode="other-methods"/>
<xsl:apply-templates select="." mode="search-methods"/>
<xsl:apply-templates select="." mode="searchpanel-methods"/>
</xsl:template>

<xsl:template match="controller[@controllerType = 'FIXEDLISTVIEW']" mode="methods">
	<xsl:apply-templates select="." mode="init-methods"/>
	<xsl:apply-templates select="." mode="doFillAction-method"/>
	<xsl:apply-templates select="." mode="nameOfViewModel-method"/>
</xsl:template>

<xsl:template match="controller" mode="methods">
</xsl:template>


<xsl:template match="controller[@controllerType='LISTVIEW' or @controllerType='LISTVIEW2D']" mode="other-methods">
</xsl:template>


<xsl:template match="controller[@controllerType='FORMVIEW']" mode="other-methods">
	<xsl:apply-templates select="." mode="do-keep-modifications"/>
</xsl:template>

<xsl:template match="controller" mode="other-methods">
</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

</xsl:stylesheet>
