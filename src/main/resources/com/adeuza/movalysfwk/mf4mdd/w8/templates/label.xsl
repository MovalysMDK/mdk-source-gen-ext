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

	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="/">
	<resources>
		<xsl:apply-templates select="labels/label">
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
</resources>
	</xsl:template>

	<xsl:template match="label">
		<string><xsl:attribute name="name"><xsl:value-of select="./@name"/></xsl:attribute><xsl:value-of select="."/></string><xsl:text>
		</xsl:text>
	</xsl:template>

</xsl:stylesheet>