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

	<!-- CLEAR VM ............................................................................. -->
	<xsl:template match="mapping" mode="generate-method-clear-header">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * @brief Clear this view model.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>- (void) clear ;&#13;</xsl:text>
		
		<xsl:apply-templates select=".//entity[not(@mapping-type)]" mode="generate-method-clear-header">
			<xsl:sort select="@type"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="entity" mode="generate-method-clear-header">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * @brief Clear datas associated to a </xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>-(void) clear</xsl:text>
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
		</xsl:call-template> ;&#13;
	</xsl:template>
	
	<xsl:template match="mapping" mode="generate-method-clear">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * @brief Clear this view model.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>- (void) clear {&#13;</xsl:text>
		<xsl:apply-templates select="../attribute[@derived='true']" mode="generate-method-clear"/>
		<xsl:apply-templates select="attribute" mode="generate-call-clear"/>
		<xsl:apply-templates select="./.." mode="generate-call-clear"/>
		<xsl:apply-templates select="entity[@mapping-type]" mode="generate-call-clear"/>
		<xsl:apply-templates select="entity[not(@mapping-type)]" mode="generate-call-clear"/>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">clear-after</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>

		<xsl:text>}&#13;</xsl:text>

		<xsl:apply-templates select=".//entity[not(@mapping-type)]" mode="generate-method-clear">
			<xsl:sort select="@type"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select=".//entity[@mapping-type='vm_comboitemselected']" mode="generate-method-clear">
			<xsl:sort select="@type"/>
		</xsl:apply-templates>

	</xsl:template>
	
	<xsl:template match="attribute[@derived='true']" mode="generate-method-clear">
		<xsl:text>self.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="@init"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vm']" mode="generate-call-clear">
		<xsl:text>	self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="@initial-value"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>
 
	<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-call-clear">
		<xsl:text>[self.</xsl:text>
		<xsl:value-of select="@vm-property-name"/>
		<xsl:text> clear];&#13;</xsl:text>
	</xsl:template> 
	
 
	<xsl:template match="entity[not(@mapping-type)]" mode="generate-method-clear">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * @brief Clear datas associated to a </xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>-(void) clear</xsl:text>
		<xsl:variable name="entityname"><xsl:call-template name="string-uppercase-firstchar">
		<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
		</xsl:call-template></xsl:variable>
		<xsl:value-of select="$entityname"/>
		<xsl:text> {&#13;</xsl:text>
		<xsl:apply-templates select="attribute" mode="generate-call-clear"/>
		<xsl:apply-templates select="entity[@mapping-type]" mode="generate-call-clear"/>
		<xsl:apply-templates select="entity[not(@mapping-type)]" mode="generate-call-clear"/>
		<xsl:text> [super clear];&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">clear-after-<xsl:value-of select="$entityname"/></xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="entity[@mapping-type='vm_comboitemselected']" mode="generate-method-clear">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * @brief Clear datas associated to a </xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>-(void) clear</xsl:text>
		<xsl:variable name="entityname"><xsl:call-template name="string-uppercase-firstchar">
		<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
		</xsl:call-template></xsl:variable>
		<xsl:value-of select="$entityname"/>
		<xsl:text> {&#13;</xsl:text>
		<xsl:text>self.selected</xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text>Item = nil;&#13;</xsl:text>
		<xsl:text> [super clear];&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">clear-after-<xsl:value-of select="$entityname"/></xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	

	<xsl:template match="subvm" mode="generate-method-clear">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * @brief Clear the sub view models.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>- (void) clear {&#13;</xsl:text>
		
<!-- 		<xsl:apply-templates select="viewmodel" mode="generate-call-clear"/> -->
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">clear-after</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>

		<xsl:text>}&#13;</xsl:text>
		</xsl:template>
		
	<xsl:template match="viewmodel" mode="generate-call-clear">
		<xsl:text>	[self.</xsl:text>
		<xsl:value-of select="property-name"/>
		<xsl:text> clear];&#13;</xsl:text>
	</xsl:template>


	<xsl:template match="entity" mode="generate-call-clear">
			<xsl:text>	[self clear</xsl:text>
			<xsl:call-template name="string-uppercase-firstchar">
				<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
			</xsl:call-template>
			<xsl:text>];&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="attribute" mode="generate-call-clear">
		<xsl:text>	self.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> = </xsl:text>
		<xsl:choose>
			<xsl:when test="count(vm-attr-initial-value) > 0 and @vm-attr-initial-value != 'nil'">
				<xsl:value-of select="vm-attr-initial-value"/>
			</xsl:when>
		
			<xsl:when test="@initial-value='nil' or @initial-value=''">
				<xsl:text>nil</xsl:text>
			</xsl:when>

			<xsl:when test="@initial-value='true'">
				<xsl:text>@1</xsl:text>
			</xsl:when>
			
			<xsl:when test="@initial-value='false'">
				<xsl:text>@0</xsl:text>
			</xsl:when>


			<xsl:when test="getter/@formula">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="getter/@formula"/>
					<xsl:with-param name="replace" select="'VALUE'"/>
					<xsl:with-param name="by" select="@initial-value"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="@initial-value"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>
	
			<!--  Cas d'une pickerlist -->
	<xsl:template match="viewmodel" mode="generate-call-clear">
		<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-call-clear-for-pickerlist"/>
		
	</xsl:template>
			
			
	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-call-clear-for-pickerlist">
		<xsl:param name="var-parent-entity">entity</xsl:param>
		<xsl:text>&#13;self.selected</xsl:text>
		<xsl:value-of select="type/item"/>
		<xsl:text> = nil ;&#13;</xsl:text>

    	<xsl:text>if(self.lst</xsl:text><xsl:value-of select="name"/>
		<xsl:text> &amp;&amp; [self.lst</xsl:text><xsl:value-of select="name"/>
		<xsl:text> getChildViewModels] &amp;&amp; [self.lst</xsl:text><xsl:value-of select="name"/>
		<xsl:text> getChildViewModels].count > 0) {&#13;&#13; self.selected</xsl:text>
		<xsl:value-of select="type/item"/>
		<xsl:text> = [[self.lst</xsl:text><xsl:value-of select="name"/>
		<xsl:text> getChildViewModels] objectAtIndex:0];&#13;}&#13;</xsl:text>

	</xsl:template>
	
<!-- 	Cas d'une pickerlist a l'intérieur d'une fixedlist -->
	<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="generate-call-clear">
		<xsl:param name="var-parent-entity">entity</xsl:param>
		<xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
		
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
			<xsl:text> *o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		    <xsl:text> = (</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		    <xsl:text> *) [((</xsl:text>
			<xsl:value-of select="parent-viewmodel/master-interface/@name"/>
		    <xsl:text>  *)[self parentViewModel]) parentViewModel];&#13;&#13;if (o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		    <xsl:text>.lst</xsl:text>
		    <xsl:value-of select="external-lists/external-list/viewmodel/name"/>
		    <xsl:text> &amp;&amp; [o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		    <xsl:text>.lst</xsl:text>
		    <xsl:value-of select="external-lists/external-list/viewmodel/name"/>
		    <xsl:text> getChildViewModels] &amp;&amp; &#13;[o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		    <xsl:text>.lst</xsl:text>
		    <xsl:value-of select="external-lists/external-list/viewmodel/name"/>
		    <xsl:text> getChildViewModels].count > 0) {&#13;self.selected</xsl:text>
			<xsl:value-of select="external-lists/external-list/viewmodel/name"/><xsl:text>Item</xsl:text>
		    <xsl:text> = [[o</xsl:text>
			<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		    <xsl:text>.lst</xsl:text>
		    <xsl:value-of select="external-lists/external-list/viewmodel/name"/>
		    <xsl:text> getChildViewModels] objectAtIndex:0];&#13;&#13; }</xsl:text>
	    </xsl:if>
	</xsl:template>
	
	
	
	
</xsl:stylesheet>