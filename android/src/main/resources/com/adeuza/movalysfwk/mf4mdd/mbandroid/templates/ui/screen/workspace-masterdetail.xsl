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
		<xsl:text>AbstractWorkspaceMasterDetailMMFragmentActivity</xsl:text>
	</xsl:template>


	<!-- *****************************************************************************************
											EXTRA METHODS
		***************************************************************************************** -->
	<xsl:template match="screen[workspace='true' and workspace-type='MASTERDETAIL']" mode="workspace-extramethods">
		
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

		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
