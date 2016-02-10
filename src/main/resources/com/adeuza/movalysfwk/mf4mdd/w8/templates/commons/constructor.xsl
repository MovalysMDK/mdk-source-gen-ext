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

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/replace-all.xsl"/>

<xsl:template match="node()" mode="constructor-model-public">
	<xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text> ()</xsl:text>
	<xsl:text>{</xsl:text>
	
	<!-- simple attributes -->
	<xsl:for-each select="//attribute[not(parent::association) and @derived = 'false']">
		<xsl:text>this._</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text>
		<xsl:choose>
			<!-- case of identifier -->
			<xsl:when test="parent::identifier">
				<xsl:value-of select="@unsaved-value"/>
			</xsl:when>
			<!-- case class Long in attribute -->
			<xsl:when test="(@type-short-name='Long' and @init='null')">
				<xsl:text>0L</xsl:text>
			</xsl:when>
			<!-- enumeration with default value -->
			<xsl:when test="enumeration-values and field[@default-value]">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="@init"/>
					<xsl:with-param name="replace" select="substring-before(@init,'.')"/>
					<xsl:with-param name="by" select="@type-short-name" />
				</xsl:call-template>
			</xsl:when>
			<!-- other cases -->
			<xsl:otherwise>
				<xsl:value-of select="@init"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>;</xsl:text>
	</xsl:for-each>
	
	<!-- complex associations -->
	<xsl:for-each select="//association[not(parent::association)]">
		<xsl:text>this._</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text>
		<xsl:value-of select="@type-init-format"/>
		<xsl:text>;</xsl:text>
	</xsl:for-each>
	
	<xsl:text>}&#13;</xsl:text>
	
	<xsl:text>&#13;//@non-generated-start[constructor]>&#13;</xsl:text>
	
	<xsl:text>//@non-generated-end>&#13;</xsl:text>

</xsl:template>

</xsl:stylesheet>