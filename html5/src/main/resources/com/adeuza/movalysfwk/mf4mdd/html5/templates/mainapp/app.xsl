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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/commons/nongenerated.xsl"/>

	<xsl:output method="text"/>

	<xsl:template match="main-app">
		<xsl:apply-templates select="./views/view" mode="app-config"/>
	</xsl:template>

	
	<xsl:template match="view[@isScreen='true']" mode="app-config">
		<xsl:choose>
			<xsl:when test="not(count(nestedSubviews/nestedSubview)>0)">
			  	<xsl:apply-templates select="." mode="state-simple-screen"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="state-nested-screen"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="view" mode="app-config">
	</xsl:template>
	
	<xsl:template match="*" mode="state-simple-screen">
			<xsl:text>.state('</xsl:text><xsl:value-of select="name"/><xsl:text>', {&#10;</xsl:text>
			<xsl:text>url: '/</xsl:text><xsl:value-of select="name"/><xsl:text>',&#10;</xsl:text>
    		<xsl:text>templateUrl: 'views/</xsl:text><xsl:value-of select="name"/><xsl:text>/</xsl:text><xsl:value-of select="name"/><xsl:text>.html',&#10;</xsl:text>
			<xsl:text>controller: '</xsl:text><xsl:value-of select="name"/><xsl:text>Ctrl',&#10;</xsl:text>
			<xsl:text>controllerAs: 'vm'</xsl:text>
		<xsl:text>})&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="*" mode="state-nested-screen">
		<xsl:text>.state('</xsl:text><xsl:value-of select="name"/><xsl:text>', {&#10;</xsl:text>
		<xsl:if test="@isWorkspace='true'">
			<xsl:text>abstract: true,&#10;</xsl:text>
			<xsl:text>url: '/</xsl:text><xsl:value-of select="name"/><xsl:text>',&#10;</xsl:text>
		</xsl:if>
	    <xsl:text>templateUrl: 'views/</xsl:text><xsl:value-of select="name"/><xsl:text>/</xsl:text><xsl:value-of select="name"/><xsl:text>.html',&#10;</xsl:text>
	    <xsl:text>controller: '</xsl:text><xsl:value-of select="name"/><xsl:text>Ctrl',&#10;</xsl:text>
		<xsl:text>controllerAs: 'vm'</xsl:text>
	    <xsl:text>})&#10;</xsl:text>
	    <!-- State Content -->
	    <xsl:text>.state('</xsl:text><xsl:value-of select="name"/><xsl:text>.content', {&#10;</xsl:text>
	    <!-- workspace do not have content url -->
	    <xsl:choose>
	    	<xsl:when test="@isWorkspace='true'">
	    		<xsl:text>url: '',&#10;</xsl:text>
	    	</xsl:when>
	    	<xsl:otherwise>
	    		<xsl:text>url: '/</xsl:text><xsl:value-of select="name"/>
			    <xsl:choose>
					<xsl:when test="not(navigation-from-screen-list/navigation-from-screen/@type='NAVIGATION_DETAIL') and not(@isWorkspace='true') and count(nestedSubviews/nestedSubview)>1">
						<!-- generate match for subview -->
						<xsl:apply-templates select="nestedSubviews/nestedSubview[.=../../../view[@isPanelOfMultiSection='true' and not(@is-list='true')]/name]" mode="nested-subview-urlparts"/>
					</xsl:when>
					<xsl:when test="navigation-to-screen-list/navigation-to-screen/source[name=../../../../view[nestedSubviews/nestedSubview[.=../../../view[@type='LIST_2']/name]]/name] and not(@isWorkspace='true') and count(nestedSubviews/nestedSubview)>0">
						<xsl:text>/:parentItemId/:itemId</xsl:text>
					</xsl:when>
					<xsl:when test="navigation-to-screen-list/navigation-to-screen/source[name=../../../../view[nestedSubviews/nestedSubview[.=../../../view[@type='LIST_3']/name]]/name] and not(@isWorkspace='true') and count(nestedSubviews/nestedSubview)>0">
						<xsl:text>/:parentParentItemId/:parentItemId/:itemId</xsl:text>
					</xsl:when>
					<xsl:when test="not(navigation-from-screen-list/navigation-from-screen/@type='NAVIGATION_DETAIL') and not(@isWorkspace='true') and count(nestedSubviews/nestedSubview)>0">
						<xsl:text>/:itemId</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!-- NOTHING -->
					</xsl:otherwise>
				</xsl:choose>
	    		<xsl:text>',&#10;</xsl:text>
	    	</xsl:otherwise>
	    </xsl:choose>
	    
	    <xsl:text>views:{&#10;</xsl:text>
	    <!-- only list of workspace are declared here -->
	    <xsl:choose>
	    	<xsl:when test="@isWorkspace='true'">
	    		<xsl:apply-templates select="./nestedSubviews/nestedSubview[.=../../../view[@isPanelOfWorkspace='true']/name and .=../../../view[@type='LIST_1' or @type='LIST_2' or @type='LIST_3']/name]" mode="main-app-nested-view-declaration"/>
	    	</xsl:when>
	    	<xsl:otherwise>
      			<xsl:apply-templates select="./nestedSubviews/nestedSubview" mode="main-app-nested-view-declaration"/>
	    	</xsl:otherwise>
	    </xsl:choose>
	     <xsl:text>}&#10;</xsl:text>
	     <xsl:text>})&#10;</xsl:text>
	     
	     <!-- state content detail for workspace -->
	     <xsl:if test="@isWorkspace='true'">
		     <xsl:text>.state('</xsl:text><xsl:value-of select="name"/><xsl:text>.content.detail', {&#10;</xsl:text>
		     	<xsl:text>url: '</xsl:text>
		     	<xsl:if test="./nestedSubviews/nestedSubview[.=../../../view[@isPanelOfWorkspace='true']/name and .=../../../view[@type='LIST_2']/name]">
		     		<xsl:text>/:parentItemId</xsl:text>
		     	</xsl:if>
		     	<xsl:text>/:itemId',</xsl:text>
		     	<xsl:text>views : {&#10;</xsl:text>
		     	<xsl:apply-templates select="./nestedSubviews/nestedSubview[.=../../../view[@isPanelOfWorkspace='true']/name and .=../../../view[@type='MASTER' or @type='DEFAULT']/name]" mode="main-app-nested-view-declaration">
		     		<xsl:with-param name="linkedState" select="name"/>
		     	</xsl:apply-templates>
				<xsl:text>}&#10;</xsl:text>
		     <xsl:text>})&#10;</xsl:text>
	     </xsl:if>
	     
	</xsl:template>

	<xsl:template match="nestedSubview" mode="main-app-nested-view-declaration">
		<xsl:param name="linkedState" select="N/A"/>
		<xsl:text>'</xsl:text><xsl:value-of select="."/>
		<xsl:if test="$linkedState!='N/A'">
			<xsl:text>@</xsl:text><xsl:value-of select="$linkedState"/>
		</xsl:if>
		<xsl:text>' : {&#10;</xsl:text>
        <xsl:text>templateUrl: 'views/</xsl:text><xsl:value-of select="."/><xsl:text>/</xsl:text><xsl:value-of select="."/><xsl:text>.html',&#10;</xsl:text>
        <xsl:text>controller: '</xsl:text><xsl:value-of select="."/><xsl:text>Ctrl',&#10;</xsl:text>
		<xsl:text>controllerAs: 'vm'</xsl:text>
        <xsl:text>}</xsl:text>
        <xsl:choose>
        	<xsl:when test="position() != last()"><xsl:text>,</xsl:text></xsl:when>
        	<xsl:otherwise><xsl:text>&#10;</xsl:text></xsl:otherwise>
        </xsl:choose>		
	</xsl:template>

	<xsl:template match="nestedSubviews/nestedSubview" mode="nested-subview-urlparts">
		<!-- /{section1:(?:animal1|animal2)}/{section1Id} -->
		<xsl:text>/{section</xsl:text>
		<xsl:value-of select="position()"/>
		<xsl:text>:(?:</xsl:text>
		<xsl:for-each select="../nestedSubview[.=../../../view[@isPanelOfMultiSection='true']/name]">
			<xsl:value-of select="."/>
			<xsl:if test="position()!=last()">
				<xsl:text>|</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)}/{section</xsl:text>
		<xsl:value-of select="position()"/>
		<xsl:text>Id}</xsl:text>
	</xsl:template>

</xsl:stylesheet>