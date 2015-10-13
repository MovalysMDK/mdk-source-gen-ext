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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
xmlns:str="http://exslt.org/strings"
extension-element-prefixes="exsl">

<xsl:output method="text"/>

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/dao/dao-methods-name.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/dao/dao-methods-parameters.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/dao/dao-methods-documentation.xsl"/>
	
	

	<!-- ##################################################
			GESTION DES CASCADES
		 ################################################## -->

	<xsl:template match="dao" mode="generateCascadeData">
		<!-- Traite les cascades vers 1 -->
		<xsl:apply-templates select="class/association[@transient='false' and @type !='one-to-many' and descendant::attribute[@transient = 'false']]"
				mode="generate-cascade-data"/>

		<!-- Traite les cascades vers n -->
		<xsl:apply-templates select="class/association[@transient = 'false' and (@type='one-to-many' or @type='many-to-many' or (@type='one-to-one' and @relation-owner='false')) and not(parent::association)]"
				mode="generate-cascade-data"/>
	</xsl:template>

	<xsl:template match="association" mode="generate-cascade-data">
		<xsl:variable name="readAction">
			<xsl:apply-templates select="." mode="generate-cascade-readAction"/>
		</xsl:variable>

		<xsl:element name="cascade">
			<xsl:attribute name="readAction">				<xsl:value-of select="$readAction"/></xsl:attribute>
			<xsl:attribute name="parentAttrPointingChild">	<xsl:value-of select="@name"/>												</xsl:attribute>
			<xsl:attribute name="childDao">					<xsl:value-of select="class/name"/><xsl:text>Dao</xsl:text>					</xsl:attribute>
			<xsl:attribute name="childAttrPointingParent">	<xsl:value-of select="@opposite-name"/>										</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="association[@type='many-to-many' or @type='one-to-many']" mode="generate-cascade-readAction">
		<xsl:text>getList</xsl:text>
	</xsl:template>

	<xsl:template match="association[@type='many-to-one' or @type='one-to-one']" mode="generate-cascade-readAction">
		<xsl:text>get</xsl:text>
	</xsl:template>

	<!-- ############################################################
			METHODES SIMPLES : GET/SAVE/UPDATE/SAVEORUPDATE/DELETE
		 ############################################################ -->

	<xsl:template match="dao" mode="simple-methods">
		<xsl:param name="methodNameToken" />
		<xsl:param name="methodParameterToken" />
		<xsl:param name="methodCriteriaToken" />
		<xsl:param name="methodInnerJoinToken" />
		
		
		<xsl:variable name="methodNameFull">
			<xsl:apply-templates select="." mode="methods-name">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="parametersWithMultipleEntitiesFiltered">
			<xsl:choose>
				<xsl:when test="contains($methodParameterToken,',')">p_properties</xsl:when>
				<xsl:otherwise><xsl:value-of select="$methodParameterToken"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="methodParametersFull">
			<xsl:apply-templates select="." mode="methods-parameters">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$parametersWithMultipleEntitiesFiltered"/>
			</xsl:apply-templates>
		</xsl:variable>
				
		
		<!-- function documentation -->
		<xsl:apply-templates select="." mode="methods-documentation">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
				<xsl:with-param name="methodCriteriaToken" select="$methodCriteriaToken"/>						
		</xsl:apply-templates>


		<!-- function prototype -->
		<xsl:text>	</xsl:text><xsl:value-of select="//name"/><xsl:text>.prototype.</xsl:text><xsl:value-of select="$methodNameFull" />		
		<xsl:text> = function(</xsl:text><xsl:value-of select="$methodParametersFull" /><xsl:text>) {&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		
			
		<!-- function body -->
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:value-of select="$methodNameFull" />-before</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#10;</xsl:text>
				
		<!-- function body: console.assert -->
		<!-- function body: console.assert: p_context, p_cascadeSet -->
		<xsl:text>		console.assert(!angular.isUndefinedOrNull(p_context), '</xsl:text>
							<xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
							<xsl:text>() : p_context is required ');&#10;</xsl:text>
		<xsl:text>		console.assert(angular.isArray(p_cascadeSet), '</xsl:text>
							<xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
							<xsl:text>() : p_cascadeSet is required and should be an array');&#10;</xsl:text>

		<!-- function body: console.assert: other -->
		<xsl:choose>
			<xsl:when test="$methodParameterToken='p_ids'">
				<xsl:text>		console.assert(angular.isUndefinedOrNull(p_ids) || angular.isArray(p_ids), '</xsl:text>
									<xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
									<xsl:text>() : p_ids should be an array, if given');&#10;</xsl:text>
			</xsl:when>		
			<xsl:when test="$methodParameterToken='p_entities'">
				<xsl:text>		console.assert(angular.isArray(p_entities), '</xsl:text>
									<xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
									<xsl:text>() : p_entities is required and should be an array');&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="($methodCriteriaToken and (count(exsl:node-set($methodCriteriaToken)/criteria)>1))">
				<xsl:text>console.assert(!angular.isUndefinedOrNullOrEmpty(p_properties), '.</xsl:text><xsl:value-of select="$methodNameFull" /><xsl:text>() : p_properties is required');&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="($methodCriteriaToken and (count(exsl:node-set($methodCriteriaToken)/criteria)=1))">
				<xsl:text>		console.assert(!angular.isUndefinedOrNull(</xsl:text><xsl:value-of select="exsl:node-set($methodCriteriaToken)/criteria/@parameterName" /><xsl:text>), '</xsl:text>
				<xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
				<xsl:text>() : </xsl:text><xsl:value-of select="exsl:node-set($methodCriteriaToken)/criteria/@parameterName" /><xsl:text> is required');&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="$methodParameterToken">
				<xsl:text>		console.assert(!angular.isUndefinedOrNull(</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>), '</xsl:text>
									<xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
									<xsl:text>() : </xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text> is required');&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
		<xsl:text>&#10;</xsl:text>
		
		
		<!-- function body: var deferred, var self -->	
		<xsl:text>		var deferred = $qSync.defer();&#10;</xsl:text>
		<xsl:text>		var self = this;&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		
		
		<!-- function body: var o_sqlQuery, var o_sqlParameters -->
		<xsl:choose>
			<xsl:when test="(substring($methodNameToken, 1, 3) = 'get')">
				<xsl:choose>
				
					<!--  if association uses column(s) from a join table -->
					<xsl:when test="starts-with($methodParameterToken, 'p_foreignKeys')">
						<xsl:text>		var o_sqlQuery = 'select * from </xsl:text><xsl:value-of select="//table-name"/>	
						
						<xsl:if test="count(exsl:node-set($methodInnerJoinToken)/join) > 0">			
							<xsl:for-each select="exsl:node-set($methodInnerJoinToken)/join">								
								<xsl:text> inner join </xsl:text><xsl:value-of select="@joinTableName" />
								<xsl:text> on </xsl:text>
									<xsl:value-of select="@classTableName" /><xsl:text>.</xsl:text><xsl:value-of select="@classIdentifierName" />
									<xsl:text> = </xsl:text><xsl:value-of select="@joinTableName" /><xsl:text>.</xsl:text><xsl:value-of select="@joinTableKeyFieldName" />
							</xsl:for-each>
						</xsl:if>
						
						<xsl:text> where </xsl:text>
						
						<xsl:for-each select="(exsl:node-set($methodCriteriaToken)/criteria)">
							<xsl:value-of select="@sqlName" /><xsl:text> in ('+ self.produceQueryInPart(</xsl:text><xsl:value-of select="@parameterName" />
							<xsl:if test="@byValue = 'false'"><xsl:text>.idToString</xsl:text></xsl:if>
							<xsl:text>) +')</xsl:text>
							<xsl:if test="position() != last()"><xsl:text> and </xsl:text></xsl:if>
				   		</xsl:for-each>
						<xsl:text>;';&#10;</xsl:text>
						
						<xsl:text>		var o_sqlParameters = [].concat(</xsl:text>
						<xsl:for-each select="(exsl:node-set($methodCriteriaToken)/criteria)">
							<xsl:value-of select="@parameterName" />
							<xsl:if test="@byValue = 'false'"><xsl:text>.idToString</xsl:text></xsl:if>
							<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
				   		</xsl:for-each>
						<xsl:text>);&#10;</xsl:text>
						
						<xsl:text>&#10;</xsl:text>
						<xsl:text>		self.executeQueryToRead(&#10;</xsl:text>
						<xsl:text>			'</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
						<xsl:text>()', p_context, o_sqlQuery, o_sqlParameters).then(&#10;</xsl:text>
					</xsl:when>
					
					
					<!--  if association uses column(s) from the table -->					
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="($methodParameterToken='p_id') or ($methodParameterToken='p_ids')">
								<xsl:text>		self.getEntitiesByProperty('</xsl:text><xsl:value-of select="/dao/class/identifier/attribute/@name" /><xsl:text>', </xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>, p_context).then(&#10;</xsl:text>
							</xsl:when>
							
							<xsl:when test="($methodCriteriaToken and (count(exsl:node-set($methodCriteriaToken)/criteria)>1))">
								<xsl:text>		self.getEntitiesByProperties(p_properties, p_context).then(&#10;</xsl:text>
							</xsl:when>
							<xsl:when test="($methodCriteriaToken and (count(exsl:node-set($methodCriteriaToken)/criteria)=1))">
								<xsl:text>		self.getEntitiesByProperty(</xsl:text>							
								<xsl:text>'</xsl:text><xsl:value-of select="substring-after(exsl:node-set($methodCriteriaToken)/criteria/@parameterName, 'p_')" /><xsl:text>', </xsl:text><xsl:value-of select="exsl:node-set($methodCriteriaToken)/criteria/@parameterName" />
								<xsl:text>, p_context).then(&#10;</xsl:text>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:text>		self.getEntitiesByProperty('*', [], p_context).then(&#10;</xsl:text>
							</xsl:otherwise>
						</xsl:choose>						
					</xsl:otherwise>
					
				</xsl:choose>
				
				<xsl:text>&#10;function (returnedSuccess_executeQueryToRead) { /* SUCCESS */&#10;</xsl:text>
				<xsl:choose>
					<xsl:when test="(starts-with($methodNameFull, 'getNbEntities'))">
              			<xsl:text>deferred.resolve(returnedSuccess_executeQueryToRead.length);&#10;</xsl:text>
					</xsl:when>					
					<xsl:otherwise>					
						<xsl:text>self.loadChildrenIfNeeded(p_context, returnedSuccess_executeQueryToRead, p_cascadeSet).then(&#10;</xsl:text>
						<xsl:text>function (returnedSuccess_cascade) {&#10;</xsl:text>
						
						<xsl:text>deferred.resolve(returnedSuccess_executeQueryToRead</xsl:text>
						<xsl:if test="not(starts-with($methodNameFull, 'getList'))"><xsl:text>[0]</xsl:text></xsl:if>
						<xsl:text>);&#10;},&#10;</xsl:text>
		                
		                <xsl:text>function (returnedError_cascade) {&#10;</xsl:text>
		                <xsl:text>console.error('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" /><xsl:text>(): cascade error: ', returnedError_cascade);&#10;</xsl:text>
						<xsl:text>p_context.addError('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" /><xsl:text>(): cascade error: '+ returnedError_cascade);&#10;</xsl:text>
		           		
		           		<xsl:text>deferred.reject(returnedError_cascade);&#10;</xsl:text>
		           		<xsl:text>}&#10;);&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>	
				
				<xsl:text>},&#10;</xsl:text>
           		<xsl:text>function (returnedError_executeQueryToRead) { /* ERROR */&#10;</xsl:text>
           		<xsl:text>console.error('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
                <xsl:text>(): error: ', returnedError_executeQueryToRead);&#10;</xsl:text>
				<xsl:text>p_context.addError('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
                <xsl:text>(): error: '+ returnedError_executeQueryToRead);&#10;</xsl:text>
           		<xsl:text>deferred.reject(returnedError_executeQueryToRead);&#10;}&#10;);</xsl:text>
           			
			</xsl:when>


			<xsl:when test="(substring($methodNameToken, 1, 12) = 'saveOrUpdate')">
				<xsl:choose>
					<xsl:when test="($methodParameterToken='p_entity')">
							<xsl:text>		if(p_entity.idToString === -1) {&#10;</xsl:text>
							<xsl:text>			/* save</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> */&#10;</xsl:text>
							<xsl:text>			console.log('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" /><xsl:text>(): ID =-1  => save</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>()');&#10;</xsl:text>
							<xsl:text>			deferred.resolve( self.save</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(</xsl:text><xsl:value-of select="$methodParametersFull" /><xsl:text>) ); // last parameter ignored by called method&#10;</xsl:text>
							<xsl:text>		} else {&#10;</xsl:text>
							<xsl:text>			/* update</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> */&#10;</xsl:text>
							<xsl:text>			console.log('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" /><xsl:text>(): ID !=-1  => update</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>()');&#10;</xsl:text>
							<xsl:text>			deferred.resolve( self.update</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(</xsl:text><xsl:value-of select="$methodParametersFull" /><xsl:text>) );&#10;</xsl:text>
							<xsl:text>		}&#10;</xsl:text>
					</xsl:when>
					
					<xsl:when test="($methodParameterToken='p_entities')">
							<xsl:text>		/* saveOrUpdateList</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() => saveOrUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() */&#10;</xsl:text>
							<xsl:text>		var o_arrayPromisesSaveOrUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> = [];&#10;</xsl:text>
							<xsl:text>		for(var i = 0; i &#60; p_entities.length; i++) {&#10;</xsl:text>
							<xsl:text>			o_arrayPromisesSaveOrUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.push( self.saveOrUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(p_entities[i], p_context, angular.copy(p_cascadeSet), p_toSync, angular.copy(p_cascadeSetForDelete)) );&#10;</xsl:text>
							<xsl:text>		}&#10;</xsl:text>
							<xsl:text>		// $qSync.all() returns an array of the results of o_arrayPromisesSaveOrUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.&#10;</xsl:text>
							<xsl:text>		// If the value returned by $qSync.all() is a rejection, the promise will be rejected instead.&#10;</xsl:text>
							<xsl:text>		deferred.resolve( $qSync.all(o_arrayPromisesSaveOrUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>) );&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise />
				</xsl:choose>
			</xsl:when>
			
			
			<xsl:when test="(substring($methodNameToken, 1, 4) = 'save')">
				<xsl:choose>
					<xsl:when test="($methodParameterToken='p_entity')">
						<xsl:text>		self.fixDoubleWaysRelationship(p_entity);</xsl:text>
						<xsl:text>&#10;</xsl:text>
			
						<xsl:text>		// --------------------------&#10;</xsl:text>
					    <xsl:text>		// 1. save or update children pointed by the parent : for relationships xxx_to_one&#10;</xsl:text>
					    <xsl:text>		// --------------------------&#10;</xsl:text>
					    <xsl:text>		var savePointedChildren = [];&#10;</xsl:text>
					    

						<xsl:text>&#10;</xsl:text>
						
						<xsl:for-each select="/dao/class/association[(			(@type='one-to-one')
 																			or	(@type='many-to-one')
 																	)
 																	and (@transient='false')]">
							<xsl:if test="position() = 1">
							<xsl:text>		//		1.1  call saveOrUpdate function of the child dao&#10;</xsl:text>
							<xsl:text>		//		1.2  check that the ID attribute of the children model entities is updated (update foreign key of the parent pointing the child just saved)&#10;</xsl:text>
							</xsl:if>
							
							<xsl:text>		var </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx = p_cascadeSet.indexOf('</xsl:text><xsl:value-of select="@name"/><xsl:text>');&#10;</xsl:text>
							<xsl:text>		if( </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx &gt; -1) {&#10;</xsl:text>
							<xsl:text>			p_cascadeSet.splice(</xsl:text><xsl:value-of select="@name"/><xsl:text>Idx, 1);&#10;</xsl:text>
							<xsl:text>			savePointedChildren.push( </xsl:text><xsl:value-of select="dao/name"/><xsl:text>Proxy.saveOrUpdate</xsl:text><xsl:value-of select="class/name"/>
											<xsl:text>(p_entity.</xsl:text><xsl:value-of select="@name"/><xsl:text>, p_context, p_cascadeSet, p_toSync) );&#10;</xsl:text>
							<xsl:text>		}&#10;</xsl:text>
						</xsl:for-each>
						<xsl:text>&#10;</xsl:text>
						
						
						<xsl:text>		$qSync.all(savePointedChildren).then(&#10;</xsl:text>
	   					<xsl:text>			function(success) { /* SUCCESS */&#10;</xsl:text>
	   					<xsl:text>				// --------------------------&#10;</xsl:text>
	   					<xsl:text>				// 2. save the main entity&#10;</xsl:text>
						<xsl:text>				// --------------------------&#10;</xsl:text>
				
						<xsl:text>&#10;</xsl:text>
						<xsl:text>				self.saveEntity(p_entity, p_context, p_toSync).then(&#10;</xsl:text>
						<xsl:text>					function (success_result) {&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>
						<xsl:text>						var saveOtherChildren = [];&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>


						<xsl:for-each select="/dao/class/association[(			(@type='one-to-one')
 																			or	(@type='one-to-many')
 																	)
 																	and (@transient='false')]">
							<xsl:if test="position() = 1">
								<xsl:text>						// --------------------------&#10;</xsl:text>
								<xsl:text>						// 3. save or update children not pointed by the parent : for relationships one_to_xxx and many_to_many&#10;</xsl:text>
								<xsl:text>						// --------------------------&#10;</xsl:text>
								<xsl:text>						// foreach child attr&#10;</xsl:text>
								<xsl:text>						// 		3.1  call saveOrUpdate function of the child dao&#10;</xsl:text>
								<xsl:text>						// 		3.2  check that the ID attribute of the children model entities is updated (update foreign key of the parent pointing the child just saved)&#10;</xsl:text>
								<xsl:text>&#10;</xsl:text>
							</xsl:if>

							<xsl:text>						var </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx = p_cascadeSet.indexOf('</xsl:text><xsl:value-of select="@name"/><xsl:text>');&#10;</xsl:text>
							<xsl:text>						if( </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx &gt; -1) {&#10;</xsl:text>
							<xsl:text>							p_cascadeSet.splice(</xsl:text><xsl:value-of select="@name"/><xsl:text>Idx, 1);&#10;</xsl:text>
							<xsl:choose>
								<xsl:when test="(@type='one-to-one')">
									<xsl:text>							saveOtherChildren.push( </xsl:text><xsl:value-of select="dao/name"/><xsl:text>Proxy.saveOrUpdate</xsl:text><xsl:value-of select="class/name"/>
																		<xsl:text>(p_entity.</xsl:text><xsl:value-of select="@name"/><xsl:text>, p_context, p_cascadeSet, p_toSync) );&#10;</xsl:text>
								</xsl:when>
								<xsl:when test="(@type='one-to-many')">
									<xsl:text>							saveOtherChildren.push( </xsl:text><xsl:value-of select="dao/name"/><xsl:text>Proxy.saveOrUpdateList</xsl:text><xsl:value-of select="class/name"/>
																		<xsl:text>(p_entity.</xsl:text><xsl:value-of select="@name"/><xsl:text>, p_context, p_cascadeSet, p_toSync) );&#10;</xsl:text>
								</xsl:when>
								<xsl:otherwise />
							</xsl:choose>
							<xsl:text>						}&#10;</xsl:text>
							<xsl:text>&#10;</xsl:text>
						</xsl:for-each>
						
						
						<xsl:for-each select="/dao/class/association[(
																				(@type='many-to-many')
 																	)
 																	and (@transient='false')]">
							<xsl:if test="position() = 1">
								<xsl:text>						// --------------------------&#10;</xsl:text>
								<xsl:text>						// 4. save association records: for relationships many_to_many&#10;</xsl:text>
								<xsl:text>						// --------------------------&#10;</xsl:text>
								<xsl:text>						// foreach child attr&#10;</xsl:text>
								<xsl:text>						// 		4.1 define SQL query&#10;</xsl:text>
								<xsl:text>						// 		4.2 get next ID of this association table&#10;</xsl:text>
								<xsl:text>						// 		4.3 define SQL parameters&#10;</xsl:text>
								<xsl:text>						// 		4.4 execute query&#10;</xsl:text>
								<xsl:text>						// TODO write an example&#10;</xsl:text>
								<xsl:text>&#10;</xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>&#10;</xsl:text>
						
						
						<xsl:text>						$qSync.all(saveOtherChildren).then(&#10;</xsl:text>
						<xsl:text>							function(success) {&#10;</xsl:text>
						<xsl:text>								deferred.resolve(success_result);&#10;</xsl:text>
						<xsl:text>							},&#10;</xsl:text>
						<xsl:text>							function(error) {&#10;</xsl:text>
						<xsl:text>								deferred.reject(error);&#10;</xsl:text>
						<xsl:text>							}&#10;</xsl:text>
						<xsl:text>						);&#10;</xsl:text>
							
						<xsl:text>					},&#10;</xsl:text>
						<xsl:text>					function(failure_result) {&#10;</xsl:text>
						<xsl:text>						deferred.reject(failure_result);&#10;</xsl:text>
						<xsl:text>					}&#10;</xsl:text>
						<xsl:text>				);&#10;</xsl:text>							
							
						<xsl:text>			},&#10;</xsl:text>
						<xsl:text>			function (error) { /* ERROR */&#10;</xsl:text>
						<xsl:text>				deferred.reject(error);&#10;</xsl:text>
						<xsl:text>			}&#10;</xsl:text>
						<xsl:text>		);&#10;</xsl:text>						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:text>		/* saveList</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() => save</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() */&#10;</xsl:text>
						<xsl:text>		var o_arrayPromisesSave</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> = [];&#10;</xsl:text>
						<xsl:text>		for( var i = 0; i &lt; </xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>.length; i++ ) {&#10;</xsl:text>
						<xsl:text>			o_arrayPromisesSave</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.push( self.save</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(</xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>[i], p_context, angular.copy(p_cascadeSet), p_toSync) );&#10;</xsl:text>
						<xsl:text>		}&#10;</xsl:text>
						<xsl:text>		// $qSync.all() returns an array of the results of o_arrayPromisesSave</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.&#10;</xsl:text>
						<xsl:text>		// If the value returned by $qSync.all() is a rejection, the promise will be rejected instead.&#10;</xsl:text>
						<xsl:text>		deferred.resolve( $qSync.all(o_arrayPromisesSave</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>) );&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			
			<xsl:when test="(substring($methodNameToken, 1, 6) = 'update')">
				<xsl:choose>
					<xsl:when test="($methodParameterToken='p_entity')">
						<xsl:text>		var childrenPromises = [];&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>
						<xsl:text>		self.fixDoubleWaysRelationship(p_entity);</xsl:text>
						<xsl:text>&#10;</xsl:text>
						
						<xsl:for-each select="/dao/class/association[(			(@type='one-to-one')
 																			or	(@type='one-to-many')
 																	)
 																	and (@transient='false')]">
							<xsl:if test="position() = 1">
							<xsl:text>		// for composition relationships one_to_xxx&#10;</xsl:text>
							</xsl:if>
							<xsl:text>&#10;</xsl:text>
							
							<xsl:text>		var </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx = p_cascadeSet.indexOf('</xsl:text><xsl:value-of select="@name"/><xsl:text>');&#10;</xsl:text>
							<xsl:text>		if( </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx &gt; -1) {&#10;</xsl:text>
							<xsl:text>			p_cascadeSet.splice(</xsl:text><xsl:value-of select="@name"/><xsl:text>Idx, 1);&#10;</xsl:text>
							<xsl:text>&#10;</xsl:text>
							
							<xsl:text>			// 1. delete the children that are not in p_entity if composition relationship one_to_xxx (delete from CHILD where PARENTID=xxx and CHILDID not in(xxx, xxx)&#10;</xsl:text>
							<xsl:text>			childrenPromises.push(&#10;</xsl:text>
							<xsl:text>				self.getChildrenIdsToRemove(p_context, p_entity, '</xsl:text><xsl:value-of select="@name" /><xsl:text>').then(&#10;</xsl:text>
							<xsl:text>					function(idsToRemove) {&#10;</xsl:text>
							<xsl:text>						console.log('children to remove found', idsToRemove);&#10;</xsl:text>
							<xsl:text>						return </xsl:text><xsl:value-of select="dao/name" /><xsl:text>Proxy.deleteList</xsl:text><xsl:value-of select="class/name"/><xsl:text>ByIds(idsToRemove, p_context, p_cascadeSet, p_toSync, p_cascadeSetForDelete);&#10;</xsl:text>
							<xsl:text>					},&#10;</xsl:text>
							<xsl:text>					function(error) {&#10;</xsl:text>
							<xsl:text>						deferred.reject(error);&#10;</xsl:text>
							<xsl:text>					}&#10;</xsl:text>
							<xsl:text>				)&#10;</xsl:text>
							<xsl:text>			);&#10;</xsl:text>
							<xsl:text>&#10;</xsl:text>
							
							<xsl:text>			// 2. save or update the remaining children if composition relationship one_to_xxx&#10;</xsl:text>
							<xsl:text>			childrenPromises.push( </xsl:text>
							<xsl:choose>
								<xsl:when test="(@type='one-to-one') or (@type='many-to-one')">
									<xsl:value-of select="dao/name" /><xsl:text>Proxy.saveOrUpdate</xsl:text><xsl:value-of select="class/name"/><xsl:text>(p_entity.</xsl:text><xsl:value-of select="@name" /><xsl:text>, p_context, p_cascadeSet, p_toSync, p_cascadeSetForDelete) );&#10;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="dao/name" /><xsl:text>Proxy.saveOrUpdateList</xsl:text><xsl:value-of select="class/name"/><xsl:text>(p_entity.</xsl:text><xsl:value-of select="@name" /><xsl:text>, p_context, p_cascadeSet, p_toSync, p_cascadeSetForDelete) );&#10;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
								
								
							<xsl:text>		}&#10;</xsl:text>							
						</xsl:for-each>
						<xsl:text>&#10;&#10;</xsl:text>
						
						
						<xsl:for-each select="/dao/class/association[(			not(@type='one-to-one')
 																			and	not(@type='one-to-many')
 																	)
 																	and (@transient='false')]">
							<xsl:if test="position() = 1">
								<xsl:text>		// 2. save or update all the other children (no matter the type of relationship), if asked by p_cascadeset&#10;</xsl:text>
							</xsl:if>
							
							<xsl:text>		var </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx = p_cascadeSet.indexOf('</xsl:text><xsl:value-of select="@name"/><xsl:text>');&#10;</xsl:text>
							<xsl:text>		if( </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx &gt; -1) {&#10;</xsl:text>												
							<xsl:text>			childrenPromises.push( </xsl:text>							
							<xsl:choose>
								<xsl:when test="(@type='one-to-one') or (@type='many-to-one')">
								<xsl:value-of select="dao/name" /><xsl:text>Proxy.saveOrUpdate</xsl:text><xsl:value-of select="class/name"/><xsl:text>(p_entity.</xsl:text><xsl:value-of select='@name' /><xsl:text>, p_context, p_cascadeSet, p_toSync, p_cascadeSetForDelete)</xsl:text>
								</xsl:when>
								
								<xsl:otherwise>
								<xsl:value-of select="dao/name" /><xsl:text>Proxy.saveOrUpdateList</xsl:text><xsl:value-of select="class/name"/><xsl:text>(p_entity.</xsl:text><xsl:value-of select='@name' /><xsl:text>, p_context, p_cascadeSet, p_toSync, p_cascadeSetForDelete)</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> );&#10;</xsl:text>
							<xsl:text>		}&#10;</xsl:text>
						</xsl:for-each>
						<xsl:text>&#10;&#10;</xsl:text>
						
						
						<xsl:text>		$qSync.all(childrenPromises).then(&#10;</xsl:text>
	   					<xsl:text>			function(success){&#10;</xsl:text>
	   					<xsl:text>				console.log('children updated', success);&#10;</xsl:text>
	   					<xsl:text>&#10;</xsl:text>
	   					<xsl:text>				// 3. update the parent&#10;</xsl:text>
 						<xsl:text>				self.updateEntity(p_entity, p_context, p_toSync).then(&#10;</xsl:text>
						<xsl:text>					function (success_result) { /* SUCCESS */&#10;</xsl:text>
						<xsl:text>						console.log('parent updated', success_result);&#10;</xsl:text>
						<xsl:text>						deferred.resolve(success_result);&#10;</xsl:text>						
						<xsl:text>					},&#10;</xsl:text>
		           		<xsl:text>					function (failure_result) { /* ERROR */&#10;</xsl:text>
		           		<xsl:text>						deferred.reject(failure_result);&#10;</xsl:text>
		           		<xsl:text>					}&#10;</xsl:text>           		
						<xsl:text>				);&#10;</xsl:text>
						<xsl:text>			},&#10;</xsl:text>
						<xsl:text>			function(error){&#10;</xsl:text>
						<xsl:text>				deferred.reject(error);&#10;</xsl:text>
						<xsl:text>			}&#10;</xsl:text>
						<xsl:text>		);&#10;</xsl:text>						
					</xsl:when>
					
					
					<xsl:otherwise>
						<xsl:text>		/* updateList</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() => update</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() */&#10;</xsl:text>
						<xsl:text>		var o_arrayPromisesUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> = [];&#10;</xsl:text>
						<xsl:text>		for( var i = 0; i &lt; </xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>.length; i++ ) {&#10;</xsl:text>
						<xsl:text>			o_arrayPromisesUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.push( self.update</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(</xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>[i], p_context, angular.copy(p_cascadeSet), p_toSync, angular.copy(p_cascadeSetForDelete)) );&#10;</xsl:text>
						<xsl:text>		}&#10;</xsl:text>
						<xsl:text>		// $qSync.all() returns an array of the results of o_arrayPromisesUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.&#10;</xsl:text>
						<xsl:text>		// If the value returned by $qSync.all() is a rejection, the promise will be rejected instead.&#10;</xsl:text>
						<xsl:text>		deferred.resolve( $qSync.all(o_arrayPromisesUpdate</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>) );&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="(substring($methodNameToken, 1, 6) = 'delete')">
				<xsl:choose>
					<xsl:when test="(count(exsl:node-set($methodCriteriaToken)/criteria) = 1)">
						<xsl:text>self.getEntitiesByProperty(</xsl:text>
						<xsl:text>'</xsl:text><xsl:value-of select="substring-after(exsl:node-set($methodCriteriaToken)/criteria/@parameterName, 'p_')" /><xsl:text>', </xsl:text><xsl:value-of select="exsl:node-set($methodCriteriaToken)/criteria/@parameterName" />
						<xsl:text>, p_context).then(&#10;</xsl:text>
				        <xsl:text>function(entities) { /* SUCCESS */&#10;</xsl:text>
				        <xsl:text>deferred.resolve(self.deleteList</xsl:text><xsl:value-of select="class/name"/><xsl:text>(entities,p_context,p_cascadeSet, p_toSync));&#10;</xsl:text>
				        <xsl:text>},&#10;function(error){&#10;deferred.reject(error);&#10;}&#10;);&#10;</xsl:text>
					</xsl:when>
					
					<xsl:when test="(count(exsl:node-set($methodCriteriaToken)/criteria) > 1)">
						<xsl:text>self.getEntitiesByProperties(p_properties, p_context).then(&#10;</xsl:text>
				        <xsl:text>function(entities) { /* SUCCESS */&#10;</xsl:text>
				        <xsl:text>deferred.resolve(self.deleteList</xsl:text><xsl:value-of select="class/name"/><xsl:text>(entities,p_context,p_cascadeSet, p_toSync));&#10;</xsl:text>
				        <xsl:text>},&#10;function(error){&#10;deferred.reject(error);&#10;}&#10;);&#10;</xsl:text>
					</xsl:when>
					
					<xsl:when test="($methodParameterToken='p_entity')">
					    <xsl:text>		//0. load children that should always be deleted or updated&#10;</xsl:text>
            			<xsl:text>		self.loadChildrenIfNeeded(p_context, </xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>).then(&#10;</xsl:text>
                		<xsl:text>			function(returnedSuccess_loadChildrenIfNeeded){&#10;</xsl:text>
						<xsl:text>				var pointersDeletes = [];&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>				
						
						
						<!-- 1 -->
						<xsl:for-each select="/dao/class/association[(@type='many-to-many')
																	and (@transient='false')]">

							<xsl:text>				// 1. delete association records : for relationships many_to_many&#10;</xsl:text>
							<xsl:text>				var o_sqlQuery = 'delete from </xsl:text><xsl:value-of select="join-table/name" /><xsl:text>' + &#10;</xsl:text>
							<xsl:text>								'inner join </xsl:text><xsl:value-of select="join-table/name" /><xsl:text> on ' + &#10;</xsl:text>
							<xsl:text>								'		</xsl:text><xsl:value-of select="../table-name" /><xsl:text>.</xsl:text><xsl:value-of select="../identifier/attribute/field/@name" />
																			<xsl:text> = </xsl:text><xsl:value-of select="join-table/name" /><xsl:text>.</xsl:text><xsl:value-of select="join-table/key-fields/field/@name" /><xsl:text>' + &#10;</xsl:text>
							<xsl:text>								'	where ' + &#10;</xsl:text>
														
							<xsl:choose>
								<xsl:when test="count(exsl:node-set($methodCriteriaToken)/criteria) > 0">
									<xsl:for-each select="(exsl:node-set($methodCriteriaToken)/criteria)">
										<xsl:text>								'		</xsl:text><xsl:value-of select="@sqlName" /><xsl:text> in ('+ self.produceQueryInPart(</xsl:text><xsl:value-of select="@parameterName" />
										<xsl:if test="@byValue = 'false'"><xsl:text>.idToString</xsl:text></xsl:if>
										<xsl:text>) ')'</xsl:text>
										<xsl:if test="position() != last()"><xsl:text> + &#10;</xsl:text><xsl:text> and </xsl:text></xsl:if>
							   		</xsl:for-each>
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:text>								'		</xsl:text><xsl:value-of select="../table-name" /><xsl:text>.</xsl:text><xsl:value-of select="join-table/key-fields/field/@name" /><xsl:text> = ?</xsl:text>
								</xsl:otherwise>							
							</xsl:choose>						
							<xsl:text>;';&#10;</xsl:text>
						
							<xsl:text>				var o_sqlParameters = [].concat(</xsl:text>
							<xsl:choose>
								<xsl:when test="count(exsl:node-set($methodCriteriaToken)/criteria) > 0">								
									<xsl:for-each select="(exsl:node-set($methodCriteriaToken)/criteria)">
										<xsl:value-of select="@parameterName" />
										<xsl:if test="@byValue = 'false'"><xsl:text>.idToString</xsl:text></xsl:if>
										<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
							   		</xsl:for-each>
							   	</xsl:when>
							   	
							   	<xsl:otherwise>
							   		<xsl:text></xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>.idToString</xsl:text>
							   	</xsl:otherwise>
							   	
						   	</xsl:choose>
							<xsl:text>);&#10;</xsl:text>

							<xsl:text>				pointersDeletes.push( self.executeQueryToWrite(&#10;</xsl:text>
							<xsl:text>					'</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
							<xsl:text>()', p_context, o_sqlQuery, o_sqlParameters) );&#10;</xsl:text>
							
							<xsl:text>&#10;</xsl:text>							
						</xsl:for-each>
						<xsl:text>&#10;</xsl:text>
						
												
						<!-- 2 -->
						<xsl:for-each select="/dao/class/association[(			(@type='one-to-one')
 																			or	(@type='one-to-many')
 																	)
																	and (@relation-owner='true')
																	and (@opposite-aggregate-type='COMPOSITE')
 																	and (@transient='false')]">
							
							<xsl:text>				// 2. for composition relationships one_to_xxx : ALWAYS delete children "nested" in the parent : &#10;</xsl:text>
							<xsl:text>				pointersDeletes.push( </xsl:text><xsl:value-of select="dao/name"/><xsl:text>Proxy</xsl:text>
												<xsl:text>.deleteList</xsl:text><xsl:value-of select="class/name"></xsl:value-of>
												<xsl:text>(</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>, p_context, p_cascadeSet, p_toSync) );&#10;</xsl:text>
							<xsl:text>&#10;</xsl:text>
						</xsl:for-each>
						<xsl:text>&#10;</xsl:text>
						
						<!-- 3 -->
						<xsl:for-each select="/dao/class/association[(			(@type='one-to-one')
																			or	(@type='one-to-many')
																	)
																	and (@relation-owner='true')
																	and (@opposite-aggregate-type='AGGREGATE')
																	and (@transient='false')]">
							
							<xsl:if test="position() = 1">
								<xsl:text>				// 3. for aggregation relationships one_to_xxx&#10;</xsl:text>
								<xsl:text>&#10;</xsl:text>	
							</xsl:if>
							
							<xsl:text>				var </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx = p_cascadeSet.indexOf('</xsl:text><xsl:value-of select="@name"/><xsl:text>');&#10;</xsl:text>
							<xsl:text>&#10;</xsl:text>							
							<xsl:text>				// 	3.1. if asked in p_cascadeset, delete the other children pointing the parent&#10;</xsl:text>
							<xsl:text>				if( </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx &gt; -1) {&#10;</xsl:text>
							<xsl:text>					p_cascadeSet.splice(</xsl:text><xsl:value-of select="@name"/><xsl:text>Idx, 1);&#10;</xsl:text>
							<xsl:text>					pointersDeletes.push( </xsl:text><xsl:value-of select="dao/name"/><xsl:text>Proxy.deleteList</xsl:text><xsl:value-of select="class/name"/>
													<xsl:text>(</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>, p_context, p_cascadeSet, p_toSync) );&#10;</xsl:text>
							<xsl:text>				//  3.2  otherwise, just clear FKs pointing the parent</xsl:text>
							<xsl:text>				} else {&#10;</xsl:text>
							<xsl:text>					for( var i=0; i&lt;</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>; i++ ) {&#10;</xsl:text>
							<xsl:text>						</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>[i] = null;&#10;</xsl:text>
							<xsl:text>					}&#10;</xsl:text>
							<xsl:text>				}&#10;</xsl:text>
							
							<xsl:text>&#10;</xsl:text>	
						</xsl:for-each>
						<xsl:text>&#10;</xsl:text>						
						
						
						<xsl:text>				$qSync.all(pointersDeletes).then(&#10;</xsl:text>
	   					<xsl:text>					function(returnedSuccess_pointers){ /* SUCCESS */&#10;</xsl:text>
	   					<xsl:text>&#10;</xsl:text>
	   					
	   					<!-- 4 -->
						<xsl:text>						// 4. delete the parent&#10;</xsl:text>			
						<xsl:text>						self.deleteEntity(</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>, p_context, p_toSync).then(&#10;</xsl:text>
						<xsl:text>							function (returnedSuccess_executeQueryToDelete) { /* SUCCESS */&#10;</xsl:text>
						<xsl:text>								pointersDeletes = [];&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>
						
						<!-- 5 -->
						<xsl:for-each select="/dao/class/association[(			(@type='one-to-one')
																			or	(@type='many-to-one')
																	)
																	and (@transient='false')]">
								
							<xsl:if test="position() = 1">
								<xsl:text>								//5. for composition and aggregation relationships xxx_to_one</xsl:text>
								<xsl:text>&#10;</xsl:text>
							</xsl:if>
							
							<xsl:text>								var </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx = p_cascadeSet.indexOf('</xsl:text><xsl:value-of select="@name"/><xsl:text>');&#10;</xsl:text>
							<xsl:text>								// 	5.1. ONLY IF asked in p_cascadeset, delete children&#10;</xsl:text>
							<xsl:text>								if( </xsl:text><xsl:value-of select="@name"/><xsl:text>Idx &gt; -1) {&#10;</xsl:text>
							<xsl:text>									p_cascadeSet.splice(</xsl:text><xsl:value-of select="@name"/><xsl:text>Idx, 1);&#10;</xsl:text>
							<xsl:text>									pointersDeletes.push( </xsl:text><xsl:value-of select="dao/name"/><xsl:text>Proxy.deleteList</xsl:text><xsl:value-of select="class/name"/>
																			<xsl:text>(</xsl:text><xsl:value-of select="$methodParameterToken" /><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>, p_context, p_cascadeSet, p_toSync) );&#10;</xsl:text>
							<xsl:text>								}&#10;</xsl:text>
							
							<xsl:text>&#10;</xsl:text>														
						</xsl:for-each>
										

						<xsl:text>								$qSync.all(pointersDeletes).then(&#10;</xsl:text>
	   					<xsl:text>									function(returnedSuccess_executeQuery2ToDelete) { /* SUCCESS */&#10;</xsl:text>
	   					<xsl:text>										deferred.resolve(returnedSuccess_executeQuery2ToDelete);&#10;</xsl:text>	   					
						<xsl:text>									},&#10;</xsl:text>
		           		<xsl:text>									function (returnedError_executeQuery2ToDelete) { /* ERROR */&#10;</xsl:text>
		           		<xsl:text>										console.error('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
		                													<xsl:text>(): error: ', returnedError_executeQuery2ToDelete);&#10;</xsl:text>
						<xsl:text>										p_context.addError('</xsl:text><xsl:value-of select="//name"/><xsl:text>.</xsl:text><xsl:value-of select="$methodNameFull" />
		                													<xsl:text>(): error: '+ returnedError_executeQuery2ToDelete);&#10;</xsl:text>
		           		<xsl:text>										deferred.reject(returnedError_executeQuery2ToDelete);&#10;</xsl:text>
		           		<xsl:text>									}&#10;</xsl:text>           		
						<xsl:text>								);&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>
												
						<xsl:text>							},&#10;</xsl:text>
						<xsl:text>							function(returnedError_executeQueryToDelete){ /* ERROR */&#10;</xsl:text>
						<xsl:text>								deferred.reject(returnedError_executeQueryToDelete);&#10;</xsl:text>
						<xsl:text>							}&#10;</xsl:text>
						<xsl:text>						);&#10;</xsl:text>
						<xsl:text>&#10;</xsl:text>						

						<xsl:text>					},&#10;</xsl:text>
						<xsl:text>					function(returnedError_pointers){ /* ERROR */&#10;</xsl:text>
						<xsl:text>						deferred.reject(returnedError_pointers);&#10;</xsl:text>
						<xsl:text>					}&#10;</xsl:text>
						<xsl:text>				);&#10;</xsl:text>
						
						<xsl:text>			},&#10;</xsl:text>
						<xsl:text>			function(returnedError_loadChildrenIfNeeded){ /* ERROR */&#10;</xsl:text>
						<xsl:text>				deferred.reject(returnedError_loadChildrenIfNeeded);&#10;</xsl:text>
						<xsl:text>			}&#10;</xsl:text>
						<xsl:text>		);</xsl:text>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="($methodParameterToken='p_id')">
								<xsl:text>		self.get</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>ById(</xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>, p_context, angular.copy(p_cascadeSet), p_toSync).then(&#10;</xsl:text>
								<xsl:text>			function(entity){&#10;</xsl:text>
								<xsl:text>				deferred.resolve( self.delete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(entity, p_context, angular.copy(p_cascadeSet), p_toSync) );&#10;</xsl:text>
								<xsl:text>			},&#10;</xsl:text>
								<xsl:text>			function(error){&#10;</xsl:text>
								<xsl:text>				deferred.reject(error);&#10;</xsl:text>
								<xsl:text>			}&#10;</xsl:text>								
								<xsl:text>		);&#10;</xsl:text>
							</xsl:when>
							
							<xsl:when test="($methodParameterToken='p_ids')">
								<xsl:text>		/* </xsl:text><xsl:value-of select="$methodNameFull"/><xsl:text>() => </xsl:text><xsl:value-of select="substring($methodNameFull, 1, string-length($methodNameFull)-1)"/><xsl:text>() */&#10;</xsl:text>
								<xsl:text>		var o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> = [];&#10;</xsl:text>
								<xsl:text>		for( var i = 0; i &lt; </xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>.length; i++ ) {&#10;</xsl:text>
								<xsl:text>			o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.push( self.delete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>ById(</xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>[i], p_context, angular.copy(p_cascadeSet), p_toSync) );&#10;</xsl:text>
								<xsl:text>		}&#10;</xsl:text>
								<xsl:text>		// $qSync.all() returns an array of the results of o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.&#10;</xsl:text>
								<xsl:text>		// If the value returned by $qSync.all() is a rejection, the promise will be rejected instead.&#10;</xsl:text>
								<xsl:text>		deferred.resolve( $qSync.all(o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>) );&#10;</xsl:text>
							</xsl:when>
							
							<xsl:when test="($methodParameterToken='p_entities')">
								<xsl:text>		/* deleteList</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() => delete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>() */&#10;</xsl:text>
								<xsl:text>		var o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text> = [];&#10;</xsl:text>
								<xsl:text>		for( var i = 0; i &lt; </xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>.length; i++ ) {&#10;</xsl:text>
								<xsl:text>			o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.push( self.delete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>(</xsl:text><xsl:value-of select="$methodParameterToken"/><xsl:text>[i], p_context, angular.copy(p_cascadeSet), p_toSync) );&#10;</xsl:text>
								<xsl:text>		}&#10;</xsl:text>
								<xsl:text>		// $qSync.all() returns an array of the results of o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>.&#10;</xsl:text>
								<xsl:text>		// If the value returned by $qSync.all() is a rejection, the promise will be rejected instead.&#10;</xsl:text>
								<xsl:text>		deferred.resolve( $qSync.all(o_arrayPromisesDelete</xsl:text><xsl:value-of select="//uml-name"/><xsl:text>) );&#10;</xsl:text>
							</xsl:when>			
						</xsl:choose>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
		</xsl:choose>
		<xsl:text>&#10;&#10;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:value-of select="$methodNameFull" />-after</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#10;</xsl:text>
		
		<xsl:text>		return deferred.promise;&#10;</xsl:text>				
		<xsl:text>	};&#10;&#10;&#10;</xsl:text>
		
	</xsl:template>

</xsl:stylesheet>