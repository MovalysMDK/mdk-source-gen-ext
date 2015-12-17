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

	<xsl:include href="commons/file-header.xsl"/>
	<xsl:include href="commons/imports.xsl"/>
	<xsl:include href="commons/non-generated.xsl"/>
	<xsl:include href="commons/constants.xsl"/>

	<xsl:template match="enum">
<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.h</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-impl-imports"/>
#import "MDKEnumHelperProtocol.h"

typedef enum <xsl:value-of select="name"/>: int16_t {
<xsl:value-of select="name-uppercase"/><xsl:text>_</xsl:text><xsl:text>NONE = 0</xsl:text>
<xsl:apply-templates select="enum-values/value"/>
} <xsl:value-of select="name"/> ;	


@interface <xsl:value-of select="name"/>Helper : NSObject<xsl:text disable-output-escaping="yes">&lt;MDKEnumHelperProtocol&gt;</xsl:text>

@end
	</xsl:template>
	
	
	
	<xsl:template match="value">
		<xsl:text>,&#13;</xsl:text>
		<xsl:value-of select="../../name-uppercase"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text> = </xsl:text><xsl:value-of select="position()"/>
	</xsl:template>
	
	<xsl:template match="node()" mode="declare-extra-imports">
	<objc-import class="Foundation" header="Foundation/Foundation.h" scope="global"/>
	</xsl:template>
</xsl:stylesheet>