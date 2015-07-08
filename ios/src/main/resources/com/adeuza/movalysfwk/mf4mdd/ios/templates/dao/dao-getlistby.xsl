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
* GET LIST ENTITY INTERFACE
* -->
<xsl:template match="method-signature[@type='getListEntite' and @by-value='false']" mode="method-signature-for-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Get array of <xsl:value-of select="$entityName"/> matching <xsl:apply-templates select="method-parameter" mode="doxygen-method-brief"/>
 <xsl:text>&#13;</xsl:text>
<xsl:apply-templates select="method-parameter" mode="doxygen-method-param"/>
 * @return Array of <xsl:value-of select="$entityName"/>
 */
<xsl:text>+ (NSArray *) MF_findBy</xsl:text>
<xsl:apply-templates select="method-parameter" mode="method-signature"/>
<xsl:text> inContext:(id&lt;MFContextProtocol&gt;) mfContext ;&#13;&#13;</xsl:text>
</xsl:template>


<!-- 
* GET LIST ENTITY IMPLEMENTATION
* -->
<xsl:template match="method-signature[@type='getListEntite' and @by-value='false']" mode="method-signature-for-daoimpl">
	<xsl:param name="entityName"/>
// <xsl:value-of select="@name"/>
//	
<xsl:text>+ (NSArray *) MF_findBy</xsl:text>
<xsl:apply-templates select="method-parameter" mode="method-signature"/>
<xsl:text> inContext:(id&lt;MFContextProtocol&gt;) mfContext</xsl:text>
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_findBy</xsl:with-param>
		<xsl:with-param name="defaultSource">
    return [self MF_findBy<xsl:apply-templates select="method-parameter" mode="parameter-for-method-invocation"/> withFetchOptions:nil inContext:mfContext];
    	</xsl:with-param>
    </xsl:call-template>
}

<xsl:text>+ (NSArray *) MF_findBy</xsl:text>
<xsl:apply-templates select="method-parameter" mode="method-signature"/>
<xsl:text> withFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id&lt;MFContextProtocol&gt;) mfContext</xsl:text>
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_findByWithFetchOptions</xsl:with-param>
		<xsl:with-param name="defaultSource">
	<xsl:apply-templates select="method-parameter" mode="compute-predicate">
		<xsl:with-param name="entityName" select="$entityName"/>
	</xsl:apply-templates>
	
	<xsl:text>NSFetchRequest *request = [self MR_createFetchRequestInContext:mfContext.entityContext];&#13;</xsl:text>
	<xsl:if test="count(method-parameter) = 1">
		<xsl:text>[request setPredicate:p1];&#13;</xsl:text>
	</xsl:if>
	
	<xsl:if test="count(method-parameter) > 1">
		<xsl:text>NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[</xsl:text>
		<xsl:for-each select="method-parameter">
			<xsl:text>p</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>]];&#13;</xsl:text>
		<xsl:text>[request setPredicate:predicate];&#13;</xsl:text>
	</xsl:if>
	
	<xsl:text>[self MF_applyFetchOptions:fetchOptions onFetchRequest:request];&#13;</xsl:text>
    
    <xsl:text>return [self MR_executeFetchRequest:request inContext:mfContext.entityContext];&#13;</xsl:text>
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>

</xsl:stylesheet>