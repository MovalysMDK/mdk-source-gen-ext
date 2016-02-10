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
		
<!-- updateFromIdentifiable method (interface) -->
<xsl:template match="viewmodel" mode="modifyToIdentifiable-method-header">

/**
  * @brief Modify the entity <xsl:value-of select="./entity-to-update/name"/> with the data of the viewmodel.
  * @param <xsl:value-of select="./entity-to-update/name"/> entity to update with the view model.
  * @param context context
  */
- (void) modifyToIdentifiable:(<xsl:value-of select="./entity-to-update/name"/> *)entity inContext:(id&lt;MFContextProtocol&gt;)context;
</xsl:template>		
		
		
<!-- updateFromIdentifiable method (implementation)-->
<xsl:template match="viewmodel" mode="modifyToIdentifiable-method">
-(void) modifyToIdentifiable:(<xsl:value-of select="./entity-to-update/name"/> *)entity inContext:(id&lt;MFContextProtocol&gt;)context {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modifyToIdentifiable-before</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:apply-templates select="mapping" mode="generate-method-modify"/>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modifyToIdentifiable-after</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
}
</xsl:template>

<xsl:template match="mapping" mode="generate-method-modify">
	<xsl:text>if (entity != nil) {&#13;</xsl:text>
	<xsl:apply-templates select="attribute[setter]" mode="generate-method-modify"/>
	<xsl:apply-templates select="entity[setter]" mode="generate-method-modify"/>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modify-to-identifiable</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	
	<xsl:apply-templates select="../external-lists/external-list/viewmodel" mode="generate-method-modify"/>
	
	<xsl:text>}&#13;</xsl:text>
</xsl:template>	


