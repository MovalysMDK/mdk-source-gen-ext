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
<xsl:include href="binding/bindingStructure-fixedListItem.xsl"/>


<xsl:template match="xib-container">
<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="view-fixedlist-name"/>.m</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="view-fixedlist-name" mode="import"/>
<xsl:apply-templates select="detailscreen-viewcontroller-name" mode="import"/>

<xsl:apply-templates select="." mode="declare-impl-imports"/>

<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="view-fixedlist-name"/>()<xsl:text>&#13;</xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-extension</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
<xsl:text>&#13;@end&#13;</xsl:text>

<xsl:text>&#13;@implementation </xsl:text><xsl:value-of select="view-fixedlist-name"/> {
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

-(id) init {
    self = [super init];
    if(self ) {
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">init</xsl:with-param>
		</xsl:call-template>
    }
    return self;
}

-(void) createBindingStructure {
	<xsl:apply-templates select="." mode="createBindingStructure-method-fixedlist"/>
}


-(NSString *)itemListViewModelName {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">itemListViewModelName</xsl:with-param>
	<xsl:with-param name="defaultSource">
	return @"<xsl:value-of select="viewmodel-item-name"/>";
	</xsl:with-param>
</xsl:call-template>
}

-(void)itemChangedAtIndexPath:(NSIndexPath*)indexPath {
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">itemChangedAtIndexPath</xsl:with-param>
	</xsl:call-template>
}
<xsl:if test="detailscreen-viewcontroller-name">
-(MFFormDetailViewController *) detailController {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">detailController</xsl:with-param>
	<xsl:with-param name="defaultSource">
    <xsl:value-of select="detailscreen-viewcontroller-name"/> *detailController = [[UIStoryboard storyboardWithName:@"<xsl:value-of select="detailscreen-storyboard-name"/>" bundle:nil] 
    	instantiateViewControllerWithIdentifier:@"<xsl:value-of select="detailscreen-viewcontroller-name"/>"]; 
    return detailController;
    </xsl:with-param>
</xsl:call-template>
}
</xsl:if>
/** 
  * @brief method launched when user delete an item of the list defined by his indexpath
  * @param indexPath section and row of the deleted item
  */
-(void) deleteItemMethodAtIndexPath:(NSIndexPath *) indexPath {
     <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">deleteItemMethodAtIndexPath</xsl:with-param>
	</xsl:call-template>
}


#pragma mark - Editing

/** 
  * @brief method launched when user click on the + button 
  */
-(void) addItemMethod{
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">addItemMethod</xsl:with-param>
	</xsl:call-template>   
}

/** 
  * @brief method launched when user edit an item of the list
  * @param indexPath section and row of the deleted item
  */
-(void) editItemMethodAtIndexPath:(NSIndexPath *) indexPath {
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">editItemMethodAtIndexPath</xsl:with-param>
	</xsl:call-template>   
}


<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
</xsl:call-template> 

@end
</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

</xsl:stylesheet>