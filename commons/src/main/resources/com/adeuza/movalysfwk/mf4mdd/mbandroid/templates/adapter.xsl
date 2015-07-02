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

<xsl:include href="ui/adapter/import.xsl" />
<xsl:include href="ui/adapter/class-parameter-types.xsl" />
<xsl:include href="ui/adapter/constructor.xsl" />
<xsl:include href="includes/class.xsl"/>

<xsl:output method="text"/>

<!--
Root template 
-->
<xsl:template match="adapter">
	<xsl:apply-templates select="." mode="declare-class" />
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_2' or viewmodel/type/name='LIST_3']" mode="declare-extra-imports">
	<import><xsl:value-of select="master-package"/>.R</import>
	<import>android.widget.ExpandableListView</import>
	<import>android.widget.ExpandableListView.OnChildClickListener</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.ConfigurableListViewHolder</import>
	<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPerformItemClickListener</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPerformItemClickView</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPerformItemClickEventData</import>	
	<xsl:apply-templates select="." mode="generate-imports"/>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.PerformItemClickEvent</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.SelectedItemEvent</import>
</xsl:template>

<xsl:template match="adapter" mode="declare-extra-imports">
	<import><xsl:value-of select="master-package"/>.R</import>
	<import>android.widget.AdapterView</import>
	<xsl:choose>
		<xsl:when test="./viewmodel/type/name='LIST_1'">
			<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMOnItemClickListener</import>
		</xsl:when>
		<xsl:otherwise>
			<import>android.widget.AdapterView.OnItemClickListener</import>
		</xsl:otherwise>
	</xsl:choose>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.ConfigurableListViewHolder</import>
	<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPerformItemClickListener</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPerformItemClickView</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMPerformItemClickEventData</import>
	<xsl:apply-templates select="." mode="generate-imports"/>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.PerformItemClickEvent</import>
	<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.SelectedItemEvent</import>
</xsl:template>



<xsl:template match="adapter" mode="superclass">
	<xsl:value-of select="./short-adapter" />
	<xsl:text>&lt;</xsl:text>
	<xsl:apply-templates select="." mode="generate-parameter-types"/>
	<xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_1']"  
		mode="declare-extra-implements">
	<interface>MMOnItemClickListener</interface>
	<interface>MMPerformItemClickListener</interface>
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_2']"  
		mode="declare-extra-implements">
	<interface>OnChildClickListener</interface>
	<interface>MMPerformItemClickListener</interface>
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_3']"  
		mode="declare-extra-implements">
	<interface>OnChildClickListener</interface>
	<interface>MMPerformItemClickListener</interface>
</xsl:template>

<xsl:template match="adapter" mode="interfaces"/>

<xsl:template match="adapter" mode="methods" >
	<xsl:call-template name="adapterConstructor"/>
	<xsl:apply-templates select="." mode="generate-extra-methods"/>
</xsl:template>

