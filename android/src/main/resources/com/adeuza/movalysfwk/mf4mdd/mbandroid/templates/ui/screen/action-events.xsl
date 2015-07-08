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

<!-- 	<xsl:template match="screen[workspace='false' and multi-panel='false']" mode="action-events"> -->
 		<!-- action events are generated in each fragment, and not in the screen --> 
<!-- 	</xsl:template> -->
	
	<xsl:template match="screen[workspace='false' and multi-panel='true']" mode="action-events">
		<xsl:apply-templates select="pages/page//action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL']" mode="action-events"/>
	</xsl:template>
	
	<xsl:template match="screen" mode="action-events">
		<xsl:apply-templates select="pages/page//action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL']" mode="action-events"/>
	</xsl:template>
	
	<xsl:template match="page[in-workspace='false' and in-multi-panel='false']" mode="action-events">
		<xsl:apply-templates select="actions/action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL']" mode="action-events"/>
	</xsl:template>

	<xsl:template match="page" mode="action-events">
	</xsl:template>
	
	<xsl:template match="action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL']" mode="action-events">
		
		/**
		 * Listener method for <xsl:value-of select="implements/interface/@name"/> action successfully processed
		 * @param p_oEvent Success event of action
		 */
		@ListenerOnActionSuccess(action=<xsl:value-of select="implements/interface/@name"/>.class)
		public void doOn<xsl:value-of select="implements/interface/@name"/>
			<xsl:text>Success(ListenerOnActionSuccessEvent&lt;</xsl:text>
			<xsl:value-of select="out/@name"/>
			<xsl:if test="out/@name = 'EntityActionParameterImpl'">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="class/implements/interface/@name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:if>
			<xsl:text>&gt; p_oEvent) {&#13;</xsl:text>
			
			<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doOn<xsl:value-of select="implements/interface/@name"/>Success</xsl:with-param>
			<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="action-event-default-source"/>
			</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="action[action-type='SAVEDETAIL' or action-type='DELETEDETAIL']" mode="action-event-default-source">

		<xsl:if test="ancestor::screen[main = 'false' and workspace != 'true']">
			<!-- close activity if not main screen -->
			<xsl:text>this.setResult(Activity.RESULT_OK);&#13;</xsl:text>			
			<xsl:text>this.exit();&#13;</xsl:text>
		</xsl:if>
			
		<xsl:apply-templates select="../../navigations/navigation"/>
		
		<xsl:if test="ancestor::screen[workspace = 'true']">
			<xsl:choose>
				<xsl:when test="action-type='SAVEDETAIL'">
					<xsl:text>this.doOnDetailSaveSuccess();</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>this.doOnDetailDeleteSuccess();</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&#13;</xsl:text>
		</xsl:if>
		
		<xsl:if test="ancestor::screen[in-multi-panel='true']">
			<xsl:text>this.setResult(Activity.RESULT_OK);&#13;</xsl:text>			
			<xsl:text>this.exit();&#13;</xsl:text>
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>
