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
	<xsl:output method="text" />

	<xsl:template match="page/adapter" mode="attributes"/>

	<xsl:template match="adapter" mode="attributes"/>

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="attributes">
		<xsl:variable name="vm-name" select="viewmodel/implements/interface/@full-name"/>
		<xsl:if test="not(../adapter/viewmodel/external-lists/external-list/viewmodel[implements/interface/@full-name=$vm-name])">
			<xsl:apply-templates select="viewmodel" mode="attributes">
				<xsl:with-param name="position" select="position()"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">declare-spinner-adapter<xsl:value-of select="position()"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				/**
				 * Adapter associated to the spinner of <xsl:value-of select="viewmodel/uml-name"/>.
				 */
				<xsl:text>private </xsl:text>
				<xsl:value-of select="name"/>
				<xsl:if test="name='ConfigurableSpinnerAdapter'">
					<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
					<xsl:text>, ListViewModel</xsl:text>
					<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
					<xsl:text>&gt;&gt;</xsl:text>
				</xsl:if>
				<xsl:text> spinnerAdapter</xsl:text><xsl:value-of select="position()"/><xsl:text> = null;&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='FIXED_LIST']" mode="attributes">
		/**
		 * Adapter associated to the fixedList of <xsl:value-of select="viewmodel/uml-name"/>.
		 */
		private <xsl:value-of select="name"/> fixedListAdapter<xsl:value-of select="position()"/> = null;
	</xsl:template>
</xsl:stylesheet>
