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

<xsl:template match="method-signature/method-parameter[attribute]" mode="compute-predicate">
	<xsl:param name="entityName"/>
	<xsl:text>NSPredicate *p</xsl:text><xsl:value-of select="position()"/>
	<xsl:text> = [NSPredicate MF_createPredicateWithProperty: </xsl:text>
	<xsl:value-of select="$entityName"/>Properties.<xsl:value-of select="attribute/@name"/>
	<xsl:text> equalsToValue: </xsl:text><xsl:value-of select="@name"/>
	<xsl:text>];&#13;</xsl:text>
</xsl:template>

<xsl:template match="method-signature/method-parameter[association/attribute and count(association/attribute) = 1]" mode="compute-predicate">
	<xsl:param name="entityName"/>
	<xsl:variable name="paramName"><xsl:value-of select="@name"/><xsl:value-of select="association/attribute/@name"/></xsl:variable>
	
	<xsl:text>NSString *keyPath</xsl:text><xsl:value-of select="position()"/><xsl:text> = [NSPredicate MF_keyPathForAsso:</xsl:text>
	<xsl:value-of select="$entityName"/><xsl:text>Properties.</xsl:text><xsl:value-of select="association/@name"/><xsl:text> andAttribute: </xsl:text>
	<xsl:value-of select="association/interface/name"/><xsl:text>Properties.</xsl:text>
	<xsl:value-of select="association/attribute/@name"/><xsl:text>];&#13;</xsl:text>
	
    <xsl:text>NSPredicate *p</xsl:text><xsl:value-of select="position()"/>
    <xsl:text> = [NSPredicate MF_create</xsl:text>
    <xsl:if test="association/@type = 'one-to-many' or association/@type = 'many-to-many'">
		<xsl:text>Contains</xsl:text>
	</xsl:if>
    <xsl:text>PredicateWithProperty: keyPath</xsl:text><xsl:value-of select="position()"/>
    <xsl:text> equalsToValue: </xsl:text><xsl:value-of select="$paramName"/><xsl:text>];&#13;</xsl:text>
</xsl:template>

<xsl:template match="method-parameter" mode="compute-predicate">
</xsl:template>

</xsl:stylesheet>