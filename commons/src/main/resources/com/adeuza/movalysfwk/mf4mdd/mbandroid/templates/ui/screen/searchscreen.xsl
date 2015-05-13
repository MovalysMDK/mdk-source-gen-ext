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

	<!-- *****************************************************************************************
											SUPERCLASS
	***************************************************************************************** -->

	<xsl:template match="screen[search-screen='true']" mode="superclass">
		<xsl:text>AbstractSearchAutoBindMMActivity</xsl:text>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="pages/page/dialogs/dialog/class/implements/interface/@name"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="pages/page/viewmodel/entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="screen[search-screen='true']" mode="superclass-import">
		<import>android.app.Dialog</import>
		<import>android.widget.ListAdapter</import>
		<import>android.view.View</import>
		<import>android.content.DialogInterface</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ItemViewModel</import>	
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.BusinessEvent</import>
		<import><xsl:value-of select="pages/page/dialogs/dialog/class/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="pages/page/dialogs/dialog/viewmodel/implements/interface/@full-name"/></import>
		<import><xsl:value-of select="pages/page/viewmodel/entity-to-update/full-name"/></import>
		<import><xsl:value-of select="pages/page/dialogs/dialog/viewmodel/dataloader-impl/implements/interface/@full-name"/></import>
		
		
		<xsl:apply-templates select="pages/page/dialogs/dialog/external-adapters/adapter/full-name" mode="declare-import"/>
		<xsl:if test="pages/page/dialogs/dialog/external-adapters/adapter[short-adapter='AbstractConfigurableSpinnerAdapter' and viewmodel/type/component-name='MMSpinner']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.abstractviews.MMSpinnerAdapterHolder</import>
		</xsl:if>

		<xsl:if test="pages/page/dialogs/dialog/external-adapters/adapter[short-adapter='AbstractConfigurableSpinnerAdapter' and viewmodel/type/component-name='MMSearchSpinner']">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.abstractviews.MMSpinnerAdapterHolder</import>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="screen[search-screen='true']" mode="attributes">
		
		<xsl:apply-templates select="." mode="requestCodeConstant"/>
		
		<xsl:apply-templates select="pages/page[@pos='1']/adapter" mode="attributes"/>
		<xsl:apply-templates select="pages/page/external-adapters/adapter" mode="attributes"/>
		
		<xsl:apply-templates select="pages/page[@pos='1']/dialogs/dialog/adapter" mode="attributes"/>
		<xsl:apply-templates select="pages/page/dialogs/dialog/external-adapters/adapter" mode="attributes"/>
	</xsl:template>

	<xsl:template match="screen[search-screen='true']" mode="methods">
		<xsl:variable name="nbPages" select="count(pages/page)"/>
		<xsl:variable name="condition" select="boolean($nbPages = 1)"/>
		<xsl:variable name="panel" select="self::node()[not($condition)] | pages/page[$condition]"/>

		<xsl:apply-templates select="pages/page" mode="customInit-method"/>

		<xsl:apply-templates select="pages/page" mode="doOnReload-method"/>
		<xsl:apply-templates select="pages/page/dialogs/dialog" mode="doOnReload-method">
			<xsl:with-param name="launchFrom">page</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="$panel" mode="createViewModel-method"/>
		<xsl:apply-templates select="$panel" mode="createCriteriaViewModel-method"/>
		<xsl:apply-templates select="$panel" mode="createListAdapter-method"/>
		<xsl:apply-templates select="$panel" mode="createResourceGetters-method"/>
		<xsl:apply-templates select="$panel" mode="loaderClassGetter-method"/>
		<xsl:apply-templates select="$panel" mode="getSelectedItemEvent-method"/>
		
		<xsl:apply-templates select="$panel" mode="onDismiss-method"/>
		
		<!-- Appel au template de génération des méthodes spécifiques au type d'écran: workspace, liste, etc. -->
		<xsl:apply-templates select="$panel" mode="extra-methods"/>
		
	</xsl:template>

	<xsl:template match="page" mode="createListAdapter-method">
	/**
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#createListAdapter()
	 */
	@Override
	protected ListAdapter createListAdapter() {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">createListAdapter</xsl:with-param>
			<xsl:with-param name="defaultSource">
				this.adapter = new <xsl:value-of select="adapter/name"/>
				<xsl:text>(((</xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>)
				<xsl:text> this.getViewModel()));&#13;</xsl:text>
				return this.adapter ;
			</xsl:with-param>
		</xsl:call-template>
	}
	</xsl:template>
	
	<xsl:template match="page" mode="createCriteriaViewModel-method">
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMDialogFragment#createViewModel()
	 */
	@Override
	public ItemViewModel&lt;<xsl:value-of select="dialogs/dialog/class/implements/interface/@name"/>
		<xsl:text>&gt; createCriteriaViewModel() {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">createCriteriaViewModel</xsl:with-param>
			<xsl:with-param name="defaultSource">
				final ViewModelCreator oCreator = (ViewModelCreator) Application.getInstance().getViewModelCreator();
				return oCreator.create<xsl:value-of select="dialogs/dialog/viewmodel-interface/name"/>();
			</xsl:with-param>
		</xsl:call-template>
	}
	</xsl:template>

	<xsl:template match="page" mode="createResourceGetters-method">
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getCriteriaViewId()
	 */
	@Override
	protected int getCriteriaLayoutId() {
		return R.layout.<xsl:value-of select="dialogs/dialog/layout-pagename"/>;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getCriteriaViewId()
	 */
	@Override
	protected int getCriteriaComponentId() {
		return R.id.<xsl:value-of select="dialogs/dialog/layout-pagename"/>;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getListViewId()
	 */
	@Override
	protected int getResultLayoutId() {
		return R.layout.<xsl:value-of select="layout-pagename"/>;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getListViewId()
	 */
	@Override
	protected int getListViewId() {
		return R.id.<xsl:value-of select="mastercomponentname"/>;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getShowCriteriaButtonId()
	 */
	@Override
	protected int getShowCriteriaButtonId() {
		return R.id.buttonDisplay<xsl:value-of select="../../name"/>SearchDialog;
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getCancelSearchButtonId()
	 */
	@Override
	protected int getCancelSearchButtonId() {
		return R.id.button<xsl:value-of select="../../name"/>CancelSearchDialog;
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getResetSearchButtonId()
	 */
	@Override
	protected int getResetSearchButtonId() {
		return R.id.button<xsl:value-of select="../../name"/>ResetSearchDialog;
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getDoSearchButtonId()
	 */
	@Override
	protected int getDoSearchButtonId() {
		return R.id.button<xsl:value-of select="../../name"/>ValidateSearchDialog;
	}
	
	</xsl:template>
	
	<xsl:template match="page" mode="loaderClassGetter-method">
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getCriteriaLoaderClass()
	 */
	@Override
	protected Class&lt;<xsl:value-of select="dialogs/dialog/viewmodel/dataloader-impl/implements/interface/@name"/>&gt; getCriteriaLoaderClass() {
		return <xsl:value-of select="dialogs/dialog/viewmodel/dataloader-impl/implements/interface/@name"/>.class;
	}
	
	/** 
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getCriteriaLoaderClass()
	 */
	@Override
	protected Class&lt;<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>&gt; getResultLoaderClass() {
		return <xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.class;
	}
	</xsl:template>
	
	<xsl:template match="page" mode="getSelectedItemEvent-method">
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#getSelectedItemEventClass()
	 */
	@Override
	protected Class&lt;? extends BusinessEvent&lt;?&gt;&gt; getSelectedItemEventClass() {
		return <xsl:value-of select="adapter/name"/>.SelectedItemEvent.class;
	}
	</xsl:template>

	<xsl:template match="page" mode="customInit-method">
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#customInitCriteriaPanel()
	 */
	@Override
	protected void customInitCriteriaPanel( View p_oCriteriaView ) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">customInitCriteriaPanel</xsl:with-param>
			<xsl:with-param name="defaultSource">
			if ( !this.isCriteriaAsDialog()) {
				<xsl:apply-templates select="dialogs/dialog/external-adapters/adapter" mode="customInitDialogAdapter-method">
					<xsl:with-param name="viewGroup">p_oCriteriaView</xsl:with-param>
				</xsl:apply-templates>
			}
			</xsl:with-param>
		</xsl:call-template>
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#customInitCriteriaDialog(android.app.Dialog)
	 */
	@Override
	protected void customInitCriteriaDialog(Dialog p_oCriteriaDialog) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">customInitCriteriaPanel</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="dialogs/dialog/external-adapters/adapter" mode="customInitDialogAdapter-method">
					<xsl:with-param name="viewGroup">p_oCriteriaDialog</xsl:with-param>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	}
	</xsl:template>

	<xsl:template match="dialogs/dialog/external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" 
		mode="customInitDialogAdapter-method">
		<xsl:param name="viewGroup">this</xsl:param>
		<xsl:variable name="vm-name" select="viewmodel/implements/interface/@full-name"/>
		<xsl:if test="not(../adapter/viewmodel/external-lists/external-list/viewmodel[implements/interface/@full-name=$vm-name])">
			this.spinner<xsl:value-of select="position()"/> = (<xsl:apply-templates select="viewmodel" mode="doAfterSetContentView-method"/>
			<xsl:text>) </xsl:text><xsl:value-of select="$viewGroup"/><xsl:text>.findViewById(R.id.</xsl:text><xsl:value-of select="@component-ref"/>);
			this.spinnerAdapter<xsl:value-of select="position()"/> = new <xsl:value-of select="name"/><xsl:text>(</xsl:text>
			<xsl:apply-templates select="." mode="dialog-adapter-constructor-parameters">
				<xsl:with-param name="position" select="position()"/>
			</xsl:apply-templates>
			<xsl:text>, true);&#13;</xsl:text>
			this.spinner<xsl:value-of select="position()"/>.setAdapter(this.spinnerAdapter<xsl:value-of select="position()"/>);
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="dialogs/dialog/external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']"
		mode="dialog-adapter-constructor-parameters">
		<xsl:apply-templates select="ancestor::dialog" mode="get-dialog-vm"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="viewmodel/list-accessor-get-name"/>
		<xsl:text>()</xsl:text>
	</xsl:template>

	<xsl:template match="dialogs/dialog/external-adapters/adapter[viewmodel/type/name='FIXED_LIST']"
		mode="dialog-adapter-constructor-parameters"/>
	
	<xsl:template match="screen[workspace='false']/pages/page/dialogs/dialog" mode="get-dialog-vm">
		<xsl:text>((</xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>) this.getCriteriaViewModel())</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="page" mode="onDismiss-method">
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractSearchAutoBindMMActivity#onDismiss()
	 */
	@Override
	public void onDismiss(DialogInterface p_oDialogInterface) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onDismiss</xsl:with-param>
			<xsl:with-param name="defaultSource">
			</xsl:with-param>
		</xsl:call-template>
	}
	</xsl:template>

</xsl:stylesheet>