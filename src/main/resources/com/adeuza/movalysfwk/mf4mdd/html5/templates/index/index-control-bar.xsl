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


	<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="main-app">
		<mf-controlbar>
			<xsl:apply-templates select="./views/view" mode="app-config"/>
		</mf-controlbar>
	</xsl:template>

	
	<xsl:template match="view[@isScreen='true' and @isMainScreen='true']" mode="app-config">
			<xsl:attribute name="mf-home-state"><xsl:value-of select="name"/>
			<xsl:if test="count(nestedSubviews/nestedSubview)>0">.content</xsl:if>
			</xsl:attribute>
	</xsl:template>
	
	
	<xsl:template match="view" mode="app-config">
	</xsl:template>

	
	

</xsl:stylesheet>