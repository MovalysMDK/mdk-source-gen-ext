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

<xsl:include href="dao/dao-method-parameter.xsl"/>

<xsl:include href="dao/dao-getby.xsl"/>
<xsl:include href="dao/dao-getbyid.xsl"/>
<xsl:include href="dao/dao-getid.xsl"/>
<xsl:include href="dao/dao-getlistby.xsl"/>

<xsl:include href="dao/dao-existbyid.xsl"/>
<xsl:include href="dao/dao-existby.xsl"/>

<xsl:include href="dao/dao-getnbby.xsl"/>

<xsl:include href="dao/dao-delete.xsl"/>
<xsl:include href="dao/dao-deleteby.xsl"/>
<xsl:include href="dao/dao-deletebyid.xsl"/>

<xsl:include href="dao/dao-predicate.xsl"/>

<xsl:template match="dao">

<xsl:variable name="entityName"><xsl:value-of select="class/name"/></xsl:variable>

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-impl-imports"/>

<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="$entityName"/>()<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-extension</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;@end&#13;</xsl:text>


@implementation <xsl:value-of select="$entityName"/>
<xsl:text> (Dao)&#13;&#13;</xsl:text>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
</xsl:call-template>


<xsl:apply-templates select="." mode="getById-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="." mode="existById-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="count-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->
<xsl:apply-templates select="." mode="getListIds-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="getList-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->

<xsl:apply-templates select="." mode="delete-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="deleteAll-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->
<xsl:apply-templates select="." mode="deleteById-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="deleteList-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->

<xsl:apply-templates select="method-signature" mode="method-signature-for-daoimpl">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

</xsl:template>



<!-- 
* Not implemented methods
* -->
<xsl:template match="method-signature" mode="method-signature-for-daoimpl">
	<xsl:text>&#13;&#13;</xsl:text>
	<xsl:text>// Not implemented: </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text> type: </xsl:text>
	<xsl:value-of select="@type"/>
	<xsl:text> byValue: </xsl:text>
	<xsl:value-of select="@by-value"/>
	<xsl:text>&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="node()" mode="declare-extra-imports">
	<objc-import category="FRAMEWORK" class="MFContextProtocol" header="MFContextProtocol.h" scope="local"/>
</xsl:template>

</xsl:stylesheet>