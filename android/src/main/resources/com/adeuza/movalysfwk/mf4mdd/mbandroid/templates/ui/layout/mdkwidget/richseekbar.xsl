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

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/initial-value.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/seekbar-min.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/seekbar-max.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/min-allowed.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/ui/layout/mdkwidget/seekbar/max-allowed.xsl"/>

<!-- Component attributes -->
<xsl:template match="visualfield[component = 'com.soprasteria.movalysmdk.widget.basic.MDKRichSeekBar']" 
	mode="componentAttributes">
	<xsl:apply-templates select="." mode="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>
	<xsl:apply-templates select="." mode="dimensions"/>
	<xsl:apply-templates select="." mode="label"/>
	<xsl:apply-templates select="." mode="initial-value"/>
	<xsl:apply-templates select="." mode="seekbar-min"/>
	<xsl:apply-templates select="." mode="seekbar-max"/>
	<xsl:apply-templates select="." mode="min-allowed"/>
	<xsl:apply-templates select="." mode="max-allowed"/>
	<xsl:apply-templates select="." mode="editable"/>
	
</xsl:template>
</xsl:stylesheet>