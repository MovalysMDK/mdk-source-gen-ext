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

<xsl:template name="jdbc-bind">
	<xsl:param name="interface"/>
	<xsl:param name="statement"/>
	<xsl:param name="valeur"/>
	<xsl:param name="pos"/>
	
	<xsl:call-template name="replace-string">
		<xsl:with-param name="text">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text">
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text"><xsl:value-of select="jdbc-bind"/></xsl:with-param>
						<xsl:with-param name="from">VALEUR</xsl:with-param>
						<xsl:with-param name="to"><xsl:value-of select="$valeur"/></xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="from">POSITION</xsl:with-param>
				<xsl:with-param name="to"><xsl:value-of select="$pos"/></xsl:with-param>
			</xsl:call-template>
		</xsl:with-param>
		<xsl:with-param name="from">STATEMENT</xsl:with-param>
		<xsl:with-param name="to"><xsl:value-of select="$statement"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>