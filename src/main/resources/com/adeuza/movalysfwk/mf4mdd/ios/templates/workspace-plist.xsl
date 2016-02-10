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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" />
	
	<xsl:template match="controller[@controllerType='WORKSPACE']">
		<plist version="1.0">
			<dict>
				<key>name</key>
				<string><xsl:value-of select="name"/></string>
				<key>typeName</key>
				<string><xsl:value-of select="customClass/name"/></string>
				<key>visible</key>
				<string>YES</string>
				<key>columns</key>
				<array>
					<xsl:apply-templates select="connections/connection"/>
				</array>
			</dict>
		</plist>
	</xsl:template>
	
	<xsl:template match="connection[connType='SEGUE']">
		<dict>
			<key>segueIdentifier</key>
			<string>column<xsl:value-of select="position()"/></string>
			<key>name</key>
			<string><xsl:value-of select="destination/name"/></string>
		</dict>
	</xsl:template>
	
	<xsl:template match="connection">
		<xsl:comment>
		UNHANDLE CASE
		</xsl:comment>
	</xsl:template>

</xsl:stylesheet>
