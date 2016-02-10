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

<xsl:template match="viewmodel" mode="loadsavecascades">
	
	@Override
	public CascadeSet getLoadCascade() {
		<xsl:if test="count(cascades/cascade) = 0">
			<xsl:text>return CascadeSet.NONE;</xsl:text>
		</xsl:if>
		<xsl:if test="count(cascades/cascade) > 0">
			<xsl:text>return CascadeSet.of(</xsl:text>
			<xsl:for-each select="cascades/cascade">
				<xsl:if test="position() > 1">
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:value-of select="."/>
			</xsl:for-each>
			<xsl:text>);</xsl:text>
		</xsl:if>
	}

	@Override
	public CascadeSet getSaveCascade() {
		<xsl:if test="count(savecascades/cascade) = 0">
			<xsl:text>return CascadeSet.NONE;</xsl:text>
		</xsl:if>
		<xsl:if test="count(savecascades/cascade) > 0">
			<xsl:text>return CascadeSet.of(</xsl:text>
			<xsl:for-each select="savecascades/cascade">
				<xsl:if test="position() > 1">
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:value-of select="."/>
			</xsl:for-each>
			<xsl:text>);</xsl:text>
		</xsl:if>
	}
	
	</xsl:template>

</xsl:stylesheet>
