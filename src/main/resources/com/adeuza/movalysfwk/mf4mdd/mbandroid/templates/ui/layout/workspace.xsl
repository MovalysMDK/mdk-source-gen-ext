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

	<xsl:output method="xml" indent="yes"/>

	<!--  Specifics options for workspace component -->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMWorkspaceMasterDetailLayout' or component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMWorkspaceMasterDetailFragmentLayout' or component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMWorkspaceDetailLayout']">	

			<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="./component"/>
			android:id="@+id/<xsl:value-of select="./name"/>"
			android:layout_width="match_parent"
			android:layout_height="match_parent"
			<xsl:if test="workspace-config/managment-main">
				movalys:workspacemain="<xsl:value-of select="./workspace-config/managment-main"/>"
				<xsl:if test="./workspace-config/tab-count > 1">
				movalys:workspacetabsize="<xsl:value-of select="./workspace-config/tab-count"/>"
				<xsl:for-each select="./workspace-config/managment-tab">
					<xsl:text>
					movalys:workspacetab</xsl:text><xsl:value-of select="./@pos"/>="<xsl:value-of select="."/>"
				</xsl:for-each>
				</xsl:if>
			</xsl:if>
     		
     		movalys:workspacedetailsize="<xsl:value-of select="count(./workspace-config/managment-details/column/managment-detail)"/>"
			<xsl:for-each select="./workspace-config/managment-details//column/managment-detail">
				<xsl:sort select="../@pos" data-type="number"/>
				<xsl:sort select="@section" data-type="number"/>
				<xsl:text>
				movalys:workspacedetail</xsl:text><xsl:value-of select="position()"/>="<xsl:value-of select="."/>"
			</xsl:for-each><xsl:text disable-output-escaping="yes"><![CDATA[/>]]>
     		</xsl:text>
			
	</xsl:template>

</xsl:stylesheet>
