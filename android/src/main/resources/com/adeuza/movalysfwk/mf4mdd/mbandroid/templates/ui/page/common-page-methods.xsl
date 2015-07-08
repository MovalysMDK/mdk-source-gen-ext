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

	<xsl:template match="page" mode="generate-doFillAction-body">
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		this.launchAction(GenericLoadDataForDisplayDetailAction.class, oInDisplayParameter);
	</xsl:template>

	<xsl:template match="page[not(name(..))]" mode="generate-doFillAction-body">
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( "-1" );
		<xsl:if test="./viewmodel/multiInstance='true'">
			oInDisplayParameter.setKey(this.getFragmentViewModel().getKey());
		</xsl:if>
		this.launchAction(GenericLoadDataForDisplayDetailAction.class, oInDisplayParameter);
	</xsl:template>

	<xsl:template match="adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="generate-adapter-registration">
		<xsl:param name="adapterName">this.spinnerAdapter<xsl:value-of select="position()"/></xsl:param>
		<xsl:param name="position"/>
		<xsl:text>oActionParameter</xsl:text><xsl:value-of select="$position"/><xsl:text>.addAdapter(</xsl:text><xsl:value-of select="$adapterName"/>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="adapter" mode="generate-adapter-registration">
		<xsl:param name="adapterName"/>
		<xsl:param name="position"/>
		<xsl:text>oActionParameter</xsl:text><xsl:value-of select="$position"/><xsl:text>.addAdapter(</xsl:text><xsl:value-of select="$adapterName"/>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>