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

<!--
* Declaration of parameters of type attribute in signature of method
* -->
<xsl:template match="method-parameter[attribute]" mode="method-signature">
	<xsl:if test="position() = 1">
		<xsl:value-of select="@name-capitalized"/>
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> *)</xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:if>
	<xsl:if test="position() > 1">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> *)</xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:if>
</xsl:template>

<!--
* Declaration of parameters of type association in signature of method
* -->
<xsl:template match="method-parameter[association and count(association/attribute) = 1]" mode="method-signature">
	<xsl:variable name="paramNamecapitalized"><xsl:value-of select="@name-capitalized"/><xsl:value-of select="association/attribute/@name"/></xsl:variable>
	<xsl:variable name="paramName"><xsl:value-of select="@name"/><xsl:value-of select="association/attribute/@name"/></xsl:variable>
	<xsl:if test="position() = 1">
		<xsl:value-of select="$paramNamecapitalized"/>
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="association/attribute/@type-short-name"/>
		<xsl:text> *)</xsl:text>
		<xsl:value-of select="$paramName"/>
	</xsl:if>
	<xsl:if test="position() > 1">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$paramNamecapitalized"/>
		<xsl:text>:(</xsl:text>
		<xsl:value-of select="association/attribute/@type-short-name"/>
		<xsl:text> *)</xsl:text>
		<xsl:value-of select="$paramName"/>
	</xsl:if>
</xsl:template>

<!--
* Parameters for method invocation
* -->
<xsl:template match="method-parameter[attribute]" mode="parameter-for-method-invocation">
	<xsl:if test="position() = 1">
		<xsl:value-of select="@name-capitalized"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:if>
	<xsl:if test="position() > 1">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:if>
</xsl:template>

<!--
* Declaration of parameters of type association in signature of method
* -->
<xsl:template match="method-parameter[association and count(association/attribute) = 1]" mode="parameter-for-method-invocation">
	<xsl:variable name="paramNamecapitalized"><xsl:value-of select="@name-capitalized"/><xsl:value-of select="association/attribute/@name"/></xsl:variable>
	<xsl:variable name="paramName"><xsl:value-of select="@name"/><xsl:value-of select="association/attribute/@name"/></xsl:variable>
	<xsl:if test="position() = 1">
		<xsl:value-of select="$paramNamecapitalized"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="$paramName"/>
	</xsl:if>
	<xsl:if test="position() > 1">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$paramName"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="$paramName"/>
	</xsl:if>
</xsl:template>

<!--
* Non-implemented declaration of parameters in signature of method
* -->
<xsl:template match="method-parameter" mode="method-signature">
</xsl:template>

<!--
* Doxygen for parameters of dao method
* -->
<xsl:template match="method-parameter" mode="doxygen-method-param">
	<xsl:text> * @param </xsl:text><xsl:value-of select="@name"/>
	<xsl:text> </xsl:text>criteria <xsl:value-of select="@name"/>
	<xsl:text>&#13;</xsl:text>
</xsl:template>

<!--
* Doxygen for parameters of dao method
* -->
<xsl:template match="method-parameter" mode="doxygen-method-brief">
	<xsl:value-of select="@name"/>
	<xsl:if test="position() != last()">
		<xsl:text> and </xsl:text>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>