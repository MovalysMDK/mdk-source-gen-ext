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
* GET ARRAY OF IDS (INTERFACE)
* -->

<xsl:template match="dao-interface" mode="getListIds-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Get all ids of <xsl:value-of select="$entityName"/>
 * @return array of all ids of <xsl:value-of select="$entityName"/>
 */
+ (NSArray *) MF_findIdsInContext:(id&lt;MFContextProtocol&gt;) mfContext ;
</xsl:template>


<!-- 
* GET ARRAY OF IDS (IMPLEMENTATION)
* -->

<xsl:template match="dao" mode="getListIds-daoimpl">
	<xsl:param name="entityName"/>
+ (NSArray *) MF_findIdsInContext:(id&lt;MFContextProtocol&gt;) mfContext
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_findIdsInContext</xsl:with-param>
		<xsl:with-param name="defaultSource">
    NSFetchRequest *request = [self MR_createFetchRequestInContext:mfContext.entityContext];
    [request setPropertiesToFetch: @[<xsl:value-of select="$entityName"/>Properties.identifier]];
    [request setResultType:NSDictionaryResultType];
    NSArray *fetchedObjects = [self MR_executeFetchRequest:request inContext:mfContext.entityContext];
    NSMutableArray *ids = [NSMutableArray array];
    for (NSManagedObject *fetchedObject in fetchedObjects) {
        [ids addObject:[fetchedObject valueForKey: <xsl:value-of select="$entityName"/>Properties.identifier]];
    }
    return ids;
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>

</xsl:stylesheet>

