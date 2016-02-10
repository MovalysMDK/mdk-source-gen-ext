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

	<xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8" />

	<xsl:template match="fields">
	<ArrayOfFieldsValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
		<xsl:apply-templates select="field">
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
	</ArrayOfFieldsValue>
	</xsl:template>

	<xsl:template match="field">
		<FieldsValue>
			<Key><xsl:value-of select="@name"/></Key>
			<Value>
		  		<xsl:apply-templates select="visual-properties">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
			</Value>
		</FieldsValue>
	</xsl:template>
	
	<xsl:template match="visual-property[@name = 'IsEnabled']">
		<IsEnabled><xsl:value-of select="."/></IsEnabled>
	</xsl:template>
	<xsl:template match="visual-property[@name = 'IsMandatory']">
		<IsMandatory><xsl:value-of select="."/></IsMandatory>
	</xsl:template>
<!-- <xsl:template match="visual-property[@name = 'IsCreateLabel']">
		<IsCreateLabel><xsl:value-of select="."/></IsCreateLabel>
	</xsl:template> -->
	<xsl:template match="visual-property">
	</xsl:template>



</xsl:stylesheet>