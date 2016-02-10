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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" xalan:indent-amount="2"/>	

<xsl:template match="views/view">
	<xsl:if test="@isMainScreen='true'">
		<xsl:text>&quot;home_page&quot;: &quot;</xsl:text><xsl:value-of select="viewName"/><xsl:text>&quot;,&#10;</xsl:text>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>