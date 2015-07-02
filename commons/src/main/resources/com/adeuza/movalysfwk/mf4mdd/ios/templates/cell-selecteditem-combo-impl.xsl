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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="text"/>

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/constants.xsl"/>

<xsl:include href="ui/storyboard/views/view-mftextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfposition.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfemailtextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfurltextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfphonetextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mflabel.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfscanner.xsl"/>

<xsl:template match="controller[@controllerType='COMBOVIEW']">
<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="selectedItemCellClassName"/>.m</xsl:with-param>
</xsl:apply-templates>

#import "<xsl:value-of select="selectedItemCellClassName"/>.h"

<xsl:apply-templates select="." mode="declare-impl-imports"/>

<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="selectedItemCellClassName"/>()<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-extension</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;@end&#13;</xsl:text>

<xsl:text>&#13;@implementation </xsl:text><xsl:value-of select="selectedItemCellClassName"/> {
<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">instance-variables</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;</xsl:text>
}

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
</xsl:call-template>

<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>


-(id)valueForUndefinedKey:(NSString *)key {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">valueForUndefinedKey</xsl:with-param>
		<xsl:with-param name="defaultSource">
		// Initialization code
		</xsl:with-param>
	</xsl:call-template>  
    return nil;
}

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end
</xsl:template>

</xsl:stylesheet>