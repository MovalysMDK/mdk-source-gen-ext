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

<xsl:template name="jdbc-bind-param">
	<xsl:param name="interface"/>
	<xsl:param name="object"/>
	<xsl:param name="statement"/>
	<xsl:param name="pos"/>
	
	<xsl:variable name="method-param" select="ancestor::method-parameter"/>
	
	<xsl:if test="parent::method-parameter">
		<xsl:call-template name="jdbc-bind">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="statement" select="$statement"/>
			<xsl:with-param name="valeur">
				<xsl:if test="$method-param/@by-value = 'true'">
					<xsl:value-of select="$object"/>
				</xsl:if>
				<xsl:if test="$method-param/@by-value = 'false'">
					<xsl:value-of select="$object"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>()</xsl:text>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="pos">
				<xsl:value-of select="position()"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	
	<xsl:if test="parent::association">
		<xsl:call-template name="jdbc-bind">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="statement" select="$statement"/>
			<xsl:with-param name="valeur">
				<xsl:value-of select="$object"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>()</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="pos"><xsl:value-of select="position()"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:text>;
	</xsl:text>
</xsl:template>

</xsl:stylesheet>