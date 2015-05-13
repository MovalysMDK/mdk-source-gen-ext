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
<xsl:include href="ui/viewmodel/modifyToIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>
<xsl:include href="ui/viewmodel/childViewModels.xsl"/>
<xsl:include href="ui/viewmodel/sublist.xsl"/>

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

<xsl:apply-templates select="." mode="synthesizeSublist"/>

<xsl:text>&#13;</xsl:text>

-(id) init {
    self = [super init];
    if(self ) {
        <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">validateForInsert</xsl:with-param>
			<xsl:with-param name="defaultSource">
    			<xsl:text>_isInitialized = NO;&#13;</xsl:text>
        		<xsl:text>_isInitialized = YES;&#13;</xsl:text>
        	</xsl:with-param>
        </xsl:call-template>
    }
        
    return self;
}

<xsl:apply-templates select="." mode="bindedProperties-method"/>

<xsl:if test="entity-to-update">
	<xsl:apply-templates select="." mode="updateFromIdentifiable-method"/>
	<xsl:apply-templates select="." mode="modifyToIdentifiable-method"/>
	<xsl:apply-templates select="." mode="defineViewModelName-method"/>
</xsl:if>
<xsl:apply-templates select="." mode="getChildViewModels-method"/>
<xsl:apply-templates select="." mode="generate-validate" />

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
		[self updateFromIdentifiable:nil];
	} else if ( [[p_dataloader class] isSubclassOfClass:[<xsl:value-of select="dataloader-impl/name"/> class]] ) {
		<xsl:value-of select="dataloader-impl/name"/> *o<xsl:value-of select="dataloader-impl/name"/> = (<xsl:value-of select="dataloader-impl/name"/> *) p_dataloader;
		MViewModelCreator *viewModelCreator = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_VIEW_MODEL_CREATOR];
			
	<xsl:apply-templates select="." mode="add-update-to-dataloader"/>

	}	
		</xsl:with-param>
	</xsl:call-template>
}
</xsl:if>

<xsl:choose>
	<xsl:when test="mapping/entity | mapping/attribute">
		<xsl:apply-templates select="mapping" mode="generate-method-clear"/>
	</xsl:when>
	<xsl:when test="subvm/viewmodel">
		<xsl:apply-templates select="subvm" mode="generate-method-clear"/>
	</xsl:when>
	<xsl:otherwise>
	<xsl:text>-(void) clear {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">clear-after</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
	<xsl:text>&#13;&#13;}&#13;</xsl:text>
	</xsl:otherwise>
</xsl:choose>

<xsl:apply-templates select="." mode="getSublist"/>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
</xsl:call-template>   
@end

</xsl:template>


<!-- general case of the pickerlist -->
<xsl:template match="viewmodel[external-lists/external-list/viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="add-update-to-dataloader">
	<xsl:text>&#13;[viewModelCreator update</xsl:text>
	<xsl:value-of select="./name"/>
	<xsl:text>:[o</xsl:text>
	<xsl:value-of select="dataloader-impl/name"/>
	<xsl:text> getLoadedData:context]</xsl:text>	
	<xsl:apply-templates select="./external-lists/external-list" mode="update-vmcreator-pickerlist"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList"/>
	
	<xsl:text>];&#13;</xsl:text>
</xsl:template>



<xsl:template match="viewmodel" mode="add-update-to-dataloader">
	<xsl:value-of select="dataloader-impl/dataloader-interface/entity-type/name"/>
	<xsl:text> *data = [o</xsl:text><xsl:value-of select="dataloader-impl/name"/> getLoadedData:context];
       
     if (data == nil) {
       data = [<xsl:value-of select="dataloader-impl/dataloader-interface/entity-type/name"/>
       <xsl:text> MF_create</xsl:text>
       <xsl:value-of select="dataloader-impl/dataloader-interface/entity-type/name"/>InContext:context];&#13;
      }
     
		[viewModelCreator update<xsl:value-of select="name"/>:data<xsl:apply-templates select="./subvm/viewmodel" mode="add-update-to-dataloader-for-fixed-list"/>];
		
		
     
</xsl:template>


<!-- In case of a pickerlist inside a fixed list -->
<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="add-update-to-dataloader-for-fixed-list">
		<xsl:apply-templates select="./external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList"/>
<!-- 		<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList"/> -->
</xsl:template>

<xsl:template match="viewmodel" mode="add-update-to-dataloader-for-fixed-list">
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist">
	<xsl:text> withLst</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text>:[o</xsl:text>
	<xsl:value-of select="../../../dataloader-impl/name"/>
	<xsl:text> getList</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>:context]</xsl:text>
	
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist-in-fixedList">
	<xsl:text> withLst</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text>:[o</xsl:text>
	<xsl:value-of select="../../../../../dataloader-impl/name"/>
	<xsl:text> getList</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>:context]</xsl:text>
	
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="defineViewModelName-method">
	<xsl:apply-templates select="." mode="defineViewModelName-method-for-combo"/>
</xsl:template>

<xsl:template match="viewmodel" mode="defineViewModelName-method">
</xsl:template>

<xsl:template match="viewmodel[linked-interface/name='MFUIBaseListViewModel']" mode="defineViewModelName-method-for-combo">
	<xsl:text>&#13;-(NSString *)defineViewModelName {&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">defineViewModelName</xsl:with-param>
		<xsl:with-param name="defaultSource">
	    	<xsl:text>return @"</xsl:text>
	    	<xsl:value-of select="name"/>
	    	<xsl:text>";&#13;</xsl:text>
	    </xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="defineViewModelName-method-for-combo">
</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>
<!-- End cases pickerlist -->


<!-- Generate Validate -->

<xsl:template match="viewmodel[type/name='LISTITEM_1']" mode="generate-validate">
		/**
		 * Validate the viewmodel before save
		 */
		<xsl:text>-(BOOL) validate {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">validate</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:text>BOOL result = YES;&#13;</xsl:text>
		    	<xsl:apply-templates select="mapping/attribute" mode="generate-test-variables-validate"/>
		    <xsl:text>return result;&#13;</xsl:text>
	       </xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#13;}&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="viewmodel" mode="generate-validate">
</xsl:template>

<xsl:template match="attribute" mode="generate-test-variables-validate">
<xsl:variable name="vmattributename" select="@vm-attr"/>
<xsl:variable name="isEnum" select="../..//attribute[@name=$vmattributename]/@enum"/>
	<xsl:if test="$isEnum != 'true'">
		<xsl:text>result = result &amp;&amp; (self.</xsl:text><xsl:value-of select="@vm-attr"/><xsl:text> !=nil);&#13;</xsl:text>
	</xsl:if>
</xsl:template>
	
</xsl:stylesheet>