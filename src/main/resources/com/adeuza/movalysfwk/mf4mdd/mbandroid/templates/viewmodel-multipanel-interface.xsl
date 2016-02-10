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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/interface.xsl"/>

	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="viewmodel">
		<xsl:apply-templates select="viewmodel-interface"/>
	</xsl:template>


	<xsl:template match="viewmodel-interface">
		<xsl:apply-templates select="." mode="declare-interface"/>
	</xsl:template>

	<!-- IMPORTS ................................................................................................... -->

	<xsl:template match="viewmodel-interface" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.UpdatableFromDataloader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ViewModel</import>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.Scope</import>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.ScopePolicy</import>
	</xsl:template>

	<!-- ANNOTATIONS ................................................................................................ -->

	<xsl:template match="viewmodel-interface" mode="class-annotations">
		<xsl:choose>
			<xsl:when test="/viewmodel/parent-viewmodel/parent-viewmodel">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/type/name='LIST_1__ONE_SELECTED'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/type/name='FIXED_LIST'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/type/name='LISTITEM_1'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when> 
			<xsl:when test="/viewmodel/type/name='LISTITEM_2'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when> 
			<xsl:when test="/viewmodel/type/name='LISTITEM_3'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>@Scope(ScopePolicy.SINGLETON)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- SUPERINTERFACES ............................................................................................ -->

	<xsl:template match="viewmodel-interface" mode="superinterfaces">
		<xsl:text>ViewModel</xsl:text>
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="viewmodel-interface" mode="methods">
		<xsl:apply-templates select="./subvmis/subvmi" mode="generate-getters"/>
		<xsl:apply-templates select="./subvmis/subvmi" mode="generate-setters"/>
	</xsl:template>

	<xsl:template match="subvmi[name=../../../subvm/viewmodel[multiInstance='true']/implements/interface/@name]" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * getter for sub view model </xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @param p_sKey the key of the view model in the list&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text> get</xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text>(String p_sKey);</xsl:text>
	</xsl:template>

	<xsl:template match="subvmi[name=../../../subvm/viewmodel[multiInstance='true']/implements/interface/@name]" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * setter for sub view model </xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @param p_sKey the key of the view model in the list&#13;</xsl:text>
		<xsl:text> * @param p_oData the new value to set&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void add</xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text>(String p_sKey, </xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text> p_oData);</xsl:text>
	</xsl:template>

	<xsl:template match="subvmi" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * getter for sub view model </xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text> get</xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text>();</xsl:text>
	</xsl:template>

	<xsl:template match="subvmi" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * setter for sub view model </xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @param p_oData the new value to set&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void set</xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./name"/>
		<xsl:text> p_oData);</xsl:text>
	</xsl:template>
</xsl:stylesheet>
