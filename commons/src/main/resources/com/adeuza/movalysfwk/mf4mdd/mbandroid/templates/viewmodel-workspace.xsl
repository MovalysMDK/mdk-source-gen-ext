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
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.Dataloader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractViewModel</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.VMTabConfiguration</import>
		<xsl:if test="count(subvm/viewmodel[type/is-list = 'true']) > 1">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.VMTabConfigHolder</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.DefaultApplicationR</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.Application</import>
		</xsl:if>

		<!-- Import nécessaire à la méthode updateFromDataLoader -->
		<xsl:apply-templates select="subvm/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
	</xsl:template>
	
	<!-- IMPLEMENTS .................................................................................................... -->
	
	<xsl:template match="viewmodel" mode="declare-extra-implements">
		<xsl:if test="count(subvm/viewmodel[type/is-list = 'true']) > 1">
			<interface>VMTabConfigHolder</interface>
		</xsl:if>
	</xsl:template>
	
	<!--  SUPERCLASS ................................................................................................ -->

	<xsl:template match="viewmodel" mode="superclass">
		<xsl:text>AbstractViewModel</xsl:text>
	</xsl:template>

	<!--  ATTRIBUTES ................................................................................................ -->

	<xsl:template match="viewmodel" mode="attributes">
		<!-- Génération d'attributs représentant les viewmodels liés -->
		<xsl:apply-templates select="subvm/viewmodel" mode ="attributes"/>
		
		<xsl:if test="count(subvm/viewmodel[type/is-list = 'true']) > 1">
		private VMTabConfiguration tabConfiguration = new VMTabConfiguration();
		</xsl:if>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="attributes">
		/**
		 * sub view model attribute
		 */
		<xsl:text>private </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = null;&#13;</xsl:text>
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

		<xsl:apply-templates select="." mode="generate-updateFromDataloader"/>
		
		<xsl:apply-templates select="." mode="generate-vmtabconfiguration-gettersetter"/>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-vmtabconfiguration-gettersetter">
	
		<xsl:if test="count(subvm/viewmodel[type/is-list = 'true']) > 1">
		/**
		 * returns the VMTabConfiguration
	 	 * @return the VMTabConfiguration
	 	 */
		public VMTabConfiguration getVMTabConfiguration() {
			return this.tabConfiguration;
		}

		/**
		 * sets the VMTabConfiguration
	 	 * @param tabConfiguration the new VMTabConfiguration value
	 	 */
		public void setVMTabConfiguration(VMTabConfiguration p_oTabConfiguration) {
			this.tabConfiguration = p_oTabConfiguration;
		}
		</xsl:if>
	
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-isEditable">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public boolean isEditable() {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:apply-templates select="./subvm/viewmodel[position()!=1]" mode="generate-isEditable"/><xsl:text>;</xsl:text>
		<xsl:text>&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="generate-isEditable">
		<xsl:if test="position()!=1">&#13;||</xsl:if>
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>!=null &amp;&amp; this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.isEditable()</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-setEditable">
		/**
	 	 * {@inheritDoc}
	 	 */
		@Override public void setEditable(final MContext p_oContext, final Map&lt;String, Object&gt; p_mapParameters) {
			<xsl:apply-templates select="./subvm/viewmodel" mode="generate-setEditable"/>
		}
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="generate-setEditable">
		<xsl:text>if (this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/> != null) {
		this.o<xsl:value-of select="./implements/interface/@name"/>.setEditable(p_oContext, p_mapParameters);
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-isReadyToChanged">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public boolean isReadyToChanged() {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:apply-templates select="./subvm/viewmodel[position()!=1]" mode="generate-isReadyToChanged"/><xsl:text>;&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-isReadyToChanged">
		<xsl:if test="position()!=1"><xsl:text>||&#13;</xsl:text></xsl:if>
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>!=null &amp;&amp; this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.isReadyToChanged()</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-clear">
		/**
	 	 * {@inheritDoc}
	 	 */
		<xsl:text>@Override public void clear() {&#13;</xsl:text>
			<xsl:apply-templates select="./subvm/viewmodel[position()!=1]" mode="generate-clear"></xsl:apply-templates>
		<xsl:text>&#13;}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-clear">
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.clear();&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-writeData">
		/**
	 	 * {@inheritDoc}
	 	 */
		<!-- <xsl:text>@Override public void writeData(MContext p_oContext, Map&lt;String, Object&gt; p_mapParameters) {&#13;</xsl:text> -->
			<xsl:text>@Override public void doOnDataLoaded(Map&lt;String, Object&gt; p_mapParameters) {&#13;</xsl:text>
			<xsl:apply-templates select="./subvm/viewmodel" mode="generate-writeData"></xsl:apply-templates>
		<xsl:text>&#13;}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="subvm/viewmodel" mode="generate-writeData">
		<xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.doOnDataLoaded(p_mapParameters);&#13;</xsl:text>
		<!-- <xsl:text>this.o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>.writeData(p_oContext, p_mapParameters);&#13;</xsl:text> -->
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-setters">
		/** 
		 * {@inheritDoc}
		 */
		@Override
		<xsl:text>public void set</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> p_oData) {&#13;</xsl:text>
		<xsl:text>this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = p_oData;&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-getters">
		/** 
		 * {@inheritDoc}
		 */
		@Override
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

	<xsl:template match="viewmodel[workspace-vm/text()='true']" mode="generate-updateFromDataloader">
		/** 
		 * {@inheritDoc}
		 */
		@Override
		public void updateFromDataloader(final Dataloader&lt;?&gt; p_oDataloader) {
			if (p_oDataloader != null) {
				<xsl:apply-templates select="subvm/viewmodel[dataloader-impl]" mode="genericUpdateFromDataloader"/>
			}
		}

		<xsl:apply-templates select="subvm/viewmodel[dataloader-impl]" mode="generate-updateFromDataloader"/>
	</xsl:template>

	<xsl:template match="subvm/viewmodel" mode="genericUpdateFromDataloader">
		<xsl:variable name="dataloader" select="dataloader-impl/implements/interface/@name"/>
		<xsl:if test="not(preceding-sibling::viewmodel[dataloader-impl/implements/interface/@name=$dataloader])">
			<xsl:if test="preceding-sibling::viewmodel">
				<xsl:text>else </xsl:text>
			</xsl:if>
			<xsl:text>if (</xsl:text><xsl:value-of select="$dataloader"/>.class.isAssignableFrom(p_oDataloader.getClass())) {
				this.updateFromDataloader((<xsl:value-of select="$dataloader"/>) p_oDataloader);
			<xsl:text>}</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="subvm/viewmodel[dataloader-impl]" mode="generate-updateFromDataloader">
		<xsl:variable name="dataloader" select="dataloader-impl/implements/interface/@name"/>
		<xsl:if test="count(preceding-sibling::viewmodel[dataloader-impl/implements/interface/@name=$dataloader]) = 0">
			/**
			 * Updates the viewmodel using a dataloader.
			 * @param p_o<xsl:value-of select="dataloader-impl/implements/interface/@name"/> The dataloader.
			 */
			public void updateFromDataloader(<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
					<xsl:text> p_o</xsl:text><xsl:value-of select="dataloader-impl/implements/interface/@name"/>) {
			
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">updateFromDataloader<xsl:value-of select="dataloader-impl/implements/interface/@name"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
			
				<xsl:apply-templates select="../../subvm/viewmodel[dataloader-impl/implements/interface/@name=$dataloader]" 
					mode="generate-updateFromDataloader-body"/>
			
				<!--  si vm de liste et plus d'une liste dans le workspace, alors il y a des onglets -->
				<xsl:if test="count(../viewmodel[type/is-list = 'true']) > 1 and type/is-list = 'true'">
					<xsl:variable name="tabRank" select="position()"/>
				this.tabConfiguration.setTabTitle("tab<xsl:value-of select="$tabRank"/>", 
					String.format(Application.getInstance().getStringResource(DefaultApplicationR.tab_default_title), <xsl:value-of select="$tabRank"/>, 
						this.o<xsl:value-of select="./implements/interface/@name"/>.getCount()), null);
				</xsl:if>
				
				p_o<xsl:value-of select="dataloader-impl/implements/interface/@name"/>.popReload(<xsl:value-of select="dataloader-impl/implements/interface/@name"/>.DEFAULT_KEY);
				
				</xsl:with-param>
			</xsl:call-template>
		}
		</xsl:if>
	</xsl:template>

	<xsl:template match="subvm/viewmodel[dataloader-impl]" mode="generate-updateFromDataloader-body">
		<xsl:text>this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.updateFromDataloader(p_o</xsl:text>
		<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
