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

<xsl:template match="attribute">

<xsl:text>&lt;ResourceDictionary</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>xmlns:conv="using:</xsl:text>
<xsl:value-of select="package"/>
<xsl:text>"</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>xmlns:mf="using:mdk_common.UI" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>&lt;conv:</xsl:text>
<xsl:value-of select="@type-short-name" />
<xsl:text>EnumToBooleanValueConverter x:Key="</xsl:text><xsl:value-of select="@type-short-name" /><xsl:text>EnumToBooleanValueConverter"/&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>&lt;DataTemplate x:Key="</xsl:text>
<xsl:value-of select="@type-short-name" />
<xsl:text>_radioenum_datatemplate"&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>&lt;StackPanel&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>
     
<xsl:apply-templates select="enumeration-values/enum-value"/>

<xsl:text>&lt;/StackPanel&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>&lt;/DataTemplate&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>
<xsl:text>&lt;/ResourceDictionary&gt;</xsl:text>
<xsl:text>&#13;</xsl:text>

</xsl:template>

<xsl:template match="enum-value"> 
<xsl:text>&lt;RadioButton x:Name="choice_</xsl:text>
<xsl:value-of select="."/>
<xsl:text>" GroupName="</xsl:text>
<xsl:value-of select="../../@type-short-name"/>
<xsl:text>_RadioEnumChoice</xsl:text>
<xsl:text>" IsChecked="{Binding Path=</xsl:text>
<xsl:value-of select="../../@name-capitalized"/>
<xsl:text>.Value, Mode=TwoWay, Converter={StaticResource </xsl:text>
<xsl:value-of select="../../@type-short-name"/>
<xsl:text>EnumToBooleanValueConverter}, ConverterParameter=</xsl:text>
<xsl:value-of select="."/><xsl:text>}" Content="</xsl:text>
<xsl:value-of select="."/>
<xsl:text>"/></xsl:text>
<xsl:choose>
	<xsl:when test="position() != last()">
		<xsl:text>&#13;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text></xsl:text>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>