<xsl:template match="entity" mode="generate-method-modify">
		<xsl:param name="var-parent-entity">entity</xsl:param>

		<xsl:variable name="var-entity">
			<xsl:text>o</xsl:text>
			<xsl:value-of select="@type"/>
		</xsl:variable>

		<xsl:if test=".//attribute/setter">

			<xsl:if test="@mandatory = 'false'">
			if ( <xsl:apply-templates select=".//attribute" mode="testEntityFieldsValued"/> ) {
			</xsl:if>
				
				<xsl:value-of select="@type"/>
				<xsl:text> *</xsl:text>
				<xsl:value-of select="$var-entity"/>
				<xsl:text> = </xsl:text>
				<xsl:value-of select="$var-parent-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="getter/@name"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>if (</xsl:text>
				<xsl:value-of select="$var-entity"/>
				<xsl:text> == nil) {&#13;</xsl:text>
				<xsl:value-of select="$var-entity"/>
				<xsl:text> = [</xsl:text>
				<xsl:value-of select="@type"/> MF_create<xsl:value-of select="@type"/><xsl:text>InContext:context];&#13;</xsl:text>
				<xsl:value-of select="$var-parent-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="setter/@name"/>
				<xsl:text> = </xsl:text>
				<xsl:value-of select="$var-entity"/>
				<xsl:text>;&#13;</xsl:text>
	
				<xsl:apply-templates select="attribute[setter]" mode="generate-method-modify">
					<xsl:with-param name="var-entity" select="$var-entity"/>
				</xsl:apply-templates>
	
				<xsl:apply-templates select="entity" mode="generate-method-modify">
					<xsl:with-param name="var-parent-entity" select="$var-entity"/>
				</xsl:apply-templates>
				
			<xsl:if test="@mandatory = 'false'">
			}
			else {
				<xsl:value-of select="$var-parent-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="setter/@name"/>
				<xsl:text> = nil;&#13;</xsl:text>
			}
			</xsl:if>

			<xsl:text>&#13;}&#13;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="entity[@mapping-type='vm']" mode="generate-method-modify">
		<xsl:param name="var-parent-entity">entity</xsl:param>

		<xsl:text>if (self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> == nil) {&#13;</xsl:text>

		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>= nil ;&#13;</xsl:text>

		<xsl:text>} else {&#13;</xsl:text>

		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>(BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="setter/@factory"/>
		<xsl:text>.class).createInstance());&#13;</xsl:text>

		<xsl:text>[self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> modifyToIdentifiable:</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>];&#13;</xsl:text>
		
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	
<xsl:template match="entity[@mapping-type='vmlist' and setter and ../../type/name!='LISTITEM_2' and ../../type/name!='LISTITEM_3']" mode="generate-method-modify">
		<xsl:param name="var-parent-entity">entity</xsl:param>

		<xsl:variable name="viewModelName" select="@vm-property-name"/>
		<xsl:variable name="viewModelNode" select="../../subvm/viewmodel[property-name = $viewModelName]"/>
		<xsl:variable name="vmIdentifier" select="$viewModelNode/identifier/attribute/@name"/>
		<xsl:variable name="entityIdentifier" select="$viewModelNode/mapping/attribute[@vm-attr = $vmIdentifier]/getter/@name"/>
		<xsl:variable name="cellVmType" select="$viewModelNode/subvm/viewmodel/name"/>

		<xsl:text>if (self.</xsl:text><xsl:value-of select="@vm-property-name"/><xsl:text> != nil) {&#13;</xsl:text>
		<xsl:text>NSMutableDictionary *dictById = [[NSMutableDictionary alloc] init];&#13;</xsl:text>
            if ( entity.<xsl:value-of select="getter/@name"/> != nil ) {
                for( <xsl:value-of select="@type"/> *entityForList in entity.<xsl:value-of select="getter/@name"/>) {
                    [dictById setValue:entityForList forKey:[entityForList.<xsl:value-of select="$entityIdentifier"/> stringValue]];
                }
                entity.<xsl:value-of select="getter/@name"/> = [NSOrderedSet orderedSet];
            }
            
            for( <xsl:value-of select="$cellVmType"/> *vmCell in self.<xsl:value-of select="@vm-property-name"/>.viewModels) {
                <xsl:value-of select="@type"/> *entityForList = [dictById valueForKey:[vmCell.<xsl:value-of select="$vmIdentifier"/> stringValue]];
                if ( entityForList == nil ) {
                    entityForList = [<xsl:value-of select="@type"/> MF_create<xsl:value-of select="@type"/>InContext:context];
                }
                [vmCell modifyToIdentifiable:entityForList inContext:context];
                [entity <xsl:value-of select="getter/@add-method"/>: entityForList];
                
                <xsl:if test="@aggregate-type = 'COMPOSITE'">
                	[dictById removeObjectForKey:[vmCell.id_identifier stringValue]];
                </xsl:if>
            }
            
            <xsl:if test="@aggregate-type = 'COMPOSITE'">
               	for (id key in dictById)
	            {
	                [[context entityContext] deleteObject: ((<xsl:value-of select="@type"/> *)[dictById objectForKey:key])];
	            }
            </xsl:if>
            
            
            
            
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>	
	
	
<xsl:template match="entity[@mapping-type='vmlist' and setter and ../../type/name='LISTITEM_2' or ../../type/name='LISTITEM_3']" mode="generate-method-modify">
	<xsl:param name="var-parent-entity">entity</xsl:param>

	<xsl:variable name="viewModelName" select="@vm-property-name"/>
	<xsl:variable name="viewModelNode" select="../../subvm/viewmodel[property-name = $viewModelName]"/>
	<xsl:variable name="vmIdentifier" select="$viewModelNode/subvm/viewmodel/identifier/attribute/@name"/>
	<xsl:variable name="entityIdentifier" select="$viewModelNode/subvm/viewmodel/mapping/attribute[@vm-attr = $vmIdentifier]/getter/@name"/>
	<xsl:variable name="cellVmType" select="$viewModelNode/subvm/viewmodel/name"/>
	

	<xsl:text>if (self.</xsl:text><xsl:value-of select="@vm-property-name"/><xsl:text> != nil) {&#13;</xsl:text>
	<xsl:text>NSMutableDictionary *dictById = [[NSMutableDictionary alloc] init];&#13;</xsl:text>
           if ( entity.<xsl:value-of select="getter/@name"/> != nil ) {
               for( <xsl:value-of select="@type"/> *entityForList in entity.<xsl:value-of select="getter/@name"/>) {
                   [dictById setValue:entityForList forKey:[entityForList.<xsl:value-of select="$entityIdentifier"/> stringValue]];
               }
               entity.<xsl:value-of select="getter/@name"/> = [NSOrderedSet orderedSet];
           }
           
           for( <xsl:value-of select="$cellVmType"/> *vmCell in self.<xsl:value-of select="@vm-property-name"/>.viewModels) {
               <xsl:value-of select="@type"/> *entityForList = [dictById valueForKey:[vmCell.<xsl:value-of select="$vmIdentifier"/> stringValue]];
               if ( entityForList == nil ) {
                   entityForList = [<xsl:value-of select="@type"/> MF_create<xsl:value-of select="@type"/>InContext:context];
               }
               [vmCell modifyToIdentifiable:entityForList inContext:context];
               [entity <xsl:value-of select="getter/@add-method"/>: entityForList];
           }
	<xsl:text>}&#13;</xsl:text>
</xsl:template>	
	
	
	<xsl:template match="attribute[setter]" mode="generate-method-modify">
		<xsl:param name="var-entity">entity</xsl:param>

		<xsl:choose>
			<xsl:when test="setter/@formula">
			
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text">
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text">
							<xsl:call-template name="string-replace-all">
								<xsl:with-param name="text" select="setter/@formula"/>
								<xsl:with-param name="replace" select="'COMPONENT'"/>
								<xsl:with-param name="by">
									<xsl:value-of select="$var-entity"/>.<xsl:value-of select="setter/@name"/>
									<xsl:text> == nil? [</xsl:text>
									<xsl:value-of select="@expandableEntityShortName"/>
									<xsl:text> MF_create</xsl:text>
									<xsl:value-of select="@expandableEntityShortName"/>
									<xsl:text>InContext:context]:</xsl:text>
									<xsl:value-of select="$var-entity"/><xsl:text>.</xsl:text>
									<xsl:value-of select="getter/@name"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="replace" select="'VALUE'"/>
						<xsl:with-param name="by">
							<xsl:text>self.</xsl:text>
							<xsl:value-of select="@vm-attr"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="replace" select="'RESULT'"/>
				<xsl:with-param name="by">
					<xsl:value-of select="$var-entity"/>.<xsl:value-of select="setter/@name"/>
				</xsl:with-param>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="$var-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="setter/@name"/>
				<xsl:text> = </xsl:text>			
				<xsl:text>self.</xsl:text>
				<xsl:value-of select="@vm-attr"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="attribute" mode="generate-method-modify">
		<xsl:text>// Pas de mise à jour de l'entité pour l'attribut </xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
	
		<xsl:template match="attribute" mode="testEntityFieldsValued">
		<xsl:if test="position() > 1">
			<xsl:text>||</xsl:text>
		</xsl:if>
		<xsl:text>self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> != nil </xsl:text>
		
	</xsl:template>
	
		<!--  Cas d'une pickerlist -->
	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-method-modify">
		<xsl:variable name="comboViewModelName"><xsl:value-of select="name"/></xsl:variable>
		
		<xsl:variable name="selectionName">
			<xsl:choose>
			<xsl:when test="../../../../viewmodel[type/name='FIXED_LIST_ITEM']">
				<xsl:value-of select="name"/><xsl:text>Item</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="type/item"/>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="selected-entity"><xsl:value-of select="type/conf-name"/></xsl:variable>
		<xsl:variable name="var-parent-entity">
		<xsl:choose>
			<xsl:when test="../../../mapping/entity/entity[@vm-type=$selected-entity]">entity.<xsl:value-of select="../../../mapping/entity[entity[@vm-type=$selected-entity]]/getter/@name"></xsl:value-of></xsl:when>
			<xsl:otherwise>entity</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
	
		<xsl:text>&#13;if(self.selected</xsl:text>
		<xsl:value-of select="$selectionName"/>
		<xsl:text>){&#13;</xsl:text>
         <xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="../../../mapping/entity[@vm-type = $comboViewModelName]/getter/@name"/>
		<xsl:value-of select="../../../mapping/entity/entity[@vm-type=$selected-entity]/getter/@name"/>
        <xsl:text> = [</xsl:text>
        <xsl:value-of select="entity-to-update/name"/>
        <xsl:text> MF_findByIdentifier:self.selected</xsl:text>
        <xsl:value-of select="$selectionName"/>
        <xsl:text>.</xsl:text>
<!--         Ceci est l'identifier du mauvais VM, mais ces deux VM étant construits a partir des même données, leur variable d'id auront toujours le meme nom -->
        <xsl:value-of select="identifier/attribute/parameter-name"/>
        <xsl:text> inContext:context];&#13;</xsl:text>
        <xsl:text>&#13;}&#13;else{&#13;</xsl:text>
        <xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="../../../mapping/entity[@vm-type = $comboViewModelName]/getter/@name"/>
		<xsl:value-of select="../../../mapping/entity/entity[@vm-type=$selected-entity]/getter/@name"/>
        <xsl:text> = nil;&#13;}&#13;</xsl:text>
  
	</xsl:template>
	
	
</xsl:stylesheet>