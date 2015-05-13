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
		<xsl:text>AbstractMultiSectionAutoBindActivity</xsl:text>
	</xsl:template>

	<xsl:template match="screen[workspace='false' and multi-panel='true' ]" mode="superclass-import">
		<import>java.util.ArrayList</import>
		<import>java.util.List</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailActionParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMultiSectionAutoBindActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveActionDetailParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveDetailAction</import>
	</xsl:template>
	
	<xsl:template match="screen[workspace='false' and multi-panel='true']" mode="extra-methods-imports">
		<xsl:apply-templates select="pages/page[parameters/parameter[@name='grid-section-parameter'] = '1']/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
	</xsl:template>
	
	
	<xsl:template match="screen[workspace='false' and multi-panel='true']" mode="extra-methods">
		<xsl:apply-templates select="." mode="do-keep-modifications"/>
		
		/**
		 * {@inheritDoc}
		 */
		 @Override
		public final int getMultiSectionId() {
			return R.id.main__<xsl:value-of select="translate(name, $uppercase, $smallcase)"/>__visualpanel;
		}
	</xsl:template>
	
	<xsl:template match="page[ancestor::screen[workspace='false' and multi-panel='true'] and parameters/parameter[@name='grid-column-parameter'] = '1' and parameters/parameter[@name='grid-section-parameter'] = '1']" mode="generate-doFillAction-body">	
		LoadDataForMultipleDisplayDetailActionParameter oMultipleDisplayParameter 
			= new LoadDataForMultipleDisplayDetailActionParameter();
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);
		
		<xsl:for-each select="../page[parameters/parameter[@name='grid-column-parameter'] = '1' and parameters/parameter[@name='grid-section-parameter'] != '1']">
			<xsl:sort select="parameters/parameter[@name='grid-column-parameter']"/>
		oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);		
		</xsl:for-each>
		
		this.launchAction(LoadDataForMultipleDisplayDetailAction.class, oMultipleDisplayParameter);		
	</xsl:template>
	
	<xsl:template match="page[ancestor::screen[workspace='false' and multi-panel='true'] and parameters/parameter[@name='grid-column-parameter'] = '1' and parameters/parameter[@name='grid-section-parameter'] != '1']" 
		mode="generate-doFillAction-body"/>

	<xsl:template match="page[ancestor::screen[workspace='false' and multi-panel='true'] and (parameters/parameter[@name='grid-column-parameter'] != '1' or parameters/parameter[@name='grid-section-parameter'] != 1) ]" 
		mode="doFillAction-method"/>

</xsl:stylesheet>