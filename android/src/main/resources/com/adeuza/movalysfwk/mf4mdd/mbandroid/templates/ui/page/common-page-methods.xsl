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

	<xsl:template match="dialog|page" mode="doFillAction-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>
		<xsl:apply-templates select="./viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
	</xsl:template>

	<xsl:template match="dialog|page" mode="generate-load-or-update-methods">
		<xsl:apply-templates select="." mode="doFillAction-method"/>
		<xsl:apply-templates select="." mode="doOnReload-method"/>
	</xsl:template>

	<xsl:template match="dialog|page" mode="doFillAction-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMDialogFragment#doFillAction()
		 */
		@Override
		public void doFillAction() {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doFillAction</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="generate-doFillAction-body"/>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="dialog" mode="generate-doFillAction-body">
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		((AbstractMMActivity)this.getOwnerActivity()).launchAction(GenericLoadDataForDisplayDetailAction.class, oInDisplayParameter);
	</xsl:template>


	<xsl:template match="page[in-workspace='false' and in-multi-panel='true' and viewmodel/dataloader-impl]" mode="generate-doFillAction-body">
		LoadDataForMultipleDisplayDetailActionParameter oMultipleDisplayParameter = new LoadDataForMultipleDisplayDetailActionParameter();
		<xsl:if test="parameters/parameter[@name='grid-column-parameter'] = '1' and viewmodel/dataloader-impl">
				<xsl:variable name="dataloaderName" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
				<xsl:if test="count(preceding-sibling::page[viewmodel/dataloader-impl/implements/interface/@name=$dataloaderName]) = 0 and $dataloaderName">
					oMultipleDisplayParameter.addDisplayParameter(
					new InDisplayParameter(this.getActivity().getIntent().getStringExtra(IDENTIFIER_CACHE_KEY),
					<xsl:value-of select="$dataloaderName"/>.class));
				</xsl:if>
		</xsl:if>
		this.launchAction(LoadDataForMultipleDisplayDetailAction.class, oMultipleDisplayParameter);
	</xsl:template>


	<xsl:template match="page[viewmodel/multiInstance='true']" mode="generate-doFillAction-body">
		<xsl:if test=" ./viewmodel/dataloader-impl/implements/interface/@name">
			InDisplayParameter oInDisplayParameter = new InDisplayParameter();
			oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
					oInDisplayParameter.setId( "-1" );
					oInDisplayParameter.setKey(this.getFragmentViewModel().getKey());
			this.launchAction(GenericLoadDataForDisplayDetailAction.class, oInDisplayParameter);
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="page[in-workspace='true' and parameters/parameter[@name='workspace-panel-type'] = 'detail' and parameters/parameter[@name='grid-column-parameter'] = '1' and parameters/parameter[@name='grid-section-parameter'] = '1']" 
		mode="generate-doFillAction-body">
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader(<xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class);
		oInDisplayParameter.setId(this.getActivity().getIntent().getStringExtra(IDENTIFIER_CACHE_KEY));
		this.launchAction(GenericLoadDataForDisplayDetailAction.class, oInDisplayParameter);
	
	</xsl:template>
	
	
	<xsl:template match="page[parameters/parameter[@name='workspace-panel-type'] = 'master' and parameters/parameter[@name='grid-column-parameter'] = '1']" 
		mode="generate-doFillAction-body">	
		<!-- dataloader for first list -->
		LoadDataForMultipleDisplayDetailActionParameter oMultipleDisplayParameter 
			= new LoadDataForMultipleDisplayDetailActionParameter();
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getActivity().getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);

		<!-- dataloader for other lists (tabs) -->		
		<xsl:for-each select="../page[parameters/parameter[@name='workspace-panel-type'] = 'master' and parameters/parameter[@name='grid-column-parameter'] != '1']">
			<xsl:sort select="parameters/parameter[@name='grid-column-parameter']"/>
		oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getActivity().getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);		
		</xsl:for-each>
		
		this.launchAction(LoadDataForMultipleDisplayDetailAction.class, oMultipleDisplayParameter);		
	</xsl:template>
	
	
	<xsl:template match="page[is-tabs-master='true']" mode="generate-doFillAction-body">	
		LoadDataForMultipleDisplayDetailActionParameter oMultipleDisplayParameter = new LoadDataForMultipleDisplayDetailActionParameter();
		
		<xsl:for-each select="./tabs/page[parameters/parameter[@name='workspace-panel-type'] = 'master']">
			<xsl:sort select="parameters/parameter[@name='grid-column-parameter']"/>
			<xsl:choose>
				<xsl:when test="position() = 1">
					InDisplayParameter oInDisplayParameter = new InDisplayParameter();
				</xsl:when>
				<xsl:otherwise>
					oInDisplayParameter = new InDisplayParameter();
				</xsl:otherwise>
			</xsl:choose>
			oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
			oInDisplayParameter.setId( this.getActivity().getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
			oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);
		</xsl:for-each>
		
		this.launchAction(LoadDataForMultipleDisplayDetailAction.class, oMultipleDisplayParameter);		
	</xsl:template>
	
	
	<xsl:template match="page[not(name(..)) and ./viewmodel/multiInstance='true']" mode="generate-doFillAction-body">
		<xsl:if test=" ./viewmodel/dataloader-impl/implements/interface/@name">
			InDisplayParameter oInDisplayParameter = new InDisplayParameter();
			oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
			oInDisplayParameter.setId( this.getActivity().getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
			this.launchAction(GenericLoadDataForDisplayDetailAction.class, oInDisplayParameter);
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="page" mode="generate-doFillAction-body">
	</xsl:template>

	<xsl:template match="adapter" mode="generate-adapter-registration">
		<xsl:param name="adapterName"/>
		<xsl:param name="position"/>
		<xsl:text>oActionParameter</xsl:text><xsl:value-of select="$position"/><xsl:text>.addAdapter(</xsl:text><xsl:value-of select="$adapterName"/>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>