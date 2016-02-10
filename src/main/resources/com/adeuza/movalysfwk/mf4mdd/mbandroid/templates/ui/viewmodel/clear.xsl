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

	<!-- CLEAR VM ............................................................................. -->

	<xsl:template match="mapping" mode="generate-method-clear">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Clear this view model.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void clear() {&#13;</xsl:text>
		<xsl:apply-templates select="../attribute[@derived='true']" mode="generate-method-clear"/>
		<xsl:apply-templates select="attribute" mode="generate-method-clear"/>
		<xsl:apply-templates select="entity[@mapping-type]" mode="generate-method-clear"/>
		<xsl:apply-templates select="entity[not(@mapping-type)]" mode="generate-call-clear"/>
		//@non-generated-start[clear-after]
		<xsl:value-of select="../non-generated/bloc[@id='clear-after']"/>
		//@non-generated-end
		super.clear();
		<xsl:text>}&#13;</xsl:text>

		<xsl:apply-templates select=".//entity[not(@mapping-type)]" mode="generate-method-clear">
			<xsl:sort select="@type"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="attribute[@derived='true']" mode="generate-method-clear">
		<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vm' or @mapping-type='vm_comboitemselected']" mode="generate-method-clear">
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="@initial-value"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-clear">
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = new ListViewModelImpl&lt;</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>&gt;(</xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>.class, false);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[not(@mapping-type)]" mode="generate-method-clear">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Clear data associated to a</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>protected void clear</xsl:text>
		<xsl:apply-templates select="." mode="generate-methodname-clear"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:apply-templates select="attribute" mode="generate-method-clear"/>
		<xsl:apply-templates select="entity[@mapping-type]" mode="generate-method-clear"/>
		<xsl:apply-templates select="entity[not(@mapping-type)]" mode="generate-call-clear"/>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity" mode="generate-call-clear">
		<xsl:text>this.clear</xsl:text>
		<xsl:apply-templates select="." mode="generate-methodname-clear"/>
		<xsl:text>();&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity" mode="generate-methodname-clear">
		<xsl:apply-templates select="parent::entity" mode="generate-methodname-clear"/>
		<xsl:value-of select="substring-after(getter/@name, 'get')"/>
	</xsl:template>

	<xsl:template match="attribute" mode="generate-method-clear">
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = </xsl:text>
		<xsl:choose>
			<xsl:when test="count(vm-attr-initial-value) > 0 ">
				<xsl:value-of select="vm-attr-initial-value"/>
			</xsl:when>
		
			<xsl:when test="@initial-value='null'">
				<xsl:text>null</xsl:text>
			</xsl:when>

			<xsl:when test="getter/@formula">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="getter/@formula"/>
					<xsl:with-param name="replace" select="'VALUE'"/>
					<xsl:with-param name="by" select="@initial-value"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="@initial-value"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
