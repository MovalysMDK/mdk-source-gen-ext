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

<xsl:template match="master-action[action/action-type = 'SAVEDETAIL']" 
	mode="actionMethods">
	
-(BOOL) validateData:(id)parameterIn inContext:(id&lt;MFContextProtocol&gt;)context {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">validateData</xsl:with-param>
	<xsl:with-param name="defaultSource">
    <xsl:value-of select="action/viewmodel/name"/> *vm = [[MFApplication getInstance] getBeanWithKey:@"<xsl:value-of select="action/viewmodel/name"/>"];
	return [vm validate];
	</xsl:with-param>
</xsl:call-template>
}

-(id) preSaveData:(id)parameterIn inContext:(id&lt;MFContextProtocol&gt;)context {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">preSaveData</xsl:with-param>
	<xsl:with-param name="defaultSource">
    
    <xsl:value-of select="action/viewmodel/dataloader-impl/name"/> *panelLoader = [[MFApplication getInstance] getBeanWithKey:@"<xsl:value-of select="action/viewmodel/dataloader-impl/name"/>"];
    <xsl:value-of select="action/class/name"/> *entity = [panelLoader getLoadedData:context];
    
    if ( entity == nil ) {
        entity = [<xsl:value-of select="action/class/name"/> MF_create<xsl:value-of select="action/class/name"/>InContext:context];
        [panelLoader setEntity:entity];
    }
    
    <xsl:value-of select="action/viewmodel/name"/> *vm = [[MFApplication getInstance] getBeanWithKey:@"<xsl:value-of select="action/viewmodel/name"/>"];
    [vm modifyToIdentifiable:entity inContext:context];
    
    return entity;
   	
   	</xsl:with-param>
</xsl:call-template>
}

-(void) postSaveData:(id)entity parameter:(id)parameterIn inContext:(id&lt;MFContextProtocol&gt;)context {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">postSaveData</xsl:with-param>
	<xsl:with-param name="defaultSource">    

    <xsl:value-of select="action/viewmodel/name"/> *vm = [[MFApplication getInstance] getBeanWithKey:@"<xsl:value-of select="action/viewmodel/name"/>"];
    <xsl:value-of select="action/class/name"/> *ent = entity ;
    [vm updateFromIdentifiable:ent];
    
    </xsl:with-param>
</xsl:call-template>
}
	
</xsl:template>


</xsl:stylesheet>