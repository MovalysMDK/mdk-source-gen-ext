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
		
<xsl:template match="visualfield[component='MFSignature']" mode="create-component">
		<xsl:text>&lt;mf:MFSignature x:Name="</xsl:text>
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="property-name-c"/>
			<xsl:with-param name="replace" select="'.'"/>
			<xsl:with-param name="by" select="'_'"/>
		</xsl:call-template>
		<xsl:text>"  Grid.Row="</xsl:text>
		<xsl:value-of select="component-position"/>
		<xsl:text>" Grid.Column="0"</xsl:text>
		<xsl:text> mf:Value="{Binding Path=</xsl:text>
		<xsl:value-of select="property-name-c" />
		<xsl:text>.Value, Mode=TwoWay}"</xsl:text>
		<xsl:text> Visibility="{Binding Path=</xsl:text>
		<xsl:value-of select="property-name-c" />
		<xsl:text>.Visibility, Mode=TwoWay, Converter={StaticResource BoolToVisibility}}"</xsl:text>
		<xsl:text> mf:Mandatory="</xsl:text>
		<xsl:value-of select="mandatory" />
		<xsl:text>" IsEnabled="</xsl:text>
		<xsl:choose>
			<xsl:when test="readonly='true'">
				<xsl:text>false</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>True</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>" mf:ErrorText="{Binding Path=ErrorList, Mode=TwoWay, Converter={StaticResource ErrorMessageConverter}, ConverterParameter=</xsl:text>
		<xsl:value-of select="property-name-c" />
		<xsl:text>}"</xsl:text>
		<xsl:text>&#47;&gt;</xsl:text>
</xsl:template>
		
</xsl:stylesheet>