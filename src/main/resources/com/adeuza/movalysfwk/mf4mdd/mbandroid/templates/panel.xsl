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

	<xsl:include href="includes/class.xsl"/>
	<xsl:include href="includes/string-replace-all.xsl"/>
	
	<xsl:include href="ui/adapter/constructor.xsl" />
	
	<xsl:include href="ui/page/import.xsl"/>
	
	<xsl:include href="ui/page/default.xsl"/>

	<xsl:include href="ui/page/attributes-declaration.xsl"/>

	<xsl:include href="ui/page/do-after-inflate.xsl"/>
	
	<xsl:include href="ui/page/list.xsl"/>
	
	<xsl:include href="ui/page/getter-method.xsl"/>
	
	<xsl:include href="ui/screen/action-events.xsl"/>
	
	<xsl:include href="ui/menus/pagemenu.xsl"/>
	
	<!-- <xsl:include href="ui/screen/workspace-masterdetail.xsl"/>	
	<xsl:include href="ui/screen/workspace-detail.xsl"/>		
	<xsl:include href="ui/screen/workspace.xsl"/>
	<xsl:include href="ui/screen/multipanel.xsl"/>
	<xsl:include href="ui/screen/searchscreen.xsl"/> -->
	
	<xsl:include href="ui/page/common-page-methods.xsl"/>
	<xsl:include href="ui/page/onDataloaderReload.xsl"/>
	<!-- <xsl:include href="ui/navigation/navigation.xsl"/> -->

	<xsl:output method="text"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template match="/">
		<xsl:apply-templates select="page" mode="declare-class"/>
	</xsl:template>


	<!-- ##########################################################################################
											ATTRIBUTES
		########################################################################################## -->

	<xsl:template match="page" mode="attributes">
		<!-- <xsl:apply-templates select="." mode="requestCodeConstant"/> -->
		<xsl:if test="parameters/parameter[@name='workspace-panel-type'] = 'master'">
			<xsl:apply-templates select="adapter" mode="attributes" />
		</xsl:if>
		<xsl:apply-templates select="external-adapters/adapter" mode="attributes"/>
	</xsl:template>
	
	<!-- <xsl:template match="screen" mode="requestCodeConstant">
		public static final int <xsl:value-of select="request-code-constant"/> = Math.abs(<xsl:value-of select="name"/>.class.getSimpleName().hashCode());
	</xsl:template> -->

	<!-- ##########################################################################################
										METHODES
		########################################################################################## -->

	<xsl:template match="page" mode="methods">
	
		<xsl:apply-templates select="." mode="onCreate-method"/>
	
		<xsl:apply-templates select="." mode="doAfterInflate-method"/>
	
		<xsl:apply-templates select="." mode="getLayoutId-method"/>
	
		<xsl:apply-templates select="." mode="getViewModel-method"/>
	
		<xsl:if test="viewmodel/multiInstance='true'">
			<xsl:apply-templates select="." mode="doFillAction-method"/>
			<xsl:apply-templates select="." mode="doOnReload-method">
				<xsl:with-param name="launchFrom" select="local-name(.)"/>
			</xsl:apply-templates>
		</xsl:if>
	
		<xsl:apply-templates select="." mode="extra-methods"/>
		
		<xsl:apply-templates select="." mode="action-events"/>
		
		<xsl:apply-templates select="." mode="action-events-notify-dataset"/>
	
		<xsl:apply-templates select="events/event" mode="event"/>
		
		<xsl:apply-templates select="." mode="getter-method"/>
		
		<xsl:apply-templates select="." mode="fragmentOptionsMenu"/>
	
	</xsl:template>

	<xsl:template match="page" mode="extra-methods">
	</xsl:template>

	<xsl:template match="event" mode="event">
		/**
		 * Listener on <xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/>
		 * @param p_oEvent the event which triggered the callback
		 */
		@ListenerOnBusinessNotification(<xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/>.class)
		public void doOn<xsl:value-of select="name"/>(<xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/> p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doOn<xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				this.doFillAction();
			</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
</xsl:stylesheet>
