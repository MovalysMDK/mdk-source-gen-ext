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

<xsl:template match="class">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="name" mode="import"/>

const struct <xsl:value-of select="name"/>Properties_Struct <xsl:value-of select="name"/><xsl:text>Properties = {&#13;</xsl:text>
	<xsl:text>	.EntityName = @"</xsl:text><xsl:value-of select="name"/><xsl:text>"</xsl:text>
	<xsl:if test="count(//*[(name() = 'attribute' or name()= 'association') and not(ancestor::association)]) > 0">
		<xsl:text>,&#13;</xsl:text>
	</xsl:if>
<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(ancestor::association)]">
    <xsl:text>	.</xsl:text><xsl:value-of select="@name"/><xsl:text> = @"</xsl:text><xsl:value-of select="@name"/><xsl:text>"</xsl:text>
    <xsl:if test="position() != last()">
    	<xsl:text>,&#13;</xsl:text>
    </xsl:if>
</xsl:for-each>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-structproperties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
};

<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="name"/>()<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-extension</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;@end&#13;</xsl:text>

<xsl:text>&#13;@implementation </xsl:text><xsl:value-of select="name"/> {
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

<xsl:text>&#13;</xsl:text>

<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(ancestor::association)]">
<xsl:text>@dynamic </xsl:text><xsl:value-of select="@name"/><xsl:text>;&#13;</xsl:text>
</xsl:for-each>


<xsl:if test="transient != 'true'">
-(void) willSave {
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">willSave</xsl:with-param>
		<xsl:with-param name="defaultSource">
			if ([self.identifier intValue] == -1 ) {
        		self.identifier = [[[MFApplication getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER] nextIdForEntity:<xsl:value-of select="name"/>Properties.EntityName];
    		}
    	</xsl:with-param>
    </xsl:call-template>
}

- (void) awakeFromInsert
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">awakeFromInsert</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="attribute" mode="initTransientMandatoryAttr"/>
		</xsl:with-param>
	</xsl:call-template>
}
</xsl:if>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-messages</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-part</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

</xsl:template>

<xsl:template match="attribute[@transient = 'true' and @nullable = 'false']" mode="initTransientMandatoryAttr">
	self.<xsl:value-of select="@name"/><xsl:text> = </xsl:text>
	<xsl:apply-templates select="." mode="defaultValueForTransientMandatoryAttr"/>
	<xsl:text>;&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="initTransientMandatoryAttr">
</xsl:template>

<xsl:template match="attribute[@type-short-name = 'NSString']" mode="defaultValueForTransientMandatoryAttr">
	<xsl:text>nil;&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="defaultValueForTransientMandatoryAttr">
	<xsl:text>nil;&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>