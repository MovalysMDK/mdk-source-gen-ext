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

<xsl:variable name="majuscules">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ</xsl:variable>
<xsl:variable name="minuscules">abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ</xsl:variable>

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/constants.xsl"/>

<xsl:template match="factory">
	<xsl:apply-templates select="class" mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="class/name"/>+Factory.m</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-impl-imports"/>
	
	<xsl:apply-templates select="class"/>
</xsl:template>



<xsl:template match="class">

<xsl:if test="transient = 'true'">
static NSNumber *incrementalIdentifier;
</xsl:if>

@implementation <xsl:value-of select="name"/> (Factory)

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
</xsl:call-template>


<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<!--
+ (<xsl:value-of select="name"/> *) MF_create<xsl:value-of select="name"/>
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    <xsl:value-of select="name"/> *newInstance = (<xsl:value-of select="name"/> *)[NSEntityDescription insertNewObjectForEntityForName:<xsl:value-of select="name"/>Properties.EntityName inManagedObjectContext:context];
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">init-properties</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>    
    return newInstance;
}
-->

+ (<xsl:value-of select="name"/> *) MF_create<xsl:value-of select="name"/>InContext:(id&lt;MFContextProtocol&gt;)context
{
    <xsl:value-of select="name"/> *newInstance = nil;
	<xsl:apply-templates select="." mode="create-in-context"/>
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">init-properties2</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	
    return newInstance;
}
<xsl:if test="transient != 'true'">
+ (<xsl:value-of select="name"/> *) MF_create<xsl:value-of select="name"/>WithDictionary:(NSDictionary*)dictionary inContext:(id&lt;MFContextProtocol&gt;)context
{    
    MFCsvLoaderHelper *csvHelper = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_CSV_LOADER_HELPER];
	<xsl:value-of select="name"/> *newInstance = [self MF_create<xsl:value-of select="name"/>InContext:context] ;
	
	// identifier attribute
	<xsl:for-each select="./identifier/attribute">
		<xsl:text>newInstance.</xsl:text><xsl:value-of select="@name"/> = [csvHelper convertCsvStringTo<xsl:value-of select="substring-before(coredata-type, ' ')"/>:
			[dictionary objectForKey:@"<xsl:value-of select="@name"/>" ]]; 
	</xsl:for-each>
	
	// associations
	<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
			<xsl:text>	</xsl:text>
			<xsl:value-of select="./class/name"/><xsl:text> * </xsl:text><xsl:value-of select="@name"/><xsl:text> = [</xsl:text> 
			<xsl:value-of select="./class/name"/> 
			<xsl:text> MF_findByIdentifier:</xsl:text><xsl:choose>
			<xsl:when test="count(attribute/coredata-type)>0">
				<xsl:if test="attribute/coredata-type != 'String'">
					<xsl:text>[csvHelper </xsl:text><xsl:apply-templates select="attribute/coredata-type" mode="wrapper-name"/>
					<xsl:text>:</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>[csvHelper convertCsvStringToInteger:</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
			<xsl:text>[dictionary objectForKey:@"</xsl:text>
			<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/>
			<xsl:value-of select="translate(attribute/@name,$majuscules,$minuscules)"/>
			<xsl:text>" ]</xsl:text>
			<xsl:if test="not(attribute/coredata-type) or attribute/coredata-type != 'String'">
				<xsl:text>   ]</xsl:text>
			</xsl:if>			
			<xsl:text> inContext:context]; &#13;</xsl:text>
			
			<xsl:text>	if (</xsl:text><xsl:value-of select="@name"/><xsl:text>){ &#13;</xsl:text>
				<xsl:text>		newInstance.</xsl:text><xsl:value-of select="@name"/>
				<xsl:text> = </xsl:text><xsl:value-of select="@name"/><xsl:text> ; &#13;</xsl:text>
			<xsl:text>	} &#13;</xsl:text>
			
			
			
		<xsl:if test="@type='one-to-one' and @opposite-navigable='true'">
 		<xsl:text>	if ( newInstance.</xsl:text><xsl:value-of select="@name"/> &amp;&amp; newInstance.<xsl:value-of select="@name"/>.<xsl:value-of select="@opposite-name"/><xsl:text> == nil ){&#13;</xsl:text>
			<xsl:text>		newInstance.</xsl:text><xsl:value-of select="@name"/>.<xsl:value-of select="@opposite-name"/><xsl:text> = newInstance ;&#13;</xsl:text>
		<xsl:text>	}&#13;</xsl:text>
		</xsl:if>
		<xsl:if test="@type='many-to-one' and @opposite-navigable='true'">
			<xsl:text>	[newInstance.</xsl:text><xsl:value-of select="@name"/> add<xsl:value-of select="@opposite-capitalized-name"/><xsl:text>Object:newInstance];&#13;</xsl:text>
		</xsl:if>
	</xsl:for-each>

	<xsl:text>&#13;	// attributes&#13;</xsl:text>
	<xsl:for-each select="./attribute[@transient ='false']">
	<xsl:choose>
		<xsl:when test="not(@enum) or @enum = 'false'">
			<xsl:text>	newInstance.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text>
			<xsl:if test="coredata-type != 'String'">[csvHelper <xsl:apply-templates select="coredata-type" mode="wrapper-name"/>:</xsl:if>
			<xsl:text>[dictionary objectForKey:@"</xsl:text><xsl:value-of select="translate(@name,$majuscules,$minuscules)"/>" <xsl:if test="not(coredata-type) or coredata-type != 'String'">]</xsl:if><xsl:text>];&#13;</xsl:text> 
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>	newInstance.</xsl:text><xsl:value-of select="@name"/> = [<xsl:value-of select="@type-short-name"/>Helper enumFromText:[dictionary objectForKey: @"<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/>" ] ];
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_create<xsl:value-of select="name"/>WithDictionary</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="./attribute" mode="initTransientMandatoryAttr"/>
		</xsl:with-param>
	</xsl:call-template>
	
	return newInstance;
}
<!-- 
+ (void) MF_fillEntityAttributesWithDictionary:(NSDictionary *)dictionary inContext:(id&lt;MFContextProtocol&gt;)context 
{
	
    MFCsvLoaderHelper *csvHelper = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_CSV_LOADER_HELPER];
    <xsl:value-of select="name"/> *modifiedInstance = [<xsl:value-of select="name"/> MF_findByIdentifier:[csvHelper convertCsvStringToInteger:[dictionary objectForKey:@"<xsl:value-of select="./identifier/attribute/@name"/><xsl:text>"]  ] inContext:context];&#13;&#13;</xsl:text>
    
    <xsl:for-each select="./association[@type='many-to-one' or (@type='one-to-one' and @transient='false')]">
	    <xsl:text>	if ( modifiedInstance.</xsl:text><xsl:value-of select="@name"/><xsl:text> == nil ) {&#13;</xsl:text>
			<xsl:text>		modifiedInstance.</xsl:text><xsl:value-of select="@name"/> = [<xsl:value-of select="./class/name"/> 
				<xsl:text> MF_findByIdentifier:[ &#13;			csvHelper convertCsvStringToInteger:[dictionary objectForKey:@"</xsl:text>
				<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/>
				<xsl:value-of select="translate(attribute/@name,$majuscules,$minuscules)"/>
				<xsl:text>" ]] inContext:context];&#13;	}&#13;</xsl:text>
				
		<xsl:if test="@type='one-to-one' and @opposite-navigable='true'">
			<xsl:text>	if ( modifiedInstance.</xsl:text><xsl:value-of select="@name"/><xsl:text> != nil ){&#13;</xsl:text>
			<xsl:text>		modifiedInstance.</xsl:text><xsl:value-of select="@name"/>.<xsl:value-of select="@opposite-name"/>
			<xsl:text> = modifiedInstance ;&#13;	}&#13;</xsl:text>
		</xsl:if>    
	</xsl:for-each> 

    <xsl:text>	//MFCoreLogVerbose(@"MF_fillEntityAttributesWithDictionary %@  completed with dictionary %@ ", modifiedInstance , dictionary);&#13;</xsl:text>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_fillEntityAttributesWithDictionary</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
}
 -->
</xsl:if>

<xsl:for-each select="./association[@type='many-to-many']">
+ (void) MF_fill<xsl:value-of select="@name-capitalized"/>WithDictionary:(NSDictionary*)dictionary inContext:(id&lt;MFContextProtocol&gt;)context;{

	MFCsvLoaderHelper *csvHelper = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_CSV_LOADER_HELPER];
	<xsl:variable name="join-class-name" select="./join-table/interface/name"/>
	<xsl:variable name="asso-att-name" select="@opposite-name"/>

	<xsl:value-of select="../name"/><xsl:text> *modifiedInstance = [</xsl:text><xsl:value-of select="../name"/> 
	<xsl:text> MF_findByIdentifier:[csvHelper convertCsvStringToInteger:[dictionary objectForKey:@"</xsl:text>
	<xsl:apply-templates select="./join-table" mode="attribute-asso-name">
		<xsl:with-param name="asso-name" select="$asso-att-name"/>
	</xsl:apply-templates>
	<xsl:text>"]  ] inContext:context];</xsl:text>

	// add the new object to the current entity	
	[modifiedInstance add<xsl:value-of select="@name-capitalized"/><xsl:text>Object:[</xsl:text>
		<xsl:value-of select="@contained-type-short-name"/>
		<xsl:text> MF_findByIdentifier:&#13;		[csvHelper convertCsvStringToInteger:[dictionary objectForKey:@"</xsl:text>
		<xsl:apply-templates select="./join-table" mode="attribute-asso-name">
			<xsl:with-param name="asso-name" select="@name"/>
		</xsl:apply-templates>
	<xsl:text>" ]] inContext:context] ] ;&#13;</xsl:text>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">MF_fill<xsl:value-of select="@name-capitalized"/>WithDictionary</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
}

</xsl:for-each>


<xsl:for-each select="./association[(@type='one-to-many' or @type='many-to-many') and @opposite-navigable='true']">
- (void)add<xsl:value-of select="@name-capitalized"/>Object:(<xsl:value-of select="./class/name"/> *)value
{
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">addObject</xsl:with-param>
		<xsl:with-param name="defaultSource">
	NSMutableOrderedSet *<xsl:value-of select="@name"/> = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.<xsl:value-of select="@name"/>];
    [<xsl:value-of select="@name"/> addObject:value];
    self.<xsl:value-of select="@name"/> = <xsl:value-of select="@name"/>;
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:for-each>


<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end
</xsl:template>

<!-- doit retourner employeridentifier attribut de la jointure pour l'asso -->
<xsl:template match="join-table" mode="attribute-asso-name">
	<xsl:param name="asso-name"/>
	<xsl:choose>
		<xsl:when test="./left-association/name = $asso-name">
			<xsl:value-of select="translate(./left-association/attr/@name,$majuscules,$minuscules)"/>
		</xsl:when>
		<xsl:when test="./right-association/name = $asso-name">
			<xsl:value-of select="translate(./right-association/attr/@name,$majuscules,$minuscules)"/>
		</xsl:when>
		<xsl:otherwise>
		CAS D ERREUR  asso not found '<xsl:value-of select="$asso-name"/>' in class '<xsl:value-of select="name"/>'
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>


<xsl:template match="coredata-type" mode="wrapper-name">
	<xsl:text>convertCsvStringTo</xsl:text>
	<xsl:choose>
		<xsl:when test="contains(. , ' ')">
			<xsl:value-of select="substring-before(., ' ')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="attribute[@transient = 'true' and @nullable = 'false']" mode="initTransientMandatoryAttr">
	newInstance.<xsl:value-of select="@name"/><xsl:text> = </xsl:text>
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


<xsl:template match="factory" mode="declare-extra-imports">
	<objc-import category="FRAMEWORK" class="MFCsvLoaderHelper" header="MFCsvLoaderHelper.h" scope="local"/>
</xsl:template>

<xsl:template match="class" mode="create-in-context">
    newInstance = (<xsl:value-of select="name"/> *)[NSEntityDescription insertNewObjectForEntityForName:<xsl:value-of select="name"/>Properties.EntityName
            inManagedObjectContext:context.entityContext];
    <xsl:if test="transient = 'true'">
    if(!incrementalIdentifier) {
        incrementalIdentifier = @1;
    }
    else {
        incrementalIdentifier = @([incrementalIdentifier intValue] + 1);
    }
    newInstance.identifier = incrementalIdentifier;
    </xsl:if>
</xsl:template>

<xsl:template match="class[transient = 'true' and scope = 'APPLICATION']" mode="create-in-context">
        if([<xsl:value-of select="name"/> MR_countOfEntitiesWithContext:context.entityContext] == 0) {
    		newInstance = (<xsl:value-of select="name"/> *)[NSEntityDescription insertNewObjectForEntityForName:<xsl:value-of select="name"/>Properties.EntityName
            inManagedObjectContext:context.entityContext];
        }
        else {
        	newInstance = [<xsl:value-of select="name"/> MR_findFirst];
        }
</xsl:template>

</xsl:stylesheet>