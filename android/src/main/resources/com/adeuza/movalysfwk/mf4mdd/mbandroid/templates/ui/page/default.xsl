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

	<xsl:template match="page" mode="superclass">
		<xsl:text>AbstractAutoBindMMFragment</xsl:text>
	</xsl:template>

	<xsl:template match="page" mode="superclass-import">
		<import>com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractAutoBindMMFragment</import>
		<xsl:apply-templates select="." mode="getViewModel-imports"/>
	</xsl:template>

	<!-- *****************************************************************************************
											METHODES
		***************************************************************************************** -->


	<xsl:template match="page" mode="getLayoutId-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractAutoBindMMFragment#getLayoutId()
		 */
		@Override
		public int getLayoutId() {
			return R.layout.<xsl:value-of select="./screenname"/>;
		}
	</xsl:template>

<!-- 	<xsl:template match="page[screen-vm-interface-fullname and screen-class-fullname]" mode="getViewModel-imports"> -->
<!-- 		<import><xsl:value-of select="screen-vm-interface-fullname"/></import> -->
<!-- 		<import><xsl:value-of select="screen-class-fullname"/></import> -->
<!-- 	</xsl:template> -->

	<xsl:template match="page[external-adapters/adapter/viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="getViewModel-imports">
		<xsl:for-each select="./external-adapters/adapter">
			<xsl:if test="./viewmodel/type/name='LIST_1__ONE_SELECTED'">
				<import><xsl:value-of select="./viewmodel/implements/interface/@full-name"/></import>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="*" mode="getViewModel-imports">
	</xsl:template>

	<xsl:template match="page" mode="getViewModel-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.fragment.AbstractAutoBindMMFragment#getFragmentViewModel()
		 */
		@Override
		protected ViewModel getFragmentViewModel() {
		<xsl:choose>
			<xsl:when test="./viewmodel/multiInstance='true'">
				<xsl:variable name="parent-vm" select="./viewmodel/parent-viewmodel/master-interface/@name"/>
				
				<xsl:value-of select="$parent-vm"/>
				<xsl:text> oParentVM = application.getViewModelCreator().getViewModel(</xsl:text>
				<xsl:value-of select="$parent-vm"/>
				<xsl:text>.class);&#13;</xsl:text>
				<xsl:value-of select="./vm"/>
				<xsl:text> r_oVm = oParentVM.get</xsl:text>
				<xsl:value-of select="./vm"/>
				<xsl:text>(this.getTag());&#13;</xsl:text>
				<xsl:text>if (r_oVm == null) {&#13;</xsl:text>
				<xsl:text>r_oVm = ((ViewModelCreator) application.getViewModelCreator()).create</xsl:text>
				<xsl:value-of select="./vm"/>
				<xsl:text>(this.getTag());</xsl:text>
				<xsl:text>oParentVM.add</xsl:text>
				<xsl:value-of select="./vm"/>
				<xsl:text>(this.getTag(), r_oVm);&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				<xsl:text>r_oVm.setKey(this.getTag());&#13;</xsl:text>
				<xsl:text>return r_oVm;&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				return application.getViewModelCreator().getViewModel(<xsl:value-of select="./vm"/>.class);
			</xsl:otherwise>
		</xsl:choose>
		}
		
	</xsl:template>
	
	
	<xsl:template match="page" mode="doOnGenericUpdateVM-method">
		<xsl:param name="launchFrom" select="local-name(.)"/>
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		@ListenerOnActionSuccess(action = { GenericUpdateVMForDisplayDetailAction.class }, classFilters={<xsl:value-of select="./viewmodel-interface/name"/>.class})
		public void doOnGenericUpdateVMForDisplayDetailAction( ListenerOnActionSuccessEvent&lt;OutUpdateVMParameter&lt; p_oEvent) {
			if ( <xsl:value-of select="$dataloader"/>.class.equals(p_oEvent.getActionResult().getDataloader())) {
				this.updateListAdapterWithVM(true);
			}
		}
	</xsl:template>
	
			
	<xsl:template match="page" mode="action-events-notify-dataset">
		<xsl:param name="launchFrom" select="local-name(.)"/>
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		
			<xsl:if test="parameters/parameter[@name='workspace-panel-type'] = 'detail'" >
				<xsl:if test="external-adapters/adapter/viewmodel/type[name='LIST_1__ONE_SELECTED' or name='FIXED_LIST']">
					/**
					* @param p_oEvent Success event of action
					*/
					@ListenerOnActionSuccess(action = { GenericUpdateVMForDisplayDetailAction.class }, classFilters={<xsl:apply-templates select="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED' or viewmodel/type/name='FIXED_LIST']" mode="action-events-notify-dataset-classfilter" />})
					public void doOnGenericUpdateVMForDisplayDetailAction( ListenerOnActionSuccessEvent&lt;OutUpdateVMParameter&gt; p_oEvent) {
						if ( <xsl:value-of select="$dataloader"/>.class.equals(p_oEvent.getActionResult().getDataloader())) {
						<xsl:apply-templates select="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED' or viewmodel/type/name='FIXED_LIST']" mode="action-events-notify-dataset">
							<xsl:with-param name="dataloader" select="$dataloader"/>
						</xsl:apply-templates>
						}
					}
				</xsl:if>
			</xsl:if>
			
	</xsl:template>
	
	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="action-events-notify-dataset-classfilter">
		<xsl:if test="position()=1">
			<xsl:value-of select="./viewmodel/implements/interface/@name"/>.class
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="external-adapters/adapter[viewmodel/type/name='FIXED_LIST']" mode="action-events-notify-dataset-classfilter">
		<xsl:if test="position()!=1">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:value-of select="./viewmodel/implements/interface/@name"/>.class
	</xsl:template>

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="action-events-notify-dataset">
		<xsl:param name="dataloader"/>
		<xsl:if test="position()=1">
			this.spinnerAdapter<xsl:value-of select="position()"/>.notifyDataSetChanged();
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="external-adapters/adapter[viewmodel/type/name='FIXED_LIST']" mode="action-events-notify-dataset">
		<xsl:param name="dataloader"/>
		<xsl:text>this.fixedListAdapter</xsl:text><xsl:value-of select="position()"/>
		<xsl:choose>
			<xsl:when test="viewmodel/type/component-name='MMFixedListView' or viewmodel/type/component-name='MMPhotoFixedListView'">
				<xsl:text>.getMasterVM().notifyCollectionChanged();&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>.notifyDataSetChanged();&#13;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
