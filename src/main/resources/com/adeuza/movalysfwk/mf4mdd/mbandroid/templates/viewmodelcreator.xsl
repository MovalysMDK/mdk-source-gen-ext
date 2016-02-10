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

	<xsl:include href="includes/class.xsl"/>

	<xsl:key name="viewmodel-name" match="viewmodel" use="implements/interface/@name"/>

	<xsl:template match="/">
		<xsl:apply-templates select="master-viewmodelcreator/viewmodelcreator" mode="declare-class"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="viewmodelcreator" mode="declare-extra-imports">
		<import>java.util.Collection</import>
	
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.DefaultViewModelCreator</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModelImpl</import>
		<xsl:apply-templates select="screens/screen/viewmodel-interface/full-name" mode="declare-import"/>
		<xsl:apply-templates select="screens/screen/viewmodel/full-name" mode="declare-import"/>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	<xsl:template match="viewmodelcreator" mode="superclass">
		<xsl:text>DefaultViewModelCreator</xsl:text>
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="viewmodelcreator" mode="methods">
	
		<xsl:apply-templates select="//viewmodel[generate-id() = generate-id(key('viewmodel-name', ./implements/interface/@name)[1])]" mode="create-vm">
			<xsl:sort select="implements/interface/@name"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="screens/screen/pages/page[not(adapter) or dialog/adapter]/viewmodel//external-lists/external-list/viewmodel |
			screens/screen/pages/page/dialogs/dialog[external-adapters/adapter]/viewmodel//external-lists/external-list/viewmodel" mode="get-vm">
			<xsl:sort select="implements/interface/@name"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
		===================================================================================
			Templates de génération des méthodes
		===================================================================================
			- Ajouter ici tout nouveau template de génération.
	-->

	<xsl:template match="viewmodel" mode="create-vm">
		/**
		 * Create an empty viewmodel.
		 * @return An empty view model.
		 */
		public <xsl:value-of select="implements/interface/@name"/> create<xsl:value-of select="implements/interface/@name"/>() {
			<xsl:text>return this.createOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(</xsl:text><xsl:if test="entity-to-update"><xsl:text>null</xsl:text></xsl:if><xsl:text>);&#13;</xsl:text>
		}

		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Create and update a view model</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if>
		<xsl:text>&#13;</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> * @param p_oData An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>&#13;</xsl:text></xsl:if>
		<xsl:text> * @return The view model representation</xsl:text><xsl:if test="entity-to-update">
		<xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance&#13;</xsl:text></xsl:if>
		<xsl:text> */&#13;</xsl:text>
		public <xsl:value-of select="implements/interface/@name"/> createOrUpdate<xsl:value-of select="implements/interface/@name"/>(<xsl:if test="entity-to-update">final <xsl:value-of select="entity-to-update/name"/> p_oData</xsl:if>) {
		<xsl:text>final </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> r_oMasterViewModel = this.createVM(p_oData, </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.class);&#13;</xsl:text>

		<xsl:if test="entity-to-update"><xsl:text>r_oMasterViewModel.updateFromIdentifiable(p_oData);&#13;</xsl:text></xsl:if>

		<xsl:text>return r_oMasterViewModel;&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="create-vm">		
	
		/**
		 * Create an empty viewmodel.
		 * @param p_oParent the view model parent
		 * @return An empty view model.
		 */
		public <xsl:value-of select="implements/interface/@name"/> createOrUpdate<xsl:value-of select="implements/interface/@name"/>(AbstractViewModel p_oParent) {
			<xsl:text>return this.createOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/>
			<xsl:text>(</xsl:text><xsl:if test="entity-to-update"><xsl:text>null</xsl:text></xsl:if>,<xsl:text> p_oParent);&#13;</xsl:text>
		}
		
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Create an empty viewmodel.&#13;</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> * @param p_oData An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>&#13;</xsl:text></xsl:if> 
		<xsl:text> * @return An empty view model.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		public <xsl:value-of select="implements/interface/@name"/> createOrUpdate<xsl:value-of select="implements/interface/@name"/>(<xsl:if test="entity-to-update">final <xsl:value-of select="entity-to-update/name"/> p_oData</xsl:if>) {
			<xsl:text>return this.createOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/>
			<xsl:text>(</xsl:text><xsl:if test="entity-to-update"><xsl:text>p_oData</xsl:text></xsl:if>,<xsl:text> null);&#13;</xsl:text>
		}

		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Create and update a view model</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if>
		<xsl:text>&#13;</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> * @param p_oData An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>&#13;</xsl:text></xsl:if>
		<xsl:text> * @param p_oParent the view model parent&#13;</xsl:text>
		<xsl:text> * @return The view model representation</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance</xsl:text></xsl:if>
		<xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		public <xsl:value-of select="implements/interface/@name"/> createOrUpdate<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(</xsl:text><xsl:if test="entity-to-update">final <xsl:value-of select="entity-to-update/name"/> p_oData,</xsl:if> AbstractViewModel p_oParent) {
		<xsl:text>final </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> r_oMasterViewModel = this.createVM(p_oData, </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.class);&#13;</xsl:text>
		r_oMasterViewModel.setParent(p_oParent);
		<xsl:if test="entity-to-update"><xsl:text>r_oMasterViewModel.updateFromIdentifiable(p_oData);&#13;</xsl:text></xsl:if>

		<xsl:text>return r_oMasterViewModel;&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='MASTER']" mode="create-vm">
	
	<xsl:apply-templates select="." mode="create-vm-data-state-class"/>
		
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Create an empty viewmodel.&#13;</xsl:text>
		<xsl:if test="multiInstance='true'"><xsl:text> * @param p_sKey the instance of the linked panel&#13;</xsl:text></xsl:if>
		<xsl:text> * @return An empty view model.&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="implements/interface/@name"/> create<xsl:value-of select="implements/interface/@name"/><xsl:text>(</xsl:text>
		<xsl:if test="multiInstance='true'">
			<xsl:text>String p_sKey</xsl:text>
		</xsl:if>
		<xsl:text>) {</xsl:text>
			<xsl:text>return this.createOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(</xsl:text>
			<xsl:choose>
				<xsl:when test="entity-to-update">
					<xsl:if test="multiInstance='true'">
						<xsl:text>p_sKey, </xsl:text>
					</xsl:if>
					<xsl:text>null</xsl:text>
					<xsl:text>, true</xsl:text>
						<xsl:if test="(count(external-lists/external-list) > 0) or (count(subvm/viewmodel/external-lists/external-list) > 0) and subvm/viewmodel[type/name='FIXED_LIST']">
							<xsl:text>, new VO</xsl:text>
							<xsl:value-of select="implements/interface/@name"/><xsl:text>()</xsl:text>
						</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>true</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>);&#13;</xsl:text>
		}

		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Create and update a view model</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if>
		<xsl:text>&#13;</xsl:text>
		<xsl:choose>
			<xsl:when test="entity-to-update">
				<xsl:if test="multiInstance='true'"><xsl:text> * @param p_sKey the instance of the linked panel&#13;</xsl:text></xsl:if>
		<xsl:text> * @param p_oData An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @param p_bModified true if the entity was modified&#13;</xsl:text>
				<xsl:if test="(count(external-lists/external-list) > 0) or (count(subvm/viewmodel/external-lists/external-list) > 0) and subvm/viewmodel[type/name='FIXED_LIST']">
					<xsl:text>* @param p_oInfo an instance of VO</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>&#13;</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:text> * @param p_bModified true if the entity was modified&#13;</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:text> * @return The view model representation</xsl:text>
		<xsl:if test="entity-to-update"><xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance</xsl:text></xsl:if>
		<xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="implements/interface/@name"/>
		<xsl:text> createOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="entity-to-update">
			<xsl:if test="multiInstance='true'">
				<xsl:text>String p_sKey, </xsl:text>
			</xsl:if>
			<xsl:text>final </xsl:text><xsl:value-of select="entity-to-update/name"/>
			<xsl:text> p_oData, boolean p_bModified</xsl:text>
					<xsl:if test="(count(external-lists/external-list) > 0) or (count(subvm/viewmodel/external-lists/external-list) > 0) and subvm/viewmodel[type/name='FIXED_LIST']">
						<xsl:text>, VO</xsl:text><xsl:value-of select="implements/interface/@name"/>
						<xsl:text> p_oInfo</xsl:text>
					</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>boolean p_bModified</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>) {&#13;</xsl:text>

		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> r_oMasterViewModel = null;&#13;</xsl:text>
		<xsl:text>if (p_bModified) {&#13;</xsl:text>
		<xsl:text>r_oMasterViewModel = this.createVM(</xsl:text>
		<xsl:if test="multiInstance='true'">
			<xsl:value-of select="implements/interface/@name"/>
			<xsl:text>.class.getName()+"#"+p_sKey, </xsl:text>
		</xsl:if>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.class);&#13;</xsl:text>
		<xsl:text>} else {&#13;</xsl:text>
		<xsl:text>r_oMasterViewModel = this.getViewModel(</xsl:text>
		<xsl:if test="multiInstance='true'">
			<xsl:value-of select="implements/interface/@name"/>
			<xsl:text>.class.getName()+"#"+p_sKey, </xsl:text>
		</xsl:if>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.class);&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		
		<xsl:apply-templates select=".//external-lists/external-list" mode="generate-view-model-creation">
			<xsl:with-param name="viewmodel-implementation" select="./name"/>
		</xsl:apply-templates>

		<xsl:if test="entity-to-update">
			<xsl:text>if (p_bModified) {&#13;</xsl:text>
			<xsl:text>r_oMasterViewModel.updateFromIdentifiable(p_oData);&#13;</xsl:text>
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
		<xsl:text>return r_oMasterViewModel;&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>

		<xsl:apply-templates select="self::node()[dataloader-impl]" mode="create-vm-using-loader"/>
	</xsl:template>

	<!-- .................................. [START] VM DATA MODIFIER CLASS .................................. -->
	<xsl:template match="viewmodel" mode="create-vm-data-state-class">
		
		<xsl:if test="external-lists/external-list or subvm/viewmodel[type/name='FIXED_LIST']/external-lists/external-list">
		
		/**
		 * Modification of data for <xsl:value-of select="implements/interface/@name"/>
		 */
		public static class VO<xsl:value-of select="implements/interface/@name"/> {
			/** attributes */
			<xsl:for-each select="external-lists/external-list">
				<xsl:variable name="listName">list<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:text>/** private </xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text> list */&#13;</xsl:text>
				<xsl:text>private Collection&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>&gt; </xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>/** private boolean </xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text> modified */&#13;</xsl:text>
				<xsl:text>private boolean </xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>Modified;&#13;</xsl:text>
			</xsl:for-each>
			
			<xsl:for-each select="subvm/viewmodel[type/name='FIXED_LIST']/external-lists/external-list">
				<xsl:variable name="listName">list<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:text>/** private </xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text> list */&#13;</xsl:text>
				<xsl:text>private Collection&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>&gt; </xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>/** private boolean </xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text> modified */&#13;</xsl:text>
				<xsl:text>private boolean </xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>Modified;&#13;</xsl:text>
			</xsl:for-each>
			
			
			/** constructor */
			<xsl:text>public VO</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> () {&#13;</xsl:text>
			<xsl:for-each select="external-lists/external-list">
				<xsl:variable name="listNameModified">list<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text> = false;&#13;</xsl:text>
			</xsl:for-each>
			
			<xsl:for-each select="subvm/viewmodel[type/name='FIXED_LIST']/external-lists/external-list">
				<xsl:variable name="listNameModified">list<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text> = false;&#13;</xsl:text>
			</xsl:for-each>
			
			
			<xsl:text>}&#13;</xsl:text>
			
			/** getter/setter */
			<xsl:for-each select="external-lists/external-list">
				<xsl:variable name="listName">list<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:variable name="setterlistName">setList<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:variable name="getterlistName">getList<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:variable name="listNameModified">list<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
				<xsl:variable name="setterlistNameModified">setList<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
				<xsl:variable name="getterlistNameModified">isList<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
			
				/**
				 * setter for <xsl:value-of select="$listName"/>
				 * @param p_o<xsl:value-of select="$listName"/> the value to set
				 */
				<xsl:text>public void </xsl:text><xsl:value-of select="$setterlistName"/>
				<xsl:text>(</xsl:text>
				<xsl:text>Collection&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>&gt; p_o</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>) {&#13;</xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text> = p_o</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
				/**
				 * getter for <xsl:value-of select="$listName"/>
				 * @return the value of <xsl:value-of select="$listName"/>
				 */
				<xsl:text>public Collection&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>&gt; </xsl:text><xsl:value-of select="$getterlistName"/>
				<xsl:text>() {&#13;</xsl:text>
				<xsl:text>return </xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
				/**
				 * sets the modified status of <xsl:value-of select="$listName"/>
				 * @param p_o<xsl:value-of select="$listNameModified"/> true if the list was modified
				 */
				<xsl:text>public void </xsl:text><xsl:value-of select="$setterlistNameModified"/>
				<xsl:text>(boolean p_o</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text>) {&#13;</xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text> = p_o</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
				/**
				 * returns whether <xsl:value-of select="$listName"/> was modified
				 * @return true if <xsl:value-of select="$listName"/> was modified
				 */
				<xsl:text>public boolean </xsl:text><xsl:value-of select="$getterlistNameModified"/>
				<xsl:text>() {&#13;</xsl:text>
				<xsl:text>return </xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
			</xsl:for-each>
			
			<xsl:for-each select="subvm/viewmodel[type/name='FIXED_LIST']/external-lists/external-list">
				<xsl:variable name="listName">list<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:variable name="setterlistName">setList<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:variable name="getterlistName">getList<xsl:value-of select="viewmodel/uml-name"/></xsl:variable>
				<xsl:variable name="listNameModified">list<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
				<xsl:variable name="setterlistNameModified">setList<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
				<xsl:variable name="getterlistNameModified">isList<xsl:value-of select="viewmodel/uml-name"/>Modified</xsl:variable>
			
				/**
				 * setter for <xsl:value-of select="$listName"/>
				 * @param p_o<xsl:value-of select="$listName"/> the value to set
				 */
				<xsl:text>public void </xsl:text><xsl:value-of select="$setterlistName"/>
				<xsl:text>(</xsl:text>
				<xsl:text>Collection&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>&gt; p_o</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>) {&#13;</xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text> = p_o</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
				/**
				 * getter for <xsl:value-of select="$listName"/>
				 * @return the value of <xsl:value-of select="$listName"/>
				 */
				<xsl:text>public Collection&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>&gt; </xsl:text><xsl:value-of select="$getterlistName"/>
				<xsl:text>() {&#13;</xsl:text>
				<xsl:text>return </xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listName"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
				/**
				 * sets the modified status of <xsl:value-of select="$listName"/>
				 * @param p_o<xsl:value-of select="$listNameModified"/> true if the list was modified
				 */
				<xsl:text>public void </xsl:text><xsl:value-of select="$setterlistNameModified"/>
				<xsl:text>(boolean p_o</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text>) {&#13;</xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text> = p_o</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
				/**
				 * returns whether <xsl:value-of select="$listName"/> was modified
				 * @return true if <xsl:value-of select="$listName"/> was modified
				 */
				<xsl:text>public boolean </xsl:text><xsl:value-of select="$getterlistNameModified"/>
				<xsl:text>() {&#13;</xsl:text>
				<xsl:text>return </xsl:text>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="$listNameModified"/>
				<xsl:text>;&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				
			</xsl:for-each>
			
			
		}
		
		</xsl:if>
	</xsl:template>
	<!-- .................................. [END] VM DATA MODIFIER CLASS .................................. -->

	<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3']" mode="create-vm">
	
		/**
		 * Create an empty viewmodel.
		 * @return An empty view model.
		 */
		public <xsl:value-of select="implements/interface/@name"/> create<xsl:value-of select="implements/interface/@name"/>() {
			<xsl:text>return this.createOrUpdate</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>(</xsl:text><xsl:if test="entity-to-update"><xsl:text>null</xsl:text></xsl:if><xsl:text>);&#13;</xsl:text>
		}

		/**
		 * Create and update a view model using a collection of <em><xsl:value-of select="./entity-to-update/name"/></em>.
		 * @param p_oDatas A collection of <em><xsl:value-of select="./entity-to-update/name"/></em>.
		 * @return The view model representation of a collection of <em><xsl:value-of select="./entity-to-update/name"/></em>.
		 */
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> createOrUpdate</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>(final Collection&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt; p_oDatas</xsl:text>
		<xsl:apply-templates select="./external-lists/external-list" mode="generate-parameter"/>
		<xsl:text>) {&#13;</xsl:text>

		<xsl:text>final </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> r_oMasterViewModel = this.createVM(</xsl:text>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="./implements/interface/@full-name"/>
		<xsl:text>", p_oDatas, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>.class, </xsl:text>
		<xsl:value-of select="./subvm/viewmodel/implements/interface/@name"/>
		<xsl:text>.class);&#13;</xsl:text>

		<xsl:apply-templates select="./external-lists/external-list" mode="generate-view-model-creation">
			<xsl:with-param name="viewmodel-implementation" select="./name"/>
		</xsl:apply-templates>

		<xsl:text>return r_oMasterViewModel;&#13;}&#13;</xsl:text>

		<xsl:apply-templates select="self::node()[dataloader-impl]" mode="create-vm-using-loader"/>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='MASTER' and (workspace-vm='true' or multipanel-vm='true')]" mode="create-vm">
		/**
		 * Create and update the view model.
		 * @return The view model
		 */
		public <xsl:value-of select="./implements/interface/@name"/> create<xsl:value-of select="./implements/interface/@name"/>() {
			final <xsl:value-of select="./implements/interface/@name"/> r_oMasterViewModel =  this.createVM(<xsl:value-of select="implements/interface/@name"/>.class);
			<xsl:for-each select="subvm/viewmodel[not(multiInstance='true')]/implements/interface/@name">
				<xsl:text>r_oMasterViewModel.set</xsl:text><xsl:value-of select="."/>(this.create<xsl:value-of select="."/>());
			</xsl:for-each>
			return r_oMasterViewModel;
		}
	</xsl:template>

	<xsl:template match="viewmodel" mode="get-vm">
		/**
		 * Retreive a view model into the cache. Here, there isn't creation or update.
		 * @param p_oData A entity's instance. Never null.
		 * @return The view model representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.
		 */
		public <xsl:value-of select="implements/interface/@name"/> get<xsl:value-of select="implements/interface/@name"/>(<xsl:value-of select="entity-to-update/name"/> p_oData) {
			return this.getViewModel(p_oData, <xsl:value-of select="implements/interface/@name"/>.class);
		}
	</xsl:template>

<xsl:template match="external-list" mode="generate-parameter">
	<xsl:text>, final Collection&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>&gt; p_list</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>s</xsl:text>
	<xsl:value-of select="position()"/>
</xsl:template>

<xsl:template match="external-list" mode="generate-view-model-creation">
	<xsl:param name="viewmodel-implementation"/>

	<xsl:variable name="var-list">
		<xsl:text>list</xsl:text>
		<xsl:value-of select="./viewmodel/implements/interface/@name"/>
		<xsl:text>s</xsl:text>
		<xsl:value-of select="position()"/>
	</xsl:variable>

	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text> = r_oMasterViewModel.</xsl:text>
	<xsl:value-of select="./viewmodel/list-accessor-get-name"/>
	<xsl:text>();&#13;</xsl:text>
	<xsl:text>if (</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text> == null) {&#13;</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text> = new ListViewModelImpl&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt;(</xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>.class);&#13;</xsl:text>
	<xsl:text>r_oMasterViewModel.</xsl:text>
	<xsl:value-of select="./viewmodel/list-accessor-set-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text>);&#13;}&#13;else if (p_oInfo</xsl:text>
	<xsl:text>.isList</xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>Modified()</xsl:text>
	<xsl:text>) {&#13;</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text>.clear();&#13;}&#13;</xsl:text>

	<xsl:text>if (p_oInfo</xsl:text>
	<xsl:text>.getList</xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>()</xsl:text>
	<xsl:text> != null &amp;&amp; p_oInfo</xsl:text>
	<xsl:text>.isList</xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>Modified()</xsl:text>
	<xsl:text>) {&#13;</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text>.setItems(p_oInfo</xsl:text>
	<xsl:text>.getList</xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>()</xsl:text>
	<xsl:text>);</xsl:text>
	<xsl:text>}&#13;&#13;</xsl:text>
</xsl:template>

	<xsl:template match="viewmodel[dataloader-impl]" mode="create-vm-using-loader">
<!--
		/**
		 * Retreive a view model into the cache. Here, there isn't creation or update.
		 * 
		 * @param p_oDataLoader
		 * 			A DataLoader. Never null.
		 * 
		 * @return The view model representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.
		 */
		<xsl:text>public </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> createOrUpdate</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
		<xsl:text> p_oDataLoader) {&#13;</xsl:text>
		<xsl:text>return this.createOrUpdate</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(p_oDataLoader.getData()</xsl:text>
		<xsl:apply-templates select=".//external-list" mode="generate-parameter-loader"/>
		<xsl:text>);&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
-->
	</xsl:template>

	<xsl:template match="external-list" mode="generate-parameter-loader">
		<!-- A revoir lorsque DataLoader alimenté -->
		<xsl:text>, new ArrayList&lt;</xsl:text>
		<xsl:value-of select="./viewmodel/entity-to-update/name"/>
		<xsl:text>&gt;()</xsl:text>
<!-- 		<xsl:text>, p_oDataLoader.getList</xsl:text>
		<xsl:value-of select="./viewmodel/entity-to-update/name"/>
		<xsl:text>()</xsl:text>
 -->
	</xsl:template>
</xsl:stylesheet>
