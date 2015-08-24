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

	<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/commons/import.xsl"/>

	<xsl:key name="comboDao" match="/dataloader-impl/dataloader-interface/combos/combo/dao-name/text()" use="." />
	<xsl:key name="comboEntity" match="/dataloader-impl/dataloader-interface/combos/combo/entity/text()" use="." />

	<xsl:template match="dataloader-impl">
		
		<xsl:text>'use strict';&#10;&#10;</xsl:text>
		<xsl:text>//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		<xsl:text>&#10;angular.module('</xsl:text><xsl:value-of select="viewName"/><xsl:text>').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>', [&#10;</xsl:text>
			
		<xsl:apply-templates select="." mode="declare-protocol-imports"/>

    	<xsl:text> {&#10;</xsl:text>

		<xsl:apply-templates select="." mode="dataloader-init"/>
		
		<xsl:apply-templates select="." mode="dataloader-extend"/>
		
		<xsl:apply-templates select="." mode="dataloader-reload"/>
		
<!-- 		<xsl:apply-templates select="." mode="dataloader-getModelCache"/> -->
		
		<xsl:text>&#10;//@non-generated-start[data-loader]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='data-loader']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:text>&#10;return new </xsl:text><xsl:value-of select="name"/><xsl:text>();&#10;</xsl:text>
		<xsl:text>}]);&#10;</xsl:text>
		
	</xsl:template>



	<xsl:template match="dataloader-impl" mode="dataloader-init">
	    <xsl:text>&#10;var </xsl:text><xsl:value-of select="name"/><xsl:text> = function </xsl:text><xsl:value-of select="name"/><xsl:text>() {&#10;</xsl:text>
        <xsl:value-of select="name"/><xsl:text>._Parent.call(this);&#10;</xsl:text>
        
        <xsl:text>&#10;&#10;//@non-generated-start[data-loader-init]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='data-loader-init']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
        
        <!-- external viewmodel - COMBOBOX  -->
	        <xsl:for-each select="dataloader-interface/combos/combo/entity/text()[generate-id() = generate-id(key('comboEntity',.)[1])]">
	       		<xsl:text>var _combo</xsl:text><xsl:value-of select="."/><xsl:text>DataModel = [];&#10;</xsl:text>
		        <xsl:text>Object.defineProperty(this, 'combo</xsl:text><xsl:value-of select="."/><xsl:text>DataModel', {&#10;</xsl:text>
		        <xsl:text>get: function () {&#10;</xsl:text>
		        <xsl:text>return _combo</xsl:text><xsl:value-of select="."/><xsl:text>DataModel;&#10;</xsl:text>
		        <xsl:text>},&#10;</xsl:text>
		        <xsl:text>set: function (value) {&#10;</xsl:text>
		        <xsl:text>_combo</xsl:text><xsl:value-of select="."/><xsl:text>DataModel = value;&#10;</xsl:text>
		        <xsl:text>},&#10;</xsl:text>
		        <xsl:text>enumerable: true,&#10;</xsl:text>
		        <xsl:text>configurable: false&#10;</xsl:text>
		        <xsl:text>});&#10;</xsl:text>
		    </xsl:for-each>
    	<xsl:text>};&#10;</xsl:text>
	</xsl:template>
	
	
	
	<xsl:template match="dataloader-impl" mode="dataloader-extend">
		<xsl:text>&#10;MFUtils.extendFromInstance(</xsl:text><xsl:value-of select="name"/><xsl:text>, MFAbstractDataLoader);&#10;</xsl:text>
	</xsl:template>
	
	
	
	<xsl:template match="dataloader-impl" mode="dataloader-reload">
		<xsl:text>&#10;</xsl:text><xsl:value-of select="name"/><xsl:text>.prototype.reload = function reload(context, params){&#10;</xsl:text>
        <xsl:apply-templates select="." mode="dataloader-reload-attributes"/>
        
			<!--        FOR COMBO-->
		<xsl:for-each select="dataloader-interface/combos/combo/entity/text()[generate-id() = generate-id(key('comboEntity',.)[1])]">
			<xsl:variable name="comboAttrName">
				<xsl:text>combo</xsl:text><xsl:value-of select="."/><xsl:text>DataModel</xsl:text>
			</xsl:variable>
			
			<xsl:if test="../../transient!='true'">
				<xsl:text>combosDaoCalls.push(&#10;</xsl:text>
				<xsl:value-of select="."/><xsl:text>DaoProxy.getList</xsl:text><xsl:value-of select="."/>(context, []).then(function(combo<xsl:value-of select="."/><xsl:text>ModelEntities) {&#10;
				 self.</xsl:text><xsl:value-of select="$comboAttrName"/><xsl:text> = combo</xsl:text><xsl:value-of select="."/><xsl:text>ModelEntities;&#10;</xsl:text>
				<xsl:text>deferred.resolve({&#10;</xsl:text>
				<xsl:value-of select="$comboAttrName"/><xsl:text>: self.</xsl:text><xsl:value-of select="$comboAttrName"/><xsl:text>&#10;</xsl:text>
				<xsl:text>}); &#10;</xsl:text>
				<xsl:text>}, function(error) { &#10;</xsl:text>
				<xsl:text>deferred.reject(error); &#10;</xsl:text>
				<xsl:text>})&#10;</xsl:text>
				<xsl:text>) ;&#10;</xsl:text>
			</xsl:if>	
		</xsl:for-each>
			
			
		<!--       FOR ALL-->
		<xsl:text>$qSync.all(combosDaoCalls).then(function success() {&#10;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">reload-dataloader</xsl:with-param>
			<xsl:with-param name="defaultSource">
			
				<xsl:apply-templates select="." mode="dataloader-qsync"/>
		
			</xsl:with-param>
		</xsl:call-template>
		
        <xsl:text>&#10;});&#10;</xsl:text>
        <xsl:text>return deferred.promise;&#10;</xsl:text>
        
    	<xsl:text>};&#10;</xsl:text>
    	
	</xsl:template>

	<xsl:template match="*" mode="dataloader-reload-attributes">
	    <xsl:text>var deferred = $qSync.defer();&#10;</xsl:text>
        <xsl:text>var self = this;&#10;&#10;</xsl:text>
        <xsl:text>var combosDaoCalls = [] ;&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="*[dataloader-interface/entity-type/transient='true']" mode="dataloader-reload-attributes">
	    <xsl:text>var deferred = $qSync.defer();&#10;</xsl:text>
   		<xsl:text>var self = this;&#10;&#10;</xsl:text>
	    
    
<!--         <xsl:choose> -->
<!-- 			<xsl:when test="dataloader-interface/entity-type/application-scope='true'"> -->
<!--            		<xsl:text>var self = this;&#10;&#10;</xsl:text> -->
<!--   			</xsl:when> -->
<!--   			<xsl:otherwise> -->
<!--   				<xsl:for-each select="dataloader-interface/combos/combo/entity/text()[generate-id() = generate-id(key('comboEntity',.)[1]) and (../../transient!='true')]"> -->
<!-- 					<xsl:if test="(position()) =1"> -->
<!--  						<xsl:text>var self = this;&#10;&#10;</xsl:text> -->
<!-- 					</xsl:if>	 -->
<!-- 				</xsl:for-each> -->
<!--   			</xsl:otherwise> -->
<!-- 		</xsl:choose> -->
        
        <xsl:text>var combosDaoCalls = [] ;&#10;&#10;</xsl:text>
	
		<xsl:if test="dataloader-interface/entity-type/application-scope='true'">
			<xsl:text>if(!self.dataModel) {&#10;</xsl:text>
			<xsl:text>self.dataModel = </xsl:text><xsl:value-of select="dataloader-interface/entity-type/name"/><xsl:text>Factory.createInstance();&#10;</xsl:text>
			<xsl:text>}</xsl:text>
		</xsl:if>
		<xsl:text>&#10;//@non-generated-start[data-loader-transient]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='data-loader-transient']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
	</xsl:template>


	<xsl:template match="dataloader-impl[dataloader-interface/type = 'LIST']" mode="dataloader-qsync">
		<xsl:apply-templates select="." mode="dataloader-qsync-content"/>
	</xsl:template>
	
	<xsl:template match="*[dataloader-interface/entity-type/transient='true']" mode="dataloader-qsync">
	<xsl:text>deferred.resolve({&#10;data: self.dataModel&#10;});&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*" mode="dataloader-qsync">
	    <xsl:text>if (!angular.isUndefinedOrNull(self.dataModelId) &amp;&amp; self.dataModelId !== -1) {&#10;</xsl:text>
		<xsl:apply-templates select="." mode="dataloader-qsync-content"/>
		<xsl:text>}else {&#10;</xsl:text>
		<xsl:apply-templates select="." mode="dataloader-qsync-new-content"/>
<!-- 		<xsl:text>self.dataModel = </xsl:text><xsl:value-of select="dao-interface/dao/class/pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text> -->
<!-- 		<xsl:text>deferred.resolve({&#10;data: self.dataModel&#10;});&#10;</xsl:text> -->
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	
	
	<xsl:template match="*" mode="dataloader-qsync-content">
		<!-- Simple and list case -->
		<xsl:value-of select="dao-interface/name"/><xsl:text>Proxy.get</xsl:text>
		<xsl:choose>
			<xsl:when test="dataloader-interface/type = 'LIST'">
				<xsl:text>List</xsl:text><xsl:value-of select="dao-interface/dao/class/name"/><xsl:text>(context, [</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="dao-interface/dao/class/name"/><xsl:text>ById(self.dataModelId, context, [</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:for-each select="dao-interface/dao/class/association">
			<xsl:text>'</xsl:text><xsl:value-of select="@name"/><xsl:text>'</xsl:text>
			<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:text>]</xsl:text>
		<xsl:text>).then(function(modelEntity) {&#10;</xsl:text>
		
        <xsl:text> //success of DAO call&#10;</xsl:text>
        <xsl:text> self.dataModel = modelEntity;&#10;</xsl:text>                    
        <xsl:text>deferred.resolve({&#10;</xsl:text>
        <xsl:text> data: modelEntity&#10;</xsl:text>
        <xsl:text> });&#10;</xsl:text>   
    	<xsl:text> },&#10; function(error){&#10;deferred.reject(error);&#10;}&#10;);&#10;</xsl:text>
	
	</xsl:template>
	
	<xsl:template match="*[dataloader-interface/entity-type/transient='true']" mode="dataloader-qsync-content">
	</xsl:template>
	
	<xsl:template match="*" mode="dataloader-qsync-new-content">
		<xsl:text>self.dataModel = </xsl:text><xsl:value-of select="dao-interface/dao/class/pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text>
		<xsl:text>deferred.resolve({&#10;data: self.dataModel&#10;});&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*[cascades/cascade]" mode="dataloader-qsync-new-content">
		<xsl:text>//cascades/cascade.......&#10;</xsl:text>
		<xsl:text>self.dataModel = </xsl:text><xsl:value-of select="dao-interface/dao/class/pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text>
		<xsl:text>deferred.resolve({&#10;data: self.dataModel&#10;});&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*[dao-interface/dao/class/association[@type='many-to-one' and @aggregate-type='COMPOSITE']]" mode="dataloader-qsync-new-content">
	
		<xsl:apply-templates select="dao-interface/dao/class/association" mode="dataloader-qsync-new-in-parent"/>
		
	</xsl:template>


	<xsl:template match="*[@type='many-to-one' and @aggregate-type='COMPOSITE']" mode="dataloader-qsync-new-in-parent">
		<xsl:text>self.dataModel = </xsl:text><xsl:value-of select="../pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text>
		
		<xsl:text>//dao-interface/dao/class/assoiation[@type='many-to-one' and @aggregate-type='COMPOSITE'].......&#10;</xsl:text>
		<xsl:text>if (!angular.isUndefinedOrNullOrEmpty(params.dataModelParentId)) {&#10;</xsl:text>
		<xsl:value-of select="dao/name"/><xsl:text>Proxy</xsl:text>
		<xsl:text>.get</xsl:text>
		<xsl:value-of select="class/name"/>
		<xsl:text>ById(params.dataModelParentId, context, [])</xsl:text>
		<xsl:text>.then(function(modelEntity) {&#10;</xsl:text>
		<xsl:text>self.dataModel.</xsl:text>
		<xsl:value-of select="variable-name"/>
		<xsl:text> = modelEntity;&#10;</xsl:text>
		<xsl:text>deferred.resolve({&#10;data: self.dataModel&#10;});&#10;</xsl:text>
		<xsl:text>}, function (error) {&#10;</xsl:text>
		<xsl:text>deferred.reject(error);&#10;</xsl:text>
		<xsl:text>});&#10;</xsl:text>
		<xsl:text>} else {&#10;</xsl:text>
		<xsl:text>deferred.resolve({&#10;data: self.dataModel&#10;});&#10;</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="*" mode="dataloader-qsync-new-in-parent">
	
	</xsl:template>

	<xsl:template match="*" mode="dataloader-reload">
	
	</xsl:template>





<!-- 	<xsl:template match="dataloader-impl" mode="dataloader-getModelCache"> -->
<!-- 		var modelCache = null; -->

<!--         <xsl:value-of select="name"/>.prototype.getModelCache = function getModelCache() { -->

<!--             if ( angular.isUndefinedOrNull(modelCache)) { -->

<!--                 modelCache = {}; -->


<!--                 // Add entity to cache -->
<!--                 if(!angular.isUndefinedOrNull(this.dataModel)){ -->
<!--                 var entityId = this.dataModel !== null ? this.dataModel.idToString : -1; -->
<!--                 var entityCacheId = MFMappingHelper.getCacheIdentifier('<xsl:value-of select="name"/>Factory', entityId); -->
<!--                 modelCache[entityCacheId] = this.dataModel; -->
<!-- 				} -->
				
<!-- 				// Add entities of combos to cache -->
<!-- 				<xsl:if test="count(dataloader-interface/combos/combo)>0"> -->
<!-- 					var i = 0; -->
<!-- 				</xsl:if> -->
<!-- 				<xsl:for-each select="dao-interface/dao/class/association[@type='many-to-one' and @opposite-aggregate-type='AGGREGATE']"> -->
<!--        		 <xsl:for-each select="dataloader-interface/combos/combo/entity/text()[generate-id() = generate-id(key('comboEntity',.)[1])]"> -->
<!-- 				<xsl:variable name="comboAttrName"> -->
<!-- 					<xsl:text>combo</xsl:text> -->
<!-- 					<xsl:value-of select="."/> -->
<!-- 					<xsl:text>DataModel</xsl:text> -->
<!-- 				</xsl:variable> -->
<!-- 				if(!angular.isUndefinedOrNull(this.<xsl:value-of select="$comboAttrName"/>)){ -->
<!-- 					for (i = 0; i &lt; this.<xsl:value-of select="$comboAttrName"/>.length; i++) { -->
<!-- 						var comboEntity<xsl:value-of select="."/> = this.<xsl:value-of select="$comboAttrName"/>[i]; -->
<!-- 	                    var comboEntityCacheId<xsl:value-of select="."/> = MFMappingHelper.getCacheIdentifier( -->
<!-- 	                    	'<xsl:value-of select="."/>Factory', comboEntity<xsl:value-of select="."/>.idToString); -->
<!-- 	                    modelCache[comboEntityCacheId<xsl:value-of select="."/>] = comboEntity<xsl:value-of select="."/>; -->
<!-- 	                } -->
<!--                 } -->
<!-- 				</xsl:for-each> -->


<!--             } -->

<!--             return modelCache; -->
<!--         }; -->
<!-- 	</xsl:template> -->

<!-- 	<xsl:template match="*" mode="dataloader-getModelCache"> -->
<!-- 	</xsl:template> -->
	
	<xsl:template match="dataloader-impl" mode="declare-extra-imports">
	
		<objc-import import="MFSyncPromiseProvider" import-in-function="$qSync" scope="local"/>
		<objc-import import="MFUtils" import-in-function="MFUtils" scope="local"/>
		<objc-import import="MFAbstractDataLoader" import-in-function="MFAbstractDataLoader" scope="local"/>
		<objc-import import="MFMappingHelper" import-in-function="MFMappingHelper" scope="local"/>
		
	</xsl:template>

</xsl:stylesheet>