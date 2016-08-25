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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ionic2/templates/commons/nongenerated.xsl"/>

	<xsl:output method="text"/>

	<xsl:template match="main-app">
		<!--  we set the screenroot as default value  -->
		<xsl:text>&#10;// if none of the above states are matched, this is used as the fallback&#10;</xsl:text>
		<xsl:text>$urlRouterProvider&#10;</xsl:text>

		<xsl:if test="count(./views/view)=0">
			<xsl:text>.otherwise('config');&#10;</xsl:text>
		</xsl:if>

		
		<xsl:apply-templates select="./views/view" mode="main-app-set-when-multisection"/>
		<xsl:apply-templates select="./views/view" mode="main-app-set-main-screen"/>
		
	</xsl:template>
	
	<xsl:template match="view[@isScreen='true' and @isWorkspace='false' and count(nestedSubviews/nestedSubview)>1]" mode="main-app-set-when-multisection">
		<xsl:text>.when('/</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>', '/</xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>/</xsl:text>
		<xsl:for-each select="nestedSubviews/nestedSubview[.=../../../view[@isPanelOfMultiSection='true' and not(@is-list='true')]/name]">
			<xsl:value-of select="."/>
			<xsl:text>/new</xsl:text>
			<xsl:if test="position()!=last()">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>')&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="view" mode="main-app-set-when-multisection">
	</xsl:template>
	
	<xsl:template match="view[@isMainScreen='true']" mode="main-app-set-main-screen">
		
		<xsl:text>.otherwise('/</xsl:text>
		<xsl:value-of select="name"/>
<!-- 	    <xsl:if test="not(navigation-from-screen-list/navigation-from-screen/@type='NAVIGATION_DETAIL') and count(nestedSubviews/nestedSubview)>0"> -->
<!-- 			<xsl:text>.content</xsl:text> -->
<!-- 		</xsl:if> -->
		<xsl:text>');&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="view" mode="main-app-set-main-screen">
	</xsl:template>
	

</xsl:stylesheet>