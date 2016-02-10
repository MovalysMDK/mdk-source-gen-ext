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
* DELETE BY ID (INTERFACE)
* -->
<xsl:template match="dao-interface" mode="deleteById-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Delete <xsl:value-of select="$entityName"/> by identifier
 * @param identifier identifier of entity to delete
 */
+(void) MF_deleteByIdentifier:(NSNumber *)identifier inContext:(id&lt;MFContextProtocol&gt;) mfContext;
</xsl:template>


<!-- 
* DELETE BY ID (IMPLEMENTATION)
* -->
<xsl:template match="dao" mode="deleteById-daoimpl">
	<xsl:param name="entityName"/>
+(void) MF_deleteByIdentifier:(NSNumber *)identifier inContext:(id&lt;MFContextProtocol&gt;) mfContext {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_deleteByIdentifier</xsl:with-param>
		<xsl:with-param name="defaultSource">
	NSPredicate *deletePredicate = [NSPredicate MF_createPredicateWithProperty:<xsl:value-of select="$entityName"/>Properties.identifier equalsToValue:identifier];    
    [self MR_deleteAllMatchingPredicate:deletePredicate inContext: [mfContext entityContext]];
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>

</xsl:stylesheet>