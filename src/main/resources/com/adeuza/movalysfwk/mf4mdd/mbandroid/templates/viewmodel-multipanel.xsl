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
	
	<xsl:include href="ui/viewmodel/import.xsl"/>
	<xsl:include href="ui/viewmodel/attribute-getter-setter.xsl"/>
	<xsl:include href="ui/viewmodel/update-from-identifiable.xsl"/>
	<xsl:include href="ui/viewmodel/update-from-dataloader.xsl"/>
	<xsl:include href="ui/viewmodel/clear.xsl"/>
	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="viewmodel">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="viewmodel" mode="declare-extra-imports">
		<import>java.util.Map</import>
		<import>java.util.HashMap</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.Dataloader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractViewModel</import>

		<!-- Import nécessaire à la méthode updateFromDataLoader -->
		<xsl:apply-templates select="subvm/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
	</xsl:template>
	
	<!-- IMPLEMENTS .................................................................................................... -->
	
	<xsl:template match="viewmodel" mode="declare-extra-implements">
	</xsl:template>
	
	<!--  SUPERCLASS ................................................................................................ -->

	<xsl:template match="viewmodel" mode="superclass">
		<xsl:text>AbstractViewModel</xsl:text>
	</xsl:template>

	<!--  ATTRIBUTES ................................................................................................ -->

	<xsl:template match="viewmodel" mode="attributes">
		<!-- Génération d'attributs représentant les viewmodels liés -->
		<xsl:apply-templates select="subvm/viewmodel" mode ="attributes"/>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="attributes">
		<xsl:text>/**&#13;* </xsl:text>
		<xsl:text>sub view model </xsl:text><xsl:value-of select="./name"/>
		<xsl:text>&#13;*/&#13;</xsl:text>
		<xsl:text>private </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = null;&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel[multiInstance='true']" mode="attributes">
		/** instances map of <xsl:value-of select="implements/interface/@name"/> panel view model */
		<xsl:text>private Map&lt;String ,</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>&gt; o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = new HashMap&lt;&gt;();&#13;</xsl:text>
	</xsl:template>
	

	<!--  METHODS ................................................................................................... -->

	<xsl:template match="viewmodel" mode="methods">
		<xsl:apply-templates select="subvm/viewmodel" mode="generate-getters"/>

		<xsl:apply-templates select="subvm/viewmodel" mode="generate-setters"/>

		<xsl:apply-templates select="." mode="generate-method-getIdVM"/>

		<xsl:apply-templates select="." mode="generate-isEditable"/>

		<xsl:apply-templates select="." mode="generate-setEditable"/>

		<xsl:apply-templates select="." mode="generate-isReadyToChanged"/>

		<xsl:apply-templates select="." mode="generate-clear"/>

		<xsl:apply-templates select="." mode="generate-writeData"/>

	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-isEditable">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public boolean isEditable() {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">isEditable-method</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:if test="./subvm/viewmodel[multiInstance='true']">
					<xsl:text>boolean r_isEditable = false;</xsl:text>
					<xsl:apply-templates select="./subvm/viewmodel[multiInstance='true']" mode="generate-isEditable-loop"/>
				</xsl:if>
				<xsl:text>return </xsl:text>
				<xsl:if test="./subvm/viewmodel[multiInstance='true']">
					<xsl:text> r_isEditable</xsl:text>
					<xsl:if test="count(./subvm/viewmodel[not(multiInstance='true')])>0">
						<xsl:text> || </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates select="./subvm/viewmodel[multiInstance='false' or not(multiInstance)]" mode="generate-isEditable"/><xsl:text>;&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="generate-isEditable">
		<xsl:if test="position()!=1">
			<xsl:text> ||&#13;</xsl:text>
		</xsl:if>
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>!=null &amp;&amp; this.o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/><xsl:text>.isEditable()</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="generate-isEditable-loop">
		<xsl:variable name="interface" select="./implements/interface/@name"/>
		<xsl:text>for (String key : this.o</xsl:text>
		<xsl:value-of select="$interface"/>
		<xsl:text>.keySet()) {&#13;</xsl:text>
		<xsl:text>r_isEditable = r_isEditable || this.o</xsl:text>
		<xsl:value-of select="$interface"/>
		<xsl:text>.get(key).isEditable();&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-setEditable">
		/**
	 	 * {@inheritDoc}
	 	 */
		@Override public void setEditable(final MContext p_oContext, final Map&lt;String, Object&gt; p_mapParameters) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">setEditable-method</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="./subvm/viewmodel" mode="generate-setEditable"/>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-setEditable">
		<xsl:text>if (this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/> != null) {
		this.o<xsl:value-of select="./implements/interface/@name"/>.setEditable(p_oContext, p_mapParameters);
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel[multiInstance='true']" mode="generate-setEditable">
		<xsl:text>if (this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text> != null) {&#13;</xsl:text>
		<xsl:text>for (String key : this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.keySet()) {&#13;</xsl:text>
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.get(key).setEditable(p_oContext, p_mapParameters);&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-isReadyToChanged">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public boolean isReadyToChanged() {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">isReadyToChanged-method</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:if test="./subvm/viewmodel[multiInstance='true']">
					<xsl:text>boolean r_isReadyToChange = false;</xsl:text>
					<xsl:apply-templates select="./subvm/viewmodel[multiInstance='true']" mode="generate-isReadyToChanged-loop"/>
				</xsl:if>
				<xsl:text>return </xsl:text>
				<xsl:if test="./subvm/viewmodel[multiInstance='true']">
					<xsl:text> r_isReadyToChange</xsl:text>
					<xsl:if test="count(./subvm/viewmodel[not(multiInstance='true')])>0">
						<xsl:text> || </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates select="./subvm/viewmodel[multiInstance='false' or not(multiInstance)]" mode="generate-isReadyToChanged"/><xsl:text>;&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>	
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="generate-isReadyToChanged-loop">
		<xsl:variable name="interface" select="./implements/interface/@name"/>
		<xsl:text>for (String key : this.o</xsl:text>
		<xsl:value-of select="$interface"/>
		<xsl:text>.keySet()) {&#13;</xsl:text>
		<xsl:text>r_isReadyToChange = r_isReadyToChange || this.o</xsl:text>
		<xsl:value-of select="$interface"/>
		<xsl:text>.get(key).isReadyToChanged();&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-isReadyToChanged">
		<xsl:if test="position()!=1">
			<xsl:text>||&#13;</xsl:text>
		</xsl:if>
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>!=null &amp;&amp; this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.isReadyToChanged()</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-clear">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public void clear() {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">clear-method</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="./subvm/viewmodel" mode="generate-clear"/>
				<xsl:text>&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-clear">
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.clear();&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-writeData">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public void doOnDataLoaded(Map&lt;String, Object&gt; p_mapParameters) {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doOnDataLoaded-method</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="./subvm/viewmodel[not(multiInstance='true')]" mode="generate-writeData"></xsl:apply-templates>
				<xsl:text>&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-writeData">
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.doOnDataLoaded(p_mapParameters);&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel[multiInstance='true']" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * {@inheritDoc}&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>@Override&#13;</xsl:text>
		<xsl:text>public void add</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(String p_sKey, </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> p_oData) {&#13;</xsl:text>
		<xsl:text>this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.put(p_sKey, p_oData);&#13;}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * {@inheritDoc}&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>@Override&#13;</xsl:text>
		<xsl:text>public void set</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> p_oData) {&#13;</xsl:text>
		<xsl:text>this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = p_oData;&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[multiInstance='true']" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * {@inheritDoc}&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>@Override&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> get</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(String p_sKey) {&#13;</xsl:text>
		<xsl:text>return this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.get(p_sKey);&#13;}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * {@inheritDoc}&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>@Override&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> get</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:text>return this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>;&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-method-getIdVM"><!-- marche car dans ce cas là on sais pour le moment qu'on a qu'un seul élément -->
		<xsl:if test="./attribute/@type-short-name!='List' and count(identifier/attribute) = 1 ">
			/**
		 	 * {@inheritDoc}
		 	 */
			@Override
			public String getIdVM() {
				return String.valueOf(this.<xsl:value-of select="identifier/attribute/get-accessor"/>());
			}
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
