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

	<!-- Import pour les menus -->
	<xsl:template name="menuImports">
		<xsl:if test="count(//options-menu) > 0 or count(//menu[@id='actions']) > 0">
			<import>android.content.Intent</import>
			<import>java.util.List</import>
			<import>java.util.Map</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.Action</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnMenuItemClick</import>
		</xsl:if>
		<xsl:if test="count(//menu[@id='actions']) > 0 and count(//button/navigation[@type='NAVIGATION_INFO']) > 0 ">
			<import>android.content.DialogInterface</import>
            <import>android.support.v4.app.FragmentManager</import>
            <import>com.adeuza.movalysfwk.mobile.mf4android.ui.dialog.WebViewDialog</import>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>