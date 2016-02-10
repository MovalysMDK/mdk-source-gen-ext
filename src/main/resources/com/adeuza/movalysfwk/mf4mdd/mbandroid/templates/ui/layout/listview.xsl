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

<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMListView']" mode="componentAttributes">
	<xsl:param name="titleId"/>
	<xsl:call-template name="standard-alignment">
		<xsl:with-param name="titleId" select="$titleId"/>
	</xsl:call-template>
	android:layout_width="match_parent"
	android:layout_height="match_parent"
	android:choiceMode="singleChoice"
	<xsl:if test="count(mandatory) > 0">movalys:mandatory="<xsl:value-of select="mandatory"/>" </xsl:if>

</xsl:template>	
</xsl:stylesheet>
