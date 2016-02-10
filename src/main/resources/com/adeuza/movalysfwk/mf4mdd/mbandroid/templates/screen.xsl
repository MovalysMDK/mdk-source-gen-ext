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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:include href="includes/class.xsl"/>

	<xsl:include href="ui/adapter/constructor.xsl" />

	<xsl:include href="ui/screen/import.xsl"/>
	<xsl:include href="ui/screen/attributes-declaration.xsl"/>

	<xsl:include href="ui/screen/do-after-set-content-view.xsl"/>
	<xsl:include href="ui/screen/default.xsl"/>
	<xsl:include href="ui/screen/list.xsl"/>
	
	<xsl:include href="ui/screen/workspace-masterdetail.xsl"/>	
	
	<xsl:include href="ui/screen/workspace-detail.xsl"/>	
		
	<xsl:include href="ui/screen/workspace.xsl"/>
	
	<xsl:include href="ui/screen/multipanel.xsl"/>
	
	<xsl:include href="ui/screen/searchscreen.xsl"/>
	
	<xsl:include href="ui/screen/action-events.xsl"/>

	<xsl:include href="ui/page/common-page-methods.xsl"/>
	<xsl:include href="ui/page/onDataloaderReload.xsl"/>
	<xsl:include href="ui/menus/import.xsl"/>
	<xsl:include href="ui/menus/screenmenu.xsl"/>
	<xsl:include href="ui/navigation/navigation.xsl"/>

	<xsl:output method="text"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template match="/">
		<xsl:apply-templates select="screen" mode="declare-class"/>
	</xsl:template>


	<!-- ##########################################################################################
											ATTRIBUTES
		########################################################################################## -->

	<xsl:template match="screen" mode="attributes">
		
		<xsl:apply-templates select="." mode="requestCodeConstant"/>
		<xsl:apply-templates select="pages/page[@pos='1']/adapter" mode="attributes"/>
		<xsl:apply-templates select="pages/page/external-adapters/adapter" mode="attributes"/>
	</xsl:template>
	
	<xsl:template match="screen" mode="requestCodeConstant">
		/** result code use with method startActivityForResult */
		public static final int <xsl:value-of select="request-code-constant"/> = getUniqueRequestCode();
		
		/** mask for result code on startActivityForResult */
		public static final int <xsl:value-of select="request-code-constant"/>_MASK = 0x0000ffff;
		
		/** 
		 * method to compute a unique positive integer
		 * @return a unique positive integer based on activity hashCode 
		 */
		private static int getUniqueRequestCode() {
			int hash = <xsl:value-of select="name"/>.class.getSimpleName().hashCode();
			
			if (hash &lt; 0) {
				hash++;
			}
			
			// in support-v7, only the last five digits of the result code are read
			// if the result value is greater, an exception will be raised
			return Math.abs(hash) &amp; <xsl:value-of select="request-code-constant"/>_MASK;
		}
	</xsl:template>
	
	<xsl:template match="screen[main='true']"  
		mode="declare-extra-implements">
		<interface>MFRootActivity</interface>
	</xsl:template>

	<!-- ##########################################################################################
										METHODES
		########################################################################################## -->

	<xsl:template match="screen" mode="methods">
		<xsl:variable name="nbPages" select="count(pages/page)"/>
		<xsl:variable name="condition" select="boolean($nbPages = 1)"/>
		<xsl:variable name="panel" select="self::node()"/>

		<xsl:apply-templates select="." mode="doAfterSetContentView-method"/>

		<xsl:apply-templates select="." mode="doFillAction-method"/>
		<xsl:apply-templates select="." mode="doOnReload-method"/>

		<xsl:apply-templates select="$panel" mode="createViewModel-method"/>

		<xsl:apply-templates select="." mode="getViewId-method"/>
		
		<!-- Appel au template de génération des méthodes spécifiques au type d'écran: workspace, liste, etc. -->
		<xsl:apply-templates select="$panel" mode="extra-methods"/>

		<!-- option menu generation -->
		<xsl:apply-templates select="." mode="activityOptionsMenu"/>
		<!-- <xsl:apply-templates select="menus/menu and options-menu" mode="activityOptionsMenu"/> -->
		<!-- <xsl:apply-templates select="options-menu" mode="activityOptionsMenu"/> -->

		<xsl:apply-templates select="." mode="action-events"/>
		
		<xsl:apply-templates select="events/event"/>
	</xsl:template>
	
	
	<xsl:template match="screen" mode="doFillAction-method">
		<xsl:apply-templates select="pages/page[viewmodel/dataloader-impl]" mode="doFillAction-method"/>
	</xsl:template>
	
	<!-- Pour certains écrans, pas de méthode supplémentaire 
		EDIT LMI: Pour un panel simple avec sauvegarde, besoin d'un doOnKeepModification 
	-->
	<xsl:template match="screen|page" mode="extra-methods">
		<xsl:apply-templates select="." mode="do-keep-modifications"/>
	</xsl:template>
 
	<xsl:template match="event">
		/**
		 * Listener on <xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/>
		 * @param p_oEvent the event which triggered the callback
		 */
		@ListenerOnBusinessNotification(<xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/>.class)
		public void doOn<xsl:value-of select="name"/>(<xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/> p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doOn<xsl:value-of select="action/@name"/>.<xsl:value-of select="name"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				if(!p_oEvent.isExitMode()) {
					this.doFillAction();
				}
			</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
</xsl:stylesheet>

