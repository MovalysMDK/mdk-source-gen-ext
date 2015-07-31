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


<xsl:template match="HTML-attribute[visualfield/component='MFTextView']" mode="partial-component-generation"  priority="1000">
	<xsl:param name="overide-text"/>
	<xsl:param name="viewModel"/>
	<xsl:param name="ignoreFormAttribute"/>
	
		
		<mf-textview>
			<xsl:apply-templates select="." mode="call-common-component-attributes">
				<xsl:with-param name="placeholder-text">no</xsl:with-param>
				<xsl:with-param name="overide-text"><xsl:value-of select="$overide-text"/></xsl:with-param>
				<xsl:with-param name="ignoreFormAttribute"><xsl:value-of select="$ignoreFormAttribute"/></xsl:with-param>
				<xsl:with-param name="viewModel"><xsl:value-of select="$viewModel"/></xsl:with-param>
			</xsl:apply-templates>
		</mf-textview>

</xsl:template>

</xsl:stylesheet>