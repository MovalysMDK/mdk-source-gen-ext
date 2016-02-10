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
* DELETE BY INTERFACE
* -->
<xsl:template match="method-signature[@type='deleteEntite' and @by-value='false']" mode="method-signature-for-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Delete <xsl:value-of select="$entityName"/> matching <xsl:apply-templates select="method-parameter" mode="doxygen-method-brief"/>
 <xsl:text>&#13;</xsl:text>
<xsl:apply-templates select="method-parameter" mode="doxygen-method-param"/>
 */
<xsl:text>+ (void) MF_deleteBy</xsl:text>
<xsl:apply-templates select="method-parameter" mode="method-signature"/>
<xsl:text> inContext:(id&lt;MFContextProtocol&gt;) mfContext ;&#13;&#13;</xsl:text>
</xsl:template>


<!-- 
* DELETE BY IMPLEMENTATION
* -->
<xsl:template match="method-signature[@type='deleteEntite' and @by-value='false']" mode="method-signature-for-daoimpl">
	<xsl:param name="entityName"/>
// <xsl:value-of select="@name"/>
//
<xsl:text>+ (void) MF_deleteBy</xsl:text>
<xsl:apply-templates select="method-parameter" mode="method-signature"/>
<xsl:text> inContext:(id&lt;MFContextProtocol&gt;) mfContext</xsl:text>
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_deleteBy</xsl:with-param>
		<xsl:with-param name="defaultSource">

	<xsl:apply-templates select="method-parameter" mode="compute-predicate">
		<xsl:with-param name="entityName" select="$entityName"/>
	</xsl:apply-templates>
	<xsl:if test="count(method-parameter) = 1">
		<xsl:text>NSPredicate *deletePredicate = p1;&#13;</xsl:text>
	</xsl:if>
	
	<xsl:if test="count(method-parameter) > 1">
		<xsl:text>NSPredicate *deletePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[</xsl:text>
		<xsl:for-each select="method-parameter">
			<xsl:text>p</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>]];&#13;</xsl:text>
	</xsl:if>
	
	[self MR_deleteAllMatchingPredicate:deletePredicate inContext: [mfContext entityContext]];
	
		</xsl:with-param>
	</xsl:call-template>
}
</xsl:template>

</xsl:stylesheet>