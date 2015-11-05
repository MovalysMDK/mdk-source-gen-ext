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

	<xsl:output method="text"/>

	<xsl:template match="page" mode="doAfterInflate-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractAutoBindMMFragment#doAfterInflate(ViewGroup p_oRoot)
		 */
		@Override
		protected void doAfterInflate(ViewGroup p_oRoot) {
			super.doAfterInflate(p_oRoot);
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">do-after-inflate-1</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
			
			<xsl:apply-templates select="adapter" mode="doAfterInflate-method"/>
			<xsl:apply-templates select="external-adapters/adapter" mode="doAfterInflate-method"/>
			<xsl:apply-templates select="layout/visualfields" mode="doAfterInflate-method"/>

			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">do-after-inflate-2</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="page/adapter[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" mode="doAfterInflate-method">
		<!-- TODO : ajouter la gestion des external-lists (cf fixedlist, add-reference-to) -->
		<!-- viewmodel/subvm/viewmodel[type/name='LISTITEM_1']/external-lists -->
		<xsl:if test="/page/widget-variant='mdkwidget'">
			<xsl:if test="layouts/layout/buttons/button[@type='NAVIGATION']">
			p_oRoot.findViewById(R.id.fab).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">doOnFabClick</xsl:with-param>
					<xsl:with-param name="defaultSource">
						<xsl:text>Intent oIntent = new Intent(</xsl:text>
						<xsl:value-of select="/page/name"/>
						<xsl:text>.this.getActivity(), </xsl:text>
						<xsl:value-of select="layouts/layout/buttons/button[@type='NAVIGATION']/navigation/target/name"/>
						<xsl:text>.class);&#13;</xsl:text>
						<xsl:text>oIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);&#13;</xsl:text>
						<xsl:value-of select="/page/name"/>
						<xsl:text>.this.getActivity().startActivityForResult(oIntent, </xsl:text>
						<xsl:value-of select="layouts/layout/buttons/button[@type='NAVIGATION']/navigation/target/name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="layouts/layout/buttons/button[@type='NAVIGATION']/navigation/target/request-code"/>
						<xsl:text>);&#13;</xsl:text>
					</xsl:with-param>
	 			</xsl:call-template>
	 			}
			});
			</xsl:if>
		</xsl:if>
		
	</xsl:template>

	<!-- ##########################################################################################
											SPINNER
		########################################################################################## -->

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="doAfterInflate-method">
		<xsl:param name="viewGroup">p_oRoot</xsl:param>
		<xsl:variable name="vm-name" select="viewmodel/implements/interface/@full-name"/>
		<!-- TODO : a revoir ; cf doAfterInflate-method pour les LIST_1, LIST_2, LIST_3 -->
		<xsl:if test="not(../adapter/viewmodel/external-lists/external-list/viewmodel[implements/interface/@full-name=$vm-name])">
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">set-spinner-adapter<xsl:value-of select="position()"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>//Spinner of </xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>.&#13;</xsl:text>
					<xsl:apply-templates select="viewmodel" mode="doAfterInflate-method"/><xsl:text> oSpinner</xsl:text><xsl:value-of select="position()"/><xsl:text> = null;&#13;</xsl:text>
					<xsl:text>oSpinner</xsl:text><xsl:value-of select="position()"/><xsl:text> = (</xsl:text>
					<xsl:apply-templates select="viewmodel" mode="doAfterInflate-method"/>
					<xsl:text>) </xsl:text><xsl:value-of select="$viewGroup"/>
					<xsl:text>.findViewById(R.id.</xsl:text><xsl:value-of select="@component-ref"/>);
					if (oSpinner<xsl:value-of select="position()"/><xsl:text> != null) {&#13;</xsl:text>
					this.spinnerAdapter<xsl:value-of select="position()"/> = new <xsl:value-of select="name"/>
					<xsl:if test="name='ConfigurableSpinnerAdapter' or name='MDKSpinnerAdaper'">
						<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
						<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
						<xsl:text>, ListViewModel</xsl:text>
						<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
						<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
						<xsl:text>&gt;&gt;</xsl:text>
					</xsl:if>
					<xsl:text>(</xsl:text>
					<xsl:apply-templates select="." mode="constructor-parameters">
						<xsl:with-param name="position" select="position()"/>
					</xsl:apply-templates>
					<xsl:text>);&#13;</xsl:text>
					MDKViewConnectorWrapper mConnectorWrapper = WidgetWrapperHelper.getInstance().getConnectorWrapper(oSpinner<xsl:value-of select="position()"/>.getClass());
					mConnectorWrapper.configure((MDKBaseAdapter)this.spinnerAdapter<xsl:value-of select="position()"/>, oSpinner<xsl:value-of select="position()"/>);
					}
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="external-adapters/adapter/viewmodel[type/name='LIST_1__ONE_SELECTED' and type/component-name='MDKRichSpinner']" mode="doAfterInflate-method">
		<xsl:text>MDKRichSpinner</xsl:text>
	</xsl:template>
	
	<xsl:template match="external-adapters/adapter/viewmodel[type/name='LIST_1__ONE_SELECTED' and not(type/component-name='MDKRichSpinner')]" mode="doAfterInflate-method">
		<xsl:text>MMSpinner&lt;?,?&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="external-adapters/adapter/viewmodel[type/name='LIST_1__ONE_SELECTED' and type/conf-name='filter']" mode="doAfterInflate-method">
		<xsl:text>MMSearchSpinner&lt;?,?&gt;</xsl:text>
	</xsl:template>

	<!-- ##########################################################################################
											FIXED_LIST
		########################################################################################## -->

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='FIXED_LIST']" mode="doAfterInflate-method">
		<xsl:variable name="adapter-name">
			<xsl:text>fixedListAdapter</xsl:text>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:variable name="component-name">
			<xsl:text>oFixedList</xsl:text>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:variable name="vm" select="../../viewmodel-interface/name"/>

		<xsl:text>// FixedList of </xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>.&#13;</xsl:text>
		
		<xsl:choose>
			<xsl:when test="viewmodel/type/component-name='MMFixedListView' or viewmodel/type/component-name='MMPhotoFixedListView'">
				<xsl:text>MMAdaptableFixedListView&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="viewmodel/implements/interface/@name"/>
				<xsl:text>&gt; </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>MMRecyclableList </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$component-name"/>
		<xsl:text> = null;&#13;</xsl:text>

		<xsl:value-of select="$component-name"/>
		<xsl:text> = (</xsl:text>
		<xsl:choose>
			<xsl:when test="viewmodel/type/component-name='MMFixedListView' or viewmodel/type/component-name='MMPhotoFixedListView'">
				<xsl:text>MMAdaptableFixedListView&lt;</xsl:text>
				<xsl:value-of select="viewmodel/entity-to-update/name"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="viewmodel/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>MMRecyclableList</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>) p_oRoot.findViewById(R.id.</xsl:text>
		<xsl:value-of select="@component-ref"/>
		<xsl:text>);&#13;</xsl:text>

		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$component-name"/>
		<xsl:text> != null) {&#13;</xsl:text>

		
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="$adapter-name"/>
		<xsl:text> = new </xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>(</xsl:text>
		<xsl:apply-templates select="." mode="constructor-parameters">
			<xsl:with-param name="position" select="position()"/>
		</xsl:apply-templates>
		<xsl:text>);&#13;</xsl:text>

		<xsl:apply-templates select="viewmodel//external-lists/external-list/viewmodel" mode="add-reference-to">
			<xsl:with-param name="fixedAdapterName" select="$adapter-name"/>
		</xsl:apply-templates>

		<xsl:choose>
			<xsl:when test="viewmodel/type/component-name='MMFixedListView' or viewmodel/type/component-name='MMPhotoFixedListView'">
				<xsl:value-of select="$component-name"/>
				<xsl:text>.setAdapter(this.fixedListAdapter</xsl:text>
				<xsl:value-of select="position()"/>
				<xsl:text>);&#13;}&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>MDKViewConnectorWrapper mConnectorWrapper</xsl:text>
				<xsl:value-of select="position()"/>
				<xsl:text> = WidgetWrapperHelper.getInstance().getConnectorWrapper(((View) </xsl:text>
				<xsl:value-of select="$component-name"/>
				<xsl:text>).getClass());&#13;</xsl:text>
				<xsl:text>mConnectorWrapper</xsl:text>
				<xsl:value-of select="position()"/>
				<xsl:text>.configure(</xsl:text>
				<xsl:value-of select="$adapter-name"/>
				<xsl:text>, (View) </xsl:text>
				<xsl:value-of select="$component-name"/>
				<xsl:text>);&#13;}&#13;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ##########################################################################################
											SEARCH_DIALOG
		########################################################################################## -->
		
	<xsl:template match="visualfield" mode="doAfterInflate-method">
		<xsl:if test="parameters/parameter/@name='dialog'">
			// sets this fragment's tag on the MMFilterButton
			MMFilterButton dialog = (MMFilterButton) p_oRoot.findViewById(R.id.<xsl:value-of select="name" />);
			dialog.getComponentFwkDelegate().setFragmentTag(this.getTag());
		</xsl:if>
	</xsl:template>

	<xsl:template match="external-list/viewmodel" mode="add-reference-to">
		<xsl:param name="fixedAdapterName"/>
		<xsl:variable name="vm-name" select="implements/interface/@full-name"/>
		<xsl:apply-templates select="ancestor::page/external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED' and viewmodel/implements/interface/@full-name=$vm-name]" mode="add-reference-to">
			<xsl:with-param name="fixedAdapterName" select="$fixedAdapterName"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="add-reference-to">
		<xsl:param name="fixedAdapterName"/>
		<xsl:variable name="adapter-pos" select="count(preceding::adapter[parent::external-adapters]) + 1"/>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">set-spinner-adapter<xsl:value-of select="$adapter-pos"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>	this.spinnerAdapter</xsl:text>
				<xsl:value-of select="$adapter-pos"/>
				<xsl:text> = new </xsl:text>
				<xsl:value-of select="name"/>
				<xsl:if test="name='ConfigurableSpinnerAdapter' or name='MDKSpinnerAdapter'">
					<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
					<xsl:text>, ListViewModel</xsl:text>
					<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
					<xsl:text>&gt;&gt;</xsl:text>
				</xsl:if>
				<xsl:text>(</xsl:text>
				<xsl:apply-templates select="." mode="constructor-parameters">
					<xsl:with-param name="position" select="$adapter-pos"/>
				</xsl:apply-templates>
				<xsl:text>, true);&#13;</xsl:text>
				<xsl:value-of select="$fixedAdapterName"/>
				<xsl:text>.addReferenceTo(R.id.sel</xsl:text>
				<xsl:value-of select="@component-ref"/>
				<xsl:text>, this.spinnerAdapter</xsl:text>
				<xsl:value-of select="$adapter-pos"/>
				<xsl:text>);&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ##########################################################################################
							PARAMETRES FOURNIS A L'INITIALISATION DES ADAPTERS
		########################################################################################## -->

	<xsl:template match="adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="constructor-parameters">
		<xsl:apply-templates select="ancestor::*[local-name()='page' or local-name()='dialog'][1]" mode="get-page-vm"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="viewmodel/list-accessor-get-name"/>
		<xsl:text>()</xsl:text>
		<xsl:text>, </xsl:text>
		<xsl:apply-templates select="." mode="generate-super-constructor-parameters"/>
	</xsl:template>

	<xsl:template match="adapter[viewmodel/type/component-name='MMFixedListView' or viewmodel/type/component-name='MMPhotoFixedListView']" mode="constructor-parameters"/>
	
	<xsl:template match="adapter[viewmodel/type/component-name='MMFixedList']" mode="constructor-parameters">
		<xsl:text>application.getViewModelCreator().getViewModel(</xsl:text>
		<xsl:value-of select="viewmodel/parent-viewmodel/master-interface/@name"/>
		<xsl:text>.class).</xsl:text>
		<xsl:value-of select="viewmodel/list-accessor-get-name"/>
		<xsl:text>()</xsl:text>
	</xsl:template>


	<!-- ##########################################################################################
											RECUPERATION D'UN VM
		########################################################################################## -->

	<!-- not a workspace -->
	<xsl:template match="page[parameters[parameter[@name='workspace-panel-type']!='detail' and parameter[@name='workspace-panel-type']!='master']]" mode="get-page-vm">
		<xsl:text>((</xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>) ((AbstractAutoBindMMActivity) this.getActivity()).getViewModel())</xsl:text>
	</xsl:template>
	
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" mode="get-page-vm">
		<xsl:text>((</xsl:text>
		<xsl:choose>
			<xsl:when test="./in-workspace='true'">
				<xsl:value-of select="screen-vm-interface"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="viewmodel/parent-viewmodel/master-interface/@name"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>) ((AbstractAutoBindMMActivity) this.getActivity()).getViewModel()).get</xsl:text>
		<xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>()</xsl:text>
	</xsl:template>
	
	<xsl:template match="page" mode="get-page-vm">
		<xsl:text>application.getViewModelCreator().getViewModel(</xsl:text>
		<xsl:value-of select="viewmodel-interface/name"/>
		<xsl:text>.class)</xsl:text>
<!-- 		<xsl:text>((</xsl:text><xsl:value-of select="screen-vm-interface"/> -->
<!-- 		<xsl:text>) ((AbstractAutoBindMMActivity) this.getActivity()).getViewModel()).</xsl:text> -->
<!-- 		<xsl:value-of select="viewmodel/accessor-get-name"/> -->
<!-- 		<xsl:text>()</xsl:text> -->
	</xsl:template>
	

</xsl:stylesheet>
