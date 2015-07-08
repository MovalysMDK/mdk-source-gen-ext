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
* EXIST BY ID (INTERFACE)
* -->
<xsl:template match="dao-interface" mode="existById-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Exist <xsl:value-of select="$entityName"/> by identifier
 * @param identifier
 * @return true if <xsl:value-of select="$entityName"/> exists
 */
+(BOOL) MF_existByIdentifier:(NSNumber *) identifier inContext:(id&lt;MFContextProtocol&gt;) mfContext;
</xsl:template>


<!-- 
* EXIST BY ID (IMPLEMENTATION)
* -->
<xsl:template match="dao" mode="existById-daoimpl">
	<xsl:param name="entityName"/>
+(BOOL) MF_existByIdentifier:(NSNumber *) identifier inContext:(id&lt;MFContextProtocol&gt;) mfContext {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_existBIdentifier</xsl:with-param>
		<xsl:with-param name="defaultSource">
	NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:<xsl:value-of select="$entityName"/>Properties.identifier equalsToValue:identifier];
    return [self MR_countOfEntitiesWithPredicate: p1 inContext:mfContext.entityContext] > 0 ;
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>

</xsl:stylesheet>