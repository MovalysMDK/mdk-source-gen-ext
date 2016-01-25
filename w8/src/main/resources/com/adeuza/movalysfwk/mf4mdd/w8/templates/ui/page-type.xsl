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
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		
<xsl:template name="layout-type">
		<xsl:choose>
		  <xsl:when test="in-workspace = 'true'">
			<xsl:text>MFWorkspace</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:text>mdk_common.Common.MFPage</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
		<xsl:if test="main = 'true'">
			<xsl:if test="is-store = 'false'">
				<xsl:text>, IFileOpenPickerContinuable</xsl:text>
			</xsl:if>
		</xsl:if>
</xsl:template>

<xsl:template name="screen-type">
		<xsl:choose>
		  <xsl:when test="workspace = 'true'">
			<xsl:text>MFWorkspace</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:text>mdk_common.Common.MFPage</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
		<xsl:if test="main = 'true'">
			<xsl:if test="is-store = 'false'">
				<xsl:text>, IFileOpenPickerContinuable</xsl:text>
			</xsl:if>
		</xsl:if>
</xsl:template>

</xsl:stylesheet>