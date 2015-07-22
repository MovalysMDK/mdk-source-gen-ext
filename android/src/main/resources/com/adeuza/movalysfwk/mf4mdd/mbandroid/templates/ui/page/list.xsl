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
			Méthodes spécifiques aux écrans qui reposent sur un viewmodel de type liste.
		########################################################################################## -->

	<!-- *****************************************************************************************
											SUPERCLASS
		***************************************************************************************** -->
		
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3'] and in-workspace='true']" mode="superclass">
		<xsl:text>AbstractMMWorkspaceListFragment</xsl:text>
	</xsl:template>
	
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3'] and in-workspace='false']" mode="superclass">
		<xsl:text>AbstractMMListFragment</xsl:text>
	</xsl:template>
	
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']  and in-workspace='true']" mode="superclass-import">
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractWorkspaceMasterDetailMMFragmentActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractMMWorkspaceListFragment</import>
		<xsl:apply-templates select="." mode="commons-list-page-imports"/>
		<import><xsl:value-of select="screen-class-fullname"/></import>
		<import><xsl:value-of select="screen-vm-interface-fullname"/></import>
	</xsl:template>
	
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']  and in-workspace='false']" mode="superclass-import">
		<import>com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractMMListFragment</import>
		<xsl:apply-templates select="." mode="commons-list-page-imports"/>
<!-- 		<import><xsl:value-of select="screen-class-fullname"/></import> -->
<!-- 		<import><xsl:value-of select="screen-vm-interface-fullname"/></import> -->
	</xsl:template>
	
	<xsl:template match="page" mode="commons-list-page-imports">
		<xsl:choose>
			<xsl:when test="./viewmodel/type/name='LIST_1'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.ui.adapters.MDKAdapter</import>
			</xsl:when>
			<xsl:when test="./viewmodel/type/name='LIST_2'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.ui.adapters.MDKExpandableAdapter</import>
			</xsl:when>
			<xsl:when test="./viewmodel/type/name='LIST_3'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.ui.adapters.MDKFlipperAdapter</import>
			</xsl:when>
			<xsl:otherwise>
				<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.MMListAdapter</import>
			</xsl:otherwise>
		</xsl:choose>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.listener.ListenerOnBusinessNotification</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.SelectedItemEvent</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.PerformItemClickEvent</import>
	</xsl:template>
	
	<!-- *****************************************************************************************
											EXTRA IMPORT
		***************************************************************************************** -->
	<xsl:template match="page[./viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3'] and ./navigations/navigation[@name='navigationdetail'] and in-workspace='false']" mode="extra-methods-imports">
	
		<import>android.content.Intent</import>
		<xsl:if test="navigations/navigation[@name = 'navigationdetail']">
			<import><xsl:value-of select="navigations/navigation[@name = 'navigationdetail']/target/full-name"/></import>
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- *****************************************************************************************
											METHODES
		***************************************************************************************** -->

	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3'] and in-workspace='true']" mode="extra-methods">
	
		<xsl:apply-templates select="." mode="getListViewId-method"/>
		<xsl:apply-templates select="." mode="createListAdapter-method"/>	
		<xsl:apply-templates select="." mode="doOnMasterListChangeSelectedItem-method"/>
