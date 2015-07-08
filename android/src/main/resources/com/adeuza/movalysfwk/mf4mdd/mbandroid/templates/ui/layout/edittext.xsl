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

<!--  Specifics options for text component -->
<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMEditText']" 
	mode="componentAttributes">
	<xsl:apply-templates select="." mode="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>
	<xsl:apply-templates select="." mode="dimensions"/>
	<xsl:if test="contains(substring-after(./name, '__'), '__value')">android:focusable="false" style="?attr/detail_value" </xsl:if>
	<xsl:apply-templates select="." mode="inputtype"/>
	<xsl:apply-templates select="." mode="maxlength"/>
	<xsl:apply-templates select="." mode="mandatory"/>
</xsl:template>

	<!-- STYLE ...................................................................................................... -->

	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMEditText']" mode="componentStyle">
		<xsl:text>detail_edit</xsl:text>
	</xsl:template>
</xsl:stylesheet>