<!-- >>>>> TEMPLATES DEDIES A LA GENERATION (FONCTION DE L'ADAPTEUR) -->

<xsl:template match="adapter[viewmodel/type/name='LIST_1']" mode="generate-extra-methods">
	<xsl:apply-templates select="." mode="generate-wrap-method"/>
	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean onPerformItemClick(View p_oView, int p_iPosition, long p_lId, MMPerformItemClickView p_oListView) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onPerformItemClick</xsl:with-param>
			<xsl:with-param name="defaultSource">
				Application.getInstance().getController().publishBusinessEvent(null,
						new PerformItemClickEvent(this, ((ConfigurableListViewHolder) p_oView.getTag()).getViewModelID(), p_oView, p_iPosition, p_lId, p_oListView));
				return false;
			</xsl:with-param>
		</xsl:call-template>
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void onItemClick(View p_oView, int p_iPosition, long p_iId, MMPerformItemClickView p_oListView,
			ConfigurableListViewHolder p_oViewHolder) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onItemClick</xsl:with-param>
			<xsl:with-param name="defaultSource">
				Application.getInstance().getController().publishBusinessEvent(null,
					new SelectedItemEvent(this, p_oViewHolder.getViewModelID()));
			</xsl:with-param>
		</xsl:call-template>
	}
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_2']" mode="generate-extra-methods">
	<xsl:apply-templates select="." mode="generate-wrap-method"/>
	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean onPerformItemClick(View p_oView, int p_iPosition, long p_lId, MMPerformItemClickView p_oListView) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onPerformItemClick</xsl:with-param>
			<xsl:with-param name="defaultSource">
				if (p_oView.getTag() != null) {
					String sViewModelId = ((ConfigurableListViewHolder) p_oView.getTag()).getViewModelID();
					Application.getInstance().getController().publishBusinessEvent(null,
							new PerformItemClickEvent(this, sViewModelId, p_oView, p_iPosition, p_lId, p_oListView));
					return false;
				}
				return true;
			</xsl:with-param>
		</xsl:call-template>
	}	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean onChildClick(ExpandableListView p_oParent, View p_oParamView, int p_iGroupPosition, int p_iChildPosition, long p_lId) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onChildClick</xsl:with-param>
			<xsl:with-param name="defaultSource">
			Application.getInstance().getController().publishBusinessEvent(null, new SelectedItemEvent(this,
			((ConfigurableListViewHolder) p_oParamView.getTag()).getViewModelID()));
			return true;
			</xsl:with-param>
		</xsl:call-template>
	}
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name='LIST_3']" mode="generate-extra-methods">
	<xsl:apply-templates select="." mode="generate-wrap-method"/>
	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean onPerformItemClick(View p_oView, int p_iPosition, long p_lId, MMPerformItemClickView p_oListView) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onPerformItemClick</xsl:with-param>
			<xsl:with-param name="defaultSource">
				if (p_oView.getTag() != null) {
					String sViewModelId = ((ConfigurableListViewHolder) p_oView.getTag()).getViewModelID();
					Application.getInstance().getController().publishBusinessEvent(null,
							new PerformItemClickEvent(this, sViewModelId, p_oView, p_iPosition, p_lId, p_oListView));
					return false;
				}
				return true;
			</xsl:with-param>
		</xsl:call-template>
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean onChildClick(ExpandableListView p_oParent, View p_oParamView, int p_iGroupPosition, int p_iChildPosition, long p_lId) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onChildClick</xsl:with-param>
			<xsl:with-param name="defaultSource">
			Application.getInstance().getController().publishBusinessEvent(null, new SelectedItemEvent(this, ((ConfigurableListViewHolder) p_oParamView.getTag()).getViewModelID()));
			
			return true;
			</xsl:with-param>
		</xsl:call-template>
	}
</xsl:template>

