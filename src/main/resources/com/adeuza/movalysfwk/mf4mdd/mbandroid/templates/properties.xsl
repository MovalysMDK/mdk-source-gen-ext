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

	<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="/">
		<xsl:text>#&#13;</xsl:text>
		<xsl:text>#&#13;</xsl:text>
		<xsl:text># !!! WARNING !!!&#13;</xsl:text>
		<xsl:text># DO NOT MODIFY THIS FILE ....&#13;</xsl:text>
		<xsl:text># If you want to change a class definition use the file beans_dev&#13;</xsl:text>
		<xsl:text>#&#13;</xsl:text>
		<xsl:apply-templates select="root/factories/factory">
			<xsl:sort select="interface"/>
		</xsl:apply-templates>
		<xsl:text>&#13;&#13;</xsl:text>
		<xsl:apply-templates select="root/daos/dao">
			<xsl:sort select="interface"/>
		</xsl:apply-templates>
		<xsl:text>&#13;&#13;</xsl:text>
		<xsl:apply-templates select="root/dataloaders/dataloader">
			<xsl:sort select="interface"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="factory|dao|dataloader">
		<xsl:value-of select="interface"/>
		<xsl:text>=</xsl:text>
		<xsl:value-of select="implementation"/>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>