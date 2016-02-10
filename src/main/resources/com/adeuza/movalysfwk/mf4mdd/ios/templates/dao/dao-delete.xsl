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
* DELETE (INTERFACE)
* -->

<xsl:template match="dao-interface" mode="delete-daointerface">
	<xsl:param name="entityName"/>
/**
 * @brief Delete a <xsl:value-of select="$entityName"/>
 * @param entity <xsl:value-of select="$entityName"/> to delete
 * @param inContext context
 */
+ (void) MF_delete:(<xsl:value-of select="$entityName"/> *)entity inContext:(id&lt;MFContextProtocol&gt;) mfContext ;
</xsl:template>


<!-- 
* DELETE (IMPLEMENTATION)
* -->

<xsl:template match="dao" mode="delete-daoimpl">
	<xsl:param name="entityName"/>
+ (void) MF_delete:(<xsl:value-of select="$entityName"/> *)entity inContext:(id&lt;MFContextProtocol&gt;) mfContext 
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_delete</xsl:with-param>
		<xsl:with-param name="defaultSource">	
    		<xsl:text>[entity MR_deleteInContext: [mfContext entityContext]];&#13;</xsl:text>
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>


</xsl:stylesheet>