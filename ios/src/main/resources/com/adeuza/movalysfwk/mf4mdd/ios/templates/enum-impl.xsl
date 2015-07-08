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

<xsl:template match="enum">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
	</xsl:apply-templates>

	<xsl:apply-templates select="." mode="declare-impl-imports"/>

@implementation <xsl:value-of select="name"/>Helper

+ (NSString *)textFromEnum:(NSNumber *)nsnEnum
{
	NSString *text = nil;
        
	switch([nsnEnum intValue]) {
		<xsl:apply-templates select="enum-values/value" mode="switchCaseForEnum"/>
		default:
		  text = @"NONE";
          break;
	}
	return text;
}

+ (int) enumFromText:(NSString *) sText
{
	<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="name-uncapitalized"/>
	<xsl:text> = </xsl:text><xsl:value-of select="name-uppercase"/><xsl:text>_NONE</xsl:text><xsl:text>;&#13;</xsl:text>

	<xsl:apply-templates select="enum-values/value" mode="compareWithText"/>

	return <xsl:value-of select="name-uncapitalized"/>;
}

+ (NSArray *) valuesToTexts
{
	return [NSArray arrayWithObjects: <xsl:apply-templates select="enum-values/value" mode="arrayFromEnum"/> nil];
}

+ (NSUInteger) valuesCount
{
	return [[self valuesToTexts] count];
}

@end

</xsl:template>

<xsl:template match="value" mode="switchCaseForEnum">
		case <xsl:value-of select="../../name-uppercase"/><xsl:text>_</xsl:text><xsl:value-of select="."/>:
			text = @"<xsl:value-of select="."/>";
			break;
</xsl:template>

<xsl:template match="value" mode="compareWithText">
<xsl:text>if ( [@"</xsl:text><xsl:value-of select="."/>
<xsl:text>" isEqualToString: sText</xsl:text><xsl:text>] )&#13;</xsl:text>
<xsl:text>	{&#13;</xsl:text>
		<xsl:value-of select="../../name-uncapitalized"/> = <xsl:value-of select="../../name-uppercase"/><xsl:text>_</xsl:text><xsl:value-of select="."/><xsl:text>;&#13;</xsl:text>
<xsl:text>	}&#13;</xsl:text>
	<xsl:if test="position() != last()">
		<xsl:text>	else </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="value" mode="arrayFromEnum">
<xsl:text>@"</xsl:text><xsl:value-of select="."/><xsl:text>",</xsl:text>
</xsl:template>


<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

</xsl:stylesheet>