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
<xsl:include href="commons/replace-all.xsl"/>

<xsl:include href="ui/viewmodel/bindedProperties.xsl"/>
<xsl:include href="ui/viewmodel/updateFromIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>
<xsl:include href="ui/viewmodel/childViewModels.xsl"/>

<xsl:template match="viewmodel">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-impl-imports"/>

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

<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>


<xsl:text>&#13;&#13;</xsl:text>

-(id)init {
    self = [super init];
    if(self) {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">init</xsl:with-param>
	<xsl:with-param name="defaultSource">
		_isInitialized = NO;
        _isInitialized = YES;
	</xsl:with-param>
</xsl:call-template>
    }
    return self;
}


-(NSString *)defineViewModelName {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">defineViewModelName</xsl:with-param>
	<xsl:with-param name="defaultSource">
	<xsl:apply-templates select="." mode="defineViewModelName"/>
	</xsl:with-param>
</xsl:call-template>
}
<!-- 
<xsl:if test="entity-to-update">
	<xsl:apply-templates select="." mode="updateFromIdentifiable-method"/>
</xsl:if>
 -->
<xsl:apply-templates select="." mode="getChildViewModels-method"/>

<xsl:if test="dataloader-impl">
/**
  * @brief update the view model with the given data loader
  * @param data loader to retrieve the information to insert in the view model
  */
-(void) updateFromDataloader:(id&lt;MFDataLoaderProtocol&gt;) p_dataloader inContext:(id&lt;MFContextProtocol&gt;)context {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromDataloader</xsl:with-param>
		<xsl:with-param name="defaultSource">
	if (p_dataloader == nil) {
		[self clear];
	} else if ( [[p_dataloader class] isSubclassOfClass:[<xsl:value-of select="dataloader-impl/name"/> class]] ) {
	        
        <xsl:value-of select="dataloader-impl/name"/> *dataLoader = (<xsl:value-of select="dataloader-impl/name"/> *) p_dataloader;
        MViewModelCreator *viewModelCreator = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_VIEW_MODEL_CREATOR];
        [self clear];

        NSFetchedResultsController *data = (NSFetchedResultsController *)[dataLoader getLoadedData:context];
        [viewModelCreator createOrUpdate<xsl:value-of select="name"/>:data];

        MFFormListViewController *formListViewController = (MFFormListViewController *) [self getForm];
        data.delegate = formListViewController;
	}	
		</xsl:with-param>
	</xsl:call-template>
}
</xsl:if>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>



<xsl:template match="viewmodel" mode="defineViewModelName">
	return @"<xsl:value-of select="subvm/viewmodel/name"/>";
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="defineViewModelName">
	return @"<xsl:value-of select="name"/>";
</xsl:template>



</xsl:stylesheet>