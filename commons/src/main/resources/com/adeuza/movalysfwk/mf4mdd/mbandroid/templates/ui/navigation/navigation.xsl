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

<xsl:output method="text"/>	


<xsl:template match="navigation[@type='NAVIGATION_WKS_SWITCHPANEL' and @name='navigation-oncreate' and @internal='true']">
	this.getWadapter().resetSelectedItem();
</xsl:template>

<xsl:template match="navigation">
	Intent oIntent = new Intent(this, <xsl:value-of select="target/name"/>.class);
	oIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
	this.startActivityForResult(oIntent, <xsl:value-of select="target/name"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="target/request-code"/>);
</xsl:template>


</xsl:stylesheet>