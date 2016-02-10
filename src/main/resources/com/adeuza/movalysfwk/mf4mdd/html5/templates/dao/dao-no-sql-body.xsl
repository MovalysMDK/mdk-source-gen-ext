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
xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">


	<!-- THIS STARTS THE CLASS -->
	<xsl:template match="node()[package and name]" mode="declare-class">
		<xsl:text>'use strict';&#10;</xsl:text>

		<xsl:apply-templates select="." mode="documentation"/>
		<xsl:apply-templates select="." mode="class-prototype"/>
		<xsl:text>{&#10;</xsl:text>
			<xsl:apply-templates select="." mode="class-body"/>
		<xsl:text>}]);&#10;</xsl:text>
	</xsl:template>


	<xsl:template match="node()" mode="class-body">
	
		<xsl:apply-templates select="." mode="factory-constructor"/>

	</xsl:template>



	<!-- ###################################################
						GESTION DE LA DOCUMENTATION
		 ################################################### -->

	<xsl:template match="node()" mode="documentation">
		<xsl:text>/**&#10;</xsl:text>
		<xsl:text> * </xsl:text>
		<xsl:value-of select="documentation"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text> *&#10;</xsl:text> 
		<xsl:call-template name="copyright"/>
		<xsl:text> *&#10;</xsl:text> 
		<xsl:text> */&#10;</xsl:text> 
	</xsl:template>

	<xsl:template name="copyright">
		<xsl:text disable-output-escaping="yes"><![CDATA[ * <p>Copyright (c) 2010</p>]]></xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ * <p>Company: Adeuza</p>]]></xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	
	
	<!-- ###################################################
			CONSTRUCTEUR INITIALISANT TOUTE LA FACTORY
	     ################################################### -->		
	<xsl:template match="node()" mode="factory-constructor">
		<xsl:variable name="daoMappingName">
			<xsl:value-of select="dao-interface/name"/><xsl:text>Mapping</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="cascadeData">
			<xsl:apply-templates select="." mode="generateCascadeData" />
		</xsl:variable>
	
	
		<xsl:text>&#10;</xsl:text>		
		<xsl:text>	var </xsl:text><xsl:value-of select="name"/><xsl:text> = function </xsl:text><xsl:value-of select="name"/><xsl:text>(){&#10;</xsl:text>
		
		<xsl:text>		// Constructor&#10;</xsl:text>
		<xsl:text>		</xsl:text><xsl:value-of select="name"/><xsl:text>._Parent.call(this, '</xsl:text><xsl:value-of select="class/uml-name"/><xsl:text>');&#10;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">constructor</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>		this.lastId = null;&#10;</xsl:text>
				<xsl:text>		this.mapping = </xsl:text><xsl:value-of select="$daoMappingName"/><xsl:text>.mappingNoSql;&#10;</xsl:text>
				<xsl:text>		this.syncDisabled = false;&#10;</xsl:text>
				<xsl:text>		this.objectStoreName = '</xsl:text><xsl:value-of select="class/uml-name"/><xsl:text>';&#10;</xsl:text>
<!-- 				<xsl:text>		this.entityName = '</xsl:text><xsl:value-of select="class/uml-name"/><xsl:text>';&#10;</xsl:text> -->
				<xsl:text>		this.cascadeDefinition = {&#10;</xsl:text>
					<xsl:for-each select="exsl:node-set($cascadeData)/cascade">
						<xsl:value-of select="@parentAttrPointingChild"/><xsl:text>: { </xsl:text>
							<xsl:text>cardinality: '</xsl:text><xsl:value-of select="@type"/><xsl:text>', </xsl:text>		
								
							<xsl:text>foreignEntity: '</xsl:text><xsl:value-of select="@childEntity"/><xsl:text>', </xsl:text>								

							<xsl:if test="@opposite-navigable='true'">
								<xsl:text>childAttrPointingParent: '</xsl:text><xsl:value-of select="@childAttrPointingParent"/><xsl:text>', </xsl:text>
							</xsl:if>
							<xsl:if test="@type='one-to-one'">
								<xsl:text>relationOwner: </xsl:text><xsl:value-of select="@relation-owner"/><xsl:text>, </xsl:text>
							</xsl:if>
							
							<xsl:text>composite: </xsl:text>
							<xsl:choose>
								<xsl:when test="@opposite-aggregate-type='COMPOSITE'">
									<xsl:text>true </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>false </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
	
						<xsl:choose>
							<xsl:when test="position() != last()"><xsl:text> },&#10;</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text> }&#10;</xsl:text></xsl:otherwise>
						</xsl:choose>
			   		</xsl:for-each>
		        <xsl:text>		};&#10;</xsl:text>
		        <xsl:text>&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>	};&#10;&#10;</xsl:text>
		
		<xsl:text>	MFUtils.extendFromInstance(</xsl:text><xsl:value-of select="name"/><xsl:text>, MFDaoNoSqlAbstract);&#10;&#10;&#10;</xsl:text>
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - GET</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
	    	<xsl:with-param name="methodNameToken" 		select="'get'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_id'"/>
		    <xsl:with-param name="methodCascadeToken" 	select="$cascadeData"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'getList'"/>
		    <xsl:with-param name="methodCascadeToken" 	select="$cascadeData"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'getList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_ids'"/>
		    <xsl:with-param name="methodCascadeToken" 	select="$cascadeData"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="extra-methods">
			<xsl:with-param name="methodFilterToken" 	select="'get'"/>
			<xsl:with-param name="methodCascadeToken" 	select="$cascadeData"/>
		</xsl:apply-templates>
		

		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - SAVE</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
	    	<xsl:with-param name="methodNameToken" 		select="'save'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entity'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'saveList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entities'"/>
		</xsl:apply-templates>
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - UPDATE</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
	    	<xsl:with-param name="methodNameToken" 		select="'update'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entity'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'updateList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entities'"/>
		</xsl:apply-templates>
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - SAVE &amp; UPDATE</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'saveOrUpdate'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entity'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'saveOrUpdateList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entities'"/>
		</xsl:apply-templates>
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - DELETE</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'delete'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entity'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'delete'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_id'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'deleteList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entities'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'deleteList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_ids'"/>
		</xsl:apply-templates>	
		
		<xsl:apply-templates select="." mode="extra-methods">
			<xsl:with-param name="methodFilterToken" 	select="'del'"/>
			<xsl:with-param name="methodCascadeToken" 	select="$cascadeData"/>
		</xsl:apply-templates>	
		<xsl:text>&#10;</xsl:text>	
		
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource" />
</xsl:call-template>
<xsl:text>&#10;&#10;</xsl:text>		

   		<xsl:text>	return new </xsl:text><xsl:value-of select="name"/><xsl:text>();&#10;</xsl:text>
	</xsl:template>

</xsl:stylesheet>