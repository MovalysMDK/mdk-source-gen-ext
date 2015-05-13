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


<xsl:template match="HTML-attribute[visualfield/component='MFCellComponentPickerList']" mode="partial-component-generation"  priority="1000">
		<xsl:param name="overide-text"/>
		<xsl:param name="ignoreFormAttribute"/>
		<xsl:param name="viewModel"/>
		
		<xsl:comment>MFCombo</xsl:comment>
		<mf-combo>
			<xsl:apply-templates select="." mode="call-common-component-attributes">
				<xsl:with-param name="placeholder-text">no</xsl:with-param>
				<xsl:with-param name="overide-text"><xsl:value-of select="$overide-text"/></xsl:with-param>
				<!-- 
				LMI: why always editable ?
				<xsl:with-param name="readonly-override-value">false</xsl:with-param>
				 -->
				<xsl:with-param name="ignoreFormAttribute"><xsl:value-of select="$ignoreFormAttribute"/></xsl:with-param>
				<xsl:with-param name="viewModel"><xsl:value-of select="$viewModel"/></xsl:with-param>
			</xsl:apply-templates>
<!-- 			<xsl:attribute name="mf-value-attribute"><xsl:value-of select="value-attribute"/></xsl:attribute> -->
			
			<xsl:attribute name="mf-displayed-attributes">
				<xsl:apply-templates select="displayed-attributes-in-selection/HTML-attribute" mode="add-picker-displayed-attributes"/>
			</xsl:attribute>			
		</mf-combo>
</xsl:template>

<xsl:template match="HTML-attribute[not(visualfield/component='MFPosition' or visualfield/component='MFPhotoThumbnail')]" mode="add-picker-displayed-attributes">
		<xsl:value-of select="field-name"/><xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="HTML-attribute[visualfield/component='MFPosition']" mode="add-picker-displayed-attributes">
		<xsl:value-of select="field-name"/><xsl:text>.latitude,</xsl:text>
		<xsl:value-of select="field-name"/><xsl:text>.longitude</xsl:text><xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="HTML-attribute[visualfield/component='MFPhotoThumbnail']" mode="add-picker-displayed-attributes">
		<xsl:value-of select="field-name"/><xsl:text>.name,</xsl:text>
		<xsl:value-of select="field-name"/><xsl:text>.date</xsl:text><xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>


</xsl:stylesheet>