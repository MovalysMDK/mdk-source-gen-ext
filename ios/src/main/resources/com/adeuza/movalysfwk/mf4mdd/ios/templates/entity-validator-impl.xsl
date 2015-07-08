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

<xsl:key name="uniqueConstraints" match="validator/class/attribute | validator/class/association" use="@unique-key" />


<xsl:template match="validator">

<xsl:apply-templates select="class" mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="class/name"/>+Validate.m</xsl:with-param>
</xsl:apply-templates>


<xsl:apply-templates select="." mode="declare-impl-imports"/>

<xsl:apply-templates select="class"/>

</xsl:template>


<xsl:template match="class">

<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="name"/>()<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-extension</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;@end&#13;</xsl:text>

@implementation <xsl:value-of select="name"/> (Validate)

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
</xsl:call-template>

<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>


- (BOOL)validateForInsert:(NSError **)error
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">validateForInsert</xsl:with-param>
		<xsl:with-param name="defaultSource">
    		<xsl:text>BOOL propertiesValid = [super validateForInsert:error];&#13;</xsl:text>
    		<xsl:text>BOOL consistencyValid = [self validateConsistency:error];&#13;</xsl:text>
    		<xsl:text>return (propertiesValid &amp;&amp; consistencyValid);&#13;</xsl:text>
    	</xsl:with-param>
    </xsl:call-template>
}
 
- (BOOL)validateForUpdate:(NSError **)error
{
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">validateForUpdate</xsl:with-param>
		<xsl:with-param name="defaultSource">
    		<xsl:text>BOOL propertiesValid = [super validateForUpdate:error];&#13;</xsl:text>
    		<xsl:text>BOOL consistencyValid = [self validateConsistency:error];&#13;</xsl:text>
    		<xsl:text>return (propertiesValid &amp;&amp; consistencyValid);&#13;</xsl:text>
    	</xsl:with-param>
    </xsl:call-template>
}

- (BOOL)validateConsistency:(NSError **)error
{
	BOOL valid = YES;
	<xsl:apply-templates select="attribute" mode="validate-attribute"/>

	<xsl:apply-templates select="(attribute | association)[generate-id(.)=generate-id(key('uniqueConstraints',@unique-key)[1])]"
		mode="uniqueConstraints"/>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-validation</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
		
    return valid;
}

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

</xsl:template>


<xsl:template match="*" mode="uniqueConstraints">
	if ( valid ){
		<xsl:value-of select="../name"/><xsl:text> *entity = [</xsl:text><xsl:value-of select="../name"/>
		<xsl:text> MF_findFirstBy</xsl:text>
		<xsl:apply-templates select="key('uniqueConstraints', @unique-key)" mode="uniqueConstraints-daocriteria"/>
		<xsl:text> inContext:[[[MFApplication getInstance] getBeanWithType:@protocol(MFContextFactoryProtocol)] createMFContextWithCoreDataContextForCurrentThread]];&#13;</xsl:text>
		if ( entity != nil &amp;&amp; ![self.identifier isEqualToNumber:entity.identifier] ) {
			if (error != nil) {
				MFTechnicalError *e = [[MFTechnicalError alloc] initWithCode:ERROR_CORE_DATA_VALIDATION_<xsl:value-of select="../name-uppercase"/>
					<xsl:text>_</xsl:text><xsl:value-of select="@unique-key-uppercase"/>
					<xsl:text>_NOT_UNIQUE localizedDescriptionKey:@"Unique constraint </xsl:text><xsl:value-of select="../name"/>
					<xsl:text>.</xsl:text><xsl:value-of select="@unique-key"/> failed"];
				*error = e;
			}
			valid = NO;
		}
	}
</xsl:template>

<xsl:template match="attribute" mode="uniqueConstraints-daocriteria">
	<xsl:if test="position() = 1">
		<xsl:value-of select="@name-capitalized"/>
		<xsl:text>: self.</xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:if>
	<xsl:if test="position() &gt; 1 ">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>: self.</xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:if>
</xsl:template>

<xsl:template match="association" mode="uniqueConstraints-daocriteria">
	<xsl:if test="position() = 1">
		<xsl:value-of select="@name-capitalized"/>
		<xsl:text>identifier: self.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>.identifier</xsl:text>
	</xsl:if>
	<xsl:if test="position() &gt; 1 ">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name-capitalized"/>
		<xsl:text>identifier: self.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>.identifier</xsl:text>
	</xsl:if>
</xsl:template>

<!-- 
 * Length validation
-->
<xsl:template match="attribute[@length]" mode="validate-attribute">
NSString *<xsl:value-of select="@name"/>Value =<xsl:choose>
	<xsl:when test="@type-name = 'NSNumber'"> [self.<xsl:value-of select="@name"/> stringValue];</xsl:when>
	<xsl:otherwise> self.<xsl:value-of select="@name"/>;</xsl:otherwise>
</xsl:choose>
if ( valid == YES &amp;&amp; [<xsl:value-of select="@name"/>Value length] &gt; <xsl:value-of select="@length"/>) {
            
	if (error != NULL) {
		MFTechnicalError *e = [[MFTechnicalError alloc] initWithCode:ERROR_CORE_DATA_VALIDATION_<xsl:value-of select="../name-uppercase"/>
			<xsl:text>_</xsl:text><xsl:value-of select="@name-uppercase"/>_TOO_LONG
			localizedDescriptionKey:@"<xsl:value-of select="../name"/>
			<xsl:text>.</xsl:text><xsl:value-of select="@name"/> is too long"];
		*error = e;
	}

	valid = NO;
}
</xsl:template>

<!-- 
 * Default template (no validation)
-->
<xsl:template match="attribute" mode="validate-attribute">
</xsl:template>


<xsl:template match="validator" mode="declare-extra-imports">
	<objc-import category="OTHERS" class="MFErrorConfig" header="MFErrorConfig.h" scope="local"/>
</xsl:template>



</xsl:stylesheet>