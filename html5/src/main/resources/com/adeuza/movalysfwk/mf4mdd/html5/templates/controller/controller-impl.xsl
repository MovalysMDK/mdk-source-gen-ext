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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/commons/import.xsl"/>

	<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="view">
	<!-- 	//IF MMPanel -> MFFormScopeBuilder -->
	<!-- 	//If MMPanelList -> MFListScopeBuilder -->
	<!-- 	//If Screen -> MFViewScopeBuilder -->
	<xsl:variable name="scopebuilder"><xsl:choose>
			<xsl:when test="@isWorkspace='true'">MFWorkspaceScopeBuilder</xsl:when>
			<xsl:when test="@isPanelOfWorkspace='true' and @is-list='true'">MFWorkspaceMasterScopeBuilder</xsl:when>
			<xsl:when test="@isPanelOfWorkspace='true'">MFWorkspaceDetailScopeBuilder</xsl:when>
			<xsl:when test="@is-list='true'">MFListScopeBuilder</xsl:when>
			<xsl:when test="@isScreen='true'">MFViewScopeBuilder</xsl:when>
			<xsl:otherwise>MFFormScopeBuilder</xsl:otherwise>
		</xsl:choose></xsl:variable>
		
	<xsl:variable name="corresponding-item-name"><xsl:choose>
			<xsl:when test="$scopebuilder='MFFormScopeBuilder'"><xsl:value-of select="name"/><xsl:text>VM</xsl:text></xsl:when>
			<xsl:when test="$scopebuilder='MFListScopeBuilder'"><xsl:value-of select="panel-list-name"/></xsl:when>
			<xsl:when test="$scopebuilder='MFWorkspaceDetailScopeBuilder'"><xsl:value-of select="name"/><xsl:text>VM</xsl:text></xsl:when>
			<xsl:when test="$scopebuilder='MFWorkspaceMasterScopeBuilder'"><xsl:value-of select="panel-list-name"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose></xsl:variable>	
	
		<xsl:text>'use strict';&#10;&#10;</xsl:text>
		<xsl:text>&#10;angular.module('</xsl:text><xsl:value-of select="viewName"/><xsl:text>').controller('</xsl:text><xsl:value-of select="name"/><xsl:text>Ctrl', [&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>
		
		<xsl:text> {&#10;</xsl:text>
		
		<!-- 		viewconfig of the controler -->
		<xsl:apply-templates select="." mode="controller-viewConfig">
			<xsl:with-param name="scopebuilder" select="$scopebuilder"/>
			<xsl:with-param name="corresponding-item-name" select="$corresponding-item-name"/>
		</xsl:apply-templates>
		<!-- 		constructor of the scope -->
		<xsl:apply-templates select="." mode="controller-init">
			<xsl:with-param name="scopebuilder" select="$scopebuilder"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="non-generated-functions">
		</xsl:apply-templates>
		
		<xsl:text>}]);&#10;</xsl:text>
		
	</xsl:template>

	<!-- 	Viewconfig general structure for all view -->
	<xsl:template match="view" mode="controller-viewConfig">
		<xsl:param name="scopebuilder"/>
		<xsl:param name="corresponding-item-name"/>
	
	    <xsl:text>&#10;&#10;$scope.viewConfig = {&#10;</xsl:text>
	    
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">view-config</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<!-- 		If the controller is not an empty screen ctrl	 -->
			    <xsl:apply-templates select="." mode="controller-viewConfig-content">
					<xsl:with-param name="scopebuilder" select="$scopebuilder"/>
					<xsl:with-param name="corresponding-item-name" select="$corresponding-item-name"/>
				</xsl:apply-templates>
       		</xsl:with-param>
        </xsl:call-template>
       
		<xsl:text>&#10;};&#10;</xsl:text>
	</xsl:template>
	
	<!-- 	Viewconfig content for panels -->
	<xsl:template match="view" mode="controller-viewConfig-content">
		<xsl:param name="scopebuilder"/>
		<xsl:param name="corresponding-item-name"/>
	       
		<xsl:text>viewName: '</xsl:text><xsl:value-of select="name"/><xsl:text>' ,&#10;</xsl:text>
		<xsl:text>viewModelFactory: </xsl:text><xsl:value-of select="$corresponding-item-name"/><xsl:text>Factory,&#10;</xsl:text>
		<xsl:if test="(@isPanelOfWorkspace='false' or @is-list='true') and @isAttachedToEntityModel='true'">
		    <xsl:choose>
  				<xsl:when test="@applicationScopeEntityAttached!=''">
					<xsl:text>dataLoader: </xsl:text><xsl:value-of select="@applicationScopeEntityAttached"/><xsl:text>DataLoader,&#10;</xsl:text>		
  				</xsl:when>
			    <xsl:otherwise>
					<xsl:text>dataLoader: </xsl:text><xsl:value-of select="name"/><xsl:text>DataLoader,&#10;</xsl:text>
               </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!-- 			        specific content -->
		<xsl:apply-templates select="." mode="controller-viewConfig-specific-content"/>
		
		<xsl:text>subControlBarTitle: '</xsl:text><xsl:value-of select="name-lc"/><xsl:text>__title',&#10;</xsl:text> 
		<xsl:text>hasSubControlBar: </xsl:text>
		<xsl:choose>
			<xsl:when test="@isPanelOfMultiSection='true' and @isPanelOfWorkspace='false'">
				<xsl:text>true&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false&#10;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 	viewconfig content : specific case of a screen   -->
	<xsl:template match="view[@isScreen='true']" mode="controller-viewConfig-content">
		<xsl:param name="scopebuilder"/>
		
		<xsl:text>viewName: '</xsl:text><xsl:value-of select="name"/><xsl:text>',&#10;</xsl:text>
		<xsl:if test="@isWorkspace='true'">
			<xsl:text>dataLoader: </xsl:text><xsl:value-of select="name"/><xsl:text>DetailDataLoader,&#10;</xsl:text>
			<xsl:if test="@hasSaveAction='true'">
				<xsl:text>saveAction: Save</xsl:text><xsl:value-of select="name"/><xsl:text>Action,&#10;</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:text>screenConfig: {&#10;</xsl:text>
		<xsl:apply-templates select="." mode="controller-viewConfig-exit-state">
			<xsl:with-param name="scopebuilder"><xsl:value-of select="$scopebuilder"/></xsl:with-param>
		</xsl:apply-templates>
		<!-- 		if the screen has panels -->
		<xsl:if test="count(nestedSubviews/nestedSubview)>0">
			<xsl:variable name="exit-boolean">
				<xsl:choose>
					<xsl:when test="@isMainScreen='true'">false</xsl:when>
					<xsl:when test="@isWorkspace='true'">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:text>exitOnSave: </xsl:text><xsl:value-of select="$exit-boolean"/><xsl:text>,&#10;</xsl:text>
			<xsl:text>exitOnCancel: </xsl:text><xsl:value-of select="$exit-boolean"/><xsl:text>,&#10;</xsl:text>
			<xsl:text>exitWithoutSaving: true,&#10;</xsl:text>
			<xsl:text>disabledModeNonEditable: true,&#10;</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="." mode="controller-viewConfig-control-bar"/>
		
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="view" mode="controller-viewConfig-exit-state">
		<xsl:param name="scopebuilder"/>
		<xsl:text>exitState: '</xsl:text><xsl:value-of select="exitState/state"/><xsl:text>',&#10;</xsl:text>
		<xsl:text>exitStateParams: {</xsl:text><xsl:apply-templates select="exitState/param" mode="controller-viewConfig-exit-state-param"/><xsl:text>},&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="view[@isMainScreen='true']" mode="controller-viewConfig-exit-state">
		<xsl:param name="scopebuilder"/>
		<xsl:text>exitState: null,&#10;</xsl:text>
	</xsl:template>
	
	
	
	<xsl:template match="exitState[count(param)>1]/param" mode="controller-viewConfig-exit-state-param">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@paramName"/>
		<xsl:text>': '</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>',&#10;</xsl:text>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@paramName"/>
		<xsl:text>Id': 'new'</xsl:text>
		<xsl:if test="position()!=last()">
			<xsl:text>,&#10;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="exitState/param" mode="controller-viewConfig-exit-state-param">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@paramName"/>
		<xsl:text>': '</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>'&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="view" mode="controller-viewConfig-control-bar">
			<xsl:text>&#10;controlBarTitle: '</xsl:text><xsl:value-of select="name-lc"/><xsl:text>__title',&#10;</xsl:text>
			<xsl:text>hideControlBar: false&#10;</xsl:text>
	</xsl:template>
	
	<!-- 	viewconfig content specific to a list -->
	<xsl:template match="view[@is-list='true']" mode="controller-viewConfig-specific-content">
	
	<xsl:text>detail: [ {level:0, </xsl:text>
	<xsl:choose>
		<xsl:when test="@type='LIST_2'">
			<xsl:text>state: null}, {level:1, </xsl:text>
		</xsl:when>
		<xsl:when test="@type='LIST_3'">
			<xsl:text>state: null}, {level:1, state: null, {level:2, </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<!-- 		lIST_1        -->
		</xsl:otherwise>
	</xsl:choose>
	
	
	<xsl:text>state:'</xsl:text>
	<xsl:choose>
		<xsl:when test="@isPanelOfWorkspace='true'">
			<xsl:value-of select="@screen-name"/><xsl:text>.content.detail</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="detail-screen-name!=''">
				<xsl:value-of select="detail-screen-name"/><xsl:text>.content</xsl:text>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>'}],&#10;</xsl:text>

		<xsl:if test="@type='LIST_2'">
			<xsl:text>groupDetailState: '',&#10;</xsl:text>
		</xsl:if>
		<xsl:text>searchable: false,&#10;</xsl:text>
		<xsl:text>canAdd: '</xsl:text><xsl:value-of select="@can-add='true' and not(@type='LIST_2')"/><xsl:text>',&#10;&#10;</xsl:text>
	</xsl:template>
	
	
	<!-- 	viewconfig content specific to a non list panel -->
	<xsl:template match="view" mode="controller-viewConfig-specific-content">
		 <xsl:text>formName: '</xsl:text><xsl:value-of select="viewName"/><xsl:text>Form',&#10;</xsl:text>
		 <xsl:text>cancelable: true,&#10;</xsl:text> 
		 <xsl:if test="saveAction">
		 	<xsl:text>saveAction: </xsl:text><xsl:value-of select="saveAction"/><xsl:text>,&#10;</xsl:text>
         </xsl:if>
         <xsl:if test="deleteAction">
		 	<xsl:text>deleteAction: </xsl:text><xsl:value-of select="deleteAction"/><xsl:text>,&#10; </xsl:text>
         </xsl:if>
         <xsl:text>&#10; </xsl:text>
	</xsl:template>
	
	
	<!-- 	scopeBuilder constructor -->
	<xsl:template match="view" mode="controller-init">
		<xsl:param name="scopebuilder"/>
		<xsl:text>&#10;&#10;</xsl:text><xsl:value-of select="$scopebuilder"/><xsl:text>.init($scope).then(function(){&#10;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">init-controller-success</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>// $scope.rootActions.goInEditionMode()&#10;</xsl:text>
				<xsl:text>console.log('</xsl:text><xsl:value-of select="name"/><xsl:text>Ctrl loaded');&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
        
        <xsl:text>}, function(e){&#10;</xsl:text>
        
        <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">init-controller-error</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>console.log('error', e);&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>});&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="view" mode="non-generated-functions">
		<xsl:text>&#10;//@non-generated-start[functions]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='functions']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
	</xsl:template>
	
	
	
	<xsl:template match="view" mode="declare-extra-imports">
	
		<objc-import import="$scope" import-in-function="$scope" scope="local"/>
		
	</xsl:template>


</xsl:stylesheet>