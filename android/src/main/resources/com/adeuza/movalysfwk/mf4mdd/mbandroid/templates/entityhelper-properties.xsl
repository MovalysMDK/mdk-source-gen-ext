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

	<xsl:template match="entity-factories">
		<xsl:apply-templates select="class">
			<xsl:sort select="implements/interface/@full-name"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="class">
		<xsl:value-of select="implements/interface/@full-name"/>
		<xsl:text>|factory=</xsl:text>
		<xsl:value-of select="pojo-factory-interface/import"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:if test="transient = 'false'">
			<xsl:value-of select="implements/interface/@full-name"/>
			<xsl:text>|dao=</xsl:text>
			<xsl:value-of select="dao-interface/@full-name"/>
			<xsl:text>&#13;</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>