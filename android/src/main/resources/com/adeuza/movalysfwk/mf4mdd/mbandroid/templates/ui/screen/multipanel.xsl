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

	<!-- ##########################################################################################
			Templates spécifiques aux écrans qui reposent sur l'utilisation d'un écran multi-section.
		########################################################################################## -->


	<!-- *****************************************************************************************
											SUPERCLASS
		***************************************************************************************** -->
	
	<xsl:template match="screen[workspace='false' and multi-panel='true' ]" mode="superclass">
		<xsl:text>AbstractMultiSectionAutoBindFragmentActivity</xsl:text>
	</xsl:template>
	

	<xsl:template match="screen[workspace='false' and multi-panel='true' ]" mode="superclass-import">
		<import>java.util.ArrayList</import>
		<import>java.util.List</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailActionParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMultiSectionAutoBindFragmentActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveActionDetailParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveDetailAction</import>
		<xsl:if test="main = 'true'">
			<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.displaymain.MFRootActivity</import>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="screen[workspace='false' and multi-panel='true']" mode="extra-methods-imports">
		<xsl:apply-templates select="pages/page[parameters/parameter[@name='grid-section-parameter'] = '1']/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="pages/page[parameters/parameter[@name='grid-section-parameter'] = '1']/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="pages/page/full-name" mode="declare-import"/>
	</xsl:template>
	
	
	<xsl:template match="screen[./workspace='false' and ./multi-panel='true']" mode="extra-methods" priority="1000">
		<xsl:apply-templates select="." mode="do-keep-modifications"/>

		/**
		 * {@inheritDoc}
		 */
		 @Override
		public final int getMultiSectionId() {
			return R.id.main__<xsl:value-of select="translate(name, $uppercase, $smallcase)"/>__visualpanel;
		}
	</xsl:template>
	
	<xsl:template match="screen[workspace='false' and multi-panel='true']" mode="attributes">	
		<xsl:apply-templates select="." mode="requestCodeConstant"/>
	</xsl:template>
	
	<xsl:template match="screen[workspace='false' and multi-panel='true']" mode="doAfterSetContentView-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity#doAfterSetContentView()
		 */
		@Override
		protected void doAfterSetContentView() {
			super.doAfterSetContentView();
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">do-after-set-content-view</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="page[ancestor::screen[workspace='false' and multi-panel='true']]|dialog[ancestor::screen[workspace='false' and multi-panel='true']]" mode="generate-adapter-registration">
		<xsl:if test="count(adapter | external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']) > 0">
		<xsl:variable name="fragmentVar">o<xsl:value-of select="name"/></xsl:variable>
		<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="$fragmentVar"/>
			<xsl:text> = (</xsl:text><xsl:value-of select="name"/><xsl:text>) getSupportFragmentManager().findFragmentById(R.id.main__</xsl:text>
				<xsl:value-of select="ancestor::screen/name-lowercase"/>sect<xsl:value-of select="parameters/parameter[@name='grid-section-parameter']"/>__visualpanel);
		if ( <xsl:value-of select="$fragmentVar"/> != null ) {
			<xsl:apply-templates select="adapter" mode="generate-adapter-registration">
				<xsl:with-param name="adapterName"><xsl:value-of select="$fragmentVar"/>.getListAdapter()</xsl:with-param>
			</xsl:apply-templates>
			<xsl:for-each select="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED' and ancestor::screen[workspace='false' and multi-panel='true']]">
				<xsl:variable name="adapterName"><xsl:value-of select="$fragmentVar"/>.getSpinnerAdapter<xsl:value-of select="position()"/>()</xsl:variable>
				<xsl:apply-templates select="." mode="generate-adapter-registration">
					<xsl:with-param name="adapterName" select="$adapterName"/>
				</xsl:apply-templates>
			</xsl:for-each>
		}
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
