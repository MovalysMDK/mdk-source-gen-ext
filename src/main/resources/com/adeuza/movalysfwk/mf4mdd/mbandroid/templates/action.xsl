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
	<xsl:include href="ui/action/import.xsl"/>
	<xsl:include href="ui/action/extends.xsl"/>
	<xsl:include href="ui/action/viewmodelcreation.xsl"/>
	<xsl:include href="ui/action/savedetail-methods.xsl"/>
	<xsl:include href="ui/action/othermethods.xsl"/>

	<xsl:output method="text"/>

	<xsl:template match="/">
		<xsl:apply-templates select="master-action/action" mode="declare-class"/>
	</xsl:template>

	<xsl:template match="action" mode="methods">
		<xsl:apply-templates select="." mode="generate-methods"/>
		<xsl:if test="viewmodel">
			<xsl:apply-templates select="." mode="generate-vmenable-method"/>
		</xsl:if>
	</xsl:template>

	<!-- Template dédié à la déclaration d'un dao. -->
	<xsl:template match="dao-interface" mode="generate-dao-declaration">
		<xsl:variable name="name" select="name"/>
		<xsl:if test="not(preceding-sibling::dao-interface[name=$name])">
		<xsl:value-of select="name"/> o<xsl:value-of select="name"/> = BeanLoader.getInstance().getBean(<xsl:value-of select="name"/>.class);
		</xsl:if>
	</xsl:template>

	<!-- Template dédié à la récupération d'un élément en base -->
	<xsl:template match="action[action-type='DISPLAY']/dao-interface" mode="generate-dao-getX">
		o<xsl:value-of select="name"/>.get<xsl:value-of select="dao/interface/name"/>(1, CascadeSet.of(<xsl:for-each select="../viewmodel//cascades/cascade">
							<xsl:if test="position()!=1">,</xsl:if>
							<xsl:value-of select="."/></xsl:for-each>), p_oContext)
	</xsl:template>

	<xsl:template match="external-daos/dao-interface" mode="generate-dao-getX">
		, o<xsl:value-of select="name"/>.getList<xsl:value-of select="dao/interface/name"/>(CascadeSet.NONE, p_oContext)
	</xsl:template>
	
	<!-- Template de génération de la méthode isViewModelEnabled -->
	<xsl:template match="action[action-type='DISPLAYWORKSPACE']" mode="generate-vmenable-method">
		<xsl:text>public boolean isViewModelEnabled(</xsl:text><xsl:value-of select="parameters/parameter[@name='vmworkspace']"/><xsl:text> p_oViewModel) {&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-viewmodel-enabled</xsl:with-param>
				<xsl:with-param name="defaultSource">
				<xsl:text>//MF_DEV_MANDATORY Change select ...&#13;</xsl:text>
				<xsl:text>return </xsl:text><xsl:value-of select="not(viewmodel/read-only = 'true')"/><xsl:text>;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL']" mode="generate-vmenable-method">
	</xsl:template>
	
	<!-- Template de génération de la méthode isViewModelEnabled -->
	<xsl:template match="action" mode="generate-vmenable-method">
		<xsl:text>public boolean isViewModelEnabled(</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/><xsl:text>  p_oViewModel) {&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-viewmodel-enabled</xsl:with-param>
				<xsl:with-param name="defaultSource">
				<xsl:text>//MF_DEV_MANDATORY Change select ...&#13;</xsl:text>
				<xsl:text>return </xsl:text><xsl:value-of select="not(viewmodel/read-only = 'true')"/><xsl:text>;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
