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

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/file-header.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/non-generated.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/constants.xsl"/>

	<xsl:template match="dataloader-impl">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.m</xsl:with-param>
</xsl:apply-templates>
		
<xsl:apply-templates select="." mode="declare-impl-imports"/>		

<xsl:text>&#13;@implementation </xsl:text><xsl:value-of select="name"/>
	<!-- custom attributes -->
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">attributes</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">synthesize</xsl:with-param>
	</xsl:call-template>

	<!-- load method -->
	<xsl:apply-templates select="." mode="loadMethod"/>
	
	<!-- getLoadedData method -->
	<xsl:apply-templates select="." mode="getLoadedDataMethod"/>

	<!-- getter for combox -->
	<xsl:apply-templates select="./dataloader-interface/combos/combo" mode="combo-getter"/>	

	<!-- custom methods -->
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">methods</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>

@end
</xsl:template>
	


<!-- LOADMETHOD (for list) -->
<xsl:template match="dataloader-impl[dataloader-interface/type='LIST']" mode="loadMethod">
-(NSFetchedResultsController *) load:(id&lt;MFContextProtocol&gt;)context {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">load</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:text>return nil;&#13;</xsl:text>
		</xsl:with-param>
	</xsl:call-template>
}	
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST']" mode="getLoadedDataMethod">
- (id) getLoadedData:(id&lt;MFContextProtocol&gt;)context {
    NSFetchedResultsController *data = nil ;
    
        
    <xsl:variable name="sort-property">
	    <xsl:choose>
		   <xsl:when test="dataloader-interface/entity-type/transient = 'true'">identifier</xsl:when>
		   <xsl:otherwise><xsl:value-of select="dao-interface/dao/class/identifier/attribute/@name"/></xsl:otherwise>
	    </xsl:choose>
    </xsl:variable>
    
    
    
     <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">getLoadedData</xsl:with-param>
		<xsl:with-param name="defaultSource">
		MFFetchOptions *fetchOptions = [MFFetchOptions createFetchOptions];
    	[fetchOptions addAscendingSortOnProperty: <xsl:value-of select="dataloader-interface/entity-type/name"/>Properties.<xsl:value-of select="$sort-property"/>];
    	[fetchOptions setCacheName: @"<xsl:value-of select="name"/>"];
    	data = [<xsl:value-of select="dataloader-interface/entity-type/name"/> MF_findAllWithFetchControllerAndFetchOptions:fetchOptions inContext:context];
		</xsl:with-param>
	</xsl:call-template>

    return data;
}	
	</xsl:template>


<!-- LOADMETHOD (default) -->
	<xsl:template match="dataloader-impl" mode="loadMethod">
-(<xsl:value-of select="dataloader-interface/entity-type/name"/> *) load:(id&lt;MFContextProtocol&gt;)context {	
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">load</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:text>return nil;</xsl:text>
		</xsl:with-param>
	</xsl:call-template>
}	
	</xsl:template>


	<xsl:template match="dataloader-impl" mode="getLoadedDataMethod">
- (id) getLoadedData:(id&lt;MFContextProtocol&gt;)context {
     <xsl:value-of select="dataloader-interface/entity-type/name"/>
     <xsl:text> *data = </xsl:text>
     
     <xsl:choose>
	     <xsl:when test="dataloader-interface/type = 'WORKSPACE'">
	    	 <xsl:text>[self getEntity];&#13;</xsl:text>
	     </xsl:when>
	     <xsl:otherwise>
	    	 <xsl:text>nil;&#13;</xsl:text>
		 </xsl:otherwise>
    </xsl:choose>
    
     <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">getLoadedData</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="." mode="getLoadedDataMethod-body"/>
		</xsl:with-param>
	</xsl:call-template>
	
    return data;
}	
	</xsl:template>

	
	<xsl:template match="dataloader-impl[dataloader-interface/entity-type/transient = 'true' and dataloader-interface/entity-type/scope = 'APPLICATION']"
		mode="getLoadedDataMethod-body">
		
    NSArray *entities = [<xsl:value-of select="dataloader-interface/entity-type/name"/> MF_findAllInContext:context];
    if (entities == nil || [entities count] == 0) {
        data = [<xsl:value-of select="dataloader-interface/entity-type/name"/>
        <xsl:text> MF_create</xsl:text>
        <xsl:value-of select="dataloader-interface/entity-type/name"/>
        <xsl:text>InContext:context];&#13;</xsl:text>
    }
    else {
        data = [entities objectAtIndex:0];
    }
		
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/entity-type/transient = 'true' and not(dataloader-interface/entity-type/scope = 'APPLICATION')]"
		mode="getLoadedDataMethod-body">
    </xsl:template>	
	
	<xsl:template match="dataloader-impl[dataloader-interface/entity-type/transient = 'false']"
		mode="getLoadedDataMethod-body">
		
		NSArray *ids = [self getDataIdentifiers];
		if ( ids != nil &amp;&amp; ids.count > 0 ) {
    		data = [<xsl:value-of select="dataloader-interface/entity-type/name"/> MF_findByIdentifier:[ids objectAtIndex:0] inContext:context];
		}
	</xsl:template>
	


<!--  COMBO GETTER -->
<xsl:template match="combo" mode="combo-getter">
	<xsl:text>- (NSArray *) getList</xsl:text><xsl:value-of select="entity-getter-name"/>
	<xsl:text>:(id&lt;MFContextProtocol&gt;)context {&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">getList</xsl:with-param>
		<xsl:with-param name="defaultSource">
			

	<xsl:text>NSMutableArray *</xsl:text><xsl:value-of select="entity-attribute-name"/>
    <xsl:text>Lst = [NSMutableArray array];&#13;</xsl:text>
    
    <xsl:text>NSArray *list</xsl:text>
    <xsl:value-of select="dao-impl-name"/>
    <xsl:text> = [</xsl:text>
    <xsl:value-of select="dao-impl-name"/>
    <xsl:text> MF_findAllInContext:context];&#13;&#13;[</xsl:text>
	<xsl:value-of select="entity-attribute-name"/>
   	<xsl:text>Lst addObjectsFromArray:list</xsl:text>
    <xsl:value-of select="dao-impl-name"/>
    <xsl:text>];&#13;</xsl:text>
	
	return <xsl:value-of select="entity-attribute-name"/><xsl:text>Lst;&#13;</xsl:text>
	
		</xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>}&#13;&#13;</xsl:text>
</xsl:template>


	
<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>	
	
</xsl:stylesheet>