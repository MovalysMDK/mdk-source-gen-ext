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

	<xsl:template match="screen[workspace='true' and workspace-type='MASTERDETAIL']" mode="superclass">
		<xsl:text>AbstractWorkspaceMasterDetailMMActivity</xsl:text>
	</xsl:template>


	<!-- *****************************************************************************************
											EXTRA METHODS
		***************************************************************************************** -->
	<xsl:template match="screen[workspace='true' and workspace-type='MASTERDETAIL']" mode="workspace-extramethods">
		
		/**
		 * {@inheritDoc}
	 	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractWorkspaceAutoBindMMActivity#createListHandlers()
	 	 */
		@Override
		protected List&lt;WorkspaceListHandler&gt; createListHandlers() {
			List&lt;WorkspaceListHandler&gt; r_listWorkspaceHandlers = new ArrayList&lt;WorkspaceListHandler&gt;();
			<xsl:for-each select="pages/page[parameters/parameter[@name='workspace-panel-type'] = 'master']">
			r_listWorkspaceHandlers.add( new WorkspaceListHandler(R.id.<xsl:value-of select="mastercomponentname"/>,
				new <xsl:value-of select="adapter/name"/>
				<xsl:text>(</xsl:text><xsl:apply-templates select="." mode="get-page-vm"/>)));
			</xsl:for-each>
			return r_listWorkspaceHandlers;
		}
		
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected void doDisplayDetail(String p_sItemId) {
			final InDisplayParameter oParam = new InDisplayParameter();
			oParam.setId( p_sItemId );
			oParam.setDataLoader( <xsl:value-of select="pages/page[parameters/parameter[@name='workspace-panel-type'] = 'detail']/viewmodel/dataloader-impl/implements/interface/@name"/>.class );
			this.launchAction(GenericLoadDataForDisplayDetailAction.class, oParam);
		}
		
		<xsl:if test="descendant::page/actions/action/action-type='SAVEDETAIL'">
		
		@Override
		protected void doOnKeepWorkspaceModifications(View p_oSource) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnKeepWorkspaceModifications</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="launch-savedetail-actions">
						<xsl:with-param name="sourceObject">FROM_LISTITEM</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
		
		/**
	 	 * 
	 	 * @param p_oEvent
	 	 */
		@ListenerOnBusinessNotification(ChainSaveDetailAction.AddEntityEvent.class)
		public void doOnChange<xsl:value-of select="pages/page/viewmodel/entity-to-update/name"/>Event(ChainSaveDetailAction.AddEntityEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnChange<xsl:value-of select="pages/page/viewmodel/entity-to-update/name"/>AddEntityEvent1</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
			((AbstractConfigurableListAdapter)
				this.getCurrentListView().getListAdapter()).setSelectedItem(p_oEvent.getData().idToString());
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnChange<xsl:value-of select="pages/page/viewmodel/entity-to-update/name"/>AddEntityEvent2</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}
	
		/**
	 	 * 
	 	 * @param p_oEvent
	 	 */
		@ListenerOnBusinessNotification(ChainSaveDetailAction.ModifyEntityEvent.class)
		public void doOnChange<xsl:value-of select="pages/page/viewmodel/entity-to-update/name"/>Event(ChainSaveDetailAction.ModifyEntityEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnChange<xsl:value-of select="pages/page/viewmodel/entity-to-update/name"/>ModifyEntityEvent</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}
		</xsl:if>
	</xsl:template>


	<!-- *****************************************************************************************
											FILL ACTION
		***************************************************************************************** -->
		
	<!--
	Fill Action signature 
	-->
	<xsl:template match="page[ancestor::screen[workspace='true' and workspace-type='MASTERDETAIL'] and (parameters/parameter[@name='grid-column-parameter'] != '1' or parameters/parameter[@name='workspace-panel-type'] != 'master')]" 
		mode="doFillAction-method">
	</xsl:template>


	<!--
	Fill Action Body 
	-->
	<xsl:template match="page[ancestor::screen[workspace='true' and workspace-type='MASTERDETAIL'] and parameters/parameter[@name='workspace-panel-type'] = 'master' and parameters/parameter[@name='grid-column-parameter'] = '1']" 
		mode="generate-doFillAction-body">	
		
		<!-- dataloader for first list -->
		LoadDataForMultipleDisplayDetailActionParameter oMultipleDisplayParameter 
			= new LoadDataForMultipleDisplayDetailActionParameter();
		InDisplayParameter oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);

		<!-- dataloader for other lists (tabs) -->		
		<xsl:for-each select="../page[parameters/parameter[@name='workspace-panel-type'] = 'master' and parameters/parameter[@name='grid-column-parameter'] != '1']">
			<xsl:sort select="parameters/parameter[@name='grid-column-parameter']"/>
		oInDisplayParameter = new InDisplayParameter();
		oInDisplayParameter.setDataLoader( <xsl:value-of select="./viewmodel/dataloader-impl/implements/interface/@name"/>.class );
		oInDisplayParameter.setId( this.getIntent().getStringExtra(IDENTIFIER_CACHE_KEY) );
		oMultipleDisplayParameter.addDisplayParameter(oInDisplayParameter);		
		</xsl:for-each>
		
		this.launchAction(LoadDataForMultipleDisplayDetailAction.class, oMultipleDisplayParameter);		
	</xsl:template>

</xsl:stylesheet>
