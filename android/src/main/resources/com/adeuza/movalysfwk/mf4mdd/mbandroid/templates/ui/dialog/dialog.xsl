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

<xsl:include href="import.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/class.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/page/common-page-methods.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/page/onDataloaderReload.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/adapter/constructor.xsl" />

<xsl:output method="text" />

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="dialog">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	<xsl:template match="dialog" mode="superclass">
		<xsl:text>AbstractAutoBindMMDialogFragment</xsl:text>
	</xsl:template>

	<!-- INTERFACES ................................................................................................. -->

	<xsl:template match="dialog" mode="declare-extra-implements">
		<interface>OnClickListener</interface>
	</xsl:template>

	<!-- CONSTRUCTORS ............................................................................................... -->

	<xsl:template match="dialog" mode="constructors">
	public <xsl:value-of select="name"/>(ConfigurableVisualComponent p_oParent) {
		super(p_oParent);
	}
	</xsl:template>
	
	<!--ATTRIBUTES ............................................................................................... -->

	<xsl:template match="dialog" mode="attributes">
		<xsl:for-each select="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']">
			<xsl:text>private MMSpinner spinnerAdapter</xsl:text><xsl:value-of select="position()"/>
			<xsl:text> = null;&#13;</xsl:text>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="dialog" mode="methods">
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void onViewCreated(View view, Bundle savedInstanceState) {
		super.onViewCreated(view, savedInstanceState);

		View oButton = null;
		<xsl:for-each select="layout/visualfields/visualfield[component='com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton' or component='com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton']">
			<xsl:text>oButton = (View) view.findViewById(R.id.</xsl:text><xsl:value-of select="name"/><xsl:text>);&#13;</xsl:text>
			<xsl:text>oButton.setOnClickListener(this);&#13;&#13;</xsl:text>
		</xsl:for-each>
		
		<xsl:for-each select="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']">
			<xsl:text>this.spinnerAdapter</xsl:text><xsl:value-of select="position()"/>
			<xsl:text> = (MMSpinner) view.findViewById(R.id.</xsl:text><xsl:value-of select="./@component-ref"/><xsl:text>);&#13;</xsl:text>
			<xsl:value-of select="./name"/><xsl:text> adapter</xsl:text><xsl:value-of select="position()"/><xsl:text> = new </xsl:text><xsl:value-of select="./name"/>
			<xsl:text>(</xsl:text>
			<xsl:apply-templates select="." mode="constructor-parameters">
			</xsl:apply-templates>
			<xsl:text>, true);&#13;</xsl:text>
			<xsl:text>MDKViewConnectorWrapper mConnectorWrapper = WidgetWrapperHelper.getInstance().getConnectorWrapper(spinnerAdapter</xsl:text>
			<xsl:value-of select="position()"/><xsl:text>.getClass());&#13;</xsl:text>
			<xsl:text>mConnectorWrapper.configure((MDKBaseAdapter) adapter</xsl:text><xsl:value-of select="position()"/><xsl:text>, spinnerAdapter</xsl:text>
			<xsl:value-of select="position()"/><xsl:text>);&#13;</xsl:text>
		</xsl:for-each>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">on-view-created</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
	}

	<xsl:apply-templates select="." mode="generate-load-or-update-methods"/>

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMDialog#createViewModel()
	 */
	public <xsl:value-of select="viewmodel-interface/name"/> createViewModel() {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">create-view-model</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="." mode="generate-viewmodel-creation"/>
			</xsl:with-param>
		</xsl:call-template>
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractAutoBindMMActivity#getViewId()
	 */
	@Override
	public int getViewId() {
		return R.layout.<xsl:value-of select="dialogname"/>;
	}
	
	/**
	 * {@inheritDoc}
	 * @see android.view.View.OnClickListener#onClick(android.view.View)
	 */
	@Override
	public void onClick(View p_oParamView) {

		switch (p_oParamView.getId()) {
		<xsl:for-each select="layout/visualfields/visualfield[component='com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMButton' or component='com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMImageButton']">
			case R.id.<xsl:value-of select="name"/>:
				<xsl:if test="parameters/parameter[@name='type'] = 'Validate'">
					<xsl:text>this.doSearch();</xsl:text>
				</xsl:if>
				<xsl:if test="parameters/parameter[@name='type'] = 'Reset'">
					<xsl:text>this.doReset();</xsl:text>
				</xsl:if>
				<xsl:if test="parameters/parameter[@name='type'] = 'Cancel'">
					<xsl:text>this.cancel();</xsl:text>
				</xsl:if>
				break;
		</xsl:for-each>
		}
	}
	
	/**
	 * Do Cancel
	 */
	private void cancel() {
		this.dismiss();
	}
	
	/**
	 * Do Reset : used to reset the search criteria
	 */
	protected void doReset() {
		final <xsl:value-of select="viewmodel-creator/name"/>
		<xsl:text> oCreator = (</xsl:text>
		<xsl:value-of select="viewmodel-creator/name"/>) Application.getInstance().getViewModelCreator();

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">create-doReset</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<!-- MF_DEV_MANDATORY implements the reset of the search criteria-->
				<xsl:apply-templates select="." mode="generate-doReset"/>
			</xsl:with-param>
		</xsl:call-template>

		this.dismiss();
		((AbstractInflateMMFragment)this.getPanelParentFragment()).doFillAction();
	}

	/**
	 * Do search
	 */
	protected void doSearch() {
		final <xsl:value-of select="viewmodel-creator/name"/>
		<xsl:text> oCreator = (</xsl:text>
		<xsl:value-of select="viewmodel-creator/name"/>) Application.getInstance().getViewModelCreator();

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">create-doSearch</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="." mode="generate-doSearch"/>
			</xsl:with-param>
		</xsl:call-template>
		
		this.dismiss();
		((AbstractInflateMMFragment)this.getPanelParentFragment()).doFillAction();
	}
	

	/**
	 * Get the OwnerActivity of this DialogFragment
	 * @return the {@link AbstractAutoBindMMActivity} owner of this DialogFragment
	 */
	private AbstractAutoBindMMActivity getOwnerActivity() {
		AbstractAutoBindMMActivity oOwnerActivity = null;
		oOwnerActivity = (AbstractAutoBindMMActivity) this.getParentActivity().get();

		return oOwnerActivity;
	}
	
	/**
	 * Get the get the parent fragment of this DialogFragment
	 * @return the {@link Fragment} parent of this DialogFragment
	 */
	private Fragment getPanelParentFragment() {
		return getOwnerActivity().getSupportFragmentManager().findFragmentByTag(this.componentFragmentTag);
	}
</xsl:template>

<!-- Template for viewmodel creation with transient entity -->
<xsl:template match="dialog[class/transient='true']" mode="generate-viewmodel-creation">
	final <xsl:value-of select="viewmodel-creator/name"/> oCreator = (<xsl:value-of select="viewmodel-creator/name"/>
	<xsl:text>) Application.getInstance().getViewModelCreator();&#13;</xsl:text>
	return oCreator.create<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>();&#13;</xsl:text>
</xsl:template>


<!-- Template for viewmodel creation with non transient entity -->
<xsl:template match="dialog[class/transient='false']" mode="generate-doReset">
	<!-- TODO: -->
	return null ;
</xsl:template>

<!-- Template for search with transient entity -->
<xsl:template match="dialog[class/transient='true']" mode="generate-doReset">
	<xsl:text>final </xsl:text>
	<xsl:value-of select="class/implements/interface/@name"/>
	<xsl:text> o</xsl:text>
	<xsl:value-of select="class/implements/interface/@name"/>
	<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
	<xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>
	<xsl:text>.class).getData(</xsl:text>
	<xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>
	<xsl:text>.DEFAULT_KEY);&#13;</xsl:text>

	<xsl:text>final </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text> o</xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text> = oCreator.getViewModel(</xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>.class);&#13;</xsl:text>

	<xsl:variable name="ViewModel">
		<xsl:text> o</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/>
	</xsl:variable>
	if (<xsl:value-of select="$ViewModel"/> != null) {
		<xsl:value-of select="$ViewModel"/>.clear();
		<!--ABE <xsl:value-of select="$ViewModel"/>.writeData( null ); -->
		<xsl:value-of select="$ViewModel"/><xsl:text>.modifyToIdentifiable(</xsl:text>
		o<xsl:value-of select="class/implements/interface/@name"/>);
	}
