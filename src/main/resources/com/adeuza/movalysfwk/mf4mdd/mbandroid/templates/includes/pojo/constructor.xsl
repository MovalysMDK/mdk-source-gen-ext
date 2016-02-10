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

<xsl:template match="class" mode="constructor">

	/**
	 * Constructor <xsl:for-each select="javadoc">
	 * <xsl:value-of select="."/>
	</xsl:for-each>
	 */
	protected <xsl:value-of select="name"/>() {
		<xsl:for-each select="descendant::attribute[not(ancestor::association) and @derived = 'false']">
			<xsl:text>this.</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text> = </xsl:text>
			<xsl:choose>
				<xsl:when test="parent::identifier">
					<xsl:value-of select="@unsaved-value"/>
				</xsl:when>
				<!-- case class Long in attribute -->
				<xsl:when test="(@type-short-name='Long' and @init='null')">
					<xsl:text>0L</xsl:text>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="@init"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> ;&#13;</xsl:text>
			
			<xsl:for-each select="properties/property">
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="../../@name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="set-accessor"/>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="@init"/>
				<xsl:text>);&#13;</xsl:text>
			</xsl:for-each>
			
		</xsl:for-each>
		<xsl:for-each select="//association[not(parent::association)]">
			<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = null ;&#13;</xsl:text>
		</xsl:for-each>
			
//@non-generated-start[constructor]
<xsl:value-of select="non-generated/bloc[@id='constructor']"/>
<xsl:text>//@non-generated-end</xsl:text>
	}


</xsl:template>
</xsl:stylesheet>