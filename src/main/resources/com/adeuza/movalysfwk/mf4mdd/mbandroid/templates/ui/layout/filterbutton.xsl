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

<!-- Specifics options for filter buttons -->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMFilterButton']"
	mode="componentAttributes">
	<xsl:call-template name="standard-alignment"/>
	android:layout_width="wrap_content"
	android:layout_height="wrap_content"
	<xsl:text>movalys:start_dialog="</xsl:text>
	<xsl:value-of select="parameters/parameter[@name='dialog']"/>
	<xsl:text>" </xsl:text>
	android:src="@drawable/ic_btn_search"
</xsl:template>

	<!-- STYLE ...................................................................................................... -->

	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMFilterButton']" mode="componentStyle">
		<xsl:text>FilterButton</xsl:text>
	</xsl:template>
</xsl:stylesheet>