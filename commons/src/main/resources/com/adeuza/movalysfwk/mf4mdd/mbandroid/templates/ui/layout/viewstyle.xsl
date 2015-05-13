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

	<!-- text viex when it's a value -->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMTextView' and substring-after(substring-after(./name, '__'), '__') = 'value']" mode="componentStyle">
		<xsl:text>detail_value</xsl:text>
	</xsl:template>

	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMTextView' and substring-after(substring-after(./name, '__'), '__') = 'label']" mode="componentStyle">
		<xsl:text>detail_label</xsl:text>
	</xsl:template>

	<!--Default style for Action image button-->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMFilterButton']" mode="componentStyle">
		<xsl:text>FilterButton</xsl:text>
	</xsl:template>

	<!--Default style for Action image button-->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSectionTitle']" mode="componentStyle">
		<xsl:text>SectionTitle</xsl:text>
	</xsl:template>
</xsl:stylesheet>