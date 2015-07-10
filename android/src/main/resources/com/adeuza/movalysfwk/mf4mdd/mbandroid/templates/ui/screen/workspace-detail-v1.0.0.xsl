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

	<xsl:template match="screen[workspace='true' and workspace-type='DETAIL']" mode="superclass">
		<xsl:text>AbstractWorkspaceDetailMMActivity</xsl:text>
	</xsl:template>

	
	<!-- *****************************************************************************************
											EXTRA METHODS
		***************************************************************************************** -->

	<xsl:template match="screen[workspace='true' and workspace-type='DETAIL']" mode="workspace-extramethods">
	
		<xsl:if test="descendant::page/actions/action/action-type='SAVEDETAIL'">
		@Override
		protected void doOnKeepWorkspaceModifications(View p_oSource) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">doOnKeepWorkspaceModifications</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="." mode="launch-savedetail-actions">
						<xsl:with-param name="sourceObject">FROM_BACK</xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}
		</xsl:if>
	
	</xsl:template>


</xsl:stylesheet>
