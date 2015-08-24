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


	<!-- THIS STARTS THE CLASS -->
	<xsl:template match="node()[package and name]" mode="declare-class">
		<xsl:text>'use strict';&#10;</xsl:text>
		<xsl:apply-templates select="." mode="documentation"/>
		<xsl:text>&#10;//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
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
		
		
		<xsl:text>&#10;</xsl:text>
		
		<xsl:text>	var </xsl:text><xsl:value-of select="name"/><xsl:text> = function </xsl:text><xsl:value-of select="name"/><xsl:text>(){&#10;</xsl:text>
		<xsl:text>		// Constructor&#10;</xsl:text>
		<xsl:text>		</xsl:text><xsl:value-of select="name"/><xsl:text>._Parent.call(this);&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">constructor</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>	};&#10;&#10;</xsl:text>
		
		<xsl:text>	MFUtils.extendFromInstance(</xsl:text><xsl:value-of select="name"/><xsl:text>, MFDaoProxyAbstract);&#10;&#10;&#10;</xsl:text>
		
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   ABSTRACT METHODS</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'getNbEntities'"/>
		</xsl:apply-templates>
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - GET</xsl:text>
        <xsl:text>&#10;	//==================================================================================</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="." mode="simple-methods">
	    	<xsl:with-param name="methodNameToken" 		select="'get'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_id'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'getList'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'getList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_ids'"/>
		</xsl:apply-templates>
		
 		<xsl:apply-templates select="." mode="methods-extra">
			<xsl:with-param name="methodFilterToken" 	select="'get'"/>
		</xsl:apply-templates>
		
		
		<xsl:text>&#10;	//==================================================================================</xsl:text>
        <xsl:text>&#10;	//========   SPECIFIC METHODS - SAVE &amp; UPDATE</xsl:text>
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
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'update'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entity'"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="simple-methods">
		    <xsl:with-param name="methodNameToken" 		select="'updateList'"/>
		    <xsl:with-param name="methodParameterToken" select="'p_entities'"/>
		</xsl:apply-templates>
		
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
		
		<xsl:apply-templates select="." mode="methods-extra">
			<xsl:with-param name="methodFilterToken" 	select="'del'"/>
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