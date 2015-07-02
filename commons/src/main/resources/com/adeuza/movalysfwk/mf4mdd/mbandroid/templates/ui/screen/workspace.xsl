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
			Templates spécifiques aux écrans qui reposent sur l'utilisation d'un workspace.
		########################################################################################## -->


	<!-- *****************************************************************************************
											SUPERCLASS
		***************************************************************************************** -->

	<xsl:template match="screen[workspace='true']" mode="superclass-import">
		<import>java.util.ArrayList</import>
		<import>java.util.List</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.LoadDataForMultipleDisplayDetailActionParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractWorkspaceMasterDetailMMFragmentActivity</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveActionDetailParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.ChainSaveDetailAction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdelete.ChainDeleteDetailAction</import>
<!-- 		<import>com.adeuza.movalysfwk.mobile.mf4android.ui.modele.AbstractConfigurableListAdapter</import> -->
		<import>android.support.v4.view.ViewPager.PageTransformer</import>
		<xsl:if test="main = 'true'">
			<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.displaymain.MFRootActivity</import>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="pages/page/actions/action[action-type='DELETEDETAIL'] and count(pages/page/actions/action[action-type='DELETEDETAIL']) > 1">
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdelete.ChainDeleteDetailAction</import>
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdelete.ChainDeleteActionDetailParameter</import>
			</xsl:when>
			<xsl:when test="pages/page/actions/action[action-type='DELETEDETAIL']">
				
			</xsl:when>
		</xsl:choose>
	
	</xsl:template>

	<!-- *****************************************************************************************
											ATTRIBUTES
		***************************************************************************************** -->

	<!--
		Les attributs associés à la liste sont gérés par la classe abstraite.
		Il faut désactivier la génération de la déclaration des attributs correspondant à l'adapter
		et au composante liste.
	-->
	<xsl:template match="pages/page[parameters/parameter[@name='workspace-panel-type'] = 'master']/adapter" mode="attributes"/>

	<!-- *****************************************************************************************
								SURCHARGE DE LA GENERATION DE METHODES
		***************************************************************************************** -->

	<!-- 
		Dans le cas du workspace, l'initisalisation de l'adapter et du composant représentant la liste est délégué à la classe mère.
		Le template ci-dessous permet de supprimer l'initialisation par défaut.
	 -->
	<xsl:template match="pages/page/adapter[ancestor::screen/workspace='true' and viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" 
		mode="doAfterSetContentView-method"/>

	<xsl:template match="pages/page/adapter[ancestor::screen/workspace='true']" 
		mode="generate-adapter-registration">
	</xsl:template>

	<xsl:template match="page[ancestor::screen/workspace='true' and parameters/parameter[@name='workspace-panel-type'] = 'master']" 
		mode="doOnReload-method">
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		/**
		 * Listener on <xsl:value-of select="$dataloader"/> reload
		 * @param p_oEvent the event sent from the dataloader
		 */
		@ListenerOnDataLoaderReload(<xsl:value-of select="$dataloader"/>.class)
		public void doOnReload<xsl:value-of select="$dataloader"/>(ListenerOnDataLoaderReloadEvent&lt;<xsl:value-of select="$dataloader"/>&gt; p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnReload</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="generate-doOnReload-body">
						<xsl:with-param name="viewmodel" select="/screen/viewmodel/implements/interface/@name"/>
						<xsl:with-param name="isScreenVm" select="true"/>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<!--  Methode de chargement du détail: template doOnReload-method surchargé afin de gérer l'appel au super.doOnReloadDetail -->
	<xsl:template match="page[ancestor::screen/workspace='true' and parameters/parameter[@name='grid-column-parameter'] = '1' and parameters/parameter[@name='grid-section-parameter'] = '1' and parameters/parameter[@name='workspace-panel-type'] = 'detail']" 
		mode="doOnReload-method">
		<xsl:variable name="dataloader" select="./viewmodel/dataloader-impl/implements/interface/@name"/>
		/**
		 * Listener on <xsl:value-of select="$dataloader"/> reload
		 * @param p_oEvent the event sent from the dataloader
		 */
		@ListenerOnDataLoaderReload(<xsl:value-of select="$dataloader"/>.class)
		public void doOnReload<xsl:value-of select="$dataloader"/>(ListenerOnDataLoaderReloadEvent&lt;<xsl:value-of select="$dataloader"/>&gt; p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnReloadDetail</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="generate-doOnReload-body">
						<xsl:with-param name="viewmodel" select="/screen/viewmodel/implements/interface/@name"/>
						<xsl:with-param name="isScreenVm" select="true"/>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
			super.doOnReloadDetail(p_oEvent);
		}
	</xsl:template>
	
	<xsl:template match="page[ancestor::screen/workspace='true' and parameters/parameter[@name='workspace-panel-type'] = 'detail' and (parameters/parameter[@name='grid-column-parameter'] != '1' or parameters/parameter[@name='grid-section-parameter'] > 1 )]" 
		mode="doOnReload-method"/>

	<xsl:template match="action[ancestor::screen/workspace='true' and (action-type='SAVEDETAIL' or action-type='DELETEDETAIL')]" 
		mode="default-source">
	</xsl:template>

	<!-- *****************************************************************************************
								METHODES SPECIFIQUES AU WORKSPACE
		***************************************************************************************** -->

	<xsl:template match="screen[workspace='true']" mode="extra-methods-imports">
		<import>android.widget.ListAdapter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.listener.ListenerOnDataLoaderReload</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.listener.ListenerOnBusinessNotification</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.genericdisplay.InDisplayParameter</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdisplay.GenericLoadDataForDisplayDetailAction</import>
		<import>android.view.View</import>		
		<xsl:apply-templates select="pages/page[parameters/parameter[@name='workspace-panel-type'] = 'master' and parameters/parameter[@name='grid-column-parameter'] = '1']/adapter/full-name" mode="declare-import"/>
		<xsl:apply-templates select="pages/page[parameters/parameter[@name='workspace-panel-type'] = 'master']/viewmodel/dataloader-impl/implements/interface/@full-name" mode="declare-import"/>
		<xsl:apply-templates select="pages/page[parameters/parameter[@name='grid-column-parameter'] = '1']" mode="doOnReload-imports"/>
	</xsl:template>

	<xsl:template match="screen[workspace='true' and descendant::action/action-type='SAVEDETAIL']" mode="do-keep-modifications">
		@Override
		protected void doOnKeepModifications(DialogInterface p_oDialog) {
			super.doOnKeepModifications(p_oDialog);
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnKeepModifications</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="launch-savedetail-actions">
						<xsl:with-param name="sourceObject">FROM_BACK</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="screen[workspace='true']" mode="extra-methods">
		/**
		 * {@inheritDoc}
		 */
		 @Override
		public final int getWorkspaceId() {
			return R.id.main__<xsl:value-of select="translate(name, $uppercase, $smallcase)"/>__visualpanel;
		}

		<xsl:apply-templates select="." mode="workspace-extramethods"/>

		<xsl:apply-templates select="self::node()[descendant::action/action-type='SAVEDETAIL']" mode="do-keep-modifications"/>

		<xsl:if test="descendant::action/action-type='SAVEDETAIL'">			
			@ListenerOnActionSuccess(action=ChainSaveDetailAction.class)
			public void doOnSave<xsl:value-of select="descendant::page/actions/action[action-type='SAVEDETAIL']/class/implements/interface/@name"/>Success(ListenerOnActionSuccessEvent&lt;EntityActionParameterImpl<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="descendant::page/actions/action[action-type='SAVEDETAIL']/class/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>&gt; p_oEvent) {
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">doOnSaveWorkspaceSuccess</xsl:with-param>
					<xsl:with-param name="defaultSource">
						super.doOnSaveWorkspaceSuccess(p_oEvent);
					</xsl:with-param>
				</xsl:call-template>
			}
			
		</xsl:if>

		<xsl:if test="descendant::page/actions/action/action-type='DELETEDETAIL'">			
<!-- 			@ListenerOnActionSuccess(action=ChainSaveDetailAction.class) -->
<!-- 			public void doOnSave<xsl:value-of select="descendant::page/actions/action[action-type='SAVEDETAIL']/class/implements/interface/@name"/>Success(ListenerOnActionSuccessEvent&lt;EntityActionParameterImpl<xsl:text>&lt;</xsl:text> -->
<!-- 				<xsl:value-of select="descendant::page/actions/action[action-type='SAVEDETAIL']/class/implements/interface/@name"/> -->
<!-- 				<xsl:text>&gt;</xsl:text>&gt; p_oEvent) { -->
<!-- 				<xsl:call-template name="non-generated-bloc"> -->
<!-- 					<xsl:with-param name="blocId">doOnSaveWorkspaceSuccess</xsl:with-param> -->
<!-- 					<xsl:with-param name="defaultSource"> -->
<!-- 						super.doOnSaveWorkspaceSuccess(p_oEvent); -->
<!-- 					</xsl:with-param> -->
<!-- 				</xsl:call-template> -->
<!-- 			} -->
			@ListenerOnActionSuccess(action = ChainDeleteDetailAction.class)
			public void doOnDelete<xsl:value-of select="descendant::page/actions/action[action-type='DELETEDETAIL']/class/implements/interface/@name"/>Success(ListenerOnActionSuccessEvent&lt;EntityActionParameterImpl<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="descendant::page/actions/action[action-type='DELETEDETAIL']/class/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>&gt; p_oEvent) {
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">doOnDeleteWorkspaceSuccess</xsl:with-param>
					<xsl:with-param name="defaultSource">
						this.doOnDetailDeleteSuccess();
					</xsl:with-param>
				</xsl:call-template>
			}
		</xsl:if>

		<!-- If all fields are read-only, there is no savedetail action. But a doOnKeepWorkspaceModifications method is needed. -->
		<xsl:if test="not(descendant::action/action-type='SAVEDETAIL')">
			@Override
				protected void doOnKeepWorkspaceModifications(View p_oSource) {
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">doOnKeepWorkspaceModifications</xsl:with-param>
					<xsl:with-param name="defaultSource">
					</xsl:with-param>
				</xsl:call-template>
			}
			
		</xsl:if>

		<xsl:apply-templates select="." mode="page-transition"/>
		
	</xsl:template>

	<xsl:template match="screen" mode="page-transition">
		@Override
		protected PageTransformer createPageTransformer() {
			return null;
		}
	</xsl:template>
	
</xsl:stylesheet>