<!-- 		<xsl:apply-templates select="." mode="doOnReload-method"/>		 -->
		<xsl:apply-templates select="." mode="doOnGenericUpdateVMForDisplayDetailAction-method"/>
		<xsl:apply-templates select="." mode="doOnChangeModifyEntityEvent-method"/>
		<xsl:apply-templates select="." mode="doOnChangeAddEntityEvent-method"/>
	</xsl:template>
	
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3'] and in-workspace='false']" mode="extra-methods">
	
		<xsl:apply-templates select="." mode="getListViewId-method"/>
		<xsl:apply-templates select="." mode="createListAdapter-method"/>
		<xsl:apply-templates select="navigations/navigation" mode="doOnSelectedItemEvent-method">
			<xsl:with-param name="adapter"><xsl:value-of select="adapter/name"/></xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="doOnPerformItemClickEvent-method">
			<xsl:with-param name="adapter"><xsl:value-of select="adapter/name"/></xsl:with-param>
		</xsl:apply-templates>
		
	</xsl:template>


	<xsl:template match="page" mode="getListViewId-method">
		@Override
		protected int getListViewId() {
			return R.id.<xsl:value-of select="mastercomponentname"/>;
		}
	</xsl:template>
	
	<xsl:template match="page" mode="createListAdapter-method">
		@Override
		<xsl:text>protected </xsl:text>
		<xsl:choose>
			<xsl:when test="./viewmodel/type/name='LIST_1'">
				<xsl:text>MDKAdapter&lt;</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:when test="./viewmodel/type/name='LIST_2'">
				<xsl:text>MDKExpandableAdapter&lt;</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:when test="./viewmodel/type/name='LIST_3'">
				<xsl:text>MDKFlipperAdapter&lt;</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/entity-to-update/name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/entity-to-update/name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/subvm/viewmodel/implements/interface/@name"/><xsl:text>,</xsl:text>
				<xsl:value-of select="./viewmodel/subvm/viewmodel/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>MMListAdapter</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> createListAdapter() {&#13;</xsl:text>
			return new <xsl:value-of select="adapter/name"/>( application.getViewModelCreator().getViewModel(<xsl:value-of select="vm"/>.class) );
		}
	</xsl:template>
	
	<xsl:template match="page" mode="doOnGenericUpdateVMForDisplayDetailAction-method">
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		@ListenerOnActionSuccess(action = { GenericUpdateVMForDisplayDetailAction.class }, classFilters={<xsl:value-of select="./viewmodel-interface/name"/>.class})
		public void doOnGenericUpdateVMForDisplayDetailAction( ListenerOnActionSuccessEvent&lt;OutUpdateVMParameter&gt; p_oEvent) {
			if ( <xsl:value-of select="$dataloader"/>.class.equals(p_oEvent.getActionResult().getDataloader())) {
				this.updateListAdapterWithVM(true);
			}
		}	
	</xsl:template>
	
	<xsl:template match="page" mode="doOnChangeModifyEntityEvent-method">
		/**
	 	 * 
	 	 * @param p_oEvent
	 	 */
		@ListenerOnBusinessNotification(ChainSaveDetailAction.ModifyEntityEvent.class)
		public void doOnChange<xsl:value-of select="viewmodel/entity-to-update/name"/>Event(ChainSaveDetailAction.ModifyEntityEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnChange<xsl:value-of select="viewmodel/entity-to-update/name"/>ModifyEntityEvent</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}	
	</xsl:template>
	
	<xsl:template match="page" mode="doOnChangeAddEntityEvent-method">
		/**
	 	 * 
	 	 * @param p_oEvent
	 	 */
		@ListenerOnBusinessNotification(ChainSaveDetailAction.AddEntityEvent.class)
		public void doOnChange<xsl:value-of select="viewmodel/entity-to-update/name"/>Event(ChainSaveDetailAction.AddEntityEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnChange<xsl:value-of select="viewmodel/entity-to-update/name"/>AddEntityEvent1</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>((</xsl:text>
			<xsl:choose>
				<xsl:when test="viewmodel/type/name='LIST_1'">
					<xsl:text>MDKAdapter</xsl:text>
				</xsl:when>
				<xsl:when test="viewmodel/type/name='LIST_2'">
					<xsl:text>MDKExpandableAdapter</xsl:text>
				</xsl:when>
				<xsl:when test="viewmodel/type/name='LIST_3'">
					<xsl:text>MDKFlipperAdapter</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>AbstractConfigurableListAdapter</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>)this.getListAdapter()).setSelectedItem(p_oEvent.getData().idToString());&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnChange<xsl:value-of select="viewmodel/entity-to-update/name"/>AddEntityEvent2</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}	
	</xsl:template>

	<!-- *****************************************************************************************
									doOnSelectedItemEvent
						Affichage du détail associé à un élément d'une liste.
		***************************************************************************************** -->

	<xsl:template match="navigation[@name = 'navigationdetail']" mode="doOnSelectedItemEvent-method">
		<xsl:param name="adapter"/>
		/**
		 * Callback from adapter event.
		 * @param p_oEvent the event 
		 */
		@ListenerOnBusinessNotification(value = SelectedItemEvent.class, classFilters = {<xsl:value-of select="$adapter"/>.class})
		public void doOnSelectedItemEvent(SelectedItemEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">OnSelectedItemEvent</xsl:with-param>
				<xsl:with-param name="defaultSource">
				if (p_oEvent.getSource() == this.getListAdapter()) {
					final Intent oIntent = new Intent(this.getActivity(), <xsl:value-of select="target/name"/>.class);
					oIntent.putExtra("id", p_oEvent.getData());
					oIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
					this.getActivity().startActivityForResult(oIntent, <xsl:value-of select="target/name"/>.REQUEST_CODE);
				}
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
		
	<xsl:template match="page" mode="doOnPerformItemClickEvent-method">
		<xsl:param name="adapter"/>
		/**
		 * {@inheritDoc}
		 */
		@ListenerOnBusinessNotification(value = PerformItemClickEvent.class, classFilters = {<xsl:value-of select="$adapter"/>.class})
		public void doOnPerformItemClickEvent(final PerformItemClickEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">OnPerformItemClickEvent</xsl:with-param>
				<xsl:with-param name="defaultSource">
					p_oEvent.getData().performItemClick();
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="*" mode="doOnSelectedItemEvent-method">
	</xsl:template>

	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2']]" mode="doOnMasterListChangeSelectedItem-method">
		/**
		 * {@inheritDoc}
		 */
		@ListenerOnBusinessNotification(value = SelectedItemEvent.class, classFilters = {<xsl:value-of select="adapter/name"/>.class})
		public void doOnMasterListChangeSelectedItem(final SelectedItemEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnMasterListChangeSelectedItem</xsl:with-param>
				<xsl:with-param name="defaultSource">
				((<xsl:value-of select="screen-class"/>) this.getActivity()).doDisplayDetail(p_oEvent.getData());
				this.getActivity().getIntent().putExtra(IDENTIFIER_CACHE_KEY, p_oEvent.getData());
				</xsl:with-param>
			</xsl:call-template>
		}
		
		/**
		 * {@inheritDoc}
		 */
		@ListenerOnBusinessNotification(value = PerformItemClickEvent.class, classFilters = {<xsl:value-of select="adapter/name"/>.class})
		public void doOnMasterListPerformItemClick(final PerformItemClickEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnMasterListChangeSelectedItem</xsl:with-param>
				<xsl:with-param name="defaultSource">
				((AbstractWorkspaceMasterDetailMMFragmentActivity) this.getActivity()).doOnMasterListChangeSelectedItem(this.getWorkspaceListHandler(),	p_oEvent);
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="page" mode="doOnMasterListChangeSelectedItem-method">
		/**
		 * {@inheritDoc}
		 */
		@ListenerOnBusinessNotification(value = SelectedItemEvent.class, classFilters = {<xsl:value-of select="adapter/name"/>.class})
		public void doOnMasterListChangeSelectedItem(final SelectedItemEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnMasterListChangeSelectedItem</xsl:with-param>
				<xsl:with-param name="defaultSource">
				((AbstractWorkspaceMasterDetailMMFragmentActivity) this.getActivity()).doOnMasterListChangeSelectedItem(this.getWorkspaceListHandler(), p_oEvent);
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3'] and (in-multi-panel='false' or in-workspace='true')]" mode="doOnReload-method">
	<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
	@ListenerOnDataLoaderReload(<xsl:value-of select="$dataloader"/>.class)
	public void doOnReload<xsl:value-of select="$dataloader"/>(ListenerOnDataLoaderReloadEvent&lt;<xsl:value-of select="$dataloader"/>&gt; p_oEvent) {
	<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doOnReload<xsl:value-of select="$dataloader"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				final InUpdateVMParameter oActionParameter = new InUpdateVMParameter();
				oActionParameter.setDataLoader(<xsl:value-of select="$dataloader"/>.class);						
				oActionParameter.setVm(<xsl:value-of select="screen-vm-interface"/>.class);
				oActionParameter.addAdapter(this.getListAdapter());
				this.launchAction(GenericUpdateVMForDisplayDetailAction.class, oActionParameter);
			</xsl:with-param>
		</xsl:call-template>		
	}
	</xsl:template>

	<xsl:template match="page" mode="doOnReload-method">
	</xsl:template>

</xsl:stylesheet>
