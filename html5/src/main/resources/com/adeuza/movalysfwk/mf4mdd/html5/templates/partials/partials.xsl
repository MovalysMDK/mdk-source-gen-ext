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

<xsl:output method="html" indent="yes" omit-xml-declaration="no"/>

<xsl:include href="components/mfbrowseurltextfield.xsl"/>
<xsl:include href="components/mfbutton.xsl"/>
<xsl:include href="components/mfcallphonenumber.xsl"/>
<xsl:include href="components/mfdatepicker.xsl"/>
<xsl:include href="components/mfdoubletextfield.xsl"/>
<xsl:include href="components/mfenumimage.xsl"/>
<xsl:include href="components/mffixedlist.xsl"/>
<xsl:include href="components/mfintegertextfield.xsl"/>
<xsl:include href="components/mflabel.xsl"/>
<xsl:include href="components/mfnumberpicker.xsl"/>
<xsl:include href="components/mfphotothumbnail.xsl"/>
<xsl:include href="components/mfpickerlist.xsl"/>
<xsl:include href="components/mfposition.xsl"/>
<xsl:include href="components/mfradiogroup.xsl"/>
<xsl:include href="components/mfsendmailtextfield.xsl"/>
<xsl:include href="components/mfsignature.xsl"/>
<xsl:include href="components/mfslider.xsl"/>
<xsl:include href="components/mfswitch.xsl"/>
<xsl:include href="components/mftextfield.xsl"/>
<xsl:include href="components/mftextview.xsl"/>
<xsl:include href="components/mfmultilinetext.xsl"/>
<xsl:include href="components/mfwebview.xsl"/>
<!-- list components -->
<xsl:include href="components/mflist.xsl"/>

	<!-- Those templates generate the global html body -->
	<xsl:template match="view">
		<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
		<xsl:comment>Html5 template for the view<xsl:value-of select="name"/></xsl:comment>
		<xsl:apply-templates select="." mode="partial-hmtl"/>
	</xsl:template>
	
	<!-- 	IF panel of list -->
	<xsl:template match="view[@isScreen='false' and @is-list='true']" mode="partial-hmtl">
		<div>
			<div>
				<xsl:attribute name="class">form-horizontal panel-body</xsl:attribute>
				<xsl:apply-templates select="." mode="partial-body"/>
			</div>
		</div>
	</xsl:template>
	

	
	<!-- 	If panel of multisection -->
	<xsl:template match="view[@isScreen='false' and not(@is-list='true') and @isPanelOfMultiSection='true' and @isPanelOfWorkspace='false']" mode="partial-hmtl">
		<div>
			<xsl:attribute name="class">panel panel-default</xsl:attribute>
<!-- 			<xsl:if test="not(@isFirstPanelOfMultiSection='true')"> -->
			<mf-subcontrolbar>
				<xsl:attribute name="mf-title">Subview title</xsl:attribute>
			</mf-subcontrolbar>