</xsl:template>

<!-- Template for search with transient entity -->
<xsl:template match="dialog[class/transient='true']" mode="generate-doSearch">
	<xsl:text>final </xsl:text>
	<xsl:value-of select="class/implements/interface/@name"/>
	<xsl:text> o</xsl:text>
	<xsl:value-of select="class/implements/interface/@name"/>
	<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
	<xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>
	<xsl:text>.class).getData(</xsl:text>
	<xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>
	<xsl:text>.DEFAULT_KEY);&#13;</xsl:text>

	<xsl:text>final </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text> o</xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text> = oCreator.getViewModel(</xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>.class);&#13;</xsl:text>

	if (<xsl:text> o</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/> != null) {
		Map&lt;String, Object&gt; map = new HashMap&lt;String, Object&gt;();
		<xsl:text> o</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/>.validComponents(null, map);
		<xsl:text> o</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/>
		<xsl:text>.modifyToIdentifiable(</xsl:text>
		o<xsl:value-of select="class/implements/interface/@name"/>);
	}
</xsl:template>


<!-- Template for search with non transient entity -->
<xsl:template match="dialog[class/transient='false']" mode="generate-doSearch">
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="constructor-parameters">
	<xsl:text>((</xsl:text>
	<xsl:value-of select="./viewmodel/parent-viewmodel/master-interface/@name"/>
	<xsl:text>)this.getViewModel()).</xsl:text>
	<xsl:value-of select="./viewmodel/list-accessor-get-name"/>
	<xsl:text>(), </xsl:text>
	<xsl:apply-templates select="." mode="generate-super-constructor-parameters"/>
</xsl:template>

</xsl:stylesheet>
