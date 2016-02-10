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
<xsl:template match="viewmodel" mode="updateFromIdentifiable-method-header">

/**
  * @brief Update the view model with the data in the given object of type <xsl:value-of select="./entity-to-update/name"/>.
  * @param <xsl:value-of select="./entity-to-update/name"/> entity to fill the view model. The entity can be nil and in this case clears the data in the view model.
  */
-(void) updateFromIdentifiable:(<xsl:value-of select="./entity-to-update/name"/> *)entity ;
</xsl:template>

<!-- updateFromIdentifiable method (implementation)-->
<xsl:template match="viewmodel" mode="updateFromIdentifiable-method">
-(void) updateFromIdentifiable:(<xsl:value-of select="./entity-to-update/name"/> *)entity {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromIdentifiable-before</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:apply-templates select="mapping" mode="generate-method-update"/>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromIdentifiable-after</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	
	<xsl:if test="type/is-list = 'false'">
	self.hasChanged = NO;
	</xsl:if>
}
</xsl:template>	

	<!-- UPDATE IDENTIFIABLE ............................................................................. -->

	<xsl:template match="mapping" mode="generate-method-update">
		<xsl:text>	[self clear];&#13;</xsl:text>
		<xsl:text>if ( entity != nil) {&#13;</xsl:text>

		<xsl:apply-templates select="attribute" mode="generate-method-update"/>

		<xsl:if test=".//entity[@mapping-type='vm' or @mapping-type='vmlist']">
			<xsl:text>		MViewModelCreator *viewModelCreator = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_VIEW_MODEL_CREATOR];&#13;</xsl:text>
		</xsl:if>
		<xsl:apply-templates select=".//entity[@mapping-type='vmlist']" mode="generate-method-update-initvmlist"/>
		<xsl:apply-templates select="entity" mode="generate-method-update"/>

		<xsl:apply-templates select="./.." mode="generate-method-update"/>

		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">update-from-identifiable</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity" mode="generate-method-update">
		<xsl:param name="var-parent-entity">entity</xsl:param>

		<xsl:variable name="var-entity">
			<xsl:text>o</xsl:text>
			<xsl:value-of select="../@type"/>
			<xsl:value-of select="@type"/>
			<xsl:value-of select="position()"/>
		</xsl:variable>
		<xsl:text>		</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> *</xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>;&#13;</xsl:text>
		<xsl:text>	if (</xsl:text><xsl:value-of select="$var-entity"/><xsl:text> == nil) {&#13;	</xsl:text>
		<xsl:if test="@mapping-type">
			<xsl:apply-templates select="." mode="generate-call-clear"/>
		</xsl:if>
		<xsl:text>	} else {&#13;</xsl:text>

		<xsl:apply-templates select="attribute" mode="generate-method-update">
			<xsl:with-param name="var-entity" select="$var-entity"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="entity" mode="generate-method-update">
			<xsl:with-param name="var-parent-entity" select="$var-entity"/>
		</xsl:apply-templates>
		

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<!--  pas maintenant -->
	<xsl:template match="entity[@mapping-type='vm']" mode="generate-method-update">
		<xsl:param name="var-parent-entity">entity</xsl:param>

		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text> == nil) {&#13;</xsl:text>
		<xsl:text>self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = nil;&#13;</xsl:text>
		<xsl:text>}&#13; else {&#13;</xsl:text>
		<xsl:text>self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = oVMCreator.get</xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text></xsl:text>
		<xsl:text>);&#13;</xsl:text>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

