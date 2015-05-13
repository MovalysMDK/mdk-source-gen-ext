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
* GET BY ID (INTERFACE)
* -->
<xsl:template match="dao-interface" mode="getById-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Get <xsl:value-of select="$entityName"/> by identifier
 * @param identifier
 * @return <xsl:value-of select="$entityName"/>
 */
+(<xsl:value-of select="$entityName"/> *) MF_findByIdentifier:(NSNumber *) identifier inContext:(id&lt;MFContextProtocol&gt;) mfContext;


/**
 * @brief Get <xsl:value-of select="$entityName"/> by identifier
 * @param identifier identifier
 * @param fetchOptions fetchOptions
 * @return <xsl:value-of select="$entityName"/>
 */
+ (<xsl:value-of select="$entityName"/> *) MF_findByIdentifier:(NSNumber *)identifier withFetchOptions:(MFFetchOptions *)fetchOptions
        inContext:(id&lt;MFContextProtocol&gt;)mfContext;
</xsl:template>

<!-- 
* GET BY ID (IMPLEMENTATION)
* -->
<xsl:template match="dao" mode="getById-daoimpl">
	<xsl:param name="entityName"/>
 +(<xsl:value-of select="$entityName"/> *) MF_findByIdentifier:(NSNumber *) identifier inContext:(id&lt;MFContextProtocol&gt;) mfContext {
 	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_findByIdentifier</xsl:with-param>
		<xsl:with-param name="defaultSource">
	return [<xsl:value-of select="$entityName"/> MF_findByIdentifier:identifier withFetchOptions:nil inContext:mfContext];
		</xsl:with-param>
	</xsl:call-template>
}


+ (<xsl:value-of select="$entityName"/> *) MF_findByIdentifier:(NSNumber *)identifier withFetchOptions:(MFFetchOptions *)fetchOptions
       inContext:(id&lt;MFContextProtocol&gt;)mfContext
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_findByIdentifierWithFetchOptions</xsl:with-param>
		<xsl:with-param name="defaultSource">
    NSFetchRequest *request = [<xsl:value-of select="$entityName"/> MR_requestFirstByAttribute:<xsl:value-of select="$entityName"/>Properties.identifier
        withValue:identifier inContext:mfContext.entityContext];
    [self MF_applyFetchOptions:fetchOptions onFetchRequest:request];
	return [<xsl:value-of select="$entityName"/> MR_executeFetchRequestAndReturnFirstObject:request inContext:mfContext.entityContext];
		</xsl:with-param>
	</xsl:call-template>
}

</xsl:template>

</xsl:stylesheet>