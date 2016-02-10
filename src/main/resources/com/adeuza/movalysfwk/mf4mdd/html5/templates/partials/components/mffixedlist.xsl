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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	extension-element-prefixes="xsi">

	<xsl:include href="components/common-component-attributes.xsl" />

	<xsl:template match="HTML-attribute[visualfield/component='MfFixedList']"
		mode="partial-component-generation" priority="1000">
		<xsl:param name="ignoreFormAttribute"/>
		<xsl:param name="viewModel"/>
		
		<mf-fixed-list>
			<xsl:apply-templates select="." mode="call-common-component-attributes">
				<xsl:with-param name="ignoreFormAttribute"><xsl:value-of select="$ignoreFormAttribute"/></xsl:with-param>
				<xsl:with-param name="viewModel"><xsl:value-of select="$viewModel"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:attribute name="mf-title-head">Test Fixed List</xsl:attribute>
			<xsl:attribute name="mf-type-vm-factory"><xsl:value-of select="visualfield/parameters/parameter[@name='fixedListVmShortName']"/>Factory</xsl:attribute>
			<xsl:attribute name="mf-detail-template"><xsl:value-of select="detail-partial"/></xsl:attribute>
			<xsl:attribute name="mf-scroll">true</xsl:attribute>
			<xsl:attribute name="mf-detail-form"><xsl:value-of select="field-name"/>Form</xsl:attribute>
			
			<xsl:apply-templates select="child-attributes/HTML-attribute" mode="partial-component-generation">
				<xsl:with-param name="ignoreFormAttribute">true</xsl:with-param>
				<xsl:with-param name="viewModel">item</xsl:with-param>
			</xsl:apply-templates>
			
		</mf-fixed-list>
	</xsl:template>

</xsl:stylesheet>