<!-- POUR MAINTENANT (LIST) -->
	<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-update">
		<xsl:param name="var-parent-entity">entity</xsl:param>
		<xsl:param name="var-parent-vm">self</xsl:param>

		<xsl:text>&#13;		if (</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text> !=nil) {&#13;</xsl:text>
		
		<xsl:text>			for (id itemData</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> in </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text> ) {&#13;</xsl:text>

		<xsl:text>MFUIBaseViewModel *vmCell = [viewModelCreator createOrUpdate</xsl:text>
		
		<xsl:choose>
			<xsl:when test="../../type/name = 'LISTITEM_2' or ../../type/name = 'LISTITEM_3'">
				<xsl:value-of select="../../subvm/viewmodel/subvm/viewmodel/name"/>
				<xsl:text>:itemData</xsl:text>
		 	 </xsl:when>
		 	 <xsl:otherwise>
				<xsl:value-of select="@vm-type"/>
				<xsl:text>ItemCell:itemData</xsl:text>
			 </xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="@type"/>
		
		<xsl:if test="../../type/name = 'MASTER' and ../../entity-to-update">
			<xsl:text> parentVm:temp</xsl:text><xsl:value-of select="@vm-property-name"/>
		</xsl:if>
		<xsl:text>];&#13;</xsl:text>

		<xsl:if test="not(../../type/name = 'MASTER')">
			<xsl:text>vmCell.parentViewModel = temp</xsl:text><xsl:value-of select="@vm-property-name"/><xsl:text>;&#13;</xsl:text>
		</xsl:if>
		
		<xsl:text>			[temp</xsl:text>
		<xsl:value-of select="@vm-property-name"/>
		<xsl:text> add:vmCell];&#13;</xsl:text>
		<xsl:text>			}&#13;	</xsl:text>
		<xsl:text>	}&#13;</xsl:text>
		
		<xsl:text>self.</xsl:text>
		<xsl:value-of select="@vm-property-name"/>
		<xsl:text> = temp</xsl:text>
		<xsl:value-of select="@vm-property-name"/>
		<xsl:text>;</xsl:text>
	 
	 </xsl:template>
	
	<xsl:template match="attribute" mode="generate-method-update">
		<xsl:param name="var-entity">entity</xsl:param>

		<xsl:text>		self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = </xsl:text>
		<xsl:choose>
			<xsl:when test="getter/@formula">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text">
						<xsl:call-template name="string-replace-all">
							<xsl:with-param name="text" select="getter/@formula"/>
							<xsl:with-param name="replace" select="'PARENTPROPNAME'"/>
							<xsl:with-param name="by">
								<xsl:value-of select="getter/@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="replace" select="'VALUE'"/>
					<xsl:with-param name="by">
						<xsl:value-of select="$var-entity"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="getter/@name"/>
					</xsl:with-param>
				</xsl:call-template>

			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="$var-entity"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="getter/@name"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-method-update-initvmlist">
		<xsl:param name="var-parent-vm">self</xsl:param>
		<xsl:value-of select="@vm-typelist"/>
		<xsl:text> *temp</xsl:text>
		<xsl:value-of select="@vm-property-name"/>
		<xsl:text> = </xsl:text>
		<xsl:text>[viewModelCreator createOrUpdate</xsl:text>
		<xsl:value-of select="@vm-typelist" />
		<xsl:text>:nil];&#13; </xsl:text>
		temp<xsl:value-of select="@vm-property-name"/>.parentViewModel = self ;
	</xsl:template>
	
	<!--  Cas d'une pickerlist dans une fixedList -->
	<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="generate-method-update">
		<xsl:param name="var-parent-entity">entity</xsl:param>
		
		<xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
			<xsl:text>&#13;</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
			<xsl:text> *o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
			<xsl:text> = (</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
			<xsl:text> *) [((</xsl:text>
			<xsl:value-of select="parent-viewmodel/master-interface/@name"/>
			<xsl:text> *)[self parentViewModel]) parentViewModel];&#13;</xsl:text>
			
			<xsl:text>&#13;if(</xsl:text>
			<xsl:value-of select="$var-parent-entity"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="mapping/entity/getter/@name"/>
			<xsl:text>)&#13;{&#13;NSArray *lstVM = [o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
			<xsl:text>.lst</xsl:text>
			<xsl:value-of select="external-lists/external-list/viewmodel/name"/>
			<text> getChildViewModels];&#13;</text>
		    <text>for(</text>
		    <xsl:value-of select="external-lists/external-list/viewmodel/type/item"/>
		    <text> *item in lstVM)&#13;{&#13;</text>
		    <xsl:text> if([item.</xsl:text>
			<xsl:value-of select="identifier/attribute/parameter-name"/>
			<xsl:text> isEqualToNumber:(</xsl:text>
		    <xsl:value-of select="$var-parent-entity"/>
		    <xsl:text>.</xsl:text>
		    <xsl:value-of select="mapping/entity/getter/@name"/>
		    <xsl:text>.</xsl:text>
		    <xsl:value-of select="mapping/attribute[@vm-attr='id_identifier']/getter/@name"/>
		    <xsl:text>)])&#13;</xsl:text>
		    <text>{&#13;self.selected</text>
			<xsl:value-of select="external-lists/external-list/viewmodel/name"/><xsl:text>Item</xsl:text>
		    <text> = item;&#13;}&#13;}&#13;}</text>
	    </xsl:if>
	</xsl:template>

	<!--  Cas d'une pickerlist -->
	<xsl:template match="viewmodel" mode="generate-method-update">
		<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-method-update-for-pickerlist"/>
	</xsl:template>


	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-method-update-for-pickerlist">

		
		<xsl:variable name="selected-entity"><xsl:value-of select="type/conf-name"/></xsl:variable>
		
		<xsl:variable name="var-parent-entity">
		<xsl:choose>
			<xsl:when test="../../../mapping/entity/entity[@vm-type=$selected-entity]">entity.<xsl:value-of select="../../../mapping/entity[entity[@vm-type=$selected-entity]]/getter/@name"></xsl:value-of></xsl:when>
			<xsl:otherwise>entity</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<xsl:text>&#13;if(</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="../../../mapping/entity[@vm-type=$selected-entity]/getter/@name"/>
		<xsl:value-of select="../../../mapping/entity/entity[@vm-type=$selected-entity]/getter/@name"/>
		<xsl:text>)&#13;{&#13;NSArray *lstVM = [self.lst</xsl:text>
		<xsl:value-of select="name"/>
		<text> getChildViewModels];&#13;</text>
	    <text>for(</text>
	    <xsl:value-of select="type/item"/>
	    <text> *item in lstVM)&#13;{&#13;</text>
	    <xsl:text> if([item.</xsl:text>
		<xsl:value-of select="identifier/attribute/parameter-name"/>
		<xsl:text> isEqualToNumber:(</xsl:text>
	    <xsl:value-of select="$var-parent-entity"/>
	    <xsl:text>.</xsl:text>
		<xsl:value-of select="../../../mapping/entity[@vm-type=$selected-entity]/getter/@name"/>
		<xsl:value-of select="../../../mapping/entity/entity[@vm-type=$selected-entity]/getter/@name"/>
	    <xsl:text>.</xsl:text>
	    <xsl:value-of select="../../../mapping/attribute[@vm-attr='id_identifier']/getter/@name"/>
	    <xsl:text>)])&#13;</xsl:text>
	    <text>{&#13;self.selected</text>
	    <xsl:value-of select="type/item"/>
	    <text> = item;&#13;}&#13;}&#13;}</text>
	</xsl:template>

</xsl:stylesheet>