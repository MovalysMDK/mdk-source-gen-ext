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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  extension-element-prefixes="xsi">

<xsl:include href="components/common-component-attributes.xsl"/>

<xsl:template match="HTML-attribute[visualfield/component='MFBrowseUrlTextField']" mode="partial-component-generation"  priority="1000">
	<xsl:param name="readonly-override-value"/>
	<xsl:param name="overide-text"/>
	<xsl:param name="ignoreFormAttribute"/>
	<xsl:param name="viewModel"/>
		
		<mf-urlfield>
			<xsl:apply-templates select="." mode="call-common-component-attributes">
				<xsl:with-param name="placeholder-text">{{'field.mfbrowseurltextfield.placeholder' | translate}}</xsl:with-param>
				<xsl:with-param name="overide-text"><xsl:value-of select="$overide-text"/></xsl:with-param>
				<xsl:with-param name="readonly-override-value" select="$readonly-override-value"/>
				<xsl:with-param name="ignoreFormAttribute"><xsl:value-of select="$ignoreFormAttribute"/></xsl:with-param>
				<xsl:with-param name="viewModel"><xsl:value-of select="$viewModel"/></xsl:with-param>
			</xsl:apply-templates>
		</mf-urlfield>
</xsl:template>

</xsl:stylesheet>