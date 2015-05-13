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
	
<!-- 
ROOT TEMPLATE
-->
<xsl:template match="/master-typhoonassembly/typhoon-config">

	<xsl:apply-templates select=".." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
	</xsl:apply-templates>
	
<xsl:text>
#import "MFFrameworkComponentsAssembly.h" &#13;
#import "</xsl:text>
<xsl:value-of select="name"/>
<xsl:text>.h"&#13;</xsl:text>
	
	<xsl:apply-templates select="./component" mode="generate-imports"/>
		
	<xsl:text>&#13;&#13;@implementation </xsl:text><xsl:value-of select="name"/><xsl:text>&#13;&#13;</xsl:text>
	
	<xsl:apply-templates select="./component" mode="generate-methods"/>
	
	<xsl:text>@end</xsl:text>
	
</xsl:template>



<xsl:template match="component"  mode="generate-imports">

<xsl:text>#import "</xsl:text>
<xsl:value-of select="./config/class"></xsl:value-of>
<xsl:text>.h"&#13;</xsl:text>

</xsl:template>




<xsl:template match="component"  mode="generate-methods">

<xsl:text>- (id) </xsl:text>
<xsl:value-of select="./config/key"></xsl:value-of>
<xsl:text> {&#13;</xsl:text>
<xsl:text>return [TyphoonDefinition withClass:[</xsl:text>
<xsl:value-of select="./config/class"></xsl:value-of>
<xsl:text> class] configuration:^(TyphoonDefinition * definition) {&#13;</xsl:text>
<xsl:text>definition.scope = </xsl:text>
<xsl:choose>
  <xsl:when test="./config/scope = 'singleton'">
  <xsl:text>TyphoonScopeSingleton;&#13;</xsl:text>
  </xsl:when>
  <xsl:when test="./config/scope = 'prototype'">
  <xsl:text>TyphoonScopePrototype;&#13;</xsl:text>
  </xsl:when>
 </xsl:choose>
<xsl:text>}];&#13;</xsl:text>
<xsl:text>}&#13;&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>