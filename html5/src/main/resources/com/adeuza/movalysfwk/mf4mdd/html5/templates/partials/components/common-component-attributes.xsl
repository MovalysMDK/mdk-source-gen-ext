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


<xsl:template match="*" mode="call-common-component-attributes">
	<xsl:param name="placeholder-text"/>
	<xsl:param name="overide-text"/>
	<xsl:param name="readonly-override-value"/>
	<xsl:param name="ignoreFormAttribute">false</xsl:param>
	<xsl:param name="viewModel"/>
	
			<xsl:attribute name="mf-field">
				<xsl:choose>
					<xsl:when test="$viewModel and $viewModel != ''">
						<xsl:value-of select="$viewModel"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>vm.viewModel</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			<xsl:text>.</xsl:text>
			<xsl:choose>
					<xsl:when test="not($overide-text='')">
						<xsl:value-of select="$overide-text"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="field-name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:if test="$ignoreFormAttribute = 'false'">
				<xsl:attribute name="mf-form"><xsl:value-of select="../../viewName"/>Form</xsl:attribute>
			</xsl:if>


			<xsl:choose>
				<xsl:when test="visualfield/create-label = 'false'">
					<xsl:attribute name="mf-hide-label">true</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="mf-label"><xsl:value-of select="visualfield/label"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:attribute name="mf-readonly">
				<xsl:choose>
					<xsl:when test="$readonly-override-value='true' or $readonly-override-value='false'">
						<xsl:value-of select="$readonly-override-value"/>
					</xsl:when>
					
					<!--
					LMI: why looking first at readonly of attribute ? visual field has a readonly attribute.
					<xsl:when test="attribute/@readonly and not($readonly-override-value='true' or $readonly-override-value='false')">
						<xsl:value-of select="attribute/@readonly"/>
					</xsl:when>
					 -->
					<xsl:otherwise>
						<xsl:value-of select="visualfield/readonly"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:if test="not($placeholder-text='' or $placeholder-text='no')">
				<xsl:attribute name="mf-placeholder"><xsl:value-of select="$placeholder-text"/></xsl:attribute>
			</xsl:if>

			<xsl:attribute name="mf-required"><xsl:value-of select="visualfield/mandatory"/></xsl:attribute>

</xsl:template>

</xsl:stylesheet>