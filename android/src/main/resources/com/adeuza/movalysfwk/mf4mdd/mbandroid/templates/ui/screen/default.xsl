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
	<xsl:output method="text" />

	<!-- ##########################################################################################
					Templates utilisés par défaut lors de la génération des écrans
		########################################################################################## -->


	<!-- *****************************************************************************************
											SUPERCLASS
		***************************************************************************************** -->

	<xsl:template match="screen" mode="superclass">
		<xsl:text>AbstractAutoBindMMActivity</xsl:text>
	</xsl:template>

	<xsl:template match="screen" mode="superclass-import">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity</import>
	</xsl:template>

	<!-- *****************************************************************************************
											METHODES
		***************************************************************************************** -->

	<xsl:template match="screen|page" mode="createViewModel-imports">
		<import><xsl:value-of select="master-package" />.viewmodel.ViewModelCreator</import>
	</xsl:template>

	<xsl:template match="screen" mode="getViewId-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity#getViewId()
		 */
		@Override
		public int getViewId() {
			return R.layout.<xsl:value-of select="./screenname"/>;
		}
	</xsl:template>
	

	<xsl:template match="screen|page" mode="createViewModel-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity#createViewModel()
		 */
		@Override
		public <xsl:value-of select="viewmodel/implements/interface/@name"/> createViewModel() {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">create-view-model</xsl:with-param>
				<xsl:with-param name="defaultSource">
					ViewModelCreator oCreator = (ViewModelCreator) Application.getInstance().getViewModelCreator();
					return oCreator.create<xsl:value-of select="viewmodel/implements/interface/@name"/>();
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="screen[pages/page/actions/action/action-type='SAVEDETAIL'] | page[actions/action/action-type='SAVEDETAIL']" mode="do-keep-modifications">
	
		/**
		 * {@inheritDoc} 
	 	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity#doOnKeepModifications(android.content.DialogInterface)
	 	 */
		@Override
		protected void doOnKeepModifications(DialogInterface p_oDialog) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnKeepModifications</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="launch-savedetail-actions">
						<xsl:with-param name="sourceObject">this</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="screen[not(pages/page/actions/action/action-type='SAVEDETAIL')] | page[not(actions/action/action-type='SAVEDETAIL')]" mode="do-keep-modifications">
	
	</xsl:template>
	
	<xsl:template match="screen[pages/page/actions/action/action-type='SAVEDETAIL'] | page[actions/action/action-type='SAVEDETAIL']" mode="launch-savedetail-actions">
		<xsl:param name="sourceObject"/>
		NullActionParameterImpl oParameterIn = new NullActionParameterImpl();
		oParameterIn.setRuleParameters(this.getParameters());
		<xsl:if test="count(descendant::page/actions/action[action-type='SAVEDETAIL']) = 1">
			<xsl:for-each select="descendant::page/actions/action[action-type='SAVEDETAIL']">
				this.launchAction(<xsl:value-of select="implements/interface/@name"/>.class, oParameterIn, <xsl:value-of select="$sourceObject"/>);
			</xsl:for-each>
		</xsl:if>
				
		<xsl:if test="count(descendant::page/actions/action[action-type='SAVEDETAIL']) > 1">
			ChainSaveActionDetailParameter oChainParameter = new ChainSaveActionDetailParameter(oParameterIn, 
			<xsl:for-each select="descendant::page/actions/action[action-type='SAVEDETAIL']">
				<xsl:value-of select="implements/interface/@name"/>
				<xsl:text>.class</xsl:text>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>);&#13;</xsl:text>
				<xsl:if test="$sourceObject = 'FROM_BACK'">
					<xsl:text>oChainParameter.setExitMode(true);&#13;</xsl:text>	
				</xsl:if>
				this.launchAction(ChainSaveDetailAction.class, oChainParameter, <xsl:value-of select="$sourceObject"/>);
			</xsl:if>
	</xsl:template>
	
	
</xsl:stylesheet>
