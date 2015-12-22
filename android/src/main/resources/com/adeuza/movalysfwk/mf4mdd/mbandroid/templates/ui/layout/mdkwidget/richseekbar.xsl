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

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/initialSeekBaralue.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/seekbarMin.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/seekbarMax.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/minAllowed.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/maxAllowed.xsl"/>

<!-- Component attributes -->
<xsl:template match="visualfield[component = 'com.soprasteria.movalysmdk.widget.basic.MDKRichSeekBar']" mode="componentAttributes">
	<xsl:param name="titleId"/>

	<xsl:apply-templates select="." mode="standard-alignment">
		<xsl:with-param name="titleId" select="$titleId"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="view-focusable"/>
	<xsl:apply-templates select="." mode="dimensions"/>
	<xsl:apply-templates select="." mode="label"/>
	<xsl:apply-templates select="." mode="initialSeekBarValue"/>
	<xsl:apply-templates select="." mode="seekbarMin"/>
	<xsl:apply-templates select="." mode="seekbarMax"/>
	<xsl:apply-templates select="." mode="minAllowed"/>
	<xsl:apply-templates select="." mode="maxAllowed"/>
	<xsl:apply-templates select="." mode="editable"/>
	
</xsl:template>
</xsl:stylesheet>