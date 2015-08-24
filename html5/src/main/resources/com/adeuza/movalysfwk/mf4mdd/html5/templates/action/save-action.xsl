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
	
	<xsl:template match="action[action-type='SAVEDETAIL']" mode="genereAction">

		<xsl:variable name="vmFactory"><xsl:value-of select="viewmodel/name"/>Factory</xsl:variable>
		<xsl:variable name="daoProxy"><xsl:value-of select="dao-interface/name"/>Proxy</xsl:variable>
		<xsl:variable name="entity"><xsl:value-of select="class/name"/></xsl:variable>

		<xsl:choose>
			<xsl:when test="parameters/parameter[@name='WorkspaceLoaderName']">
				<xsl:apply-templates select="." mode="genere-action-params">
					<xsl:with-param name="vmFactory" select="$vmFactory"/>
					<xsl:with-param name="daoProxy" select="$daoProxy"/>
					<xsl:with-param name="entity" select="$entity"/>
					<xsl:with-param name="dataloader" select="parameters/parameter[@name='WorkspaceLoaderName']"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="genere-action-params">
					<xsl:with-param name="vmFactory"><xsl:value-of select="viewmodel/name"/>Factory</xsl:with-param>
					<xsl:with-param name="daoProxy"><xsl:value-of select="dao-interface/name"/>Proxy</xsl:with-param>
					<xsl:with-param name="entity"><xsl:value-of select="class/name"/></xsl:with-param>
					<xsl:with-param name="dataloader" select="viewmodel/dataloader-impl/name"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="*" mode="genere-action-params">
		<xsl:param name="vmFactory"/>
		<xsl:param name="daoProxy"/>
		<xsl:param name="entity"/>
		<xsl:param name="dataloader"/>
		
		<xsl:text>'use strict';&#10;</xsl:text>
		<xsl:text>&#10;//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<xsl:text>angular.module('view_</xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>', [</xsl:text>
		
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>
		
		<xsl:text>{&#10;</xsl:text>
		<xsl:text>return {&#10;</xsl:text>
		<xsl:text>createInstance: function() {&#10;&#10;</xsl:text>
		
		<xsl:text>var action = MFBaseAction.createInstance({&#10;</xsl:text>
		<xsl:text>atomic: true,&#10;</xsl:text>
		<xsl:text>database: true,&#10;</xsl:text>
		<xsl:text>type: '</xsl:text><xsl:value-of select="name"/><xsl:text>'&#10;</xsl:text>
		<xsl:text>});&#10;&#10;</xsl:text>
		
		<xsl:text>/**&#10;</xsl:text>
		<xsl:text> * Execute operations&#10;</xsl:text>
		<xsl:text> **/&#10;</xsl:text>
		<xsl:text>action.doAction = function(context, params) {&#10;&#10;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doAction</xsl:with-param>
			<xsl:with-param name="defaultSource">
		
				<xsl:text>var that = this;&#10;</xsl:text>
				<xsl:text>try {&#10;</xsl:text>	
			
				<!-- not workspace/workspace-screen='true' -->
				<xsl:if test="not(../workspace/workspace-screen='true')">
				
					<xsl:text>var viewModel = params.viewModel;&#10;</xsl:text>
					<xsl:text></xsl:text><xsl:value-of select="$vmFactory"/><xsl:text>.updateDataLoaderEntityWithViewModel(</xsl:text><xsl:value-of select="$dataloader"/><xsl:text>, viewModel);&#10;&#10;</xsl:text>
				
				</xsl:if>
			
				<xsl:choose>
					<xsl:when test="class/transient = 'false' and ../workspace/workspace-detail='true'">
						<xsl:text>that.resolvePromise(</xsl:text><xsl:value-of select="$dataloader"/><xsl:text>.dataModel, context);&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="class/transient = 'false'">
						<xsl:value-of select="$daoProxy"/><xsl:text>.saveOrUpdate</xsl:text>
						<xsl:value-of select="$entity"/><xsl:text>(</xsl:text><xsl:value-of select="$dataloader"/>
						<xsl:text>.dataModel, context, </xsl:text>
						<xsl:apply-templates select="viewmodel/savecascades" mode="cascades"/>
						<xsl:text>, true).then( function(modelEntity) {&#10;</xsl:text>
						
						<xsl:if test="not(../workspace/workspace-screen='true')">
							<xsl:value-of select="$vmFactory"/><xsl:text>.updateViewModelWithDataLoader(viewModel, </xsl:text><xsl:value-of select="$dataloader"/><xsl:text>);&#10;</xsl:text>
						</xsl:if>
						
						<xsl:text>that.resolvePromise(modelEntity.idToString, context);&#10;</xsl:text>
						<xsl:text>}, function(error) {&#10;</xsl:text>
						<xsl:text>context.addError('Error saving data: '+error);&#10;</xsl:text>
						<xsl:text>that.rejectPromise(error, context);&#10;</xsl:text>
						<xsl:text>});&#10;&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="$dataloader and class/transient = 'true' and not(../workspace/workspace-screen='true')">
						<xsl:text>that.resolvePromise(</xsl:text><xsl:value-of select="$dataloader"/><xsl:text>.dataModel.idToString, context);&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
				
				
				<xsl:text>} catch (error) {&#10;</xsl:text>
				<xsl:text>context.addError('Error saving data: '+error);&#10;</xsl:text>
				<xsl:text>that.rejectPromise(error, context);&#10;</xsl:text>
				<xsl:text>}&#10;</xsl:text>
				<xsl:text>return this;&#10;</xsl:text>
		
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>};&#10;&#10;</xsl:text>
		
		<xsl:text>return action;&#10;</xsl:text>
		<xsl:text>}&#10;&#10;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">other-methods</xsl:with-param>
			<xsl:with-param name="defaultSource">
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>};&#10;&#10;</xsl:text>
		
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>]);&#10;</xsl:text>
		
	</xsl:template>
	
	<xsl:template match="action[action-type='SAVEDETAIL']" mode="declare-extra-imports">
			
		<objc-import import="MFBaseAction" import-in-function="MFBaseAction" scope="local"/>
		<objc-import import="$injector" import-in-function="$injector" scope="local"/>
		
	</xsl:template>
	

</xsl:stylesheet>