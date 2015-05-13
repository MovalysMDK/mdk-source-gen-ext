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

<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMRadioGroup']" 
	mode="componentAttributes">
	<xsl:call-template name="standard-alignment"/>
	<xsl:apply-templates select="." mode="view-focusable"/>	
	<xsl:text> android:orientation="vertical"
	android:layout_width="match_parent"
	android:layout_height="wrap_content"
	</xsl:text>
	<xsl:if test="count(./mandatory) > 0">movalys:mandatory="<xsl:value-of select="./mandatory"/>" </xsl:if>
</xsl:template>

<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMRadioGroup']" 
	mode="componentContent">
	
	<xsl:call-template name="radioButton">
		<xsl:with-param name="list" select="parameters/parameter[@name='values']"/>
	</xsl:call-template>

</xsl:template>


<xsl:template name="radioButton">
	<xsl:param name="list" />
	<xsl:variable name="newlist" select="concat(normalize-space($list), ' ')" />
	<xsl:variable name="first" select="substring-before($newlist, ' ')" />
	<xsl:variable name="remaining" select="substring-after($newlist, ' ')" />

	<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text>
		<xsl:text>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMRadioButton android:id="@+id/radio_</xsl:text>
		<xsl:value-of select="$first"/>
		<xsl:text>"
          android:layout_width="wrap_content"
          android:layout_height="wrap_content"
          android:text="@string/enum_</xsl:text>
          <xsl:value-of select="parameters/parameter[@name='enum']"/>
          <xsl:text>_</xsl:text>
        <xsl:value-of select="$first"/>
        <xsl:text>"</xsl:text>
        <xsl:apply-templates select="." mode="view-focusable"/>
     <xsl:text disable-output-escaping="yes"><![CDATA[/>]]>
     </xsl:text>
	
	<xsl:if test="$remaining">
		<xsl:call-template name="radioButton">
			<xsl:with-param name="list" select="$remaining" />
		</xsl:call-template>
	</xsl:if>
 </xsl:template>

</xsl:stylesheet>