<!-- 			</xsl:if> -->
			<form>
				<xsl:attribute name="class">form-horizontal panel-body</xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="viewName"/>Form</xsl:attribute>
				<xsl:attribute name="novalidate">true</xsl:attribute>
				<xsl:apply-templates select="." mode="partial-body"/>
			</form>	
		</div>
	</xsl:template>
	
	<!-- 	If simple panel -->
	<xsl:template match="view[@isScreen='false' and (not(@is-list='true' or @isPanelOfMultiSection='true') or @isPanelOfWorkspace='true')]" mode="partial-hmtl">
		<div>
			<form>
				<xsl:attribute name="class">form-horizontal</xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="viewName"/>Form</xsl:attribute>
				<xsl:attribute name="novalidate">true</xsl:attribute>
				<xsl:apply-templates select="." mode="partial-body"/>
			</form>
		</div>
	</xsl:template>
	
	<!-- IF Workspace Screen -->
	<xsl:template match="view[@isWorkspace='true']" mode="partial-hmtl">
		<div>
			<xsl:attribute name="class"><xsl:value-of select="name"/>-workspace-container</xsl:attribute>
			<xsl:apply-templates select="." mode="screen-partial-hmtl"/>
		</div>
	</xsl:template>
	
	<!-- 	IF screen -->
	<xsl:template match="view" mode="partial-hmtl">
		<xsl:apply-templates select="." mode="screen-partial-hmtl"/>
	</xsl:template>
	
	
	<xsl:template match="view" mode="screen-partial-hmtl">
		<xsl:choose> <!-- Si y y a que des liens avec d'autres écrans et PAS de liens avec des panels -->
			<xsl:when test="count(navigation-from-screen-list/navigation-from-screen)>0">
				<div><xsl:attribute name="class">container menu</xsl:attribute>
					<xsl:apply-templates select="." mode="partial-body"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="partial-body"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- 		Ici le body -->
	<xsl:template match="view" mode="partial-body">
			<xsl:if test="@isScreen='true'">
				<xsl:choose>
					<!-- case when multilist in workspace -->
					<xsl:when test="@isWorkspace='true' and count(nestedSubviews/nestedSubview[@isList='true'])>1">
						<tabset>
							<xsl:attribute name="class"><xsl:value-of select="name"/>-workspace-column</xsl:attribute>
							<xsl:apply-templates select="./nestedSubviews/nestedSubview[@isList='true']" mode="display-nested-subviews">
								<xsl:with-param name="tabset" select="1"/>
							</xsl:apply-templates>
						</tabset>
						<xsl:apply-templates select="./nestedSubviews/nestedSubview[@isList='false']" mode="display-nested-subviews">
							<xsl:with-param name="tabset" select="0"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@isWorkspace='true'">
						<xsl:apply-templates select="./nestedSubviews/nestedSubview" mode="display-nested-subviews">
							<xsl:with-param name="tabset" select="0"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="./nestedSubviews/nestedSubview" mode="display-nested-subviews">
								<xsl:with-param name="tabset" select="-1"/>
							</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
						
			<xsl:apply-templates select="." mode="partial-menu-list"/>
			
			<!-- 			Here is the generation of all components -->
			<xsl:choose>
				<xsl:when test="@type='LIST_1' or @type='LIST_2' or @type='LIST_3'">
					<xsl:apply-templates select="." mode="partial-List-generation"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="attributes/HTML-attribute" mode="partial-component-generation"/>
				</xsl:otherwise>
			</xsl:choose>
			
	</xsl:template>
	
	<xsl:template match="nestedSubview" mode="display-nested-subviews">
		<xsl:param name="tabset"/>
		
		<xsl:choose>
			<xsl:when test="$tabset='1'">
				<tab>
					<xsl:attribute name="heading"><xsl:value-of select="."/></xsl:attribute>
					<div>
						<xsl:attribute name="ui-view"><xsl:value-of select="."/></xsl:attribute>
					</div>
				</tab>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:if test="$tabset='0'">
						<xsl:if test="@isFirstDetail='true'">
							<xsl:attribute name="id">firstColumnScroll</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="class"><xsl:value-of select="../../name"/>-workspace-column</xsl:attribute>
						<xsl:attribute name="data-snap-ignore">true</xsl:attribute>
					</xsl:if>
					
					<xsl:attribute name="ui-view"><xsl:value-of select="."/></xsl:attribute>
					
				</div>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	
	<!-- Those templates generate the buttons linking the parent screen to its subscreens (not panels ) -->
	<xsl:template match="view[@isScreen='true' and count(navigation-from-screen-list/navigation-from-screen[@type='NAVIGATION'])>0]" mode="partial-menu-list">
		<ul>
			<xsl:apply-templates select="./navigation-from-screen-list" mode="partial-menu-link-to-page"/>
        </ul>
	</xsl:template>
	
	
	<xsl:template match="view" mode="partial-menu-list">
	<xsl:comment> match="view" mode="partial-menu-list"</xsl:comment>
	</xsl:template>
	
	
	<xsl:template match="navigation-from-screen-list/navigation-from-screen[@type='NAVIGATION']" mode="partial-menu-link-to-page">
		<li>
			<xsl:attribute name="ng-click">
				<xsl:text>rootActions.go('</xsl:text>
				<xsl:value-of select="target/name"/>
				<xsl:if test="count(target/sections/section)>0">
					<xsl:text>.content</xsl:text>
				</xsl:if>
				<xsl:text>'</xsl:text>
				<xsl:if test="count(target/sections/section)>1 and target/isWorkspace!='true'">
					<xsl:text> , {</xsl:text>
					<xsl:for-each select="target/sections/section[@isList='false']">
						<xsl:text>section</xsl:text><xsl:value-of select="position()"/><xsl:text> :'</xsl:text>
						<xsl:value-of select="."/><xsl:text>', </xsl:text>
						<xsl:text>section</xsl:text><xsl:value-of select="position()"/><xsl:text>Id :'new'</xsl:text>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>}</xsl:text>
				</xsl:if>
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		
			<xsl:text>{{'</xsl:text><xsl:value-of select="target/name-lc"/><xsl:text>__title' | translate}}</xsl:text>			
		</li>
	</xsl:template>
	

	<xsl:template match="HTML-attribute" mode="partial-component-generation" priority="-900">
	<xsl:comment>********** WARNING ************
		[partials.xsl]  The attribute  '<xsl:value-of select="attribute/@name"/>' (type ='<xsl:value-of select="visualfield/component"/>', mode='partial-component-generation') is not well handled by the generator
	*******************************</xsl:comment>
	</xsl:template>
	
	<xsl:template match="view" mode="partial-List-generation" priority="-900">
	<xsl:comment>********** WARNING ************
		[partials.xsl]  The list  '<xsl:value-of select="name"/>' (type ='<xsl:value-of select="@type"/>', mode='partial-List-generation') is not well handled by the generator
	*******************************</xsl:comment>
	</xsl:template>
</xsl:stylesheet>