<xsl:template match="adapter[navigation/action/action-type='DISPLAYDETAIL' and viewmodel/type/name = 'LIST_2' and viewmodel/type/conf-name = 'multiselect']" mode="generate-extra-methods">
	/**
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void postBindChildView(View p_oView, </xsl:text> 
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text> p_oCurrentViewModel, int p_iParamGroupPosition, int p_iParamChildPosition) {&#13;</xsl:text>
	<xsl:text>super.postBindChildView(p_oView, p_oCurrentViewModel, p_iParamGroupPosition, p_iParamChildPosition);&#13;</xsl:text>
	<xsl:text>//@non-generated-start[postBindChildView]&#13;</xsl:text>
	<xsl:text>//@non-generated-end</xsl:text>
	}
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name = 'LIST_3']" mode="generate-wrap-method">
	/**
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void postBindChildView(View p_oView,</xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/> 
	<xsl:text> p_oCurrentViewModel,	int p_iParamGroupPosition, int p_iParamChildPosition) {&#13;</xsl:text>
	<xsl:text>super.postBindChildView(p_oView, p_oCurrentViewModel, p_iParamGroupPosition, p_iParamChildPosition);&#13;</xsl:text>
	<xsl:text>//@non-generated-start[postBindChildView]&#13;</xsl:text>
	<xsl:value-of select="non-generated/bloc[@id='wrapCurrentChildView']"/>
	<xsl:text>//@non-generated-end&#13;</xsl:text>
	}
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name = 'LIST_2' and viewmodel/type/conf-name != 'multiselect'] " mode="generate-wrap-method">
	/**
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void postBindChildView(View p_oView, </xsl:text> 
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text> p_oCurrentViewModel, int p_iParamGroupPosition, int p_iParamChildPosition) {&#13;</xsl:text>
	<xsl:text>super.postBindChildView(p_oView, p_oCurrentViewModel, p_iParamGroupPosition, p_iParamChildPosition);&#13;</xsl:text>
	<xsl:text>//@non-generated-start[postBindChildView]&#13;</xsl:text>
	<xsl:value-of select="non-generated/bloc[@id='postBindChildView']"/>
	<xsl:text>//@non-generated-end</xsl:text>
	}
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name = 'LIST_2' and viewmodel/type/conf-name = 'multiselect'] " mode="generate-wrap-method">
	/**
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void postBindChildView(View p_oView, </xsl:text> 
	<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text> p_oCurrentViewModel, int p_iParamGroupPosition, int p_iParamChildPosition) {&#13;</xsl:text>
	<xsl:text>super.postBindChildView(p_oView, p_oCurrentViewModel, p_iParamGroupPosition, p_iParamChildPosition);&#13;</xsl:text>
	<xsl:text>//@non-generated-start[postBindChildView]&#13;</xsl:text>
	<xsl:value-of select="non-generated/bloc[@id='postBindChildView']"/>
	<xsl:text>//@non-generated-end</xsl:text>
	}
</xsl:template>

<xsl:template match="adapter[viewmodel/type/name = 'LIST_1']" mode="generate-wrap-method">
	/**
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void postInflate(MDKAdapter&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>,
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt; p_oAdapter, View p_oCurrentRow, boolean b_isExpanded) {&#13;</xsl:text>
	<xsl:text>super.postInflate(p_oAdapter, p_oCurrentRow, b_isExpanded);&#13;</xsl:text>
	<xsl:text>//@non-generated-start[postInflate]&#13;</xsl:text>
	<xsl:value-of select="non-generated/bloc[@id='postInflate']"/>
	<xsl:text>//@non-generated-end</xsl:text>
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void postBind(MDKAdapter&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/>,
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>,
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt; p_oAdapter, View p_oCurrentRow, </xsl:text>
	<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
	<xsl:text> p_oCurrentVM, boolean b_isExpanded, int... p_oPositions) {&#13;</xsl:text>
	<xsl:text>super.postBind(p_oAdapter, p_oCurrentRow, p_oCurrentVM, b_isExpanded, p_oPositions);&#13;</xsl:text>
	<xsl:text>//@non-generated-start[postBind]&#13;</xsl:text>
	<xsl:value-of select="non-generated/bloc[@id='postBind']"/>
	<xsl:text>//@non-generated-end</xsl:text>
	}
</xsl:template>

<xsl:template match="adapter[short-adapter='AbstractConfigurableFixedListAdapter']" mode="generate-extra-methods">
	/**
	 * {@inheritDoc}
	 */
	@Override
	public <xsl:value-of select="viewmodel/implements/interface/@name"/> createEmptyVM() {
		ViewModelCreator oCreator = (ViewModelCreator) Application.getInstance().getViewModelCreator();

		<xsl:value-of select="viewmodel/implements/interface/@name"/> r_oVm = oCreator.createOrUpdate<xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>(BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="viewmodel/entity-to-update/name"/>
		<xsl:text>Factory.class).createInstance());&#13;</xsl:text>
		r_oVm.setEditable(this.isViewModelEnabled(r_oVm));

		return r_oVm;
	}

	/**
	 * Checks if the view model sent in parameter is enabled
	 * @param p_oViewModel the view model to test
	 * @return true if the given view model is enabled
	 */
	public boolean isViewModelEnabled(<xsl:value-of select="viewmodel/implements/interface/@name"/> p_oViewModel) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">method-viewmodel-enabled</xsl:with-param>
			<xsl:with-param name="defaultSource">
			//MF_DEV_MANDATORY Change select ...
			return <xsl:value-of select="not(viewmodel/read-only = 'true')"/>;
			</xsl:with-param>
		</xsl:call-template>
	}
</xsl:template>

<xsl:template match="adapter" mode="generate-extra-methods"/>

<xsl:template match="adapter[viewmodel/type/name='LIST_1' or viewmodel/type/name='LIST_2' or viewmodel/type/name='LIST_3']" mode="inner-classes"/>

</xsl:stylesheet>
