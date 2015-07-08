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
<xsl:include href="dao/dao-getid.xsl"/>
<xsl:include href="dao/dao-getbyid.xsl"/>
<xsl:include href="dao/dao-getlistby.xsl"/>
<xsl:include href="dao/dao-existbyid.xsl"/>
<xsl:include href="dao/dao-existby.xsl"/>

<xsl:include href="dao/dao-getnbby.xsl"/>

<xsl:include href="dao/dao-delete.xsl"/>
<xsl:include href="dao/dao-deleteby.xsl"/>
<xsl:include href="dao/dao-deletebyid.xsl"/>

<xsl:include href="dao/dao-predicate.xsl"/>


  
  
<xsl:template match="dao-interface">

 
<xsl:variable name="entityName"><xsl:value-of select="dao/class/name"/></xsl:variable>

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.h</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-protocol-imports"/>

/**
 * @category <xsl:value-of select="$entityName"/>(Dao) 
 * @abstract Category Dao on <xsl:value-of select="$entityName"/>
 */ 
<xsl:text>@interface </xsl:text><xsl:value-of select="$entityName"/><xsl:text> (Dao)&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-signature</xsl:with-param>
	<xsl:with-param name="defaultSource"><xsl:value-of select="/*/non-generated/bloc[@id='class-signature']"/></xsl:with-param>
</xsl:call-template>


<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<xsl:apply-templates select="." mode="getById-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="." mode="existById-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="count-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->
<xsl:apply-templates select="." mode="getListIds-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="getList-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->

<xsl:apply-templates select="." mode="delete-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="deleteAll-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->
<xsl:apply-templates select="." mode="deleteById-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
<!-- 
<xsl:apply-templates select="." mode="deleteList-daointerface">
	<xsl:with-param name="entityName"><xsl:value-of select="$entityName"/></xsl:with-param>
</xsl:apply-templates>
 -->

<xsl:apply-templates select="dao/method-signature" mode="method-signature-for-daointerface">
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
<xsl:template match="method-signature" mode="method-signature-for-daointerface">
	// Not implemented: <xsl:value-of select="@name"/> type: <xsl:value-of select="@type"/> byValue: <xsl:value-of select="@by-value"/>
</xsl:template>


<xsl:template match="node()" mode="declare-extra-imports">
	<objc-import category="FRAMEWORK" class="MFContextProtocol" header="MFContextProtocol.h" scope="local"/>
</xsl:template>


</xsl:stylesheet>