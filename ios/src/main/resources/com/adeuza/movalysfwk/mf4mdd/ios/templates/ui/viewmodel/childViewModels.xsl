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

<xsl:template match="viewmodel[type/is-list = 'true']" mode="getChildViewModels-method">
</xsl:template>

<xsl:template match="viewmodel" mode="getChildViewModels-method">
-(NSArray *)getChildViewModels {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">getChildViewModels</xsl:with-param>
	<xsl:with-param name="defaultSource">
    	<xsl:apply-templates select="." mode="getChildViewModels-method-body"/>
    </xsl:with-param>
 </xsl:call-template>
}
</xsl:template>

<xsl:template match="viewmodel" mode="getPropertyNameInParent-method">
	<xsl:if test="parent-viewmodel">
	<xsl:text>-(NSString *)propertyNameInParentViewModel {&#13;</xsl:text>
	<xsl:text>return @"</xsl:text>
	<xsl:value-of select="property-name"/>
	<xsl:text>";&#13;</xsl:text>
	}
	</xsl:if>
</xsl:template>

<xsl:template match="viewmodel" mode="getChildViewModels-method-body">
	NSMutableArray *result = [[NSMutableArray alloc] init];
	<xsl:for-each select="subvm/viewmodel">
    	if ( self.<xsl:value-of select="property-name"/> != nil ) {
        	[result addObject:self.<xsl:value-of select="property-name"/>];
    	}
	</xsl:for-each>
	<xsl:text>return result;&#13;</xsl:text>
</xsl:template>

<!--
Sous viewmodels : return @[self.mVMAgencyPanel, self.mVMAgencyPanelDetail];
 -->

</xsl:stylesheet>