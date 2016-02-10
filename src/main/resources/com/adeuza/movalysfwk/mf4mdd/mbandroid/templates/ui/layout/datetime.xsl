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

<!-- Specifics attribute for datetime component -->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMDateTimeEditText' or component='com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMDateTimeTextView']" 
	mode="componentAttributes">
	<xsl:call-template name="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>
	android:layout_width="match_parent"
	android:layout_height="wrap_content"
	<xsl:text>movalys:mode="datetime" </xsl:text>
	<xsl:if test="count(./mandatory) > 0">movalys:mandatory="<xsl:value-of select="./mandatory"/>" </xsl:if>
	<xsl:if test="not(//parameters/parameter[text() = 'LIST_1__ONE_SELECTED'])">style="?attr/detail_value"</xsl:if>	
</xsl:template>

	<!-- STYLE ...................................................................................................... -->

	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMDateTimeEditText' and substring-after(substring-after(./name, '__'), '__') = 'value']" mode="componentStyle">
		<xsl:text>detail_editDateTime</xsl:text>
	</xsl:template>
</xsl:stylesheet>
