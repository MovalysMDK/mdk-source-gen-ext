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

<xsl:include href="action/action-savedetail-itf.xsl"/>
<xsl:include href="action/action-deletedetail-itf.xsl"/>

<xsl:template match="master-action-interface">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="action-interface/name"/>.h</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-protocol-imports"/>

@interface <xsl:value-of select="action-interface/name"/>
	<xsl:text> : &#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">class-signature</xsl:with-param>
		<xsl:with-param name="defaultSource"><xsl:apply-templates select="." mode="actionInherit"/>&#13;</xsl:with-param>
	</xsl:call-template>	
	
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

FOUNDATION_EXPORT NSString *const MFAction_<xsl:value-of select="action-interface/name"/> ;

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end
 
</xsl:template>


<xsl:template match="master-action-interface" mode="declare-extra-imports">
	<!-- 
	<objc-import category="FRAMEWORK" class="MFCsvLoaderHelper" header="MFCsvLoaderHelper.h" scope="local"/>
	 -->
</xsl:template>

</xsl:stylesheet>