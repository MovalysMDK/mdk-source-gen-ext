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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- Generate getter/setter for viewmodel non derived attribute -->
	<xsl:template match="attribute" mode="generate-attribute-get-and-set">
		<xsl:variable name="name" select="./@name" />
		<xsl:text>private MFProperty&lt;</xsl:text>
		<xsl:value-of select="@type-short-name" />
		<xsl:text>&gt; _</xsl:text><xsl:value-of select="@name" /><xsl:text>;&#13;</xsl:text>
		<xsl:text>[MFPropertyAttribute("</xsl:text><xsl:value-of select="//viewmodel/name" /><xsl:text>.</xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>")]&#13;</xsl:text>
		<xsl:text>public MFProperty&lt;</xsl:text>
		<xsl:value-of select="@type-short-name" />
		<xsl:text>&gt; </xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>&#13;</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>get { return _</xsl:text><xsl:value-of select="@name" /><xsl:text>; }&#13;</xsl:text>
		<xsl:text>set{_</xsl:text><xsl:value-of select="@name" /><xsl:text> = value;</xsl:text>
		<xsl:text>OnPropertyChanged("</xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>");</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="attribute[contains(@name,'_id')='true']" mode="generate-attribute-get-and-set">
		<xsl:variable name="name" select="./@name" />
		<xsl:text>private </xsl:text>
		<xsl:value-of select="@type-short-name" />
		<xsl:text> _</xsl:text><xsl:value-of select="@name" /><xsl:text>;&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="@type-short-name" />
		<xsl:text> </xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>&#13;</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>get { return _</xsl:text><xsl:value-of select="@name" /><xsl:text>; }&#13;</xsl:text>
		<xsl:text>set{_</xsl:text><xsl:value-of select="@name" /><xsl:text> = value;</xsl:text>
		<xsl:text>OnPropertyChanged("</xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>");</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<!-- JCO MODIFICATION START -->
	<!--<xsl:template match="attribute[@enum='true']" mode="generate-attribute-get-and-set">
		<xsl:variable name="name" select="./@name" />
		<xsl:text>private </xsl:text><xsl:value-of select="@type-short-name" /><xsl:text> _</xsl:text><xsl:value-of select="@name" /><xsl:text>;&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="@type-short-name" /><xsl:text> </xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>&#13;</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>get { return _</xsl:text><xsl:value-of select="@name" /><xsl:text>; }&#13;</xsl:text>
		<xsl:text>set{_</xsl:text><xsl:value-of select="@name" /><xsl:text> = value;</xsl:text>
		<xsl:text>OnPropertyChanged("</xsl:text><xsl:value-of select="@name-capitalized" /><xsl:text>");</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>-->
	<!-- JCO MODIFICATION END -->

</xsl:stylesheet>