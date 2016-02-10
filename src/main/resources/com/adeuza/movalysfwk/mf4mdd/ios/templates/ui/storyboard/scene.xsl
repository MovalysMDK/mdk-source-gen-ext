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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  >

<xsl:output method="xml"/>

<xsl:template match="scene">
	<scene>
		<xsl:attribute name="sceneID"><xsl:value-of select="@id"/></xsl:attribute>
		<objects>
			<xsl:apply-templates select="controller"/>
				<!-- **** => xxx-controller.xsl *** -->
			<placeholder placeholderIdentifier="IBFirstResponder" userLabel="First Responder" sceneMemberID="firstResponder">
				<xsl:attribute name="id"><xsl:value-of select="@placeHolderId"/></xsl:attribute>
			</placeholder>
		</objects>
		<point key="canvasLocation">
			<xsl:attribute name="x"><xsl:value-of select="@posX"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="@posY"/></xsl:attribute>
		</point>
	</scene>
</xsl:template>

</xsl:stylesheet>