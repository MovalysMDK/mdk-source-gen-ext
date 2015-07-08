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

<xsl:template match="factory">
	<xsl:apply-templates select="class" mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="class/name"/>+Factory.h</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	
	<xsl:apply-templates select="class"/>
</xsl:template>

<xsl:template match="class">

<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="name"/>()<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-extension</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;@end&#13;</xsl:text>

/**
 * @category <xsl:value-of select="name"/>(Factory) 
 * @abstract Category Factory on <xsl:value-of select="name"/>
 */
@interface <xsl:value-of select="name"/> (Factory) &#13;
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-signature</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<!-- 
/**
 * @brief Create a new instance of <xsl:value-of select="name"/>
 * @return new instance of <xsl:value-of select="name"/>
 */
+(<xsl:value-of select="name"/>*) MF_create<xsl:value-of select="name"/> ;
 -->
/**
 * @brief Create a new instance of <xsl:value-of select="name"/> using MFContext
 * @param context MFContext
 * @return new instance of <xsl:value-of select="name"/>
 */
+ (<xsl:value-of select="name"/> *) MF_create<xsl:value-of select="name"/>InContext:(id&lt;MFContextProtocol&gt;)context;

<xsl:if test="transient != 'true'">
/**
 * @brief Create a new instance of <xsl:value-of select="name"/> using MFContext and the data contains in the dictionary
 * @param dictionary NSDictionary data to initialize object
 * @param context MFContext
 * @return new instance of <xsl:value-of select="name"/>
 */
+ (<xsl:value-of select="name"/> *) MF_create<xsl:value-of select="name"/>WithDictionary:(NSDictionary*)dictionary inContext:(id&lt;MFContextProtocol&gt;)context ;
</xsl:if>

<xsl:for-each select="association[@type='many-to-many']">
/**
 * @brief Fill the variable <xsl:value-of select="@name-capitalized"/> of the instance <xsl:value-of select="name"/> using MFContext and the identifier contains in the dictionary 
 * @param dictionary NSDictionary string data contains identifier of entities to complete the instance in the context
 * @param context MFContext entity context to search and modify the entity 
 */ 
+ (void) MF_fill<xsl:value-of select="@name-capitalized"/>WithDictionary:(NSDictionary*)dictionary inContext:(id&lt;MFContextProtocol&gt;)context;
</xsl:for-each>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

</xsl:template>


<xsl:template match="factory" mode="declare-extra-imports">
	<objc-import category="FRAMEWORK" class="MFContextProtocol" header="MFContextProtocol.h" scope="local"/>
</xsl:template>

</xsl:stylesheet>